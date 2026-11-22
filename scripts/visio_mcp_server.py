"""
Microsoft Visio Model Context Protocol (MCP) Server for TexEye AI
Enables AI assistants to drive and inspect Microsoft Visio 365 / 2016+ desktop applications natively.
"""

import os
import sys
import pythoncom
import win32com.client
from mcp.server.mcpserver import MCPServer

# Initialize MCP Server instance
server = MCPServer("visio")

def get_visio_app(make_visible=True):
    """Acquires active Visio instance or launches a new one."""
    pythoncom.CoInitialize()
    try:
        visio = win32com.client.GetActiveObject("Visio.Application")
    except Exception:
        visio = win32com.client.Dispatch("Visio.Application")
    
    if make_visible:
        visio.Visible = True
        try:
            visio.AlertResponse = 1 # Suppress alerts
        except Exception:
            pass
    return visio

@server.tool()
def visio_launch_gui() -> str:
    """Launches or brings Microsoft Visio to the foreground."""
    try:
        visio = get_visio_app(make_visible=True)
        return f"Microsoft Visio (Version {visio.Version}) is active and visible."
    except Exception as e:
        return f"Failed to launch Visio: {str(e)}"

@server.tool()
def visio_open_diagram(file_path: str) -> str:
    """
    Opens an existing Visio diagram (.vsdx or .vdx) in Microsoft Visio.
    
    :param file_path: Absolute or workspace-relative path to the diagram file.
    """
    try:
        abs_path = os.path.abspath(file_path)
        if not os.path.exists(abs_path):
            return f"Error: File does not exist at {abs_path}"
        
        visio = get_visio_app(make_visible=True)
        # visOpenDontAutoprompt = 8
        doc = visio.Documents.OpenEx(abs_path, 8)
        page_name = doc.Pages.Item(1).Name if doc.Pages.Count > 0 else "None"
        return f"Successfully opened '{doc.Name}' in Microsoft Visio. Active page: '{page_name}', Shapes: {doc.Pages.Item(1).Shapes.Count}."
    except Exception as e:
        return f"Error opening diagram in Visio: {str(e)}"

@server.tool()
def visio_create_blank_diagram(page_name: str = "New Architecture") -> str:
    """
    Creates a new blank drawing in Microsoft Visio.
    
    :param page_name: Name for the primary page.
    """
    try:
        visio = get_visio_app(make_visible=True)
        doc = visio.Documents.Add("")
        page = doc.Pages.Item(1)
        page.Name = page_name
        return f"Created new Visio document '{doc.Name}' with initial page '{page_name}'."
    except Exception as e:
        return f"Error creating blank diagram: {str(e)}"

@server.tool()
def visio_add_shape(text: str, x: float, y: float, w: float = 2.0, h: float = 1.0, shape_type: str = "rectangle") -> str:
    """
    Draws a shape on the active Visio page.
    
    :param text: Label or text content for the shape.
    :param x: Center X coordinate in inches (e.g. 5.5 for center of 11in page).
    :param y: Center Y coordinate in inches (e.g. 4.25 for center of 8.5in page).
    :param w: Width in inches.
    :param h: Height in inches.
    :param shape_type: 'rectangle' or 'oval'.
    """
    try:
        visio = get_visio_app(make_visible=True)
        if visio.ActiveDocument is None:
            visio.Documents.Add("")
            
        page = visio.ActivePage
        x1 = x - (w / 2.0)
        y1 = y - (h / 2.0)
        x2 = x + (w / 2.0)
        y2 = y + (h / 2.0)
        
        if shape_type.lower() == "oval":
            shape = page.DrawOval(x1, y1, x2, y2)
        else:
            shape = page.DrawRectangle(x1, y1, x2, y2)
            
        shape.Text = text
        return f"Added shape ID {shape.ID} ('{text}') at ({x}, {y}) inches."
    except Exception as e:
        return f"Error adding shape: {str(e)}"

@server.tool()
def visio_get_active_info() -> str:
    """Retrieves status and metadata of the currently active document in Microsoft Visio."""
    try:
        visio = get_visio_app(make_visible=True)
        if visio.ActiveDocument is None:
            return "Visio is running, but no document is currently open."
            
        doc = visio.ActiveDocument
        page = visio.ActivePage
        shapes_count = page.Shapes.Count if page else 0
        return f"Active Document: '{doc.Name}' | Active Page: '{page.Name}' | Total Shapes: {shapes_count} | Total Pages: {doc.Pages.Count}"
    except Exception as e:
        return f"Error reading Visio info: {str(e)}"

@server.tool()
def visio_export_diagram(output_path: str) -> str:
    """
    Exports the active Visio page to a file (PDF, PNG, SVG).
    
    :param output_path: Destination path for the exported image or document.
    """
    try:
        visio = get_visio_app(make_visible=True)
        if visio.ActiveDocument is None:
            return "Error: No active document to export."
            
        abs_output = os.path.abspath(output_path)
        os.makedirs(os.path.dirname(abs_output), exist_ok=True)
        visio.ActivePage.Export(abs_output)
        return f"Successfully exported active diagram page to '{abs_output}'."
    except Exception as e:
        return f"Error exporting diagram: {str(e)}"

if __name__ == "__main__":
    # Run the MCP server over standard input/output (stdio)
    server.run(transport="stdio")

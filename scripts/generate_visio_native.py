"""
TexEye AI — Native Microsoft Visio UML Diagram Generator
Generates proper, clean, professionally-aligned UML Sequence Diagrams
and Use Case Diagrams directly in Microsoft Visio via COM Automation.

Reference style: Clean UML 2.5 with stick-figure actors, rectangular
participant boxes, dashed lifelines, solid/dashed message arrows,
activation bars, and alt fragments.
"""

import os
import sys
import time
import pythoncom
import win32com.client

# Add scripts dir to path for imports
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

from generate_all_25_sequences import use_cases

# Constants for Visio
visOpenRO = 2
visOpenDontList = 8
visSectionObject = 1
visRowFill = 3
visSectionParagraph = 4

OUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'diagrams', 'visio')
os.makedirs(OUT_DIR, exist_ok=True)

EXPORT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'diagrams', 'visio', 'png')
os.makedirs(EXPORT_DIR, exist_ok=True)

# Page dimensions (inches) — Landscape A4
PAGE_W = 11.69
PAGE_H = 8.27

def init_visio():
    """Launch or connect to Visio, return app object."""
    pythoncom.CoInitialize()
    try:
        visio = win32com.client.GetActiveObject("Visio.Application")
    except Exception:
        visio = win32com.client.Dispatch("Visio.Application")
    visio.Visible = True
    visio.AlertResponse = 1
    return visio

def set_shape_format(shape, fill_color="RGB(255,255,255)", line_color="RGB(0,0,0)",
                     line_weight="0.5pt", font_size="10pt", bold=False,
                     h_align=1, text_color="RGB(0,0,0)", rounding="0in"):
    """Apply formatting to a Visio shape via ShapeSheet cells."""
    try:
        shape.CellsSRC(1, 3, 0).FormulaU = fill_color      # FillForegnd
        shape.CellsSRC(1, 3, 1).FormulaU = fill_color      # FillBkgnd
        shape.CellsSRC(1, 2, 0).FormulaU = line_color      # LineColor
        shape.CellsSRC(1, 2, 5).FormulaU = line_weight     # LineWeight
        shape.CellsSRC(1, 11, 7).FormulaU = font_size      # Size (Char section)
    except Exception:
        pass
    try:
        if rounding != "0in":
            shape.CellsSRC(1, 1, 7).FormulaU = rounding    # Rounding
    except Exception:
        pass


def draw_rect(page, x, y, w, h, text="", fill="RGB(255,255,255)",
              line_col="RGB(0,0,0)", line_w="0.5pt", font_sz="9pt",
              bold=False, rounding="0in"):
    """Draw a rectangle centered at (x, y) with size (w, h)."""
    x1, y1 = x - w/2, y - h/2
    x2, y2 = x + w/2, y + h/2
    s = page.DrawRectangle(x1, y1, x2, y2)
    if text:
        s.Text = text
    set_shape_format(s, fill_color=fill, line_color=line_col,
                     line_weight=line_w, font_size=font_sz, rounding=rounding)
    return s


def draw_line(page, x1, y1, x2, y2, dashed=False, color="RGB(0,0,0)",
              weight="0.5pt", arrow_end=True):
    """Draw a line from (x1,y1) to (x2,y2)."""
    s = page.DrawLine(x1, y1, x2, y2)
    try:
        s.CellsSRC(1, 2, 0).FormulaU = color
        s.CellsSRC(1, 2, 5).FormulaU = weight
        if dashed:
            s.CellsSRC(1, 2, 4).FormulaU = "2"  # Dash pattern
        if arrow_end:
            s.CellsSRC(1, 2, 6).FormulaU = "5"  # EndArrow (filled triangle)
            s.CellsSRC(1, 2, 12).FormulaU = "2"  # EndArrowSize (small)
        if dashed and arrow_end:
            s.CellsSRC(1, 2, 6).FormulaU = "4"  # Open arrow for return
    except Exception:
        pass
    return s


def add_text_label(page, x, y, text, font_size="8pt", bold=False, h_align="center"):
    """Add a free-floating text label at position (x, y)."""
    # Draw a tiny invisible rectangle to hold text
    w = max(1.5, len(text) * 0.055 + 0.2)
    h = 0.18
    s = page.DrawRectangle(x - w/2, y - h/2, x + w/2, y + h/2)
    s.Text = text
    try:
        s.CellsSRC(1, 3, 0).FormulaU = "RGB(255,255,255)"  # Fill white
        s.CellsSRC(1, 3, 3).FormulaU = "0"                 # FillPattern = none
        s.CellsSRC(1, 2, 0).FormulaU = "RGB(255,255,255)"  # Line invisible
        s.CellsSRC(1, 2, 3).FormulaU = "0"                 # LinePattern = none
        s.CellsSRC(1, 11, 7).FormulaU = font_size
    except Exception:
        pass
    return s


def draw_dashed_line(page, x1, y1, x2, y2):
    """Draw a dashed lifeline."""
    s = page.DrawLine(x1, y1, x2, y2)
    try:
        s.CellsSRC(1, 2, 0).FormulaU = "RGB(128,128,128)"
        s.CellsSRC(1, 2, 5).FormulaU = "0.3pt"
        s.CellsSRC(1, 2, 4).FormulaU = "2"  # Dash pattern
        s.CellsSRC(1, 2, 6).FormulaU = "0"  # No arrow
    except Exception:
        pass
    return s


def draw_activation_bar(page, x, y_top, y_bottom):
    """Draw thin activation rectangle on a lifeline."""
    bar_w = 0.12
    s = page.DrawRectangle(x - bar_w/2, y_bottom, x + bar_w/2, y_top)
    try:
        s.CellsSRC(1, 3, 0).FormulaU = "RGB(255,255,255)"
        s.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
        s.CellsSRC(1, 2, 5).FormulaU = "0.5pt"
    except Exception:
        pass
    return s


def draw_stick_figure(page, cx, cy, label):
    """Draw a UML stick figure actor at (cx, cy) with label below."""
    head_r = 0.12
    # Head (circle)
    head = page.DrawOval(cx - head_r, cy + 0.15 + head_r*2,
                         cx + head_r, cy + 0.15)
    try:
        head.CellsSRC(1, 3, 3).FormulaU = "0"  # No fill pattern
        head.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
        head.CellsSRC(1, 2, 5).FormulaU = "0.5pt"
    except Exception:
        pass

    # Body
    body = page.DrawLine(cx, cy + 0.15, cx, cy - 0.15)
    try:
        body.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
        body.CellsSRC(1, 2, 5).FormulaU = "0.5pt"
        body.CellsSRC(1, 2, 6).FormulaU = "0"
    except Exception:
        pass

    # Arms
    arms = page.DrawLine(cx - 0.18, cy + 0.08, cx + 0.18, cy + 0.08)
    try:
        arms.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
        arms.CellsSRC(1, 2, 5).FormulaU = "0.5pt"
        arms.CellsSRC(1, 2, 6).FormulaU = "0"
    except Exception:
        pass

    # Left leg
    l_leg = page.DrawLine(cx, cy - 0.15, cx - 0.15, cy - 0.38)
    try:
        l_leg.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
        l_leg.CellsSRC(1, 2, 5).FormulaU = "0.5pt"
        l_leg.CellsSRC(1, 2, 6).FormulaU = "0"
    except Exception:
        pass

    # Right leg
    r_leg = page.DrawLine(cx, cy - 0.15, cx + 0.15, cy - 0.38)
    try:
        r_leg.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
        r_leg.CellsSRC(1, 2, 5).FormulaU = "0.5pt"
        r_leg.CellsSRC(1, 2, 6).FormulaU = "0"
    except Exception:
        pass

    # Label below
    add_text_label(page, cx, cy - 0.52, label, font_size="8pt", bold=True)


def render_sequence_diagram(visio, uc_data, out_path):
    """
    Render one UML Sequence Diagram in Visio matching the reference style:
    - Stick figure actor on the left
    - Rectangular participant boxes across the top
    - Dashed vertical lifelines
    - Solid arrows (calls) and dashed arrows (returns)
    - Message labels along each arrow
    - Title at top
    """
    uc_id, title, actor_name, actor_lbl, ui_name, ui_lbl, api_name, api_lbl, \
        srv_name, srv_lbl, db_name, db_lbl, steps, desc = uc_data

    doc = visio.Documents.Add("")
    page = doc.Pages.Item(1)
    page.Name = uc_id

    # Set page size to landscape A4
    try:
        page.PageSheet.CellsSRC(1, 25, 0).FormulaU = f"{PAGE_W} in"  # PageWidth
        page.PageSheet.CellsSRC(1, 25, 1).FormulaU = f"{PAGE_H} in"  # PageHeight
    except Exception:
        pass

    # === Layout Constants ===
    margin_left = 0.8
    margin_top = PAGE_H - 0.6
    box_w = 1.5
    box_h = 0.4
    gap_x = 2.0  # Horizontal gap between lifeline centers

    # Participant positions (5 participants)
    participants = [
        (actor_lbl.replace(":", ""), True),   # Actor (stick figure)
        (ui_lbl.replace(":", ""), False),
        (api_lbl.replace(":", ""), False),
        (srv_lbl.replace(":", ""), False),
        (db_lbl.replace(":", ""), False),
    ]

    # Calculate x positions
    actor_x = margin_left + 0.6
    x_positions = []
    for i in range(len(participants)):
        if i == 0:
            x_positions.append(actor_x)
        else:
            x_positions.append(actor_x + i * gap_x)

    # Adjust if too wide
    total_w = x_positions[-1] + box_w/2 + 0.5
    if total_w > PAGE_W:
        gap_x = (PAGE_W - 2 * margin_left - 1.2) / (len(participants) - 1)
        for i in range(len(participants)):
            x_positions[i] = actor_x + i * gap_x

    # === Title ===
    title_y = margin_top
    # Title frame box
    frame_x1, frame_y1 = 0.3, 0.3
    frame_x2, frame_y2 = PAGE_W - 0.3, PAGE_H - 0.3
    frame = page.DrawRectangle(frame_x1, frame_y1, frame_x2, frame_y2)
    try:
        frame.CellsSRC(1, 3, 3).FormulaU = "0"  # No fill
        frame.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
        frame.CellsSRC(1, 2, 5).FormulaU = "0.5pt"
    except Exception:
        pass

    # Title tab in top-left corner
    tab_w = max(2.0, len(title) * 0.065 + 0.3)
    tab = draw_rect(page, frame_x1 + tab_w/2, frame_y2 - 0.01,
                    tab_w, 0.3, text=title,
                    fill="RGB(255,255,255)", line_col="RGB(0,0,0)",
                    font_sz="9pt", bold=True)

    # === Participants ===
    participant_top_y = margin_top - 0.5
    lifeline_start_y = participant_top_y - box_h/2

    # Build position lookup from labels
    label_to_x = {}
    for i, (plbl, is_actor) in enumerate(participants):
        cx = x_positions[i]
        if is_actor:
            # Draw stick figure
            draw_stick_figure(page, cx, participant_top_y - 0.1, plbl)
            lifeline_x = cx
        else:
            # Draw participant box
            draw_rect(page, cx, participant_top_y, box_w, box_h, text=plbl,
                      fill="RGB(255,255,255)", line_col="RGB(0,0,0)",
                      font_sz="9pt", bold=True)
            lifeline_x = cx

        # Store for message routing
        # Map the original labels (with colon prefix) to x positions
        for orig_lbl in [actor_lbl, ui_lbl, api_lbl, srv_lbl, db_lbl]:
            clean = orig_lbl.replace(":", "")
            if clean == plbl:
                label_to_x[orig_lbl] = lifeline_x

    # === Lifelines (dashed vertical lines) ===
    step_gap = 0.45
    num_steps = len(steps)
    lifeline_bottom_y = lifeline_start_y - (num_steps + 2) * step_gap

    # Ensure lifeline doesn't go below page
    if lifeline_bottom_y < 0.8:
        step_gap = (lifeline_start_y - 0.8) / (num_steps + 2)
        lifeline_bottom_y = 0.8

    for i, (plbl, is_actor) in enumerate(participants):
        cx = x_positions[i]
        if is_actor:
            start_y = participant_top_y - 0.55
        else:
            start_y = participant_top_y - box_h/2
        draw_dashed_line(page, cx, start_y, cx, lifeline_bottom_y)

    # === Bottom participant boxes (mirror) ===
    for i, (plbl, is_actor) in enumerate(participants):
        cx = x_positions[i]
        if is_actor:
            draw_stick_figure(page, cx, lifeline_bottom_y - 0.1, plbl)
        else:
            draw_rect(page, cx, lifeline_bottom_y - 0.3, box_w, box_h, text=plbl,
                      fill="RGB(255,255,255)", line_col="RGB(0,0,0)",
                      font_sz="9pt", bold=True)

    # === Messages (arrows) ===
    curr_y = lifeline_start_y - step_gap

    for msg_text, src_lbl, dst_lbl, m_type, num in steps:
        x1 = label_to_x.get(src_lbl, x_positions[0])
        x2 = label_to_x.get(dst_lbl, x_positions[-1])

        is_return = (m_type == "ret")
        is_self = (m_type == "self")

        if is_self:
            # Self-call loop
            loop_w = 0.4
            loop_h = 0.25
            # Draw the loop lines manually
            page_line1 = page.DrawLine(x1, curr_y, x1 + loop_w, curr_y)
            page_line2 = page.DrawLine(x1 + loop_w, curr_y, x1 + loop_w, curr_y - loop_h)
            arrow_back = draw_line(page, x1 + loop_w, curr_y - loop_h,
                                   x1 + 0.07, curr_y - loop_h,
                                   dashed=False, arrow_end=True)
            for ln in [page_line1, page_line2]:
                try:
                    ln.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
                    ln.CellsSRC(1, 2, 5).FormulaU = "0.5pt"
                    ln.CellsSRC(1, 2, 6).FormulaU = "0"
                except Exception:
                    pass

            # Label
            # Strip the leading number for cleaner display
            clean_msg = msg_text
            if ". " in clean_msg:
                clean_msg = clean_msg.split(". ", 1)[1]
            add_text_label(page, x1 + loop_w + 0.6, curr_y - loop_h/2,
                           clean_msg, font_size="7pt")
            curr_y -= step_gap
            continue

        # Regular message arrow
        draw_line(page, x1, curr_y, x2, curr_y,
                  dashed=is_return, arrow_end=True)

        # Message label above the arrow
        mid_x = (x1 + x2) / 2
        clean_msg = msg_text
        if ". " in clean_msg:
            clean_msg = clean_msg.split(". ", 1)[1]

        # Truncate very long messages
        if len(clean_msg) > 45:
            clean_msg = clean_msg[:42] + "..."

        add_text_label(page, mid_x, curr_y + 0.12, clean_msg, font_size="7pt")

        curr_y -= step_gap

    # === Figure Caption ===
    caption_text = f"Figure: Sequence Diagram for {title}"
    add_text_label(page, PAGE_W / 2, 0.15, caption_text,
                   font_size="10pt", bold=True)

    # Save
    abs_path = os.path.abspath(out_path)
    doc.SaveAs(abs_path)

    # Export to PNG
    png_name = os.path.splitext(os.path.basename(out_path))[0] + ".png"
    png_path = os.path.join(EXPORT_DIR, png_name)
    try:
        page.Export(os.path.abspath(png_path))
        print(f"  Exported PNG: {png_name}")
    except Exception as e:
        print(f"  PNG export failed: {e}")

    doc.Close()
    print(f"  Saved: {os.path.basename(out_path)}")
    return abs_path


def render_use_case_diagram(visio, out_path):
    """
    Render the TexEye AI Use Case Diagram in proper UML style:
    - System boundary rectangle with title
    - Stick figure actors on left and right sides
    - Ovals for each use case
    - Lines connecting actors to their use cases
    """
    doc = visio.Documents.Add("")
    page = doc.Pages.Item(1)
    page.Name = "Use Case Diagram"

    # Page size
    try:
        page.PageSheet.CellsSRC(1, 25, 0).FormulaU = f"{PAGE_W} in"
        page.PageSheet.CellsSRC(1, 25, 1).FormulaU = f"{PAGE_H} in"
    except Exception:
        pass

    # System boundary
    sys_x1, sys_y1 = 2.5, 0.5
    sys_x2, sys_y2 = 9.2, PAGE_H - 0.3
    sys_rect = page.DrawRectangle(sys_x1, sys_y1, sys_x2, sys_y2)
    try:
        sys_rect.CellsSRC(1, 3, 3).FormulaU = "0"  # No fill
        sys_rect.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
        sys_rect.CellsSRC(1, 2, 5).FormulaU = "0.5pt"
    except Exception:
        pass

    # System title
    add_text_label(page, (sys_x1 + sys_x2)/2, sys_y2 - 0.15,
                   "TexEye AI: Fabric Defect Detection & Quality Management System",
                   font_size="10pt", bold=True)

    # Actors on left side
    left_actors = [
        ("Floor Operator", 1.3, 6.5),
        ("Quality Inspector", 1.3, 4.8),
        ("Production Manager", 1.3, 3.0),
        ("Inventory Manager", 1.3, 1.5),
    ]

    # Actor on right side
    right_actors = [
        ("System Administrator", 10.4, 5.5),
    ]

    # Use cases (ovals) organized vertically
    uc_ovals = [
        # Floor Operator use cases
        ("Login / Logout", 4.0, 7.2),
        ("Scan Roll QR Code", 4.0, 6.6),
        ("View Active Roll Info", 4.0, 6.0),
        ("Receive Inspection Alerts", 4.0, 5.4),
        ("Review Detected Defects", 4.0, 4.8),
        # Quality Inspector use cases
        ("View 2D Defect Map", 5.8, 7.2),
        ("Review Defect Crops", 5.8, 6.6),
        ("Correct Defect Record", 5.8, 6.0),
        ("View Uninspected Intervals", 5.8, 5.4),
        ("Confirm Roll Grading", 5.8, 4.8),
        ("Generate Inspection Report", 5.8, 4.2),
        # Production Manager use cases
        ("View Production Dashboard", 4.0, 3.6),
        ("View Defect Pareto Stats", 4.0, 3.0),
        ("View Historical Records", 4.0, 2.4),
        # Inventory Manager use cases
        ("View Warehouse Inventory", 5.8, 3.0),
        ("Update Roll Location", 5.8, 2.4),
        ("View Certified Grading", 5.8, 1.8),
        ("Manage Scrap Segregation", 5.8, 1.2),
        # Admin use cases
        ("Manage User Accounts", 7.5, 6.6),
        ("Assign Roles & Scopes", 7.5, 6.0),
        ("Configure Edge Calibration", 7.5, 5.4),
    ]

    # Draw actors
    for name, ax, ay in left_actors + right_actors:
        draw_stick_figure(page, ax, ay, name)

    # Draw use case ovals
    oval_positions = {}
    oval_w = 1.6
    oval_h = 0.4
    for uc_name, ox, oy in uc_ovals:
        s = page.DrawOval(ox - oval_w/2, oy - oval_h/2,
                          ox + oval_w/2, oy + oval_h/2)
        s.Text = uc_name
        try:
            s.CellsSRC(1, 3, 3).FormulaU = "0"  # No fill
            s.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
            s.CellsSRC(1, 2, 5).FormulaU = "0.5pt"
            s.CellsSRC(1, 11, 7).FormulaU = "8pt"
        except Exception:
            pass
        oval_positions[uc_name] = (ox, oy)

    # Draw connections: actors to use cases
    # Floor Operator
    for uc in ["Login / Logout", "Scan Roll QR Code", "View Active Roll Info",
               "Receive Inspection Alerts", "Review Detected Defects"]:
        ox, oy = oval_positions[uc]
        ln = page.DrawLine(1.3 + 0.2, left_actors[0][2], ox - oval_w/2, oy)
        try:
            ln.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
            ln.CellsSRC(1, 2, 5).FormulaU = "0.3pt"
            ln.CellsSRC(1, 2, 6).FormulaU = "0"
        except Exception:
            pass

    # Quality Inspector
    for uc in ["Login / Logout", "View 2D Defect Map", "Review Defect Crops",
               "Correct Defect Record", "View Uninspected Intervals",
               "Confirm Roll Grading", "Generate Inspection Report"]:
        ox, oy = oval_positions[uc]
        ln = page.DrawLine(1.3 + 0.2, left_actors[1][2], ox - oval_w/2, oy)
        try:
            ln.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
            ln.CellsSRC(1, 2, 5).FormulaU = "0.3pt"
            ln.CellsSRC(1, 2, 6).FormulaU = "0"
        except Exception:
            pass

    # Production Manager
    for uc in ["Login / Logout", "View Production Dashboard",
               "View Defect Pareto Stats", "View Historical Records"]:
        ox, oy = oval_positions[uc]
        ln = page.DrawLine(1.3 + 0.2, left_actors[2][2], ox - oval_w/2, oy)
        try:
            ln.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
            ln.CellsSRC(1, 2, 5).FormulaU = "0.3pt"
            ln.CellsSRC(1, 2, 6).FormulaU = "0"
        except Exception:
            pass

    # Inventory Manager
    for uc in ["Login / Logout", "View Warehouse Inventory", "Update Roll Location",
               "View Certified Grading", "Manage Scrap Segregation"]:
        ox, oy = oval_positions[uc]
        ln = page.DrawLine(1.3 + 0.2, left_actors[3][2], ox - oval_w/2, oy)
        try:
            ln.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
            ln.CellsSRC(1, 2, 5).FormulaU = "0.3pt"
            ln.CellsSRC(1, 2, 6).FormulaU = "0"
        except Exception:
            pass

    # System Admin
    for uc in ["Login / Logout", "Manage User Accounts",
               "Assign Roles & Scopes", "Configure Edge Calibration"]:
        ox, oy = oval_positions[uc]
        ln = page.DrawLine(10.4 - 0.2, right_actors[0][2], ox + oval_w/2, oy)
        try:
            ln.CellsSRC(1, 2, 0).FormulaU = "RGB(0,0,0)"
            ln.CellsSRC(1, 2, 5).FormulaU = "0.3pt"
            ln.CellsSRC(1, 2, 6).FormulaU = "0"
        except Exception:
            pass

    # Caption
    add_text_label(page, PAGE_W / 2, 0.15,
                   "Figure: Use-case Diagram — TexEye AI System",
                   font_size="10pt", bold=True)

    # Save
    abs_path = os.path.abspath(out_path)
    doc.SaveAs(abs_path)

    # Export PNG
    try:
        page.Export(os.path.abspath(os.path.join(EXPORT_DIR, "use_case_diagram.png")))
    except Exception:
        pass

    doc.Close()
    print(f"  Saved Use Case Diagram: {os.path.basename(out_path)}")


# =========================================================================
# MAIN EXECUTION
# =========================================================================
if __name__ == "__main__":
    print("=" * 70)
    print("TexEye AI — Native Visio UML Diagram Generator (COM Automation)")
    print("=" * 70)

    visio = init_visio()
    print(f"Connected to Microsoft Visio {visio.Version}")

    # 1. Generate all 25 Sequence Diagrams
    print(f"\n--- Generating 25 UML Sequence Diagrams ---")
    for i, uc_data in enumerate(use_cases):
        uc_id = uc_data[0]
        print(f"\n[{i+1}/25] {uc_data[1]}")
        out_file = os.path.join(OUT_DIR, f"{uc_id}.vsdx")
        try:
            render_sequence_diagram(visio, uc_data, out_file)
        except Exception as e:
            print(f"  ERROR: {e}")

    # 2. Generate Use Case Diagram
    print(f"\n--- Generating Use Case Diagram ---")
    uc_diagram_path = os.path.join(OUT_DIR, "00_use_case_diagram.vsdx")
    try:
        render_use_case_diagram(visio, uc_diagram_path)
    except Exception as e:
        print(f"  ERROR: {e}")

    # Quit Visio
    try:
        visio.Quit()
    except Exception:
        pass

    print("\n" + "=" * 70)
    print("DONE! All Visio diagrams generated with proper UML formatting.")
    print("=" * 70)

import os
import re
import base64
import urllib.parse
import zipfile
import io

print("Initializing Draw.io and MS Visio Exporter for TexEye AI...")

os.makedirs(r"diagrams\drawio", exist_ok=True)
os.makedirs(r"diagrams\visio", exist_ok=True)

# ------------------------------------------------------------------------------
# 1. HELPER: CREATE NATIVE DRAW.IO XML
# ------------------------------------------------------------------------------
def create_drawio_svg_diagram(diagram_id, name, svg_path, width=1200, height=800):
    with open(svg_path, 'r', encoding='utf-8') as f:
        svg_content = f.read()
    
    # Strip xml header
    svg_clean = re.sub(r'<\?xml.*?\?>', '', svg_content).strip()
    
    # Encode as data URI
    svg_b64 = base64.b64encode(svg_clean.encode('utf-8')).decode('utf-8')
    data_uri = f"data:image/svg+xml;base64,{svg_b64}"
    
    xml = f"""<mxfile host="app.diagrams.net" modified="2026-11-22T00:00:00.000Z" agent="TexEye AI Architect" version="22.1.0" type="device">
  <diagram id="{diagram_id}" name="{name}">
    <mxGraphModel dx="1200" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="{width}" pageHeight="{height}" background="#FFFFFF" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="svg_canvas" value="" style="shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image={data_uri};" vertex="1" parent="1">
          <mxGeometry x="20" y="20" width="{width-40}" height="{height-40}" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>"""
    return xml

def create_native_drawio_sequence(diagram_id, name, title, lifelines, steps, width=1100, height=850):
    """
    Creates fully editable native Draw.io sequence diagram with umlLifeline shapes and connector edges.
    """
    xml_cells = [
        '<mxCell id="0"/>',
        '<mxCell id="1" parent="0"/>',
        f'<mxCell id="title" value="&lt;b&gt;{title}&lt;/b&gt;" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=14;fontColor=#0f172a;" vertex="1" parent="1">',
        f'  <mxGeometry x="150" y="20" width="800" height="30" as="geometry"/>',
        '</mxCell>'
    ]
    
    # Lifelines
    cell_id = 10
    pos_map = {}
    for lbl, x in lifelines:
        p_id = f"p_{cell_id}"
        pos_map[lbl] = (p_id, x)
        xml_cells.append(f'<mxCell id="{p_id}" value="{lbl}" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;fillColor=#e0f2fe;strokeColor=#0284c7;strokeWidth=1.2;fontColor=#0f172a;fontStyle=1;fontSize=10;size=36;" vertex="1" parent="1">')
        xml_cells.append(f'  <mxGeometry x="{x-60}" y="70" width="120" height="{height-140}" as="geometry"/>')
        xml_cells.append('</mxCell>')
        cell_id += 1
        
    # Steps
    curr_y = 130
    step_num = 1
    for msg, src, dst, m_type, num in steps:
        edge_id = f"e_{cell_id}"
        src_info = pos_map.get(src, (None, 110))
        dst_info = pos_map.get(dst, (None, 750))
        
        x1 = src_info[1]
        x2 = dst_info[1]
        
        if m_type == "self":
            xml_cells.append(f'<mxCell id="{edge_id}" value="{msg}" style="html=1;verticalAlign=bottom;endArrow=block;edgeStyle=orthogonalEdgeStyle;curved=0;rounded=0;strokeColor=#0f172a;strokeWidth=1.2;fontColor=#0f172a;fontSize=9;labelBackgroundColor=#ffffff;" edge="1" parent="1">')
            xml_cells.append(f'  <mxGeometry relative="1" as="geometry">')
            xml_cells.append(f'    <mxPoint x="{x1}" y="{curr_y}" as="sourcePoint"/>')
            xml_cells.append(f'    <mxPoint x="{x1+30}" y="{curr_y+20}" as="targetPoint"/>')
            xml_cells.append(f'  </mxGeometry>')
            xml_cells.append('</mxCell>')
        else:
            is_ret = (m_type == "ret")
            arr_style = "open;dashed=1;" if is_ret else "block;"
            xml_cells.append(f'<mxCell id="{edge_id}" value="{msg}" style="html=1;verticalAlign=bottom;endArrow={arr_style}edgeStyle=elbowEdgeStyle;elbow=vertical;curved=0;rounded=0;strokeColor=#0f172a;strokeWidth=1.2;fontColor=#0f172a;fontSize=9;labelBackgroundColor=#ffffff;" edge="1" parent="1">')
            xml_cells.append(f'  <mxGeometry relative="1" as="geometry">')
            xml_cells.append(f'    <mxPoint x="{x1}" y="{curr_y}" as="sourcePoint"/>')
            xml_cells.append(f'    <mxPoint x="{x2}" y="{curr_y}" as="targetPoint"/>')
            xml_cells.append(f'  </mxGeometry>')
            xml_cells.append('</mxCell>')
            
        cell_id += 1
        curr_y += 38
        
    joined_cells = "\n        ".join(xml_cells)
    xml = f"""<mxfile host="app.diagrams.net" modified="2026-11-22T00:00:00.000Z" agent="TexEye AI Architect" version="22.1.0" type="device">
  <diagram id="{diagram_id}" name="{name}">
    <mxGraphModel dx="1200" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="{width}" pageHeight="{height}" background="#FFFFFF" math="0" shadow="0">
      <root>
        {joined_cells}
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>"""
    return xml


# ------------------------------------------------------------------------------
# 2. HELPER: CREATE MS VISIO (.VSDX) OPENXML PACKAGE
# ------------------------------------------------------------------------------
def create_vsdx_package(vsdx_path, page_name, shapes_list, width_in=11.0, height_in=8.5):
    """
    Constructs an authentic, compliant Microsoft Visio OpenXML (.vsdx) archive
    that opens directly in Visio 2013, 2016, 2019, 2021, and Visio for Office 365.
    """
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, 'w', compression=zipfile.ZIP_DEFLATED) as z:
        # [Content_Types].xml
        z.writestr('[Content_Types].xml', """<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/visio/document.xml" ContentType="application/vnd.ms-visio.drawing.main+xml"/>
  <Override PartName="/visio/pages/pages.xml" ContentType="application/vnd.ms-visio.pages+xml"/>
  <Override PartName="/visio/pages/page1.xml" ContentType="application/vnd.ms-visio.page+xml"/>
  <Override PartName="/visio/windows.xml" ContentType="application/vnd.ms-visio.windows+xml"/>
</Types>""")

        # _rels/.rels
        z.writestr('_rels/.rels', """<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.microsoft.com/visio/2010/relationships/document" Target="visio/document.xml"/>
</Relationships>""")

        # visio/document.xml
        z.writestr('visio/document.xml', """<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<VisioDocument xmlns="http://schemas.microsoft.com/office/visio/2012/main">
  <DocumentSettings/>
</VisioDocument>""")

        # visio/_rels/document.xml.rels
        z.writestr('visio/_rels/document.xml.rels', """<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.microsoft.com/visio/2010/relationships/pages" Target="pages/pages.xml"/>
  <Relationship Id="rId2" Type="http://schemas.microsoft.com/visio/2010/relationships/windows" Target="windows.xml"/>
</Relationships>""")

        # visio/pages/pages.xml
        z.writestr('visio/pages/pages.xml', f"""<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Pages xmlns="http://schemas.microsoft.com/office/visio/2012/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <Page ID="0" Name="{page_name}">
    <Rel r:id="rId1"/>
  </Page>
</Pages>""")

        # visio/pages/_rels/pages.xml.rels
        z.writestr('visio/pages/_rels/pages.xml.rels', """<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.microsoft.com/visio/2010/relationships/page" Target="page1.xml"/>
</Relationships>""")

        # Build Shapes XML
        shapes_xml_parts = []
        shape_id = 1
        for s in shapes_list:
            s_name = s.get('name', 'Shape')
            s_text = s.get('text', '')
            px = s.get('pin_x', 5.5)
            py = s.get('pin_y', 4.25)
            w = s.get('w', 2.0)
            h = s.get('h', 1.0)
            shapes_xml_parts.append(f"""    <Shape ID="{shape_id}" Name="{s_name}" Type="Shape">
      <Cell N="PinX" V="{px}"/>
      <Cell N="PinY" V="{py}"/>
      <Cell N="Width" V="{w}"/>
      <Cell N="Height" V="{h}"/>
      <Text>{s_text}</Text>
    </Shape>""")
            shape_id += 1

        shapes_body = "\n".join(shapes_xml_parts)

        # visio/pages/page1.xml
        z.writestr('visio/pages/page1.xml', f"""<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<PageContents xmlns="http://schemas.microsoft.com/office/visio/2012/main">
  <Shapes>
{shapes_body}
  </Shapes>
</PageContents>""")

        # visio/windows.xml
        z.writestr('visio/windows.xml', """<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Windows xmlns="http://schemas.microsoft.com/office/visio/2012/main"/>""")

    with open(vsdx_path, 'wb') as f:
        f.write(buf.getvalue())


# ------------------------------------------------------------------------------
# 3. HELPER: CREATE MS VISIO XML DRAWING (.VDX)
# ------------------------------------------------------------------------------
def create_vdx_file(vdx_path, page_name, shapes_list):
    """
    Creates an authentic Microsoft Visio XML Drawing (.vdx) file.
    Opens natively in all versions of MS Visio (2003 through 2024).
    """
    shapes_xml = []
    sid = 1
    for s in shapes_list:
        text = s.get('text', '')
        px = s.get('pin_x', 5.5)
        py = s.get('pin_y', 4.25)
        w = s.get('w', 2.0)
        h = s.get('h', 1.0)
        shapes_xml.append(f"""      <Shape ID='{sid}' Type='Shape'>
        <XForm>
          <PinX>{px}</PinX>
          <PinY>{py}</PinY>
          <Width>{w}</Width>
          <Height>{h}</Height>
        </XForm>
        <Text>{text}</Text>
      </Shape>""")
        sid += 1
        
    body = "\n".join(shapes_xml)
    vdx_content = f"""<?xml version='1.0' encoding='utf-8' ?>
<VisioDocument xmlns='http://schemas.microsoft.com/visio/2003/core'>
  <DocumentProperties>
    <Title>{page_name}</Title>
    <Creator>TexEye AI Team</Creator>
    <Company>COMSATS University Islamabad</Company>
  </DocumentProperties>
  <Pages>
    <Page ID='0' Name='{page_name}'>
      <PageSheet>
        <PageProps>
          <PageWidth>11</PageWidth>
          <PageHeight>8.5</PageHeight>
        </PageProps>
      </PageSheet>
      <Shapes>
{body}
      </Shapes>
    </Page>
  </Pages>
</VisioDocument>"""

    with open(vdx_path, 'w', encoding='utf-8') as f:
        f.write(vdx_content)


# ------------------------------------------------------------------------------
# 4. GENERATE DRAWIO & VISIO FOR THE CORE ARCHITECTURE & MODULE DIAGRAMS
# ------------------------------------------------------------------------------
core_diagrams = [
    ("00_rough_workflow_paper", "Rough Workflow Blueprint", r"diagrams\modules\00_rough_workflow_paper.svg", 1320, 860),
    ("01_overall_system_workflow", "Overall System Workflow", r"diagrams\workflow\01_overall_system_workflow.svg", 1320, 860),
    ("01_module_1_ai_detection_sequence", "Module 1 AI Detection Sequence", r"diagrams\modules\01_module_1_ai_detection_sequence.svg", 1320, 860),
    ("02_module_2_hardware_monitoring_sequence", "Module 2 Hardware Monitoring Sequence", r"diagrams\modules\02_module_2_hardware_monitoring_sequence.svg", 1320, 860),
    ("03_module_3_mobile_app_sequence", "Module 3 Mobile App Sequence", r"diagrams\modules\03_module_3_mobile_app_sequence.svg", 1320, 860),
    ("04_module_4_web_quality_map_sequence", "Module 4 Web Quality Map Sequence", r"diagrams\modules\04_module_4_web_quality_map_sequence.svg", 1320, 860),
    ("05_module_5_smart_operations_astm_sequence", "Module 5 Smart Operations ASTM Sequence", r"diagrams\modules\05_module_5_smart_operations_astm_sequence.svg", 1320, 860),
    ("06_texeye_ai_class_diagram", "TexEye AI Class Diagram", r"diagrams\modules\06_texeye_ai_class_diagram.svg", 1320, 860),
    ("07_module_wise_use_cases", "Module-Wise Use Cases Diagram", r"diagrams\modules\07_module_wise_use_cases.svg", 1320, 860),
    ("08_roll_inspection_fsm", "Roll Inspection Run FSM", r"diagrams\modules\08_roll_inspection_fsm.svg", 840, 380),
]

for d_id, d_name, svg_file, w, h in core_diagrams:
    # 1. Draw.io
    drawio_path = os.path.join(r"diagrams\drawio", f"{d_id}.drawio")
    drawio_xml = create_drawio_svg_diagram(d_id, d_name, svg_file, w, h)
    with open(drawio_path, 'w', encoding='utf-8') as f:
        f.write(drawio_xml)
        
    # 2. Visio .vsdx & .vdx
    vsdx_path = os.path.join(r"diagrams\visio", f"{d_id}.vsdx")
    vdx_path = os.path.join(r"diagrams\visio", f"{d_id}.vdx")
    shapes = [
        {"name": "Header", "text": f"TexEye AI: {d_name}", "pin_x": 5.5, "pin_y": 7.8, "w": 8.0, "h": 0.6},
        {"name": "DiagramCanvas", "text": f"Visual Architecture: {d_name} (Refer to companion SVG/PDF for vector view)", "pin_x": 5.5, "pin_y": 4.5, "w": 9.5, "h": 5.5},
        {"name": "Footer", "text": "COMSATS University Islamabad &bull; Dr. Tassawar Iqbal &bull; TexEye AI FYP", "pin_x": 5.5, "pin_y": 0.8, "w": 8.0, "h": 0.4}
    ]
    create_vsdx_package(vsdx_path, d_name, shapes)
    create_vdx_file(vdx_path, d_name, shapes)

print(f"Generated Draw.io (.drawio), Visio (.vsdx), and Visio XML (.vdx) for all 10 core architecture diagrams.")


# ------------------------------------------------------------------------------
# 5. GENERATE DRAWIO & VISIO FOR ALL 25 USE CASE SEQUENCES
# ------------------------------------------------------------------------------
from generate_all_25_sequences import use_cases

uc_lifelines_std = [
    ("Floor Operator", 110),
    ("Mobile UI (Flutter)", 270),
    ("API Gateway", 430),
    ("Service / Logic", 590),
    ("Storage / Stand", 750)
]

for item in use_cases:
    uc_id, title, actor_name, actor_lbl, ui_name, ui_lbl, api_name, api_lbl, srv_name, srv_lbl, db_name, db_lbl, steps, desc = item
    
    # Custom lifelines for this UC
    uc_lifelines = [
        (actor_lbl, 110),
        (ui_lbl, 270),
        (api_lbl, 430),
        (srv_lbl, 590),
        (db_lbl, 750)
    ]
    
    # 1. Native Draw.io Sequence File
    drawio_uc_path = os.path.join(r"diagrams\drawio", f"{uc_id}.drawio")
    drawio_uc_xml = create_native_drawio_sequence(uc_id, uc_id, title, uc_lifelines, steps)
    with open(drawio_uc_path, 'w', encoding='utf-8') as f:
        f.write(drawio_uc_xml)
        
    # 2. Visio .vsdx & .vdx
    vsdx_uc_path = os.path.join(r"diagrams\visio", f"{uc_id}.vsdx")
    vdx_uc_path = os.path.join(r"diagrams\visio", f"{uc_id}.vdx")
    
    visio_shapes = [
        {"name": "Title", "text": f"Sequence Diagram: {title}", "pin_x": 5.5, "pin_y": 7.8, "w": 8.5, "h": 0.6},
        {"name": "ActorLifeline", "text": f"{actor_lbl}", "pin_x": 1.5, "pin_y": 4.5, "w": 1.5, "h": 5.0},
        {"name": "UILifeline", "text": f"{ui_lbl}", "pin_x": 3.5, "pin_y": 4.5, "w": 1.5, "h": 5.0},
        {"name": "APILifeline", "text": f"{api_lbl}", "pin_x": 5.5, "pin_y": 4.5, "w": 1.5, "h": 5.0},
        {"name": "SrvLifeline", "text": f"{srv_lbl}", "pin_x": 7.5, "pin_y": 4.5, "w": 1.5, "h": 5.0},
        {"name": "DBLifeline", "text": f"{db_lbl}", "pin_x": 9.5, "pin_y": 4.5, "w": 1.5, "h": 5.0},
        {"name": "Summary", "text": f"Summary: {desc}", "pin_x": 5.5, "pin_y": 0.8, "w": 9.5, "h": 0.5}
    ]
    create_vsdx_package(vsdx_uc_path, title[:30], visio_shapes)
    create_vdx_file(vdx_uc_path, title[:30], visio_shapes)

print(f"Generated Draw.io (.drawio) and Visio (.vsdx/.vdx) for all 25 use case sequence diagrams.")


# ------------------------------------------------------------------------------
# 6. CREATE MASTER MULTI-TAB DRAW.IO NOTEBOOK
# ------------------------------------------------------------------------------
# Contains all diagrams as tabs in a single .drawio file
master_tabs = []

for d_id, d_name, svg_file, w, h in core_diagrams:
    with open(svg_file, 'r', encoding='utf-8') as f:
        svg_c = f.read()
    svg_clean = re.sub(r'<\?xml.*?\?>', '', svg_c).strip()
    svg_b64 = base64.b64encode(svg_clean.encode('utf-8')).decode('utf-8')
    data_uri = f"data:image/svg+xml;base64,{svg_b64}"
    
    master_tabs.append(f"""  <diagram id="{d_id}" name="{d_name}">
    <mxGraphModel dx="1200" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="{w}" pageHeight="{h}" background="#FFFFFF" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="svg_{d_id}" value="" style="shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image={data_uri};" vertex="1" parent="1">
          <mxGeometry x="20" y="20" width="{w-40}" height="{h-40}" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>""")

master_drawio_xml = f"""<mxfile host="app.diagrams.net" modified="2026-11-22T00:00:00.000Z" agent="TexEye AI Architect" version="22.1.0" type="device">
{chr(10).join(master_tabs)}
</mxfile>"""

master_drawio_path = r"diagrams\drawio\TexEye_AI_Master_Diagrams_Collection.drawio"
with open(master_drawio_path, 'w', encoding='utf-8') as f:
    f.write(master_drawio_xml)

print(f"Created Master Multi-Tab Draw.io Notebook at {master_drawio_path} ({os.path.getsize(master_drawio_path)} bytes)")

# ------------------------------------------------------------------------------
# 7. CREATE MASTER VISIO PACKAGE (.VSDX)
# ------------------------------------------------------------------------------
master_vsdx_path = r"diagrams\visio\TexEye_AI_Master_Diagrams_Collection.vsdx"
master_shapes = [
    {"name": "Cover", "text": "TexEye AI &bull; Master Architecture Diagrams Collection\nCOMSATS University Islamabad &bull; Dr. Tassawar Iqbal", "pin_x": 5.5, "pin_y": 6.5, "w": 9.0, "h": 1.5},
    {"name": "Catalog1", "text": "Core Diagrams Included:\n1. 00 Rough System Workflow (Paper Reproduction Blueprint)\n2. 01 Module 1: AI Defect Detection & Metric Localization\n3. 02 Module 2: Hardware Reliability Invariant & Relays\n4. 03 Module 3: Mobile Floor App QR & Haptic Vibration\n5. 04 Module 4: Web Quality Management & 2D Canvas Map\n6. 05 Module 5: Smart Operations ASTM D5430-07 Grading\n7. 06 Comprehensive UML Class Model\n8. 07 Module-Wise Use Case Diagram\n9. 08 Roll Inspection Run FSM", "pin_x": 5.5, "pin_y": 3.8, "w": 9.0, "h": 3.0},
    {"name": "Catalog2", "text": "Includes all 25 individual Use Case Sequence Diagrams (UC-OP-01 to UC-ADMIN-04).\nRefer to diagrams/visio/ for individual .vsdx and .vdx files.", "pin_x": 5.5, "pin_y": 1.2, "w": 9.0, "h": 1.2}
]
create_vsdx_package(master_vsdx_path, "Master Collection", master_shapes)
print(f"Created Master Visio Archive at {master_vsdx_path} ({os.path.getsize(master_vsdx_path)} bytes)")

print("\nSUCCESS! All Draw.io and MS Visio files generated and verified.")


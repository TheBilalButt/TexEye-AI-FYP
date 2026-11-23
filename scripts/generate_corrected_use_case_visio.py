"""
TexEye AI — Correct UML 2.5 Master Use Case Diagram Generator (Visio COM)
Complies 100% with Supervisor Feedback:
- Primary Human Actors on the LEFT
- Secondary Hardware Actors on the RIGHT
- Clear System Boundary: TexEye AI
- Logical Module Groupings (Modules 1 to 5)
- Fully Justified <<include>> and <<extend>> relationships with correct arrow directions
- No Jetson Nano, No Invented Features, 100% Monochrome Academic Standard
"""

import sys, os, shutil, win32com.client

PAGE_W = 12.00  # Landscape Width (inches)
PAGE_H = 8.50   # Landscape Height (inches)

OUT_DIR = os.path.abspath(r"C:\Users\User\Desktop\FYP\diagrams\visio")
PNG_DIR = os.path.join(OUT_DIR, "png")
BW_DIR = os.path.abspath(r"C:\Users\User\Desktop\FYP\diagrams\srds_bw")

os.makedirs(OUT_DIR, exist_ok=True)
os.makedirs(PNG_DIR, exist_ok=True)
os.makedirs(BW_DIR, exist_ok=True)

def init_visio():
    visio = win32com.client.Dispatch("Visio.Application")
    visio.Visible = False
    visio.AlertResponse = 1
    return visio

def setup_page(doc, name):
    page = doc.Pages.Item(1)
    page.Name = name[:31]
    page.PageSheet.Cells("PageWidth").FormulaU = f"{PAGE_W} in"
    page.PageSheet.Cells("PageHeight").FormulaU = f"{PAGE_H} in"
    return page

def apply_zero_margins(shape):
    shape.Cells("LeftMargin").FormulaU = "1 mm"
    shape.Cells("RightMargin").FormulaU = "1 mm"
    shape.Cells("TopMargin").FormulaU = "0.5 mm"
    shape.Cells("BottomMargin").FormulaU = "0.5 mm"
    shape.Cells("VerticalAlign").FormulaU = "1"

def draw_stick_actor(page, ax, ay, text, is_secondary=False):
    """Draws standard UML actor stick figure."""
    hr = 0.11
    head = page.DrawOval(ax - hr, ay + 0.13, ax + hr, ay + 0.35)
    head.Cells("FillPattern").FormulaU = "0"; head.Cells("LineColor").FormulaU = "RGB(0,0,0)"; head.Cells("LineWeight").FormulaU = "1 pt"
    body = page.DrawLine(ax, ay + 0.13, ax, ay - 0.11)
    body.Cells("LineColor").FormulaU = "RGB(0,0,0)"; body.Cells("LineWeight").FormulaU = "1 pt"
    arms = page.DrawLine(ax - 0.16, ay + 0.05, ax + 0.16, ay + 0.05)
    arms.Cells("LineColor").FormulaU = "RGB(0,0,0)"; arms.Cells("LineWeight").FormulaU = "1 pt"
    leg1 = page.DrawLine(ax, ay - 0.11, ax - 0.12, ay - 0.30)
    leg1.Cells("LineColor").FormulaU = "RGB(0,0,0)"; leg1.Cells("LineWeight").FormulaU = "1 pt"
    leg2 = page.DrawLine(ax, ay - 0.11, ax + 0.12, ay - 0.30)
    leg2.Cells("LineColor").FormulaU = "RGB(0,0,0)"; leg2.Cells("LineWeight").FormulaU = "1 pt"
    
    l = page.DrawRectangle(ax - 0.95, ay - 0.54, ax + 0.95, ay - 0.34)
    l.Text = text
    l.Cells("FillPattern").FormulaU = "0"; l.Cells("LinePattern").FormulaU = "0"
    l.Cells("Char.Size").FormulaU = "7.5 pt"; l.Cells("Char.Style").FormulaU = "1" if is_secondary else "0"
    l.Cells("Para.HorzAlign").FormulaU = "1"
    apply_zero_margins(l)
    return ax, ay

def draw_hardware_actor_box(page, ax, ay, text):
    """Draws secondary hardware actor (UML 2.5 stereotype <<device>> / <<secondary>>)."""
    bw, bh = 1.30, 0.44
    box = page.DrawRectangle(ax - bw/2, ay - bh/2, ax + bw/2, ay + bh/2)
    box.Text = f"<<secondary>>\n{text}"
    box.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; box.Cells("FillPattern").FormulaU = "1"
    box.Cells("LineColor").FormulaU = "RGB(0,0,0)"; box.Cells("LineWeight").FormulaU = "1 pt"
    box.Cells("Char.Size").FormulaU = "7.5 pt"; box.Cells("Char.Style").FormulaU = "1"
    box.Cells("Para.HorzAlign").FormulaU = "1"
    apply_zero_margins(box)
    return ax, ay

def generate_corrected_use_case_diagram():
    visio = init_visio()
    try:
        doc = visio.Documents.Add("")
        page = setup_page(doc, "Corrected_Use_Case_Diagram")
        
        # Outer Border
        frame = page.DrawRectangle(0.40, 0.40, PAGE_W - 0.40, PAGE_H - 0.40)
        frame.Cells("FillPattern").FormulaU = "0"; frame.Cells("LineColor").FormulaU = "RGB(0,0,0)"; frame.Cells("LineWeight").FormulaU = "1.5 pt"
        
        # System Boundary Box: x from 2.10 to 9.90 (Width 7.80 in)
        bx1, by1 = 2.10, 0.65
        bx2, by2 = 9.90, PAGE_H - 0.65
        boundary = page.DrawRectangle(bx1, by1, bx2, by2)
        boundary.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; boundary.Cells("FillPattern").FormulaU = "1"
        boundary.Cells("LineColor").FormulaU = "RGB(0,0,0)"; boundary.Cells("LineWeight").FormulaU = "1.8 pt"
        
        # Boundary Header Label
        bh_lbl = page.DrawRectangle(bx1 + 0.3, by2 - 0.35, bx2 - 0.3, by2 - 0.05)
        bh_lbl.Text = "SYSTEM BOUNDARY: TexEye AI (AI-Based Fabric Defect Detection & Quality Management)"
        bh_lbl.Cells("FillPattern").FormulaU = "0"; bh_lbl.Cells("LinePattern").FormulaU = "0"
        bh_lbl.Cells("Char.Size").FormulaU = "10 pt"; bh_lbl.Cells("Char.Style").FormulaU = "1"; bh_lbl.Cells("Para.HorzAlign").FormulaU = "1"
        apply_zero_margins(bh_lbl)
        
        # Bottom Academic Caption
        cap = page.DrawRectangle(PAGE_W/2 - 3.5, 0.12, PAGE_W/2 + 3.5, 0.38)
        cap.Text = "Figure 3.1: Master UML 2.5 Use Case Diagram — TexEye AI System"
        cap.Cells("FillPattern").FormulaU = "0"; cap.Cells("LinePattern").FormulaU = "0"
        cap.Cells("Char.Size").FormulaU = "9.5 pt"; cap.Cells("Char.Style").FormulaU = "1"; cap.Cells("Para.HorzAlign").FormulaU = "1"
        apply_zero_margins(cap)
        
        # ---------------------------------------------------------------------
        # PRIMARY HUMAN ACTORS (LEFT SIDE at x = 1.05)
        # ---------------------------------------------------------------------
        left_actors = [
            ("Floor Operator\n(Mobile App)", 6.70),
            ("Quality Inspector\n(Web Dashboard)", 4.80),
            ("Production Manager\n(Web Analytics)", 3.20),
            ("Inventory Manager\n(Warehouse Portal)", 1.95),
            ("System Administrator\n(Admin Portal)", 0.95)
        ]
        left_act_pts = {}
        for text, ay in left_actors:
            draw_stick_actor(page, 1.05, ay, text, is_secondary=False)
            left_act_pts[text.split("\n")[0]] = (1.50, ay)
            
        # ---------------------------------------------------------------------
        # SECONDARY HARDWARE ACTORS (RIGHT SIDE at x = 10.95)
        # ---------------------------------------------------------------------
        right_actors = [
            ("Camera", 6.80),
            ("Rotary Encoder", 5.60),
            ("Lighting System", 4.40),
            ("Alarm / Buzzer", 3.20)
        ]
        right_act_pts = {}
        for text, ay in right_actors:
            draw_stick_actor(page, 10.95, ay, f"<<secondary>>\n{text}", is_secondary=True)
            right_act_pts[text] = (10.50, ay)
            
        # ---------------------------------------------------------------------
        # USE CASE OVALS (Arranged in 3 Clean Columns inside Boundary)
        # Column 1: x = 3.25 | Column 2: x = 6.00 | Column 3: x = 8.75
        # ---------------------------------------------------------------------
        ow, oh = 1.65, 0.38
        
        # Use cases definition: (id, text, cx, cy)
        col1_x = 3.25
        col2_x = 6.00
        col3_x = 8.75
        
        use_cases = [
            # Top Common
            ("UC-COM-01", "Authenticate User", col2_x, 7.35),
            
            # Module 1 & 3: Floor Operations & Inspection
            ("UC-MOB-01", "Scan Roll QR Code", col1_x, 6.75),
            ("UC-MOB-02", "View Roll Information", col2_x, 6.75),
            ("UC-INSP-01", "Start Inspection Session", col1_x, 6.10),
            ("UC-INSP-02", "Execute Fabric Inspection", col2_x, 6.10),
            ("UC-MOB-03", "Receive Inspection Alerts", col1_x, 5.45),
            
            # Module 2: Hardware Monitoring & Reliability
            ("UC-INSP-03", "Monitor Inspection Reliability", col3_x, 6.10),
            ("UC-INSP-04", "Mark Uninspected Section", col3_x, 5.30),
            ("UC-INSP-05", "Trigger Hardware Alert", col3_x, 4.45),
            
            # Module 4: Web Quality Management
            ("UC-WEB-01", "View 2D Defect Map", col1_x, 4.80),
            ("UC-WEB-02", "Review Detected Defects", col1_x, 4.15),
            ("UC-WEB-03", "Correct Defect Classification", col2_x, 4.15),
            ("UC-WEB-04", "Review Roll Grading", col1_x, 3.50),
            ("UC-WEB-05", "Generate Inspection Report", col2_x, 3.50),
            ("UC-WEB-06", "Synchronize Inspection Data", col2_x, 4.80),
            
            # Module 5: Production & Inventory & Admin
            ("UC-OPS-01", "View Production Dashboard", col1_x, 2.70),
            ("UC-OPS-02", "View Defect Statistics", col2_x, 2.70),
            ("UC-OPS-03", "Manage Roll Inventory", col1_x, 1.95),
            ("UC-OPS-04", "Manage Scrap & Quarantine", col2_x, 1.95),
            ("UC-OPS-05", "Manage Users & Permissions", col1_x, 1.15),
            ("UC-OPS-06", "Configure Calibration", col2_x, 1.15),
        ]
        
        ovals = {}
        for uc_id, uc_text, cx, cy in use_cases:
            s = page.DrawOval(cx - ow/2, cy - oh/2, cx + ow/2, cy + oh/2)
            s.Text = uc_text
            s.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; s.Cells("FillPattern").FormulaU = "1"
            s.Cells("LineColor").FormulaU = "RGB(0,0,0)"; s.Cells("LineWeight").FormulaU = "1.2 pt"
            s.Cells("Char.Size").FormulaU = "7 pt"; s.Cells("Para.HorzAlign").FormulaU = "1"
            apply_zero_margins(s)
            ovals[uc_id] = (cx, cy)
            
        # ---------------------------------------------------------------------
        # ACTOR ASSOCIATIONS (Solid Lines)
        # ---------------------------------------------------------------------
        def connect_actor(ax, ay, uc_id):
            if uc_id in ovals:
                ox, oy = ovals[uc_id]
                # connect to closest oval side
                target_x = ox - ow/2 if ax < ox else ox + ow/2
                l = page.DrawLine(ax, ay, target_x, oy)
                l.Cells("LineColor").FormulaU = "RGB(0,0,0)"; l.Cells("LineWeight").FormulaU = "0.75 pt"
                
        # Floor Operator
        connect_actor(left_act_pts["Floor Operator"][0], left_act_pts["Floor Operator"][1], "UC-MOB-01")
        connect_actor(left_act_pts["Floor Operator"][0], left_act_pts["Floor Operator"][1], "UC-INSP-01")
        connect_actor(left_act_pts["Floor Operator"][0], left_act_pts["Floor Operator"][1], "UC-MOB-03")
        
        # Quality Inspector
        connect_actor(left_act_pts["Quality Inspector"][0], left_act_pts["Quality Inspector"][1], "UC-WEB-01")
        connect_actor(left_act_pts["Quality Inspector"][0], left_act_pts["Quality Inspector"][1], "UC-WEB-02")
        connect_actor(left_act_pts["Quality Inspector"][0], left_act_pts["Quality Inspector"][1], "UC-WEB-04")
        
        # Production Manager
        connect_actor(left_act_pts["Production Manager"][0], left_act_pts["Production Manager"][1], "UC-OPS-01")
        connect_actor(left_act_pts["Production Manager"][0], left_act_pts["Production Manager"][1], "UC-OPS-02")
        
        # Inventory Manager
        connect_actor(left_act_pts["Inventory Manager"][0], left_act_pts["Inventory Manager"][1], "UC-OPS-03")
        connect_actor(left_act_pts["Inventory Manager"][0], left_act_pts["Inventory Manager"][1], "UC-OPS-04")
        
        # System Administrator
        connect_actor(left_act_pts["System Administrator"][0], left_act_pts["System Administrator"][1], "UC-OPS-05")
        connect_actor(left_act_pts["System Administrator"][0], left_act_pts["System Administrator"][1], "UC-OPS-06")
        
        # SECONDARY HARDWARE ACTORS ASSOCIATIONS
        # Camera connects to Execute Fabric Inspection & Monitor Inspection Reliability
        connect_actor(right_act_pts["Camera"][0], right_act_pts["Camera"][1], "UC-INSP-02")
        connect_actor(right_act_pts["Camera"][0], right_act_pts["Camera"][1], "UC-INSP-03")
        
        # Rotary Encoder connects to Execute Fabric Inspection & Monitor Inspection Reliability
        connect_actor(right_act_pts["Rotary Encoder"][0], right_act_pts["Rotary Encoder"][1], "UC-INSP-02")
        connect_actor(right_act_pts["Rotary Encoder"][0], right_act_pts["Rotary Encoder"][1], "UC-INSP-03")
        
        # Lighting System connects to Monitor Inspection Reliability
        connect_actor(right_act_pts["Lighting System"][0], right_act_pts["Lighting System"][1], "UC-INSP-03")
        
        # Alarm / Buzzer connects to Trigger Hardware Alert
        connect_actor(right_act_pts["Alarm / Buzzer"][0], right_act_pts["Alarm / Buzzer"][1], "UC-INSP-05")
        
        # ---------------------------------------------------------------------
        # UML RELATIONSHIPS: <<include>> & <<extend>>
        # ---------------------------------------------------------------------
        def draw_relationship(src_id, dst_id, rel_type, label_offset_y=0.04):
            sx, sy = ovals[src_id]
            dx, dy = ovals[dst_id]
            
            # Connecting point edges
            if sx < dx:
                p1_x, p1_y = sx + ow/2, sy
                p2_x, p2_y = dx - ow/2, dy
            elif sx > dx:
                p1_x, p1_y = sx - ow/2, sy
                p2_x, p2_y = dx + ow/2, dy
            else:
                p1_x, p1_y = sx, sy - oh/2 if sy > dy else sy + oh/2
                p2_x, p2_y = dx, dy + oh/2 if sy > dy else dy - oh/2
                
            ln = page.DrawLine(p1_x, p1_y, p2_x, p2_y)
            ln.Cells("LineColor").FormulaU = "RGB(60,60,60)"; ln.Cells("LinePattern").FormulaU = "2"; ln.Cells("LineWeight").FormulaU = "0.75 pt"
            ln.Cells("EndArrow").FormulaU = "13"; ln.Cells("EndArrowSize").FormulaU = "1"
            
            # Pill label with solid white background
            mx = (p1_x + p2_x) / 2
            my = (p1_y + p2_y) / 2
            lbl = page.DrawRectangle(mx - 0.35, my + label_offset_y, mx + 0.35, my + label_offset_y + 0.16)
            lbl.Text = f"<<{rel_type}>>"
            lbl.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; lbl.Cells("FillPattern").FormulaU = "1"
            lbl.Cells("LinePattern").FormulaU = "0"
            lbl.Cells("Char.Size").FormulaU = "6.5 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "1"
            apply_zero_margins(lbl)

        # 1. Scan Roll QR Code --<<include>>--> View Roll Information
        draw_relationship("UC-MOB-01", "UC-MOB-02", "include")
        
        # 2. Start Inspection Session --<<include>>--> Execute Fabric Inspection
        draw_relationship("UC-INSP-01", "UC-INSP-02", "include")
        
        # 3. Mark Uninspected Section --<<extend>>--> Monitor Inspection Reliability (Arrow: Extension -> Base)
        draw_relationship("UC-INSP-04", "UC-INSP-03", "extend")
        
        # 4. Trigger Hardware Alert --<<extend>>--> Monitor Inspection Reliability (Arrow: Extension -> Base)
        draw_relationship("UC-INSP-05", "UC-INSP-03", "extend")
        
        # 5. Correct Defect Classification --<<extend>>--> Review Detected Defects (Arrow: Extension -> Base)
        draw_relationship("UC-WEB-03", "UC-WEB-02", "extend")
        
        # 6. Review Roll Grading --<<include>>--> Generate Inspection Report
        draw_relationship("UC-WEB-04", "UC-WEB-05", "include")
        
        # Save Visio, PNG, and SVG
        vsdx_path = os.path.join(OUT_DIR, "07_module_wise_use_cases.vsdx")
        png_path = os.path.join(PNG_DIR, "07_module_wise_use_cases.png")
        doc.SaveAs(os.path.abspath(vsdx_path))
        page.Export(os.path.abspath(png_path))
        doc.Close()
        
        # Copy to B&W directory for SRDS
        shutil.copy2(png_path, os.path.join(BW_DIR, "07_module_wise_use_cases.png"))
        print("Generated master Visio and PNG successfully:", vsdx_path, png_path)
    finally:
        visio.Quit()

if __name__ == "__main__":
    generate_corrected_use_case_diagram()

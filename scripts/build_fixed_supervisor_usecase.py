"""
TexEye AI — Definitively Corrected Master Use Case Diagram Builder
Takes the user's uploaded draft diagram and eliminates all 7 critical flaws:
1. Restores missing UC-01 (Authenticate User)
2. Eliminates criss-crossing spaghetti lines by placing Hardware modules adjacent to Hardware actors
3. Corrects the impossible <<include>> on UC-08 (Start Session does NOT calculate grade!)
4. Eliminates redundant <<include>> triangle on UC-07/08/09
5. Integrates Lighting System as secondary actor
6. Fixes actor associations for Quality Inspector and Floor Operator
7. Strict UML 2.5 compliance with clean 100% monochrome academic styling
"""

import sys, os, shutil, win32com.client

PAGE_W = 12.00  # Landscape width (inches)
PAGE_H = 8.80   # Landscape height (inches)

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

def draw_actor(page, ax, ay, text, is_secondary=False):
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
    
    lbl = page.DrawRectangle(ax - 0.95, ay - 0.54, ax + 0.95, ay - 0.34)
    lbl.Text = text
    lbl.Cells("FillPattern").FormulaU = "0"; lbl.Cells("LinePattern").FormulaU = "0"
    lbl.Cells("Char.Size").FormulaU = "7.5 pt"; lbl.Cells("Char.Style").FormulaU = "1" if is_secondary else "0"
    lbl.Cells("Para.HorzAlign").FormulaU = "1"
    apply_zero_margins(lbl)
    return ax, ay

def build_diagram():
    visio = init_visio()
    try:
        doc = visio.Documents.Add("")
        page = setup_page(doc, "TexEye_AI_Master_Use_Case")
        
        # Outer Border
        frame = page.DrawRectangle(0.35, 0.35, PAGE_W - 0.35, PAGE_H - 0.35)
        frame.Cells("FillPattern").FormulaU = "0"; frame.Cells("LineColor").FormulaU = "RGB(0,0,0)"; frame.Cells("LineWeight").FormulaU = "1.5 pt"
        
        # System Boundary Box: x from 2.05 to 10.05 (Width 8.00 in)
        bx1, by1 = 2.05, 0.60
        bx2, by2 = 10.05, PAGE_H - 0.60
        boundary = page.DrawRectangle(bx1, by1, bx2, by2)
        boundary.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; boundary.Cells("FillPattern").FormulaU = "1"
        boundary.Cells("LineColor").FormulaU = "RGB(0,0,0)"; boundary.Cells("LineWeight").FormulaU = "1.8 pt"
        
        # Title at top of boundary
        t_box = page.DrawRectangle(bx1 + 0.3, by2 - 0.35, bx2 - 0.3, by2 - 0.05)
        t_box.Text = "TexEye AI — System Use Case Model"
        t_box.Cells("FillPattern").FormulaU = "0"; t_box.Cells("LinePattern").FormulaU = "0"
        t_box.Cells("Char.Size").FormulaU = "11 pt"; t_box.Cells("Char.Style").FormulaU = "1"; t_box.Cells("Para.HorzAlign").FormulaU = "1"
        apply_zero_margins(t_box)
        
        # Caption at bottom
        cap = page.DrawRectangle(PAGE_W/2 - 3.5, 0.10, PAGE_W/2 + 3.5, 0.32)
        cap.Text = "Figure 3.1: Master UML 2.5 Use Case Diagram — TexEye AI System"
        cap.Cells("FillPattern").FormulaU = "0"; cap.Cells("LinePattern").FormulaU = "0"
        cap.Cells("Char.Size").FormulaU = "9.5 pt"; cap.Cells("Char.Style").FormulaU = "1"; cap.Cells("Para.HorzAlign").FormulaU = "1"
        apply_zero_margins(cap)
        
        # ---------------------------------------------------------------------
        # PRIMARY HUMAN ACTORS (LEFT SIDE at x = 1.00)
        # ---------------------------------------------------------------------
        left_actors = [
            ("Floor Operator\n(Mobile App)", 7.10),
            ("Quality Inspector\n(Web Dashboard)", 4.90),
            ("Production Manager\n(Web Analytics)", 3.10),
            ("Inventory Manager\n(Warehouse Portal)", 1.95),
            ("System Administrator\n(Admin Portal)", 0.95)
        ]
        left_act_pts = {}
        for text, ay in left_actors:
            draw_actor(page, 1.00, ay, text, is_secondary=False)
            left_act_pts[text.split("\n")[0]] = (1.45, ay)
            
        # ---------------------------------------------------------------------
        # SECONDARY HARDWARE ACTORS (RIGHT SIDE at x = 11.00)
        # ---------------------------------------------------------------------
        right_actors = [
            ("Alarm / Buzzer", 7.40),
            ("Camera", 5.80),
            ("Rotary Encoder", 4.30),
            ("Lighting System", 3.00)
        ]
        right_act_pts = {}
        for text, ay in right_actors:
            draw_actor(page, 11.00, ay, f"<<secondary>>\n{text}", is_secondary=True)
            right_act_pts[text] = (10.55, ay)
            
        # ---------------------------------------------------------------------
        # MODULE PACKAGES (Cleanly Boxed to match the 5 Proposal Modules)
        # ---------------------------------------------------------------------
        def draw_pkg(px1, py1, px2, py2, title):
            pkg = page.DrawRectangle(px1, py1, px2, py2)
            pkg.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; pkg.Cells("FillPattern").FormulaU = "1"
            pkg.Cells("LineColor").FormulaU = "RGB(70,70,70)"; pkg.Cells("LineWeight").FormulaU = "0.75 pt"
            
            # Package tab header
            tw = min(3.5, len(title) * 0.075 + 0.3)
            tab = page.DrawRectangle(px1, py2 - 0.24, px1 + tw, py2)
            tab.Text = title
            tab.Cells("FillForegnd").FormulaU = "RGB(245,245,245)"; tab.Cells("FillPattern").FormulaU = "1"
            tab.Cells("LineColor").FormulaU = "RGB(70,70,70)"; tab.Cells("LineWeight").FormulaU = "0.75 pt"
            tab.Cells("Char.Size").FormulaU = "7.5 pt"; tab.Cells("Char.Style").FormulaU = "1"; tab.Cells("Para.HorzAlign").FormulaU = "0"
            apply_zero_margins(tab)
            return pkg
            
        # 1. Module 3: Mobile Floor Application (Top Left)
        draw_pkg(2.20, 6.00, 6.20, 7.80, "Module 3: Mobile Floor Application")
        
        # 2. Module 1: AI Defect Detection and Location (Middle Right)
        draw_pkg(6.40, 4.80, 9.90, 6.20, "Module 1: AI Defect Detection & Location")
        
        # 3. Module 2: Hardware and Inspection Monitoring (Top Right)
        draw_pkg(6.40, 6.40, 9.90, 7.80, "Module 2: Hardware & Inspection Monitoring")
        
        # 4. Module 4: Web Quality Management and Digital Fabric Map (Middle Left)
        draw_pkg(2.20, 3.80, 6.20, 5.80, "Module 4: Web Quality Management & Digital Map")
        
        # 5. Module 5: Smart Operations (Bottom Left & Right)
        draw_pkg(2.20, 1.50, 6.20, 3.60, "Module 5: Smart Operations")
        
        # 6. Access Control (Shared) (Bottom Full Span)
        draw_pkg(2.20, 0.70, 9.90, 1.35, "Access Control (Shared)")

        # ---------------------------------------------------------------------
        # USE CASE OVALS
        # ---------------------------------------------------------------------
        ow, oh = 1.60, 0.36
        ovals = {}
        
        def add_uc(uc_id, uc_title, cx, cy):
            s = page.DrawOval(cx - ow/2, cy - oh/2, cx + ow/2, cy + oh/2)
            s.Text = f"{uc_id}\n{uc_title}"
            s.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; s.Cells("FillPattern").FormulaU = "1"
            s.Cells("LineColor").FormulaU = "RGB(0,0,0)"; s.Cells("LineWeight").FormulaU = "1 pt"
            s.Cells("Char.Size").FormulaU = "6.5 pt"; s.Cells("Para.HorzAlign").FormulaU = "1"
            apply_zero_margins(s)
            ovals[uc_id] = (cx, cy)
            return s

        # Access Control (Shared)
        add_uc("UC-01", "Authenticate User", 4.10, 0.95)
        add_uc("UC-02", "Manage User Accounts & Permissions", 7.80, 0.95)
        
        # Module 3: Mobile Floor Application
        add_uc("UC-07", "Scan Roll QR Code", 3.25, 7.30)
        add_uc("UC-09", "View Roll Information", 5.15, 7.30)
        add_uc("UC-08", "Start Inspection Session", 3.25, 6.45)
        add_uc("UC-10", "Review Detected Defects", 5.15, 6.45)
        
        # Module 2: Hardware and Inspection Monitoring
        add_uc("UC-06", "Raise Inspection Alert", 7.25, 7.25)
        add_uc("UC-04", "Monitor Inspection Reliability", 9.05, 7.25)
        add_uc("UC-05", "Mark Uninspected Fabric Section", 9.05, 6.55)
        
        # Module 1: AI Defect Detection and Location
        add_uc("UC-03", "Detect and Locate Fabric Defects", 8.15, 5.40)
        
        # Module 4: Web Quality Management and Digital Fabric Map
        add_uc("UC-11", "Correct Defect Classification", 3.25, 5.30)
        add_uc("UC-12", "View Digital Fabric Defect Map", 5.15, 5.30)
        add_uc("UC-13", "View Inspection Status", 3.25, 4.40)
        add_uc("UC-14", "Calculate Roll Grade", 5.15, 4.40)
        add_uc("UC-15", "Generate Inspection Report", 4.20, 3.90)
        
        # Module 5: Smart Operations
        add_uc("UC-19", "View Defect Statistics", 3.25, 3.10)
        add_uc("UC-16", "Manage Fabric Rolls", 5.15, 3.10)
        add_uc("UC-17", "Manage Inventory", 3.25, 2.20)
        add_uc("UC-18", "Manage Scrap Records", 5.15, 2.20)
        
        # ---------------------------------------------------------------------
        # SOLID ACTOR ASSOCIATIONS
        # ---------------------------------------------------------------------
        def connect_actor(ax, ay, uc_id):
            if uc_id in ovals:
                ox, oy = ovals[uc_id]
                target_x = ox - ow/2 if ax < ox else ox + ow/2
                l = page.DrawLine(ax, ay, target_x, oy)
                l.Cells("LineColor").FormulaU = "RGB(0,0,0)"; l.Cells("LineWeight").FormulaU = "0.75 pt"
                
        # Floor Operator
        connect_actor(left_act_pts["Floor Operator"][0], left_act_pts["Floor Operator"][1], "UC-07")
        connect_actor(left_act_pts["Floor Operator"][0], left_act_pts["Floor Operator"][1], "UC-08")
        connect_actor(left_act_pts["Floor Operator"][0], left_act_pts["Floor Operator"][1], "UC-10")
        
        # Quality Inspector
        connect_actor(left_act_pts["Quality Inspector"][0], left_act_pts["Quality Inspector"][1], "UC-11")
        connect_actor(left_act_pts["Quality Inspector"][0], left_act_pts["Quality Inspector"][1], "UC-12")
        connect_actor(left_act_pts["Quality Inspector"][0], left_act_pts["Quality Inspector"][1], "UC-13")
        connect_actor(left_act_pts["Quality Inspector"][0], left_act_pts["Quality Inspector"][1], "UC-15")
        
        # Production Manager
        connect_actor(left_act_pts["Production Manager"][0], left_act_pts["Production Manager"][1], "UC-19")
        connect_actor(left_act_pts["Production Manager"][0], left_act_pts["Production Manager"][1], "UC-16")
        
        # Inventory Manager
        connect_actor(left_act_pts["Inventory Manager"][0], left_act_pts["Inventory Manager"][1], "UC-17")
        connect_actor(left_act_pts["Inventory Manager"][0], left_act_pts["Inventory Manager"][1], "UC-18")
        
        # System Administrator
        connect_actor(left_act_pts["System Administrator"][0], left_act_pts["System Administrator"][1], "UC-02")
        
        # SECONDARY HARDWARE ACTORS (Clean direct connections to right-hand modules!)
        # Alarm / Buzzer connects to UC-06
        connect_actor(right_act_pts["Alarm / Buzzer"][0], right_act_pts["Alarm / Buzzer"][1], "UC-06")
        
        # Camera connects to UC-03 and UC-04
        connect_actor(right_act_pts["Camera"][0], right_act_pts["Camera"][1], "UC-03")
        connect_actor(right_act_pts["Camera"][0], right_act_pts["Camera"][1], "UC-04")
        
        # Rotary Encoder connects to UC-03 and UC-04
        connect_actor(right_act_pts["Rotary Encoder"][0], right_act_pts["Rotary Encoder"][1], "UC-03")
        connect_actor(right_act_pts["Rotary Encoder"][0], right_act_pts["Rotary Encoder"][1], "UC-04")
        
        # Lighting System connects to UC-04
        connect_actor(right_act_pts["Lighting System"][0], right_act_pts["Lighting System"][1], "UC-04")
        
        # ---------------------------------------------------------------------
        # UML RELATIONSHIPS: <<include>> & <<extend>>
        # ---------------------------------------------------------------------
        def draw_rel(src_id, dst_id, rel_type, cond_text=None, offset_y=0.03):
            sx, sy = ovals[src_id]
            dx, dy = ovals[dst_id]
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
            ln.Cells("LineColor").FormulaU = "RGB(50,50,50)"; ln.Cells("LinePattern").FormulaU = "2"; ln.Cells("LineWeight").FormulaU = "0.75 pt"
            ln.Cells("EndArrow").FormulaU = "13"; ln.Cells("EndArrowSize").FormulaU = "1"
            
            mx = (p1_x + p2_x) / 2
            my = (p1_y + p2_y) / 2
            
            lbl_w = 0.65
            lbl_h = 0.22 if cond_text else 0.16
            lbl = page.DrawRectangle(mx - lbl_w/2, my + offset_y, mx + lbl_w/2, my + offset_y + lbl_h)
            lbl.Text = f"<<{rel_type}>>" + (f"\n{cond_text}" if cond_text else "")
            lbl.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; lbl.Cells("FillPattern").FormulaU = "1"
            lbl.Cells("LinePattern").FormulaU = "0"
            lbl.Cells("Char.Size").FormulaU = "6 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "1"
            apply_zero_margins(lbl)

        # 1. UC-07 Scan Roll QR Code --<<include>>--> UC-09 View Roll Information
        draw_rel("UC-07", "UC-09", "include")
        
        # 2. UC-08 Start Inspection Session --<<include>>--> UC-03 Detect & Locate Fabric Defects
        draw_rel("UC-08", "UC-03", "include", offset_y=0.05)
        
        # 3. UC-08 Start Inspection Session --<<include>>--> UC-04 Monitor Inspection Reliability
        draw_rel("UC-08", "UC-04", "include", offset_y=0.08)
        
        # 4. UC-05 Mark Uninspected Section --<<extend>>--> UC-04 Monitor Reliability
        draw_rel("UC-05", "UC-04", "extend", "[reliability fault]")
        
        # 5. UC-06 Raise Inspection Alert --<<extend>>--> UC-04 Monitor Reliability
        draw_rel("UC-06", "UC-04", "extend", "[reliability fault]")
        
        # 6. UC-06 Raise Inspection Alert --<<extend>>--> UC-03 Detect Defects
        draw_rel("UC-06", "UC-03", "extend", "[defect confirmed]")
        
        # 7. UC-11 Correct Defect Classification --<<extend>>--> UC-10 Review Detected Defects
        draw_rel("UC-11", "UC-10", "extend", "[misclassified]")
        
        # 8. UC-15 Generate Inspection Report --<<include>>--> UC-14 Calculate Roll Grade
        draw_rel("UC-15", "UC-14", "include")
        
        # Save Visio and PNG
        vsdx_path = os.path.join(OUT_DIR, "07_module_wise_use_cases.vsdx")
        png_path = os.path.join(PNG_DIR, "07_module_wise_use_cases.png")
        doc.SaveAs(os.path.abspath(vsdx_path))
        page.Export(os.path.abspath(png_path))
        doc.Close()
        
        shutil.copy2(png_path, os.path.join(BW_DIR, "07_module_wise_use_cases.png"))
        print("Master Fixed Visio and PNG generated successfully!")
    finally:
        visio.Quit()

if __name__ == "__main__":
    build_diagram()

import sys, os

def patch():
    with open('scripts/rebuild_visio_perfect.py', 'r', encoding='utf-8') as f:
        orig = f.read()

    new_render = '''# =============================================================================
# 1. SEQUENCE DIAGRAM ENGINE (Reference Perfect, Zero Cuts, Pure Geometry)
# =============================================================================
def render_sequence_sheet(visio, diag_id, fig_caption, tab_text, participants, steps, out_vsdx_path, out_png_path):
    doc = visio.Documents.Add("")
    page = setup_page(doc, diag_id[:31])
    
    # Outer frame
    fx1, fy1 = 0.6, 0.65
    fx2, fy2 = PAGE_W - 0.6, 7.60
    frame = page.DrawRectangle(fx1, fy1, fx2, fy2)
    frame.Cells("FillPattern").FormulaU = "0"; frame.Cells("LineColor").FormulaU = "RGB(0,0,0)"; frame.Cells("LineWeight").FormulaU = "1.2 pt"
    
    # Header Tab in top-left
    tab_w = max(2.2, len(tab_text) * 0.075 + 0.4)
    tab = page.DrawRectangle(fx1, fy2 - 0.32, fx1 + tab_w, fy2)
    tab.Text = tab_text
    tab.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; tab.Cells("LineColor").FormulaU = "RGB(0,0,0)"; tab.Cells("LineWeight").FormulaU = "1 pt"
    tab.Cells("Char.Size").FormulaU = "9 pt"; tab.Cells("Char.Style").FormulaU = "1"; tab.Cells("Para.HorzAlign").FormulaU = "1"
    apply_zero_margins(tab)
    
    # Bottom Caption
    caption = page.DrawRectangle(PAGE_W / 2 - 4.0, 0.15, PAGE_W / 2 + 4.0, 0.45)
    caption.Text = fig_caption
    caption.Cells("FillPattern").FormulaU = "0"; caption.Cells("LinePattern").FormulaU = "0"
    caption.Cells("Char.Size").FormulaU = "9.5 pt"; caption.Cells("Char.Style").FormulaU = "1"; caption.Cells("Para.HorzAlign").FormulaU = "1"
    apply_zero_margins(caption)
    
    # Participants layout
    num_p = len(participants)
    x_start = fx1 + 1.1
    x_end = fx2 - 1.1
    dx = (x_end - x_start) / (num_p - 1)
    x_coords = [x_start + i * dx for i in range(num_p)]
    
    top_y = 6.40
    bot_y = 1.70
    bw, bh = 1.35, 0.45
    
    lifeline_tops = []
    lifeline_bots = []
    
    for i, (p_display, p_tag, is_act) in enumerate(participants):
        cx = x_coords[i]
        if is_act:
            lt = draw_stick_figure(page, cx, top_y, p_display)
            lb = draw_stick_figure_bottom(page, cx, bot_y, p_display)
            lifeline_tops.append(lt)
            lifeline_bots.append(lb)
        else:
            box_t = page.DrawRectangle(cx - bw/2, top_y - bh/2, cx + bw/2, top_y + bh/2)
            box_t.Text = p_display
            box_t.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; box_t.Cells("LineColor").FormulaU = "RGB(0,0,0)"; box_t.Cells("LineWeight").FormulaU = "1 pt"
            box_t.Cells("Char.Size").FormulaU = "8 pt"; box_t.Cells("Para.HorzAlign").FormulaU = "1"
            apply_zero_margins(box_t)
            
            box_b = page.DrawRectangle(cx - bw/2, bot_y - bh/2, cx + bw/2, bot_y + bh/2)
            box_b.Text = p_display
            box_b.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; box_b.Cells("LineColor").FormulaU = "RGB(0,0,0)"; box_b.Cells("LineWeight").FormulaU = "1 pt"
            box_b.Cells("Char.Size").FormulaU = "8 pt"; box_b.Cells("Para.HorzAlign").FormulaU = "1"
            apply_zero_margins(box_b)
            
            lifeline_tops.append(top_y - bh/2)
            lifeline_bots.append(bot_y + bh/2)
            
        ll = page.DrawLine(cx, lifeline_tops[i], cx, lifeline_bots[i])
        ll.Cells("LineColor").FormulaU = "RGB(100,100,100)"; ll.Cells("LinePattern").FormulaU = "2"; ll.Cells("LineWeight").FormulaU = "0.75 pt"
        
    tag_map = {participants[i][1]: i for i in range(num_p)}
    num_steps = len(steps)
    step_start_y = min(lifeline_tops) - 0.25
    step_end_y = max(lifeline_bots) + 0.25
    step_dy = (step_start_y - step_end_y) / (num_steps + 1)
    
    act_w = 0.12
    for s_idx, (s_text, s_src, s_dst, s_type, s_num) in enumerate(steps):
        curr_y = step_start_y - (s_idx + 1) * step_dy
        i1 = tag_map.get(s_src, 0)
        i2 = tag_map.get(s_dst, 1)
        x1 = x_coords[i1]
        x2 = x_coords[i2]
        
        # Human-written clean method names (never truncated with ...)
        clean_text = s_text.split(". ", 1)[1] if ". " in s_text else s_text
        tw = max(1.2, len(clean_text) * 0.050 + 0.15)
        
        if s_type == "self":
            loop_w = 0.35
            loop_h = min(0.22, step_dy * 0.45)
            
            # Activation box is fully closed, spans the self loop cleanly
            act_top = curr_y + 0.06
            act_bot = curr_y - loop_h - 0.06
            act_box = page.DrawRectangle(x1 - act_w/2, act_bot, x1 + act_w/2, act_top)
            act_box.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; act_box.Cells("FillPattern").FormulaU = "1"
            act_box.Cells("LineColor").FormulaU = "RGB(0,0,0)"; act_box.Cells("LineWeight").FormulaU = "0.75 pt"
            act_box.Cells("LinePattern").FormulaU = "1"
            
            # Self loop attaches strictly to the RIGHT FACE of activation box
            start_x = x1 + act_w/2
            l1 = page.DrawLine(start_x, curr_y, start_x + loop_w, curr_y)
            l1.Cells("LineColor").FormulaU = "RGB(0,0,0)"; l1.Cells("LineWeight").FormulaU = "0.75 pt"
            l2 = page.DrawLine(start_x + loop_w, curr_y, start_x + loop_w, curr_y - loop_h)
            l2.Cells("LineColor").FormulaU = "RGB(0,0,0)"; l2.Cells("LineWeight").FormulaU = "0.75 pt"
            l3 = page.DrawLine(start_x + loop_w, curr_y - loop_h, start_x, curr_y - loop_h)
            l3.Cells("LineColor").FormulaU = "RGB(0,0,0)"; l3.Cells("LineWeight").FormulaU = "0.75 pt"
            l3.Cells("EndArrow").FormulaU = "13"; l3.Cells("EndArrowSize").FormulaU = "2"
            
            # Label placed cleanly to the right, transparent (zero cuts into any line)
            lbl_x1 = start_x + loop_w + 0.08
            lbl_x2 = lbl_x1 + tw
            lbl = page.DrawRectangle(lbl_x1, curr_y - loop_h - 0.02, lbl_x2, curr_y + 0.12)
            lbl.Text = clean_text
            lbl.Cells("FillPattern").FormulaU = "0"; lbl.Cells("LinePattern").FormulaU = "0"
            lbl.Cells("Char.Size").FormulaU = "7.5 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "0"
            apply_zero_margins(lbl)
        else:
            # Fully closed rectangular activation box on target (complete 4 borders)
            act_h = min(0.32, step_dy * 0.70)
            act_box = page.DrawRectangle(x2 - act_w/2, curr_y - act_h/2, x2 + act_w/2, curr_y + act_h/2)
            act_box.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; act_box.Cells("FillPattern").FormulaU = "1"
            act_box.Cells("LineColor").FormulaU = "RGB(0,0,0)"; act_box.Cells("LineWeight").FormulaU = "0.75 pt"
            act_box.Cells("LinePattern").FormulaU = "1"
            
            # Start and End points touch outside face of activation box
            if x1 < x2:
                # Left to Right
                src_pt_x = x1 + (act_w/2 if not participants[i1][2] else 0)
                dst_pt_x = x2 - act_w/2
                msg_line = page.DrawLine(src_pt_x, curr_y, dst_pt_x, curr_y)
                
                # Label placed in open airspace ABOVE arrow, transparent, bounds strictly before target
                lbl_left = src_pt_x + 0.12
                max_w = (dst_pt_x - 0.10) - lbl_left
                eff_w = min(tw, max_w)
                lbl_right = lbl_left + eff_w
                
                lbl = page.DrawRectangle(lbl_left, curr_y + 0.03, lbl_right, curr_y + 0.22)
                lbl.Text = clean_text
                lbl.Cells("FillPattern").FormulaU = "0"; lbl.Cells("LinePattern").FormulaU = "0"
                lbl.Cells("Char.Size").FormulaU = "7.5 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "0"
                apply_zero_margins(lbl)
            else:
                # Right to Left
                src_pt_x = x1 - (act_w/2 if not participants[i1][2] else 0)
                dst_pt_x = x2 + act_w/2
                msg_line = page.DrawLine(src_pt_x, curr_y, dst_pt_x, curr_y)
                
                # Label placed near destination, strictly bounded before source
                lbl_left = dst_pt_x + 0.12
                max_w = (src_pt_x - 0.10) - lbl_left
                eff_w = min(tw, max_w)
                lbl_right = lbl_left + eff_w
                
                lbl = page.DrawRectangle(lbl_left, curr_y + 0.03, lbl_right, curr_y + 0.22)
                lbl.Text = clean_text
                lbl.Cells("FillPattern").FormulaU = "0"; lbl.Cells("LinePattern").FormulaU = "0"
                lbl.Cells("Char.Size").FormulaU = "7.5 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "0"
                apply_zero_margins(lbl)
                
            msg_line.Cells("LineColor").FormulaU = "RGB(0,0,0)"; msg_line.Cells("LineWeight").FormulaU = "0.75 pt"
            if s_type == "ret":
                msg_line.Cells("LinePattern").FormulaU = "2"
                msg_line.Cells("EndArrow").FormulaU = "4"
            else:
                msg_line.Cells("EndArrow").FormulaU = "13"
            msg_line.Cells("EndArrowSize").FormulaU = "2"
            
    doc.SaveAs(os.path.abspath(out_vsdx_path))
    page.Export(os.path.abspath(out_png_path))
    doc.Close()
    return out_vsdx_path, out_png_path

# =============================================================================
# 2. SYSTEM USE CASE DIAGRAM (Reference Matching, Zero Crossings)
# =============================================================================
def build_system_use_case_diagram(visio):
    """
    Renders the formal System Use Case Diagram strictly matching Use-case_Diagram(Final).pdf:
    - System Boundary Box with centered title
    - Left Margin: 4 Human Actors (Floor Op, Quality Insp, Prod Mgr, Inv Mgr) at x=1.15
    - Right Margin: 2 Actors (System Admin, Edge Sentinel Stand) at x=10.55
    - 3 Clean Columns of Ovals:
      Col 1 (x=3.55): Primary Left Actor Use Cases
      Col 2 (x=5.80): Sub-use cases connected via <<includes>> / <<extends>>
      Col 3 (x=8.05): Primary Right Actor Use Cases
    - Non-colliding relationships (horizontal between Col 1 & 2, vertical within Col 2)
    - Dedicated connection lines never crossing through text or ovals!
    """
    doc = visio.Documents.Add("")
    page = setup_page(doc, "07_module_wise_use_cases")
    
    # Outer frame
    frame = page.DrawRectangle(0.5, 0.5, PAGE_W - 0.5, PAGE_H - 0.5)
    frame.Cells("FillPattern").FormulaU = "0"; frame.Cells("LineColor").FormulaU = "RGB(0,0,0)"; frame.Cells("LineWeight").FormulaU = "1.5 pt"
    
    # Boundary box: bx1 = 2.2, bx2 = 9.4
    bx1, by1 = 2.2, 0.7
    bx2, by2 = 9.4, PAGE_H - 0.7
    box = page.DrawRectangle(bx1, by1, bx2, by2)
    box.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; box.Cells("LineColor").FormulaU = "RGB(0,0,0)"; box.Cells("LineWeight").FormulaU = "2 pt"
    
    # Boundary title
    bt = page.DrawRectangle(bx1 + 0.5, by2 - 0.40, bx2 - 0.5, by2 - 0.05)
    bt.Text = "TexEye AI: AI-Based Fabric Defect Detection & Quality Management System"
    bt.Cells("FillPattern").FormulaU = "0"; bt.Cells("LinePattern").FormulaU = "0"
    bt.Cells("Char.Size").FormulaU = "10.5 pt"; bt.Cells("Char.Style").FormulaU = "1"; bt.Cells("Para.HorzAlign").FormulaU = "1"
    apply_zero_margins(bt)
    
    # Caption
    cap = page.DrawRectangle(PAGE_W / 2 - 3.0, 0.15, PAGE_W / 2 + 3.0, 0.42)
    cap.Text = "Figure: Use-case Diagram — TexEye AI System"
    cap.Cells("FillPattern").FormulaU = "0"; cap.Cells("LinePattern").FormulaU = "0"
    cap.Cells("Char.Size").FormulaU = "10 pt"; cap.Cells("Char.Style").FormulaU = "1"; cap.Cells("Para.HorzAlign").FormulaU = "1"
    apply_zero_margins(cap)
    
    # Helper to draw actor
    def draw_uc_actor(page, ax, ay, text):
        hr = 0.12
        page.DrawOval(ax - hr, ay + 0.14, ax + hr, ay + 0.38)
        page.DrawLine(ax, ay + 0.14, ax, ay - 0.12)
        page.DrawLine(ax - 0.18, ay + 0.06, ax + 0.18, ay + 0.06)
        page.DrawLine(ax, ay - 0.12, ax - 0.14, ay - 0.32)
        page.DrawLine(ax, ay - 0.12, ax + 0.14, ay - 0.32)
        l = page.DrawRectangle(ax - 0.85, ay - 0.54, ax + 0.85, ay - 0.36)
        l.Text = text
        l.Cells("FillPattern").FormulaU = "0"; l.Cells("LinePattern").FormulaU = "0"
        l.Cells("Char.Size").FormulaU = "7.5 pt"; l.Cells("Para.HorzAlign").FormulaU = "1"
        apply_zero_margins(l)
        return ax, ay
        
    left_acts = [
        ("Floor Operator\\n(Mobile App)", 6.3),
        ("Quality Inspector\\n(Web Dashboard)", 4.7),
        ("Production Manager\\n(Analytics)", 3.1),
        ("Inventory Manager\\n(Warehouse)", 1.5)
    ]
    for txt, y in left_acts:
        draw_uc_actor(page, 1.15, y, txt)
        
    # Right actors placed at x = 10.55 (completely outside boundary box bx2 = 9.4!)
    draw_uc_actor(page, 10.55, 5.4, "System Administrator\\n(Portal)")
    draw_uc_actor(page, 10.55, 2.3, "<<system>>\\nEdge Sentinel Stand")
    
    # 3 Columns of ovals
    col1_x = 3.55
    col2_x = 5.80
    col3_x = 8.05
    ow, oh = 1.95, 0.42
    
    c1 = [
        ("Scan Roll QR Code", 6.8),
        ("Review Active Flaws", 6.1),
        ("View 2D Defect Map", 5.2),
        ("Audit Defect Record", 4.5),
        ("Finalize Roll Grade", 3.8),
        ("Monitor Live Yield", 3.0),
        ("Defect Pareto Stats", 2.4),
        ("Manage Roll Inventory", 1.6),
        ("Segregate Scrap Rolls", 1.0)
    ]
    
    c2 = [
        ("Validate Roll QR", 6.8),
        ("Review Defect Crops", 5.2),
        ("Reclassify Flaw Class", 4.5),
        ("Compute ASTM Score", 3.8),
        ("Export PDF Certificate", 3.1),
        ("Update Bin Location", 1.6),
        ("Flag Quarantine Outbox", 1.0)
    ]
    
    c3 = [
        ("Manage User Accounts", 6.2),
        ("Assign Roles & Scopes", 5.4),
        ("Configure Calibration", 4.6),
        ("Capture Camera Frames", 3.0),
        ("Track Encoder Pulses", 2.2),
        ("Trigger Stack Light Relay", 1.4)
    ]
    
    ovals_map = {}
    for cx_col, items in [(col1_x, c1), (col2_x, c2), (col3_x, c3)]:
        for text, cy in items:
            s = page.DrawOval(cx_col - ow/2, cy - oh/2, cx_col + ow/2, cy + oh/2)
            s.Text = text
            s.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; s.Cells("LineColor").FormulaU = "RGB(0,0,0)"; s.Cells("LineWeight").FormulaU = "1.2 pt"
            s.Cells("Char.Size").FormulaU = "7.5 pt"; s.Cells("Para.HorzAlign").FormulaU = "1"
            apply_zero_margins(s)
            ovals_map[text] = (cx_col, cy)
            
    # Connect Left Actors from x = 1.65 to left face of column 1 ovals
    def conn_left(ay, targets):
        for name in targets:
            if name in ovals_map:
                ox, oy = ovals_map[name]
                l = page.DrawLine(1.65, ay, ox - ow/2, oy)
                l.Cells("LineColor").FormulaU = "RGB(0,0,0)"; l.Cells("LineWeight").FormulaU = "0.75 pt"
            
    conn_left(6.3, ["Scan Roll QR Code", "Review Active Flaws"])
    conn_left(4.7, ["View 2D Defect Map", "Audit Defect Record", "Finalize Roll Grade"])
    conn_left(3.1, ["Monitor Live Yield", "Defect Pareto Stats"])
    conn_left(1.5, ["Manage Roll Inventory", "Segregate Scrap Rolls"])
    
    # Connect Right Actors from x = 9.75 (clear margin) to right face of column 3 ovals
    def conn_right(ay, targets):
        for name in targets:
            if name in ovals_map:
                ox, oy = ovals_map[name]
                l = page.DrawLine(9.75, ay, ox + ow/2, oy)
                l.Cells("LineColor").FormulaU = "RGB(0,0,0)"; l.Cells("LineWeight").FormulaU = "0.75 pt"
            
    conn_right(5.4, ["Manage User Accounts", "Assign Roles & Scopes", "Configure Calibration"])
    conn_right(2.3, ["Capture Camera Frames", "Track Encoder Pulses", "Trigger Stack Light Relay"])
    
    # Non-colliding relationships (horizontal between Col 1 & 2, vertical within Col 2)
    def draw_uc_rel(src_name, dst_name, rel_type):
        if src_name in ovals_map and dst_name in ovals_map:
            sx, sy = ovals_map[src_name]
            dx, dy = ovals_map[dst_name]
            if sx == dx:
                # Vertical relationship (e.g. inside Column 2!)
                ln = page.DrawLine(sx, sy - oh/2, dx, dy + oh/2)
                ln.Cells("LineColor").FormulaU = "RGB(70,70,70)"; ln.Cells("LinePattern").FormulaU = "2"; ln.Cells("LineWeight").FormulaU = "0.75 pt"
                ln.Cells("EndArrow").FormulaU = "13"; ln.Cells("EndArrowSize").FormulaU = "1"
                lbl = page.DrawRectangle(sx + 0.08, (sy + dy)/2 - 0.08, sx + 0.95, (sy + dy)/2 + 0.08)
                lbl.Text = f"<<{rel_type}>>"
                lbl.Cells("FillPattern").FormulaU = "0"; lbl.Cells("LinePattern").FormulaU = "0"
                lbl.Cells("Char.Size").FormulaU = "6.5 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "0"
                apply_zero_margins(lbl)
            else:
                # Horizontal relationship between Col 1 and Col 2
                ln = page.DrawLine(sx + ow/2, sy, dx - ow/2, dy)
                ln.Cells("LineColor").FormulaU = "RGB(70,70,70)"; ln.Cells("LinePattern").FormulaU = "2"; ln.Cells("LineWeight").FormulaU = "0.75 pt"
                ln.Cells("EndArrow").FormulaU = "13"; ln.Cells("EndArrowSize").FormulaU = "1"
                mx = (sx + ow/2 + dx - ow/2) / 2
                my = (sy + dy) / 2
                lbl = page.DrawRectangle(mx - 0.40, my + 0.02, mx + 0.40, my + 0.16)
                lbl.Text = f"<<{rel_type}>>"
                lbl.Cells("FillPattern").FormulaU = "0"; lbl.Cells("LinePattern").FormulaU = "0"
                lbl.Cells("Char.Size").FormulaU = "6.5 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "1"
                apply_zero_margins(lbl)

    draw_uc_rel("Scan Roll QR Code", "Validate Roll QR", "includes")
    draw_uc_rel("View 2D Defect Map", "Review Defect Crops", "extends")
    draw_uc_rel("Audit Defect Record", "Reclassify Flaw Class", "extends")
    
    # Finalize Roll Grade includes Compute ASTM Score (clean horizontal!)
    draw_uc_rel("Finalize Roll Grade", "Compute ASTM Score", "includes")
    # Compute ASTM Score includes Export PDF Certificate (clean vertical down in Col 2!)
    draw_uc_rel("Compute ASTM Score", "Export PDF Certificate", "includes")
    
    draw_uc_rel("Manage Roll Inventory", "Update Bin Location", "extends")
    draw_uc_rel("Segregate Scrap Rolls", "Flag Quarantine Outbox", "includes")
    
    vsdx_path = os.path.join(OUT_DIR, "07_module_wise_use_cases.vsdx")
    doc.SaveAs(os.path.abspath(vsdx_path))
    png_path = os.path.join(PNG_DIR, "07_module_wise_use_cases.png")
    page.Export(os.path.abspath(png_path))
    doc.Close()
    return vsdx_path, png_path
'''

    p1 = orig.find('# 1. SEQUENCE DIAGRAM ENGINE')
    p2 = orig.find('# =============================================================================\n# 3. ROUGH WORKFLOW BLUEPRINT')
    if p2 == -1:
        p2 = orig.find('def build_rough_workflow(visio):')

    print(f'p1: {p1}, p2: {p2}')
    if p1 != -1 and p2 != -1:
        updated = orig[:p1] + new_render + '\n\n' + orig[p2:]
        with open('scripts/rebuild_visio_perfect.py', 'w', encoding='utf-8') as f:
            f.write(updated)
        print('SUCCESS: scripts/rebuild_visio_perfect.py patched successfully!')
    else:
        print('ERROR: markers not found')

if __name__ == '__main__':
    patch()

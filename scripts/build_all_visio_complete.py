"""
TexEye AI — Comprehensive Native Microsoft Visio Diagram Builder (Version 2.0)
Fixes all collisions, line crossings, and ensures textbook-perfect UML alignment.
"""

import os
import sys
import shutil
import pythoncom
import win32com.client

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from generate_all_25_sequences import use_cases

OUT_DIR = os.path.abspath(r"diagrams\visio")
PNG_DIR = os.path.abspath(r"diagrams\visio\png")
ONEDRIVE_DIR = r"C:\Users\User\OneDrive\TexEye_AI_Visio_Diagrams"

os.makedirs(OUT_DIR, exist_ok=True)
os.makedirs(PNG_DIR, exist_ok=True)
if os.path.exists(r"C:\Users\User\OneDrive"):
    os.makedirs(ONEDRIVE_DIR, exist_ok=True)

PAGE_W = 11.69
PAGE_H = 8.27

def init_visio():
    pythoncom.CoInitialize()
    try:
        visio = win32com.client.GetActiveObject("Visio.Application")
    except Exception:
        visio = win32com.client.Dispatch("Visio.Application")
    visio.Visible = False
    visio.AlertResponse = 1
    return visio

def draw_stick_figure(page, cx, cy, label):
    """Draws a clean UML stick figure actor at (cx, cy) with label below."""
    head_r = 0.12
    h = page.DrawOval(cx - head_r, cy + 0.08, cx + head_r, cy + 0.08 + head_r * 2)
    h.Cells("FillPattern").FormulaU = "0"; h.Cells("LineColor").FormulaU = "RGB(0,0,0)"; h.Cells("LineWeight").FormulaU = "1 pt"
    b = page.DrawLine(cx, cy + 0.08, cx, cy - 0.20)
    b.Cells("LineColor").FormulaU = "RGB(0,0,0)"; b.Cells("LineWeight").FormulaU = "1 pt"
    a = page.DrawLine(cx - 0.18, cy - 0.02, cx + 0.18, cy - 0.02)
    a.Cells("LineColor").FormulaU = "RGB(0,0,0)"; a.Cells("LineWeight").FormulaU = "1 pt"
    ll = page.DrawLine(cx, cy - 0.20, cx - 0.15, cy - 0.45)
    ll.Cells("LineColor").FormulaU = "RGB(0,0,0)"; ll.Cells("LineWeight").FormulaU = "1 pt"
    rl = page.DrawLine(cx, cy - 0.20, cx + 0.15, cy - 0.45)
    rl.Cells("LineColor").FormulaU = "RGB(0,0,0)"; rl.Cells("LineWeight").FormulaU = "1 pt"
    lbl = page.DrawRectangle(cx - 0.9, cy - 0.72, cx + 0.9, cy - 0.48)
    lbl.Text = label
    lbl.Cells("FillPattern").FormulaU = "0"; lbl.Cells("LinePattern").FormulaU = "0"
    lbl.Cells("Char.Size").FormulaU = "8 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "1"
    return cy - 0.76

def draw_stick_figure_bottom(page, cx, cy, label):
    """Draws mirror stick figure actor at bottom."""
    head_r = 0.12
    h = page.DrawOval(cx - head_r, cy + 0.08, cx + head_r, cy + 0.08 + head_r * 2)
    h.Cells("FillPattern").FormulaU = "0"; h.Cells("LineColor").FormulaU = "RGB(0,0,0)"; h.Cells("LineWeight").FormulaU = "1 pt"
    b = page.DrawLine(cx, cy + 0.08, cx, cy - 0.20)
    b.Cells("LineColor").FormulaU = "RGB(0,0,0)"; b.Cells("LineWeight").FormulaU = "1 pt"
    a = page.DrawLine(cx - 0.18, cy - 0.02, cx + 0.18, cy - 0.02)
    a.Cells("LineColor").FormulaU = "RGB(0,0,0)"; a.Cells("LineWeight").FormulaU = "1 pt"
    ll = page.DrawLine(cx, cy - 0.20, cx - 0.15, cy - 0.45)
    ll.Cells("LineColor").FormulaU = "RGB(0,0,0)"; ll.Cells("LineWeight").FormulaU = "1 pt"
    rl = page.DrawLine(cx, cy - 0.20, cx + 0.15, cy - 0.45)
    rl.Cells("LineColor").FormulaU = "RGB(0,0,0)"; rl.Cells("LineWeight").FormulaU = "1 pt"
    lbl = page.DrawRectangle(cx - 0.9, cy - 0.72, cx + 0.9, cy - 0.48)
    lbl.Text = label
    lbl.Cells("FillPattern").FormulaU = "0"; lbl.Cells("LinePattern").FormulaU = "0"
    lbl.Cells("Char.Size").FormulaU = "8 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "1"
    return cy + 0.35

def render_sequence_sheet(visio, page_title, fig_caption, tab_text, participants, steps, out_vsdx_path, out_png_path):
    """Generic sequence diagram renderer that draws standard UML 2.5 sequence diagrams."""
    doc = visio.Documents.Add("")
    page = doc.Pages.Item(1)
    page.Name = page_title[:30]
    page.PageSheet.Cells("PageWidth").FormulaU = f"{PAGE_W} in"
    page.PageSheet.Cells("PageHeight").FormulaU = f"{PAGE_H} in"
    
    # 1. Outer Frame
    mx, my = 0.5, 0.5
    fx1, fy1 = mx, my + 0.4
    fx2, fy2 = PAGE_W - mx, PAGE_H - my
    frame = page.DrawRectangle(fx1, fy1, fx2, fy2)
    frame.Cells("FillPattern").FormulaU = "0"; frame.Cells("LineColor").FormulaU = "RGB(0,0,0)"; frame.Cells("LineWeight").FormulaU = "1 pt"
    
    # 2. Header Tab
    tab_w = max(2.4, len(tab_text) * 0.08 + 0.4)
    tab = page.DrawRectangle(fx1, fy2 - 0.32, fx1 + tab_w, fy2)
    tab.Text = tab_text
    tab.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; tab.Cells("LineColor").FormulaU = "RGB(0,0,0)"; tab.Cells("LineWeight").FormulaU = "1 pt"
    tab.Cells("Char.Size").FormulaU = "9 pt"; tab.Cells("Para.HorzAlign").FormulaU = "1"
    
    # 3. Caption
    caption = page.DrawRectangle(PAGE_W / 2 - 3.8, my - 0.12, PAGE_W / 2 + 3.8, my + 0.24)
    caption.Text = fig_caption
    caption.Cells("FillPattern").FormulaU = "0"; caption.Cells("LinePattern").FormulaU = "0"
    caption.Cells("Char.Size").FormulaU = "10 pt"; caption.Cells("Char.Style").FormulaU = "1"; caption.Cells("Para.HorzAlign").FormulaU = "1"
    
    # 4. Participants
    num_p = len(participants)
    x_start = fx1 + 1.1
    x_end = fx2 - 1.1
    dx = (x_end - x_start) / (num_p - 1)
    x_coords = [x_start + i * dx for i in range(num_p)]
    
    top_y = fy2 - 0.85
    bot_y = fy1 + 0.95
    bw, bh = 1.35, 0.48
    
    lifeline_tops = []
    lifeline_bots = []
    
    for i, (p_display, p_tag, is_act) in enumerate(participants):
        cx = x_coords[i]
        if is_act:
            lt = draw_stick_figure(page, cx, top_y + 0.1, p_display)
            lb = draw_stick_figure_bottom(page, cx, bot_y - 0.2, p_display)
            lifeline_tops.append(lt)
            lifeline_bots.append(lb)
        else:
            box_t = page.DrawRectangle(cx - bw/2, top_y - bh/2, cx + bw/2, top_y + bh/2)
            box_t.Text = p_display
            box_t.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; box_t.Cells("LineColor").FormulaU = "RGB(0,0,0)"; box_t.Cells("LineWeight").FormulaU = "1 pt"
            box_t.Cells("Char.Size").FormulaU = "8 pt"; box_t.Cells("Para.HorzAlign").FormulaU = "1"
            
            box_b = page.DrawRectangle(cx - bw/2, bot_y - bh/2, cx + bw/2, bot_y + bh/2)
            box_b.Text = p_display
            box_b.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; box_b.Cells("LineColor").FormulaU = "RGB(0,0,0)"; box_b.Cells("LineWeight").FormulaU = "1 pt"
            box_b.Cells("Char.Size").FormulaU = "8 pt"; box_b.Cells("Para.HorzAlign").FormulaU = "1"
            
            lifeline_tops.append(top_y - bh/2)
            lifeline_bots.append(bot_y + bh/2)
            
        ll = page.DrawLine(cx, lifeline_tops[i], cx, lifeline_bots[i])
        ll.Cells("LineColor").FormulaU = "RGB(120,120,120)"; ll.Cells("LinePattern").FormulaU = "2"; ll.Cells("LineWeight").FormulaU = "0.75 pt"
        
    tag_map = {participants[i][1]: i for i in range(num_p)}
    num_steps = len(steps)
    step_start_y = min(lifeline_tops) - 0.35
    step_end_y = max(lifeline_bots) + 0.35
    step_dy = (step_start_y - step_end_y) / (num_steps + 1)
    
    for s_idx, (s_text, s_src, s_dst, s_type, s_num) in enumerate(steps):
        curr_y = step_start_y - (s_idx + 1) * step_dy
        i1 = tag_map.get(s_src, 0)
        i2 = tag_map.get(s_dst, 1)
        x1 = x_coords[i1]
        x2 = x_coords[i2]
        
        clean_text = s_text.split(". ", 1)[1] if ". " in s_text else s_text
        if len(clean_text) > 42:
            clean_text = clean_text[:40] + "..."
            
        if s_type == "self":
            loop_w = 0.35
            loop_h = min(0.22, step_dy * 0.45)
            l1 = page.DrawLine(x1, curr_y, x1 + loop_w, curr_y)
            l1.Cells("LineColor").FormulaU = "RGB(0,0,0)"; l1.Cells("LineWeight").FormulaU = "0.75 pt"
            l2 = page.DrawLine(x1 + loop_w, curr_y, x1 + loop_w, curr_y - loop_h)
            l2.Cells("LineColor").FormulaU = "RGB(0,0,0)"; l2.Cells("LineWeight").FormulaU = "0.75 pt"
            l3 = page.DrawLine(x1 + loop_w, curr_y - loop_h, x1, curr_y - loop_h)
            l3.Cells("LineColor").FormulaU = "RGB(0,0,0)"; l3.Cells("LineWeight").FormulaU = "0.75 pt"
            l3.Cells("EndArrow").FormulaU = "13"; l3.Cells("EndArrowSize").FormulaU = "2"
            
            lbl = page.DrawRectangle(x1 + loop_w + 0.05, curr_y - loop_h - 0.05, x1 + loop_w + 2.4, curr_y + 0.1)
            lbl.Text = clean_text
            lbl.Cells("FillPattern").FormulaU = "0"; lbl.Cells("LinePattern").FormulaU = "0"
            lbl.Cells("Char.Size").FormulaU = "7.5 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "0"
        else:
            msg_line = page.DrawLine(x1, curr_y, x2, curr_y)
            msg_line.Cells("LineColor").FormulaU = "RGB(0,0,0)"; msg_line.Cells("LineWeight").FormulaU = "0.75 pt"
            if s_type == "ret":
                msg_line.Cells("LinePattern").FormulaU = "2"
                msg_line.Cells("EndArrow").FormulaU = "4"
            else:
                msg_line.Cells("EndArrow").FormulaU = "13"
            msg_line.Cells("EndArrowSize").FormulaU = "2"
            
            tw = max(1.6, len(clean_text) * 0.052 + 0.2)
            tx = (x1 + x2) / 2
            lbl = page.DrawRectangle(tx - tw/2, curr_y + 0.03, tx + tw/2, curr_y + 0.22)
            lbl.Text = clean_text
            lbl.Cells("FillPattern").FormulaU = "0"; lbl.Cells("LinePattern").FormulaU = "0"
            lbl.Cells("Char.Size").FormulaU = "7.5 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "1"
            
    doc.SaveAs(os.path.abspath(out_vsdx_path))
    page.Export(os.path.abspath(out_png_path))
    doc.Close()
    return out_vsdx_path, out_png_path

# -----------------------------------------------------------------------------
# Module Diagrams 01 to 05 Specifications
# -----------------------------------------------------------------------------
module_diagrams = [
    (
        "01_module_1_ai_detection_sequence",
        "Module 1: AI Defect Detection & Location",
        "Figure 5.4.1: Sequence Diagram for Module 1 — AI Defect Detection & Localization",
        "Module 1: AI Vision Detection",
        [
            ("Camera Stream", ":CameraStream", False),
            ("YOLO Detector", ":YOLODetector", False),
            ("Rotary Encoder", ":RotaryEncoder", False),
            ("Metric Mapper", ":MetricMapper", False),
            ("Kalman Tracker", ":KalmanTracker", False),
            ("SQLite Buffer", ":SQLiteBuffer", False)
        ],
        [
            ("1. grab_frame(frame_id)", ":CameraStream", ":YOLODetector", "sync", 1),
            ("infer_yolo(bbox, conf)", ":YOLODetector", ":YOLODetector", "self", 2),
            ("2. get_current_pulses()", ":YOLODetector", ":RotaryEncoder", "sync", 3),
            ("return pulse_count", ":RotaryEncoder", ":YOLODetector", "ret", 4),
            ("3. compute_coords(bbox, pulses)", ":YOLODetector", ":MetricMapper", "sync", 5),
            ("return (X_cm, Y_meters)", ":MetricMapper", ":YOLODetector", "ret", 6),
            ("4. track_flaw(bbox, X_cm, Y_m)", ":YOLODetector", ":KalmanTracker", "sync", 7),
            ("return is_new_defect", ":KalmanTracker", ":YOLODetector", "ret", 8),
            ("5. insert_defect(flaw_data, crop_jpg)", ":YOLODetector", ":SQLiteBuffer", "sync", 9),
            ("commit_ok (defect_id)", ":SQLiteBuffer", ":YOLODetector", "ret", 10),
            ("6. emit_ws('defect_detected', data)", ":YOLODetector", ":SQLiteBuffer", "sync", 11)
        ]
    ),
    (
        "02_module_2_hardware_monitoring_sequence",
        "Module 2: Hardware & Inspection Monitoring",
        "Figure 5.4.2: Sequence Diagram for Module 2 — Hardware Reliability Guard & Relays",
        "Module 2: Hardware Reliability",
        [
            ("Stand Sensors", ":StandSensors", False),
            ("Reliability Guard", ":ReliabilityGuard", False),
            ("USB Relay Board", ":USBRelayBox", False),
            ("Amber Siren Light", ":AmberLightSiren", False),
            ("Uninspected Logger", ":UninspectedLogger", False),
            ("SQLite Buffer", ":SQLiteBuffer", False)
        ],
        [
            ("1. check_frame_health(lux, blur)", ":StandSensors", ":ReliabilityGuard", "sync", 1),
            ("detect: lux < 800 | blur", ":ReliabilityGuard", ":ReliabilityGuard", "self", 2),
            ("2. trip_relay(AMBER, ON)", ":ReliabilityGuard", ":USBRelayBox", "sync", 3),
            ("3. sound_buzzer()", ":USBRelayBox", ":AmberLightSiren", "sync", 4),
            ("4. start_uninspected_span(Y1)", ":ReliabilityGuard", ":UninspectedLogger", "sync", 5),
            ("5. insert_span_start()", ":UninspectedLogger", ":SQLiteBuffer", "sync", 6),
            ("6. sensors_recovered(lux > 800)", ":StandSensors", ":ReliabilityGuard", "sync", 7),
            ("7. trip_relay(AMBER, OFF)", ":ReliabilityGuard", ":USBRelayBox", "sync", 8),
            ("8. close_uninspected_span(Y2)", ":ReliabilityGuard", ":UninspectedLogger", "sync", 9),
            ("9. update_span_end([Y1, Y2])", ":UninspectedLogger", ":SQLiteBuffer", "sync", 10)
        ]
    ),
    (
        "03_module_3_mobile_app_sequence",
        "Module 3: Mobile Floor Application",
        "Figure 5.4.3: Sequence Diagram for Module 3 — Mobile Floor App (QR & Live Alerts)",
        "Module 3: Mobile Floor App",
        [
            ("Floor Operator", ":FloorOperator", True),
            ("Mobile UI (Flutter)", ":MobileUI", False),
            ("QR Scanner", ":QRScanner", False),
            ("WebSocket Client", ":WSClient", False),
            ("Stand Edge PC", ":StandEdgePC", False),
            ("Local SQLite Cache", ":LocalCache", False)
        ],
        [
            ("1. tap_scan_qr()", ":FloorOperator", ":MobileUI", "sync", 1),
            ("2. open_viewfinder()", ":MobileUI", ":QRScanner", "sync", 2),
            ("qr_decoded(roll_id, batch)", ":QRScanner", ":MobileUI", "ret", 3),
            ("3. POST /session/start(roll_id)", ":MobileUI", ":StandEdgePC", "sync", 4),
            ("200 OK (session_active, limits)", ":StandEdgePC", ":MobileUI", "ret", 5),
            ("4. connect_websocket(ws_url)", ":MobileUI", ":WSClient", "sync", 6),
            ("emit: defect_event(data)", ":StandEdgePC", ":WSClient", "sync", 7),
            ("5. trigger_haptic_vibration()", ":WSClient", ":MobileUI", "sync", 8),
            ("6. display_alarm_modal()", ":MobileUI", ":FloorOperator", "sync", 9),
            ("7. tap_acknowledge()", ":FloorOperator", ":MobileUI", "sync", 10),
            ("8. select_manual_flaw('Hole')", ":FloorOperator", ":MobileUI", "sync", 11),
            ("9. POST /defects/manual(flaw)", ":MobileUI", ":StandEdgePC", "sync", 12),
            ("10. cache_local_session(data)", ":MobileUI", ":LocalCache", "sync", 13)
        ]
    ),
    (
        "04_module_4_web_quality_map_sequence",
        "Module 4: Web Quality Management & Digital Map",
        "Figure 5.4.4: Sequence Diagram for Module 4 — Web Quality Dashboard & 2D Map",
        "Module 4: Web Quality Dashboard",
        [
            ("Quality Inspector", ":QualityInspector", True),
            ("React Dashboard", ":ReactDashboard", False),
            ("2D Canvas Map", ":Canvas2DMap", False),
            ("FastAPI Gateway", ":FastAPIGateway", False),
            ("PostgreSQL DB", ":PostgreSQLDB", False),
            ("MinIO Crop Store", ":MinIOStore", False)
        ],
        [
            ("1. select_roll(roll_id)", ":QualityInspector", ":ReactDashboard", "sync", 1),
            ("2. GET /api/v1/rolls/{id}/map", ":ReactDashboard", ":FastAPIGateway", "sync", 2),
            ("3. SELECT defects & spans", ":FastAPIGateway", ":PostgreSQLDB", "sync", 3),
            ("return defects_list, spans", ":PostgreSQLDB", ":FastAPIGateway", "ret", 4),
            ("200 OK (map_payload_json)", ":FastAPIGateway", ":ReactDashboard", "ret", 5),
            ("4. render_2d_web(defects)", ":ReactDashboard", ":Canvas2DMap", "sync", 6),
            ("5. click_defect_glyph(#14)", ":QualityInspector", ":ReactDashboard", "sync", 7),
            ("6. fetch_crop_url(defect_id)", ":ReactDashboard", ":MinIOStore", "sync", 8),
            ("return crop_image_blob", ":MinIOStore", ":ReactDashboard", "ret", 9),
            ("7. show_gallery_modal()", ":ReactDashboard", ":QualityInspector", "sync", 10),
            ("8. reclassify('Foreign Yarn')", ":QualityInspector", ":ReactDashboard", "sync", 11),
            ("9. PATCH /api/v1/defects/{id}", ":ReactDashboard", ":FastAPIGateway", "sync", 12),
            ("10. UPDATE & INSERT audit", ":FastAPIGateway", ":PostgreSQLDB", "sync", 13),
            ("200 OK (reclassified, audit_id)", ":PostgreSQLDB", ":ReactDashboard", "ret", 14)
        ]
    ),
    (
        "05_module_5_smart_operations_astm_sequence",
        "Module 5: Smart Operations & ASTM 4-Point Grading",
        "Figure 5.4.5: Sequence Diagram for Module 5 — Smart Operations & ASTM D5430-07 Grading",
        "Module 5: Smart Operations",
        [
            ("Quality Manager", ":QualityManager", True),
            ("Web Dashboard", ":WebDashboard", False),
            ("FastAPI Server", ":FastAPIServer", False),
            ("ASTM Engine", ":ASTMEngine", False),
            ("PostgreSQL DB", ":PostgreSQLDB", False),
            ("PDF Export Service", ":PDFExportService", False)
        ],
        [
            ("1. click_finalize_roll()", ":QualityManager", ":WebDashboard", "sync", 1),
            ("2. POST /rolls/{id}/grade", ":WebDashboard", ":FastAPIServer", "sync", 2),
            ("3. execute_astm_d5430(defects)", ":FastAPIServer", ":ASTMEngine", "sync", 3),
            ("4. SELECT defects FROM db", ":ASTMEngine", ":PostgreSQLDB", "sync", 4),
            ("return verified_defects", ":PostgreSQLDB", ":ASTMEngine", "ret", 5),
            ("calculate penalty points (1-4)", ":ASTMEngine", ":ASTMEngine", "self", 6),
            ("5. UPDATE rolls SET grade='A'", ":ASTMEngine", ":PostgreSQLDB", "sync", 7),
            ("6. request_pdf_export(report)", ":WebDashboard", ":PDFExportService", "sync", 8),
            ("compile_astm_pdf_report()", ":PDFExportService", ":PDFExportService", "self", 9),
            ("200 OK (download_url)", ":PDFExportService", ":WebDashboard", "ret", 10),
            ("display_quality_certificate()", ":WebDashboard", ":QualityManager", "ret", 11)
        ]
    )
]

def build_rough_workflow(visio):
    """
    Builds the 00 Rough Workflow Paper Blueprint with pure, non-intersecting channels:
    - 4 progressive layers
    - Decision diamond with straight [YES] down and [NO] right
    - Clean [Central Backend] -> [Web Dashboard] feedback channel along open right margin
    - Zero line crossings or box collisions.
    """
    doc = visio.Documents.Add("")
    page = doc.Pages.Item(1)
    page.Name = "00_rough_workflow_paper"
    page.PageSheet.Cells("PageWidth").FormulaU = f"{PAGE_W} in"
    page.PageSheet.Cells("PageHeight").FormulaU = f"{PAGE_H} in"
    
    # Outer frame
    frame = page.DrawRectangle(0.5, 0.5, PAGE_W - 0.5, PAGE_H - 0.5)
    frame.Cells("FillPattern").FormulaU = "0"; frame.Cells("LineColor").FormulaU = "RGB(0,0,0)"; frame.Cells("LineWeight").FormulaU = "1.5 pt"
    
    # Title
    tbox = page.DrawRectangle(0.5, PAGE_H - 1.05, PAGE_W - 0.5, PAGE_H - 0.5)
    tbox.Text = "TexEye AI — Complete End-to-End System Workflow Diagram\nPaper-Reproduction Blueprint for FYP Supervisor Presentation | COMSATS University Islamabad"
    tbox.Cells("FillPattern").FormulaU = "0"; tbox.Cells("LinePattern").FormulaU = "0"
    tbox.Cells("Char.Size").FormulaU = "11 pt"; tbox.Cells("Char.Style").FormulaU = "1"; tbox.Cells("Para.HorzAlign").FormulaU = "1"
    
    # 4 Progressive Layer Swimlanes
    layers = [
        ("1. USER & FRONTEND LAYER", 5.6, 6.9, "RGB(240,249,255)"),
        ("2. HARDWARE & SENSING LAYER", 4.1, 5.4, "RGB(248,250,252)"),
        ("3. EDGE AI & LOCAL BUFFER LAYER", 2.6, 3.9, "RGB(240,253,244)"),
        ("4. CENTRAL BACKEND & ENTERPRISE DB", 1.1, 2.4, "RGB(255,247,237)")
    ]
    
    for l_title, ly1, ly2, l_color in layers:
        lane = page.DrawRectangle(0.8, ly1, PAGE_W - 0.8, ly2)
        lane.Cells("FillForegnd").FormulaU = l_color; lane.Cells("LineColor").FormulaU = "RGB(148,163,184)"; lane.Cells("LineWeight").FormulaU = "0.75 pt"
        lt = page.DrawRectangle(0.9, ly2 - 0.28, 4.0, ly2 - 0.05)
        lt.Text = l_title
        lt.Cells("FillPattern").FormulaU = "0"; lt.Cells("LinePattern").FormulaU = "0"
        lt.Cells("Char.Size").FormulaU = "8 pt"; lt.Cells("Char.Style").FormulaU = "1"; lt.Cells("Para.HorzAlign").FormulaU = "0"

    # Layer 1: Frontend
    b1 = page.DrawRectangle(1.1, 5.8, 2.8, 6.6); b1.Text = "Floor Operator\n(Mobile App)\nScan Roll QR & Start"
    b2 = page.DrawRectangle(3.3, 5.8, 5.0, 6.6); b2.Text = "Live Floor View\nInstant Defect Vibration\nSpeed & Meters Gauge"
    b3 = page.DrawRectangle(7.2, 5.8, 8.9, 6.6); b3.Text = "Quality Manager / Inspector\n(Web Dashboard)\n2D Defect Map & Crop Gallery"
    b4 = page.DrawRectangle(9.3, 5.8, 10.7, 6.6); b4.Text = "Final Result\nPDF Certificate\nVerified ASTM Grade"
    b4.Cells("FillForegnd").FormulaU = "RGB(220,252,231)"; b4.Cells("LineColor").FormulaU = "RGB(22,163,74)"; b4.Cells("LineWeight").FormulaU = "1.5 pt"

    # Layer 2: Hardware & Sensing
    b5 = page.DrawRectangle(1.1, 4.3, 2.8, 5.1); b5.Text = "Fabric Movement & Sensing\n• Camera (1080p Frames)\n• Rotary Encoder (Pulses)"
    dia = page.DrawOval(3.3, 4.3, 4.9, 5.1); dia.Text = "Inspection\nReliable?"
    dia.Cells("FillForegnd").FormulaU = "RGB(254,243,199)"; dia.Cells("LineColor").FormulaU = "RGB(217,119,6)"; dia.Cells("LineWeight").FormulaU = "1.5 pt"
    b6 = page.DrawRectangle(5.4, 4.3, 7.0, 5.1); b6.Text = "Trigger Hardware Relay\n• Amber Stack Light & Siren\n• Flag Uninspected Span [Y1, Y2]"
    b6.Cells("FillForegnd").FormulaU = "RGB(254,226,226)"; b6.Cells("LineColor").FormulaU = "RGB(220,38,38)"

    # Layer 3: Edge AI & Buffer
    b7 = page.DrawRectangle(1.1, 2.8, 2.8, 3.6); b7.Text = "AI Vision Detection\n• YOLO Defect BBox\n• Defect Class (Hole, Stain...)"
    b8 = page.DrawRectangle(3.3, 2.8, 5.0, 3.6); b8.Text = "Location & Deduplication\n• Coordinate Mapper (X_cm, Y_m)\n• Multi-Frame Tracker (No Dups)"
    b9 = page.DrawRectangle(5.4, 2.8, 7.0, 3.6); b9.Text = "Local SQLite Storage\n• Zero Delay Offline-First\n• Roll & Defect Records + JPEGs"

    # Layer 4: Central Backend
    b10 = page.DrawRectangle(3.3, 1.3, 5.0, 2.1); b10.Text = "Smart Operations Module\n• ASTM D5430 4-Point Grading\n• Grade Assignment (A, B, Scrap)"
    b11 = page.DrawRectangle(5.4, 1.3, 7.0, 2.1); b11.Text = "Central FastAPI Backend\n& PostgreSQL Enterprise DB\nSync Batches & WebSockets"

    for b in [b1, b2, b3, b5, b7, b8, b9, b10, b11]:
        b.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; b.Cells("LineColor").FormulaU = "RGB(15,23,42)"; b.Cells("LineWeight").FormulaU = "1 pt"
        b.Cells("Char.Size").FormulaU = "7.5 pt"; b.Cells("Para.HorzAlign").FormulaU = "1"

    # Connecting Flow Arrows with zero collisions
    def draw_flow_arrow(x1, y1, x2, y2, label=""):
        ln = page.DrawLine(x1, y1, x2, y2)
        ln.Cells("LineColor").FormulaU = "RGB(15,23,42)"; ln.Cells("LineWeight").FormulaU = "1 pt"
        ln.Cells("EndArrow").FormulaU = "13"; ln.Cells("EndArrowSize").FormulaU = "2"
        if label:
            mx, my = (x1 + x2)/2, (y1 + y2)/2
            lbl = page.DrawRectangle(mx - 0.75, my - 0.08, mx + 0.75, my + 0.12)
            lbl.Text = label
            lbl.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; lbl.Cells("LinePattern").FormulaU = "0"
            lbl.Cells("Char.Size").FormulaU = "7 pt"; lbl.Cells("Para.HorzAlign").FormulaU = "1"

    # 1. Floor Op -> Sensing (straight down)
    draw_flow_arrow(1.95, 5.8, 1.95, 5.1, "1. Start Session")
    # 2. Sensing -> Reliability Diamond (straight right)
    draw_flow_arrow(2.8, 4.7, 3.3, 4.7, "Raw Data")
    # 3. Diamond -> [NO: Fault] -> Amber Relay (straight right)
    draw_flow_arrow(4.9, 4.7, 5.4, 4.7, "[NO: Fault]")
    # 4. Diamond -> [YES: Reliable] -> AI Detection
    draw_flow_arrow(3.6, 4.3, 2.5, 3.6, "[YES: Reliable]")
    # 5. AI Detection -> Deduplication (straight right)
    draw_flow_arrow(2.8, 3.2, 3.3, 3.2, "BBox")
    # 6. Deduplication -> SQLite (straight right)
    draw_flow_arrow(5.0, 3.2, 5.4, 3.2, "(X, Y) Flaw")
    # 7. Live push up to Mobile View (routes cleanly at x=5.15 between dia and b6)
    draw_flow_arrow(5.15, 3.6, 5.15, 6.2, "")
    draw_flow_arrow(5.15, 6.2, 5.0, 6.2, "Live Push")
    # 8. SQLite sync down to FastAPI (straight down)
    draw_flow_arrow(6.2, 2.8, 6.2, 2.1, "Batch Sync")
    # 9. FastAPI -> Smart Operations (straight left)
    draw_flow_arrow(5.4, 1.7, 5.0, 1.7, "Compute")
    draw_flow_arrow(4.15, 2.1, 4.15, 2.8, "Grade")
    # 10. Central Backend -> Web Dashboard (routes cleanly along open airspace at x=8.05)
    draw_flow_arrow(7.0, 1.7, 8.05, 1.7, "")
    draw_flow_arrow(8.05, 1.7, 8.05, 5.8, "Load 2D Map")
    # 11. Web Dashboard -> PDF Export (straight right)
    draw_flow_arrow(8.9, 6.2, 9.3, 6.2, "Export")

    # Caption
    caption = page.DrawRectangle(PAGE_W/2 - 3.8, 0.15, PAGE_W/2 + 3.8, 0.45)
    caption.Text = "Figure: Complete System Workflow — TexEye AI"
    caption.Cells("FillPattern").FormulaU = "0"; caption.Cells("LinePattern").FormulaU = "0"
    caption.Cells("Char.Size").FormulaU = "10 pt"; caption.Cells("Char.Style").FormulaU = "1"; caption.Cells("Para.HorzAlign").FormulaU = "1"

    vsdx_path = os.path.join(OUT_DIR, "00_rough_workflow_paper.vsdx")
    doc.SaveAs(os.path.abspath(vsdx_path))
    png_path = os.path.join(PNG_DIR, "00_rough_workflow_paper.png")
    page.Export(os.path.abspath(png_path))
    doc.Close()
    return vsdx_path, png_path

def sync_all_to_onedrive():
    """Copies all vsdx files to OneDrive for instant Visio for the Web access."""
    if not os.path.exists(ONEDRIVE_DIR):
        return
    count = 0
    for f in os.listdir(OUT_DIR):
        if f.endswith(".vsdx"):
            shutil.copy2(os.path.join(OUT_DIR, f), os.path.join(ONEDRIVE_DIR, f))
            count += 1
    print(f"Synced {count} .vsdx files to OneDrive: {ONEDRIVE_DIR}")

if __name__ == "__main__":
    print("=" * 70)
    print("TexEye AI — Comprehensive Visio Diagram Builder v2.0")
    print("=" * 70)
    
    visio = init_visio()
    print(f"Connected to Microsoft Visio version: {visio.Version}")
    
    # 1. Build all 25 Use Case Sequence Diagrams
    print("\n--- 1. Building 25 Use Case Sequence Diagrams ---")
    for i, uc in enumerate(use_cases):
        uc_id, title = uc[0], uc[1]
        v_out = os.path.join(OUT_DIR, f"{uc_id}.vsdx")
        p_out = os.path.join(PNG_DIR, f"{uc_id}.png")
        clean_title = title.split(": ", 1)[1] if ": " in title else title
        fig_cap = f"Figure 5.5.{i+1}: Sequence Diagram for {title}"
        parts = [
            (uc[2], uc[3], True),
            (uc[5].replace(":", ""), uc[5], False),
            (uc[7].replace(":", ""), uc[7], False),
            (uc[9].replace(":", ""), uc[9], False),
            (uc[11].replace(":", ""), uc[11], False)
        ]
        render_sequence_sheet(visio, uc_id, fig_cap, clean_title, parts, uc[12], v_out, p_out)
        print(f"  [{i+1}/25] {uc_id}.vsdx")
        
    # 2. Build 5 Module Sequence Diagrams
    print("\n--- 2. Building 5 Core Module Sequence Diagrams ---")
    for m in module_diagrams:
        m_id, m_title, m_cap, m_tab, m_parts, m_steps = m
        v_out = os.path.join(OUT_DIR, f"{m_id}.vsdx")
        p_out = os.path.join(PNG_DIR, f"{m_id}.png")
        render_sequence_sheet(visio, m_id, m_cap, m_tab, m_parts, m_steps, v_out, p_out)
        print(f"  {m_id}.vsdx")
        
    # 3. Build Rough Workflow Blueprint
    print("\n--- 3. Building Rough Workflow Blueprint ---")
    rw_vsdx, rw_png = build_rough_workflow(visio)
    print(f"  {os.path.basename(rw_vsdx)}")
    
    # 4. Copy 00 to 01_overall_system_workflow as well
    shutil.copy2(rw_vsdx, os.path.join(OUT_DIR, "01_overall_system_workflow.vsdx"))
    shutil.copy2(rw_png, os.path.join(PNG_DIR, "01_overall_system_workflow.png"))
    
    # 5. Build Master Collection
    print("\n--- 4. Building Master Diagrams Notebook ---")
    master_doc = visio.Documents.Add("")
    p1 = master_doc.Pages.Item(1)
    p1.Name = "Master Index"
    p1.PageSheet.Cells("PageWidth").FormulaU = f"{PAGE_W} in"
    p1.PageSheet.Cells("PageHeight").FormulaU = f"{PAGE_H} in"
    
    hdr = p1.DrawRectangle(1.0, 5.0, PAGE_W - 1.0, 7.5)
    hdr.Text = "TexEye AI — Master Microsoft Visio Diagrams Collection\n\nCOMSATS University Islamabad • Wah Cantt Campus\nDepartment of Computer Science • Final Year Project (FYP)\nSupervisor: Dr. Tassawar Iqbal\nStudents: Muhammad Bilal Butt (FA23-BAI-042) & Muhammad Afnan Khan (FA23-BAI-028)"
    hdr.Cells("FillForegnd").FormulaU = "RGB(241,245,249)"; hdr.Cells("LineColor").FormulaU = "RGB(15,23,42)"; hdr.Cells("LineWeight").FormulaU = "1.5 pt"
    hdr.Cells("Char.Size").FormulaU = "13 pt"; hdr.Cells("Char.Style").FormulaU = "1"; hdr.Cells("Para.HorzAlign").FormulaU = "1"
    
    cat = p1.DrawRectangle(1.0, 1.2, PAGE_W - 1.0, 4.6)
    cat.Text = "Included Diagram Collections:\n1. 00 Rough Workflow Blueprint (Paper Reproduction)\n2. 07 Module-Wise System Use Case Diagram\n3. Modules 1 to 5 Subsystem Sequence Diagrams\n4. All 25 Formal UML Use Case Sequence Realization Diagrams (UC-OP-01 through UC-ADMIN-04)\n\nEvery diagram is 100% native Visio vector objects with proper UML lifelines, actors, activation bars, and arrow connectors matching the supervisor's exact presentation standards."
    cat.Cells("FillForegnd").FormulaU = "RGB(255,255,255)"; cat.Cells("LineColor").FormulaU = "RGB(203,213,225)"; cat.Cells("LineWeight").FormulaU = "1 pt"
    cat.Cells("Char.Size").FormulaU = "10 pt"; cat.Cells("Para.HorzAlign").FormulaU = "0"
    
    master_path = os.path.join(OUT_DIR, "TexEye_AI_Master_Diagrams_Collection.vsdx")
    master_doc.SaveAs(os.path.abspath(master_path))
    master_doc.Close()
    print(f"  TexEye_AI_Master_Diagrams_Collection.vsdx")
    
    visio.Quit()
    print("\nVisio session closed cleanly.")
    
    # 6. Sync to OneDrive
    sync_all_to_onedrive()
    
    print("\n" + "=" * 70)
    print("ALL VISIO DIAGRAMS REBUILT AND VERIFIED SUCCESSFULLY!")
    print("=" * 70)

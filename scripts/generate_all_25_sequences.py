import os
import re
import subprocess

print("Generating all 25 UML Sequence Diagrams for TexEye AI...")

os.makedirs(r"diagrams\usecases\pdf", exist_ok=True)
os.makedirs(r"diagrams\usecases\png", exist_ok=True)

# 25 Use Cases Specifications: (id, name, actor, actor_label, ui, ui_label, api, api_label, srv, srv_label, db, db_label, steps)
use_cases = [
    # --- Floor Operator (5) ---
    (
        "uc_op_01_login_logout",
        "UC-OP-01: Login / Logout",
        "Floor Operator",
        ":FloorOperator",
        "Mobile App",
        ":MobileUI (Flutter)",
        "API Gateway",
        ":FastAPIGateway",
        "Auth Service",
        ":AuthService",
        "Local Storage",
        ":SecureStorage",
        [
            ("1. enter_credentials(pin, stand_id)", ":FloorOperator", ":MobileUI (Flutter)", "sync", 1),
            ("2. POST /api/v1/auth/floor-login", ":MobileUI (Flutter)", ":FastAPIGateway", "sync", 2),
            ("3. verify_operator_pin()", ":FastAPIGateway", ":AuthService", "sync", 3),
            ("4. return jwt_token & operator_profile", ":AuthService", ":FastAPIGateway", "ret", 4),
            ("5. 200 OK (token, expires_in)", ":FastAPIGateway", ":MobileUI (Flutter)", "ret", 5),
            ("6. store_encrypted_jwt(token)", ":MobileUI (Flutter)", ":SecureStorage", "sync", 6),
            ("7. display_stand_home_dashboard()", ":MobileUI (Flutter)", ":FloorOperator", "ret", 7)
        ],
        "Floor operator authenticates at the machine stand tablet, validates operator credentials, receives a signed JWT token, and accesses the floor run interface."
    ),
    (
        "uc_op_02_scan_roll_qr",
        "UC-OP-02: Scan Roll QR Code",
        "Floor Operator",
        ":FloorOperator",
        "Mobile App",
        ":MobileUI (Flutter)",
        "Camera Plugin",
        ":QRScannerPlugin",
        "Edge Daemon",
        ":EdgeEngine",
        "Local SQLite",
        ":SQLiteBuffer",
        [
            ("1. tap_scan_roll_qr()", ":FloorOperator", ":MobileUI (Flutter)", "sync", 1),
            ("2. start_camera_viewfinder()", ":MobileUI (Flutter)", ":QRScannerPlugin", "sync", 2),
            ("3. qr_decoded('ROLL-2026-X89')", ":QRScannerPlugin", ":MobileUI (Flutter)", "ret", 3),
            ("4. POST /sessions/start(roll_id)", ":MobileUI (Flutter)", ":EdgeEngine", "sync", 4),
            ("5. zero_encoder_pulses()", ":EdgeEngine", ":EdgeEngine", "self", 5),
            ("6. INSERT roll_session(roll_id, status='ACTIVE')", ":EdgeEngine", ":SQLiteBuffer", "sync", 6),
            ("7. 200 OK (session_active, limits)", ":EdgeEngine", ":MobileUI (Flutter)", "ret", 7),
            ("8. display_ready_to_roll_screen()", ":MobileUI (Flutter)", ":FloorOperator", "ret", 8)
        ],
        "Operator scans the fabric roll physical QR tag, initializes the inspection run on the stand edge daemon, zeros the displacement pulse counter, and readies the stand."
    ),
    (
        "uc_op_03_view_active_roll",
        "UC-OP-03: View Active Roll Information & Telemetry",
        "Floor Operator",
        ":FloorOperator",
        "Mobile App",
        ":MobileUI (Flutter)",
        "WebSocket Client",
        ":WSClient",
        "Edge Daemon",
        ":EdgeEngine",
        "Local SQLite",
        ":SQLiteBuffer",
        [
            ("1. fabric_rolls_on_stand()", ":FloorOperator", ":EdgeEngine", "sync", 1),
            ("2. emit_telemetry(velocity=0.35m/s, length=42.6m)", ":EdgeEngine", ":WSClient", "sync", 2),
            ("3. on_speed_update(velocity, meters)", ":WSClient", ":MobileUI (Flutter)", "ret", 3),
            ("4. SELECT count(*) FROM defect_records", ":EdgeEngine", ":SQLiteBuffer", "sync", 4),
            ("5. return current_flaw_count=3", ":SQLiteBuffer", ":EdgeEngine", "ret", 5),
            ("6. update_meters_gauge_and_defect_counter()", ":MobileUI (Flutter)", ":FloorOperator", "ret", 6)
        ],
        "Displays real-time fabric movement velocity (m/s), elapsed inspection meters, and cumulative defect count via high-speed local WebSocket during active production."
    ),
    (
        "uc_op_04_receive_inspection_alerts",
        "UC-OP-04: Receive Inspection Warning Alerts",
        "Floor Operator",
        ":FloorOperator",
        "Mobile App",
        ":MobileUI (Flutter)",
        "WebSocket Client",
        ":WSClient",
        "Reliability Guard",
        ":ReliabilityGuard",
        "Hardware Relays",
        ":USBRelayBoard",
        [
            ("1. sensor_fault_detected(lux < 800 | hole > 25mm)", ":ReliabilityGuard", ":ReliabilityGuard", "self", 1),
            ("2. trip_relay(AMBER_LIGHT, ON)", ":ReliabilityGuard", ":USBRelayBoard", "sync", 2),
            ("3. emit_alert_event(severity='CRITICAL', flaw='Hole')", ":ReliabilityGuard", ":WSClient", "sync", 3),
            ("4. trigger_device_haptic_vibration(500ms)", ":WSClient", ":MobileUI (Flutter)", "sync", 4),
            ("5. render_high_contrast_alarm_modal()", ":MobileUI (Flutter)", ":FloorOperator", "sync", 5),
            ("6. tap_acknowledge_alarm()", ":FloorOperator", ":MobileUI (Flutter)", "sync", 6),
            ("7. POST /alerts/ack(alert_id)", ":MobileUI (Flutter)", ":ReliabilityGuard", "ret", 7)
        ],
        "Notifies the floor operator of critical defects or sensor faults through physical stack lights, sirens, and tactile mobile vibration pulses."
    ),
    (
        "uc_op_05_review_detected_defects",
        "UC-OP-05: Review Detected Defects on Mobile Screen",
        "Floor Operator",
        ":FloorOperator",
        "Mobile App",
        ":MobileUI (Flutter)",
        "Edge API",
        ":EdgeAPIServer",
        "Local NVMe",
        ":DiskCropStore",
        "Local SQLite",
        ":SQLiteBuffer",
        [
            ("1. tap_view_detected_defects()", ":FloorOperator", ":MobileUI (Flutter)", "sync", 1),
            ("2. GET /sessions/current/defects", ":MobileUI (Flutter)", ":EdgeAPIServer", "sync", 2),
            ("3. SELECT id, flaw_class, coord_x, coord_y FROM defects", ":EdgeAPIServer", ":SQLiteBuffer", "sync", 3),
            ("4. return defects_list_meta", ":SQLiteBuffer", ":EdgeAPIServer", "ret", 4),
            ("5. read_crop_image(crop_uuid.jpg)", ":EdgeAPIServer", ":DiskCropStore", "sync", 5),
            ("6. return jpeg_bytes(256x256)", ":DiskCropStore", ":EdgeAPIServer", "ret", 6),
            ("7. render_defect_card_carousel()", ":MobileUI (Flutter)", ":FloorOperator", "ret", 7)
        ],
        "Allows the floor operator to review detected flaws and thumbnail crops directly on the tablet screen without leaving the inspection stand."
    ),

    # --- Quality Inspector (7) ---
    (
        "uc_qi_01_login_logout",
        "UC-QI-01: Quality Inspector Login / Logout",
        "Quality Inspector",
        ":QualityInspector",
        "Web Dashboard",
        ":ReactWebDashboard",
        "API Gateway",
        ":FastAPIGateway",
        "Auth Service",
        ":AuthService",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. enter_username_password()", ":QualityInspector", ":ReactWebDashboard", "sync", 1),
            ("2. POST /api/v1/auth/login", ":ReactWebDashboard", ":FastAPIGateway", "sync", 2),
            ("3. query_user_roles(user_id)", ":FastAPIGateway", ":AuthService", "sync", 3),
            ("4. SELECT password_hash, role='INSPECTOR'", ":AuthService", ":PostgreSQLDB", "sync", 4),
            ("5. return user_record_and_permissions", ":PostgreSQLDB", ":AuthService", "ret", 5),
            ("6. issue_signed_jwt_token(roles=['QA_INSPECTOR'])", ":AuthService", ":FastAPIGateway", "ret", 6),
            ("7. 200 OK (access_token, user_profile)", ":FastAPIGateway", ":ReactWebDashboard", "ret", 7),
            ("8. render_qa_control_panel_view()", ":ReactWebDashboard", ":QualityInspector", "ret", 8)
        ],
        "Quality inspector securely authenticates into the web management dashboard via role-based access control (RBAC)."
    ),
    (
        "uc_qi_02_view_2d_defect_map",
        "UC-QI-02: View Digital Fabric Defect Map (2D Canvas)",
        "Quality Inspector",
        ":QualityInspector",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Canvas Engine",
        ":HTML5CanvasMap",
        "Roll Service",
        ":RollService",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. select_roll(roll_id='ROLL-2026-X89')", ":QualityInspector", ":ReactWebDashboard", "sync", 1),
            ("2. GET /api/v1/rolls/{id}/map", ":ReactWebDashboard", ":RollService", "sync", 2),
            ("3. SELECT * FROM defects WHERE roll_id={id}", ":RollService", ":PostgreSQLDB", "sync", 3),
            ("4. SELECT * FROM uninspected_spans WHERE roll_id={id}", ":RollService", ":PostgreSQLDB", "sync", 4),
            ("5. return roll_defects_and_spans_payload", ":PostgreSQLDB", ":RollService", "ret", 5),
            ("6. 200 OK (map_json)", ":RollService", ":ReactWebDashboard", "ret", 6),
            ("7. draw_roll_canvas(length=100m, width=1.8m)", ":ReactWebDashboard", ":HTML5CanvasMap", "sync", 7),
            ("8. render_color_pins_and_amber_bands()", ":HTML5CanvasMap", ":QualityInspector", "ret", 8)
        ],
        "Renders a high-performance 2D HTML5 Canvas map representing the entire unwound fabric roll with interactive colored flaw pins and amber uninspected warning bands."
    ),
    (
        "uc_qi_03_review_defect_crops",
        "UC-QI-03: Review Defect High-Resolution Images & Calipers",
        "Quality Inspector",
        ":QualityInspector",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Crop Modal",
        ":DefectInspectorModal",
        "Object Storage",
        ":MinIOStore",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. click_defect_pin(defect_id=14)", ":QualityInspector", ":ReactWebDashboard", "sync", 1),
            ("2. GET /api/v1/defects/{id}/details", ":ReactWebDashboard", ":PostgreSQLDB", "sync", 2),
            ("3. return flaw_meta(class='Hole', length=12mm, crop_key)", ":PostgreSQLDB", ":ReactWebDashboard", "ret", 3),
            ("4. GET /storage/crops/{crop_key}", ":ReactWebDashboard", ":MinIOStore", "sync", 4),
            ("5. stream_jpeg_blob(256x256, lossless)", ":MinIOStore", ":ReactWebDashboard", "ret", 5),
            ("6. open_modal_with_caliper_overlay()", ":ReactWebDashboard", ":DefectInspectorModal", "sync", 6),
            ("7. display_zoomable_crop_with_metrics()", ":DefectInspectorModal", ":QualityInspector", "ret", 7)
        ],
        "Enables the inspector to inspect high-resolution lossless JPEG crops and use on-screen digital calipers to verify defect millimeter measurements."
    ),
    (
        "uc_qi_04_correct_defect_record",
        "UC-QI-04: Correct Defect Record & Audit Trail",
        "Quality Inspector",
        ":QualityInspector",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Defect Service",
        ":DefectService",
        "Audit Service",
        ":AuditService",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. select_new_class('Foreign Yarn') & enter_reason()", ":QualityInspector", ":ReactWebDashboard", "sync", 1),
            ("2. PATCH /api/v1/defects/{id} {class, reason}", ":ReactWebDashboard", ":DefectService", "sync", 2),
            ("3. UPDATE defects SET flaw_class='Foreign Yarn'", ":DefectService", ":PostgreSQLDB", "sync", 3),
            ("4. log_audit_trail(defect_id, old='Hole', new='Yarn', inspector)", ":DefectService", ":AuditService", "sync", 4),
            ("5. INSERT INTO defect_audit_logs", ":AuditService", ":PostgreSQLDB", "sync", 5),
            ("6. 200 OK (reclassification_committed)", ":DefectService", ":ReactWebDashboard", "ret", 6),
            ("7. update_defect_glyph_color_on_canvas()", ":ReactWebDashboard", ":QualityInspector", "ret", 7)
        ],
        "Allows quality inspectors to override AI classifications with mandatory justification, recording an immutable audit trail for export compliance."
    ),
    (
        "uc_qi_05_view_uninspected_intervals",
        "UC-QI-05: View Roll Inspection Status & Uninspected Intervals",
        "Quality Inspector",
        ":QualityInspector",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Coverage Service",
        ":CoverageService",
        "Roll Service",
        ":RollService",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. click_coverage_tab()", ":QualityInspector", ":ReactWebDashboard", "sync", 1),
            ("2. GET /api/v1/rolls/{id}/uninspected-spans", ":ReactWebDashboard", ":CoverageService", "sync", 2),
            ("3. SELECT * FROM uninspected_spans WHERE roll_id={id}", ":CoverageService", ":PostgreSQLDB", "sync", 3),
            ("4. return spans_list [ [14.2m, 15.8m, 'LUX_DROP'] ]", ":PostgreSQLDB", ":CoverageService", "ret", 4),
            ("5. calculate_coverage_ratio(98.4%)", ":CoverageService", ":CoverageService", "self", 5),
            ("6. 200 OK (coverage_stats, flag_zones)", ":CoverageService", ":ReactWebDashboard", "ret", 6),
            ("7. render_amber_span_table_and_action_flag()", ":ReactWebDashboard", ":QualityInspector", "ret", 7)
        ],
        "Displays uninspected interval metrics, highlighting gaps caused by lighting or sensor faults and flagging rolls requiring manual re-inspection."
    ),
    (
        "uc_qi_06_confirm_roll_grading",
        "UC-QI-06: Confirm / Update 4-Point Roll Grading",
        "Quality Inspector",
        ":QualityInspector",
        "Web Dashboard",
        ":ReactWebDashboard",
        "ASTM Engine",
        ":ASTMEngine",
        "Roll Service",
        ":RollService",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. tap_calculate_final_grade()", ":QualityInspector", ":ReactWebDashboard", "sync", 1),
            ("2. POST /api/v1/rolls/{id}/compute-astm", ":ReactWebDashboard", ":ASTMEngine", "sync", 2),
            ("3. SELECT length_mm, flaw_class FROM defects", ":ASTMEngine", ":PostgreSQLDB", "sync", 3),
            ("4. return verified_defects_list", ":PostgreSQLDB", ":ASTMEngine", "ret", 4),
            ("5. execute_astm_d5430_penalty_calculation()", ":ASTMEngine", ":ASTMEngine", "self", 5),
            ("6. UPDATE fabric_rolls SET grade='Grade A', points=14.2", ":ASTMEngine", ":PostgreSQLDB", "sync", 6),
            ("7. 200 OK (grade='Grade A', points_per_100sqm=14.2)", ":ASTMEngine", ":ReactWebDashboard", "ret", 7),
            ("8. render_astm_scorecard_badge()", ":ReactWebDashboard", ":QualityInspector", "ret", 8)
        ],
        "Computes ASTM D5430-07 penalty points based on defect length and standardizes total points per 100 square meters to determine final roll export grade."
    ),
    (
        "uc_qi_07_generate_inspection_report",
        "UC-QI-07: Generate Digital Inspection Report & PDF",
        "Quality Inspector",
        ":QualityInspector",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Report Engine",
        ":ReportEngine",
        "Signer Service",
        ":CryptoSigner",
        "Object Storage",
        ":MinIOStore",
        [
            ("1. tap_export_inspection_report()", ":QualityInspector", ":ReactWebDashboard", "sync", 1),
            ("2. POST /api/v1/reports/pdf/compile", ":ReactWebDashboard", ":ReportEngine", "sync", 2),
            ("3. assemble_report_data(roll, defects, astm, audit)", ":ReportEngine", ":ReportEngine", "self", 3),
            ("4. generate_sha256_hash_digest()", ":ReportEngine", ":CryptoSigner", "sync", 4),
            ("5. return cryptographic_seal_hex", ":CryptoSigner", ":ReportEngine", "ret", 5),
            ("6. render_pdf_binary_and_upload()", ":ReportEngine", ":MinIOStore", "sync", 6),
            ("7. 200 OK (download_url, sha256_seal)", ":ReportEngine", ":ReactWebDashboard", "ret", 7),
            ("8. prompt_download_certified_pdf()", ":ReactWebDashboard", ":QualityInspector", "ret", 8)
        ],
        "Compiles an export-ready digital inspection report with defect charts, canvas miniatures, and cryptographic SHA-256 digital seals."
    ),

    # --- Production Manager (4) ---
    (
        "uc_pm_01_login_logout",
        "UC-PM-01: Production Manager Login / Logout",
        "Production Manager",
        ":ProductionManager",
        "Web Dashboard",
        ":ReactWebDashboard",
        "API Gateway",
        ":FastAPIGateway",
        "Auth Service",
        ":AuthService",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. enter_manager_credentials()", ":ProductionManager", ":ReactWebDashboard", "sync", 1),
            ("2. POST /api/v1/auth/login", ":ReactWebDashboard", ":FastAPIGateway", "sync", 2),
            ("3. verify_executive_privileges()", ":FastAPIGateway", ":AuthService", "sync", 3),
            ("4. SELECT role='PROD_MANAGER'", ":AuthService", ":PostgreSQLDB", "sync", 4),
            ("5. return user_and_scopes", ":PostgreSQLDB", ":AuthService", "ret", 5),
            ("6. 200 OK (jwt_token, dashboard_scope)", ":AuthService", ":ReactWebDashboard", "ret", 6),
            ("7. render_executive_portal_view()", ":ReactWebDashboard", ":ProductionManager", "ret", 7)
        ],
        "Production Manager authenticates with executive credentials to access high-level plant throughput and quality analytics."
    ),
    (
        "uc_pm_02_view_production_dashboard",
        "UC-PM-02: View Production Executive Dashboard",
        "Production Manager",
        ":ProductionManager",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Analytics Engine",
        ":AnalyticsEngine",
        "FastAPI Gateway",
        ":FastAPIGateway",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. open_executive_dashboard()", ":ProductionManager", ":ReactWebDashboard", "sync", 1),
            ("2. GET /api/v1/analytics/kpi?shift='CURRENT'", ":ReactWebDashboard", ":FastAPIGateway", "sync", 2),
            ("3. aggregate_shift_metrics()", ":FastAPIGateway", ":AnalyticsEngine", "sync", 3),
            ("4. SELECT count(rolls), sum(meters), avg(grade) FROM fabric_rolls", ":AnalyticsEngine", ":PostgreSQLDB", "sync", 4),
            ("5. return aggregated_kpi_payload", ":PostgreSQLDB", ":AnalyticsEngine", "ret", 5),
            ("6. 200 OK (total_rolls=28, yield=94.2%, scrap=2)", ":AnalyticsEngine", ":ReactWebDashboard", "ret", 6),
            ("7. render_kpi_cards_and_throughput_gauge()", ":ReactWebDashboard", ":ProductionManager", "ret", 7)
        ],
        "Aggregates plant-wide KPIs across active shifts, including total rolls inspected, total fabric meters, first-pass yield, and scrap rates."
    ),
    (
        "uc_pm_03_view_defect_pareto_stats",
        "UC-PM-03: View Defect Pareto Statistics & Trend Analytics",
        "Production Manager",
        ":ProductionManager",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Pareto Engine",
        ":ParetoEngine",
        "FastAPI Gateway",
        ":FastAPIGateway",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. select_batch_filter(batch='BATCH-402')", ":ProductionManager", ":ReactWebDashboard", "sync", 1),
            ("2. GET /api/v1/analytics/pareto?batch=B402", ":ReactWebDashboard", ":FastAPIGateway", "sync", 2),
            ("3. compute_pareto_distribution()", ":FastAPIGateway", ":ParetoEngine", "sync", 3),
            ("4. SELECT flaw_class, count(*) FROM defects GROUP BY flaw_class", ":ParetoEngine", ":PostgreSQLDB", "sync", 4),
            ("5. return flaw_frequencies_desc", ":PostgreSQLDB", ":ParetoEngine", "ret", 5),
            ("6. calculate_cumulative_percentage()", ":ParetoEngine", ":ParetoEngine", "self", 6),
            ("7. 200 OK (pareto_dataset_json)", ":ParetoEngine", ":ReactWebDashboard", "ret", 7),
            ("8. render_pareto_80_20_chart()", ":ReactWebDashboard", ":ProductionManager", "ret", 8)
        ],
        "Computes an 80/20 Pareto distribution identifying primary defect root causes (e.g. Broken Warp threads vs. machine oil drips) to guide loom maintenance."
    ),
    (
        "uc_pm_04_view_historical_records",
        "UC-PM-04: View Historical Production Quality Records",
        "Production Manager",
        ":ProductionManager",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Query Service",
        ":HistoricalQueryService",
        "FastAPI Gateway",
        ":FastAPIGateway",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. apply_filters(date_range, fabric_type='Denim')", ":ProductionManager", ":ReactWebDashboard", "sync", 1),
            ("2. GET /api/v1/rolls/history?limit=50&offset=0", ":ReactWebDashboard", ":FastAPIGateway", "sync", 2),
            ("3. build_dynamic_sql_query()", ":FastAPIGateway", ":HistoricalQueryService", "sync", 3),
            ("4. SELECT * FROM fabric_rolls WHERE type='Denim'", ":HistoricalQueryService", ":PostgreSQLDB", "sync", 4),
            ("5. return paginated_historical_records", ":PostgreSQLDB", ":HistoricalQueryService", "ret", 5),
            ("6. 200 OK (records_page, total_count=340)", ":HistoricalQueryService", ":ReactWebDashboard", "ret", 6),
            ("7. render_searchable_data_table_with_export()", ":ReactWebDashboard", ":ProductionManager", "ret", 7)
        ],
        "Provides multi-criteria search and filtering across past production runs with direct export options for factory ERP auditing."
    ),

    # --- Inventory Manager (5) ---
    (
        "uc_im_01_login_logout",
        "UC-IM-01: Inventory Manager Login / Logout",
        "Inventory Manager",
        ":InventoryManager",
        "Web Dashboard",
        ":ReactWebDashboard",
        "API Gateway",
        ":FastAPIGateway",
        "Auth Service",
        ":AuthService",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. enter_warehouse_credentials()", ":InventoryManager", ":ReactWebDashboard", "sync", 1),
            ("2. POST /api/v1/auth/login", ":ReactWebDashboard", ":FastAPIGateway", "sync", 2),
            ("3. verify_warehouse_scope()", ":FastAPIGateway", ":AuthService", "sync", 3),
            ("4. SELECT role='INVENTORY_MGR'", ":AuthService", ":PostgreSQLDB", "sync", 4),
            ("5. return user_and_scopes", ":PostgreSQLDB", ":AuthService", "ret", 5),
            ("6. 200 OK (jwt_token, warehouse_scope)", ":AuthService", ":ReactWebDashboard", "ret", 6),
            ("7. render_warehouse_management_view()", ":ReactWebDashboard", ":InventoryManager", "ret", 7)
        ],
        "Inventory manager authenticates to access warehouse roll allocation, pallet assignment, and scrap segregation records."
    ),
    (
        "uc_im_02_view_warehouse_inventory",
        "UC-IM-02: View Warehouse Inventory Records",
        "Inventory Manager",
        ":InventoryManager",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Inventory Service",
        ":InventoryService",
        "FastAPI Gateway",
        ":FastAPIGateway",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. open_inventory_ledger()", ":InventoryManager", ":ReactWebDashboard", "sync", 1),
            ("2. GET /api/v1/inventory/rolls?status=IN_STOCK", ":ReactWebDashboard", ":FastAPIGateway", "sync", 2),
            ("3. query_available_stock()", ":FastAPIGateway", ":InventoryService", "sync", 3),
            ("4. SELECT roll_id, grade, length, rack_location FROM rolls", ":InventoryService", ":PostgreSQLDB", "sync", 4),
            ("5. return current_warehouse_stock", ":PostgreSQLDB", ":InventoryService", "ret", 5),
            ("6. 200 OK (stock_items_list)", ":InventoryService", ":ReactWebDashboard", "ret", 6),
            ("7. render_warehouse_stock_grid()", ":ReactWebDashboard", ":InventoryManager", "ret", 7)
        ],
        "Displays real-time stock levels of certified fabric rolls categorized by ASTM grade, fabric blend, and physical warehouse location."
    ),
    (
        "uc_im_03_update_roll_location",
        "UC-IM-03: Update Roll Warehouse Storage Location",
        "Inventory Manager",
        ":InventoryManager",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Inventory Service",
        ":InventoryService",
        "FastAPI Gateway",
        ":FastAPIGateway",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. update_location(roll_id, rack='B-04-S2')", ":InventoryManager", ":ReactWebDashboard", "sync", 1),
            ("2. PATCH /api/v1/inventory/rolls/{id}/location", ":ReactWebDashboard", ":FastAPIGateway", "sync", 2),
            ("3. update_storage_bay()", ":FastAPIGateway", ":InventoryService", "sync", 3),
            ("4. UPDATE fabric_rolls SET rack_location='B-04-S2'", ":InventoryService", ":PostgreSQLDB", "sync", 4),
            ("5. return update_success", ":PostgreSQLDB", ":InventoryService", "ret", 5),
            ("6. 200 OK (location_updated)", ":InventoryService", ":ReactWebDashboard", "ret", 6),
            ("7. display_toast('Roll moved to Bay B-04-S2')", ":ReactWebDashboard", ":InventoryManager", "ret", 7)
        ],
        "Updates physical storage bay and pallet coordinates when rolls are moved into warehouse storage or staged for shipping."
    ),
    (
        "uc_im_04_view_certified_grading",
        "UC-IM-04: View Certified Roll Grading Status",
        "Inventory Manager",
        ":InventoryManager",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Cert Service",
        ":CertVerificationService",
        "FastAPI Gateway",
        ":FastAPIGateway",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. search_order_requirements(grade='Grade A')", ":InventoryManager", ":ReactWebDashboard", "sync", 1),
            ("2. GET /api/v1/inventory/certified?grade=Grade_A", ":ReactWebDashboard", ":FastAPIGateway", "sync", 2),
            ("3. query_export_certified_stock()", ":FastAPIGateway", ":CertVerificationService", "sync", 3),
            ("4. SELECT roll_id, grade, sha256_hash FROM fabric_rolls", ":CertVerificationService", ":PostgreSQLDB", "sync", 4),
            ("5. return certified_rolls_batch", ":PostgreSQLDB", ":CertVerificationService", "ret", 5),
            ("6. 200 OK (certified_list, cert_urls)", ":CertVerificationService", ":ReactWebDashboard", "ret", 6),
            ("7. render_export_allocation_table()", ":ReactWebDashboard", ":InventoryManager", "ret", 7)
        ],
        "Enables warehouse teams to verify quality certificates and match Grade A certified rolls against customer export orders."
    ),
    (
        "uc_im_05_manage_scrap_segregation",
        "UC-IM-05: Manage Scrap & Quarantined Roll Segregation",
        "Inventory Manager",
        ":InventoryManager",
        "Web Dashboard",
        ":ReactWebDashboard",
        "Quarantine Service",
        ":QuarantineService",
        "FastAPI Gateway",
        ":FastAPIGateway",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. select_scrap_roll(roll_id='ROLL-109')", ":InventoryManager", ":ReactWebDashboard", "sync", 1),
            ("2. POST /api/v1/inventory/quarantine/segregate", ":ReactWebDashboard", ":FastAPIGateway", "sync", 2),
            ("3. tag_quarantine_bay('BIN-SCRAP-RED')", ":FastAPIGateway", ":QuarantineService", "sync", 3),
            ("4. UPDATE rolls SET status='SCRAP_LOCKED', bay='BIN-RED'", ":QuarantineService", ":PostgreSQLDB", "sync", 4),
            ("5. return quarantine_record_id", ":PostgreSQLDB", ":QuarantineService", "ret", 5),
            ("6. 200 OK (segregation_manifest_pdf)", ":QuarantineService", ":ReactWebDashboard", "ret", 6),
            ("7. print_quarantine_red_tag()", ":ReactWebDashboard", ":InventoryManager", "ret", 7)
        ],
        "Enforces physical quarantine procedures for rejected/scrap fabric rolls, locking them from shipping and logging segregation manifests."
    ),

    # --- System Administrator (4) ---
    (
        "uc_admin_01_login_logout",
        "UC-ADMIN-01: System Administrator Login / Logout",
        "System Admin",
        ":SystemAdmin",
        "Admin Panel",
        ":AdminPortal (React)",
        "API Gateway",
        ":FastAPIGateway",
        "Auth Service",
        ":AuthService",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. enter_admin_credentials()", ":SystemAdmin", ":AdminPortal (React)", "sync", 1),
            ("2. POST /api/v1/auth/admin-login", ":AdminPortal (React)", ":FastAPIGateway", "sync", 2),
            ("3. verify_superuser_status()", ":FastAPIGateway", ":AuthService", "sync", 3),
            ("4. SELECT is_superuser=TRUE, mfa_valid", ":AuthService", ":PostgreSQLDB", "sync", 4),
            ("5. return admin_user_record", ":PostgreSQLDB", ":AuthService", "ret", 5),
            ("6. 200 OK (admin_jwt_token, scopes=['*'])", ":AuthService", ":AdminPortal (React)", "ret", 6),
            ("7. render_system_administration_console()", ":AdminPortal (React)", ":SystemAdmin", "ret", 7)
        ],
        "Superuser administrator authenticates with elevated privileges to configure edge stand hardware, manage users, and adjust thresholds."
    ),
    (
        "uc_admin_02_manage_user_accounts",
        "UC-ADMIN-02: Manage User Accounts (CRUD)",
        "System Admin",
        ":SystemAdmin",
        "Admin Panel",
        ":AdminPortal (React)",
        "User Service",
        ":UserManagementService",
        "FastAPI Gateway",
        ":FastAPIGateway",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. submit_new_user_form(username, role, pass)", ":SystemAdmin", ":AdminPortal (React)", "sync", 1),
            ("2. POST /api/v1/admin/users", ":AdminPortal (React)", ":FastAPIGateway", "sync", 2),
            ("3. hash_password_bcrypt()", ":FastAPIGateway", ":UserManagementService", "sync", 3),
            ("4. INSERT INTO users (username, role, pwd_hash)", ":UserManagementService", ":PostgreSQLDB", "sync", 4),
            ("5. return new_user_uuid", ":PostgreSQLDB", ":UserManagementService", "ret", 5),
            ("6. 201 Created (user_created_successfully)", ":UserManagementService", ":AdminPortal (React)", "ret", 6),
            ("7. update_active_user_table()", ":AdminPortal (React)", ":SystemAdmin", "ret", 7)
        ],
        "Handles user account creation, credential rotation, role assignment, and account deactivation across shop-floor and management roles."
    ),
    (
        "uc_admin_03_assign_roles_scopes",
        "UC-ADMIN-03: Assign Roles & Scopes (RBAC)",
        "System Admin",
        ":SystemAdmin",
        "Admin Panel",
        ":AdminPortal (React)",
        "RBAC Engine",
        ":RBACService",
        "FastAPI Gateway",
        ":FastAPIGateway",
        "Central DB",
        ":PostgreSQLDB",
        [
            ("1. select_user_and_update_role('Inspector')", ":SystemAdmin", ":AdminPortal (React)", "sync", 1),
            ("2. PUT /api/v1/admin/users/{id}/roles", ":AdminPortal (React)", ":FastAPIGateway", "sync", 2),
            ("3. update_role_permissions()", ":FastAPIGateway", ":RBACService", "sync", 3),
            ("4. UPDATE user_roles SET role_id=2", ":RBACService", ":PostgreSQLDB", "sync", 4),
            ("5. revoke_cached_jwt_tokens(user_id)", ":RBACService", ":PostgreSQLDB", "sync", 5),
            ("6. 200 OK (role_permissions_updated)", ":RBACService", ":AdminPortal (React)", "ret", 6),
            ("7. display_toast('Permissions updated successfully')", ":AdminPortal (React)", ":SystemAdmin", "ret", 7)
        ],
        "Configures granular permission matrices (e.g. view only vs. reclassify defects vs. export certificates) adhering to the principle of least privilege."
    ),
    (
        "uc_admin_04_configure_edge_calibration",
        "UC-ADMIN-04: Configure Edge Calibration & Quality Thresholds",
        "System Admin",
        ":SystemAdmin",
        "Admin Panel",
        ":AdminPortal (React)",
        "Config Service",
        ":ConfigService",
        "Sync Bus",
        ":EdgeSyncBus",
        "Edge Stand PC",
        ":EdgeStandDaemon",
        [
            ("1. enter_new_calibration(mm_per_pulse=0.235, min_lux=800)", ":SystemAdmin", ":AdminPortal (React)", "sync", 1),
            ("2. PUT /api/v1/admin/stand-config", ":AdminPortal (React)", ":ConfigService", "sync", 2),
            ("3. save_calibration_settings()", ":ConfigService", ":ConfigService", "self", 3),
            ("4. broadcast_config_update(settings)", ":ConfigService", ":EdgeSyncBus", "sync", 4),
            ("5. push_ws('CONFIG_RELOAD', settings)", ":EdgeSyncBus", ":EdgeStandDaemon", "sync", 5),
            ("6. reload_encoder_and_lux_sentinels()", ":EdgeStandDaemon", ":EdgeStandDaemon", "self", 6),
            ("7. 200 OK (stand_recalibrated_successfully)", ":EdgeStandDaemon", ":AdminPortal (React)", "ret", 7),
            ("8. display_success_banner('Stand calibrated')", ":AdminPortal (React)", ":SystemAdmin", "ret", 8)
        ],
        "Pushes updated physical calibration constants (pulses-per-mm, frame scale factor, and lux failure thresholds) dynamically to edge stands without restarting hardware."
    )
]

def render_sequence_svg(uc_id, title, actor_name, actor_lbl, ui_name, ui_lbl, api_name, api_lbl, srv_name, srv_lbl, db_name, db_lbl, steps, description):
    lifelines = [
        ("Actor", actor_lbl, 110),
        ("UI / Client", ui_lbl, 270),
        ("API / Gateway", api_lbl, 430),
        ("Service / Logic", srv_lbl, 590),
        ("Storage / Stand", db_lbl, 750)
    ]
    
    y_start = 120
    step_gap = 36
    total_steps = len(steps)
    svg_height = max(420, y_start + (total_steps + 1) * step_gap + 80)
    
    svg_lines = [
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 860 {svg_height}" width="860" height="{svg_height}" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, Arial, sans-serif;">',
        '  <defs>',
        '    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>',
        '    <marker id="arr-ret" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polyline points="2 1, 7 4, 2 7" fill="none" stroke="#0f172a" stroke-width="1.2"/></marker>',
        '  </defs>',
        '  <!-- Header Bar -->',
        f'  <rect x="20" y="12" width="820" height="42" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="5"/>',
        f'  <text x="430" y="30" font-size="12.5" font-weight="bold" fill="#0f172a" text-anchor="middle">{title}</text>',
        f'  <text x="430" y="44" font-size="8.5" fill="#475569" text-anchor="middle">TexEye AI &bull; Formal UML Use-Case Sequence Realization &bull; COMSATS University Islamabad</text>'
    ]
    
    # Participant Lifeline Boxes
    for role, lbl, x in lifelines:
        fill_col = "#e0f2fe" if "Operator" in lbl or "Inspector" in lbl or "Manager" in lbl or "Admin" in lbl else "#f1f5f9"
        border_col = "#0284c7" if "Operator" in lbl or "Inspector" in lbl or "Manager" in lbl or "Admin" in lbl else "#0f172a"
        svg_lines.append(f'  <rect x="{x-65}" y="65" width="130" height="32" rx="4" fill="{fill_col}" stroke="{border_col}" stroke-width="1.2"/>')
        svg_lines.append(f'  <text x="{x}" y="85" font-size="8.5" font-weight="bold" fill="#0f172a" text-anchor="middle">{lbl}</text>')
        # Lifeline line
        y_bottom = svg_height - 65
        svg_lines.append(f'  <line x1="{x}" y1="97" x2="{x}" y2="{y_bottom}" stroke="#94a3b8" stroke-width="1" stroke-dasharray="3 3"/>')
    
    # Participant lookup
    pos_map = {lbl: x for _, lbl, x in lifelines}
    
    # Messages
    curr_y = y_start
    for msg_text, src_lbl, dst_lbl, m_type, num in steps:
        x1 = pos_map.get(src_lbl, 110)
        x2 = pos_map.get(dst_lbl, 750)
        
        if m_type == "self":
            # Self loop
            svg_lines.append(f'  <path d="M {x1} {curr_y} L {x1+25} {curr_y} L {x1+25} {curr_y+18} L {x1+5} {curr_y+18}" fill="none" stroke="#0f172a" stroke-width="1.2" marker-end="url(#arr-black)"/>')
            svg_lines.append(f'  <rect x="{x1+30}" y="{curr_y-2}" width="160" height="15" fill="#ffffff" stroke="#cbd5e1" rx="3"/>')
            svg_lines.append(f'  <text x="{x1+35}" y="{curr_y+9}" font-size="7.5" font-weight="bold" fill="#0f172a">{msg_text}</text>')
            curr_y += step_gap
            continue
        
        is_ret = (m_type == "ret")
        marker = "url(#arr-ret)" if is_ret else "url(#arr-black)"
        stroke_dash = 'stroke-dasharray="3 3"' if is_ret else ''
        
        # Message line
        svg_lines.append(f'  <line x1="{x1}" y1="{curr_y}" x2="{x2}" y2="{curr_y}" stroke="#0f172a" stroke-width="1.2" {stroke_dash} marker-end="{marker}"/>')
        
        # Message label pill placed strictly between lifelines
        mid_x = (x1 + x2) / 2
        # Text width approximation
        w = min(220, max(110, len(msg_text) * 5.5 + 16))
        rect_x = mid_x - (w / 2)
        
        pill_fill = "#f0fdf4" if is_ret else "#ffffff"
        pill_stroke = "#86efac" if is_ret else "#cbd5e1"
        text_fill = "#166534" if is_ret else "#0f172a"
        font_weight = "normal" if is_ret else "bold"
        
        svg_lines.append(f'  <rect x="{rect_x}" y="{curr_y-9}" width="{w}" height="16" fill="{pill_fill}" stroke="{pill_stroke}" rx="3"/>')
        svg_lines.append(f'  <text x="{mid_x}" y="{curr_y+2}" font-size="7.5" font-weight="{font_weight}" fill="{text_fill}" text-anchor="middle">{msg_text}</text>')
        
        curr_y += step_gap
    
    # Bottom Note Box
    note_y = svg_height - 52
    svg_lines.append(f'  <rect x="20" y="{note_y}" width="820" height="38" fill="#f8fafc" stroke="#cbd5e1" rx="4"/>')
    svg_lines.append(f'  <text x="32" y="{note_y+15}" font-size="8" font-weight="bold" fill="#0f172a">Use Case Execution Summary:</text>')
    svg_lines.append(f'  <text x="32" y="{note_y+28}" font-size="7.5" fill="#334155">{description}</text>')
    
    svg_lines.append('</svg>')
    return '\n'.join(svg_lines)

edge_exe = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

generated_count = 0
svg_dict = {}

for item in use_cases:
    uc_id, title, actor_name, actor_lbl, ui_name, ui_lbl, api_name, api_lbl, srv_name, srv_lbl, db_name, db_lbl, steps, desc = item
    svg_str = render_sequence_svg(uc_id, title, actor_name, actor_lbl, ui_name, ui_lbl, api_name, api_lbl, srv_name, srv_lbl, db_name, db_lbl, steps, desc)
    svg_dict[uc_id] = svg_str
    
    svg_path = os.path.join(r"diagrams\usecases", f"{uc_id}.svg")
    with open(svg_path, "w", encoding="utf-8") as f:
        f.write(svg_str)
        
    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{title} | TexEye AI</title>
  <style>
    @page {{ size: A4 landscape; margin: 6mm; }}
    * {{ box-sizing: border-box; }}
    body {{ margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; background: #ffffff; color: #0f172a; }}
    .page-container {{ width: 100%; max-width: 900px; margin: 0 auto; padding: 10px 14px; }}
    .svg-wrapper {{ width: 100%; background: #ffffff; border: 1px solid #cbd5e1; border-radius: 6px; padding: 4px; }}
    .svg-wrapper svg {{ width: 100%; height: auto; display: block; }}
  </style>
</head>
<body>
  <div class="page-container">
    <div class="svg-wrapper">
      {svg_str}
    </div>
  </div>
</body>
</html>
"""
    html_path = os.path.join(r"diagrams\usecases", f"{uc_id}.html")
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(html_content)
        
    generated_count += 1

print(f"Generated {generated_count} SVG and HTML sequence diagrams in diagrams/usecases/")

# Compile the Master 25 Use Case Manual
manual_html = f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>TexEye AI — 25 Use Case Sequence Realization Manual</title>
  <style>
    @page {{
      size: A4 landscape;
      margin: 8mm 10mm;
      @bottom-right {{
        content: counter(page);
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        font-size: 8pt;
        color: #64748b;
      }}
    }}
    * {{
      box-sizing: border-box;
      -webkit-print-color-adjust: exact !important;
      print-color-adjust: exact !important;
    }}
    body {{
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
      font-size: 9pt;
      line-height: 1.4;
      color: #0f172a;
      background: #f8fafc;
      margin: 0;
      padding: 0;
    }}
    .container {{
      max-width: 297mm;
      margin: 0 auto;
      background: #ffffff;
      padding: 10mm 12mm;
    }}
    .page-break {{
      page-break-before: always;
      break-before: page;
    }}
    .cover-card {{
      border: 2px solid #0f172a;
      border-radius: 8px;
      padding: 18px 24px;
      margin-bottom: 24px;
      background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
      color: #ffffff;
    }}
    .uni-badge {{
      font-size: 8.5pt;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      color: #38bdf8;
      font-weight: 700;
      margin-bottom: 6px;
    }}
    .doc-title {{
      font-size: 22pt;
      font-weight: 800;
      margin: 0 0 6px 0;
      color: #ffffff;
    }}
    .doc-subtitle {{
      font-size: 11pt;
      color: #94a3b8;
      margin: 0 0 16px 0;
    }}
    .meta-grid {{
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 16px;
      border-top: 1px solid rgba(255, 255, 255, 0.15);
      padding-top: 14px;
      font-size: 9pt;
    }}
    .meta-item strong {{
      display: block;
      color: #38bdf8;
      font-size: 8pt;
      text-transform: uppercase;
    }}
    .sec-header {{
      font-size: 14pt;
      font-weight: 800;
      color: #0f172a;
      border-bottom: 2px solid #0284c7;
      padding-bottom: 4px;
      margin-top: 20px;
      margin-bottom: 12px;
      display: flex;
      justify-content: space-between;
    }}
    .sec-header span.badge {{
      font-size: 8pt;
      background: #e0f2fe;
      color: #0284c7;
      padding: 2px 8px;
      border-radius: 4px;
    }}
    .card-frame {{
      border: 1.5px solid #cbd5e1;
      border-radius: 6px;
      padding: 8px;
      background: #ffffff;
      margin-bottom: 18px;
      page-break-inside: avoid;
      break-inside: avoid;
    }}
    .card-frame svg {{
      width: 100%;
      height: auto;
      display: block;
    }}
    table.summary-table {{
      width: 100%;
      border-collapse: collapse;
      font-size: 8.5pt;
      margin: 12px 0 20px 0;
    }}
    table.summary-table th, table.summary-table td {{
      border: 1px solid #cbd5e1;
      padding: 6px 9px;
      text-align: left;
    }}
    table.summary-table th {{
      background: #f1f5f9;
      color: #0f172a;
      font-weight: 700;
    }}
  </style>
</head>
<body>
  <div class="container">
    <div class="cover-card">
      <div class="uni-badge">COMSATS University Islamabad &bull; Wah Cantt Campus &bull; Department of Computer Science</div>
      <div class="doc-title">TexEye AI — 25 Use Case Sequence Realization Manual</div>
      <div class="doc-subtitle">Formal 1-to-1 Dynamic Realization for All 25 Actor Use Cases | Complete Software Engineering Deliverable for Dr. Tassawar Iqbal</div>
      <div class="meta-grid">
        <div class="meta-item">
          <strong>Supervisor</strong>
          Dr. Tassawar Iqbal
        </div>
        <div class="meta-item">
          <strong>Students</strong>
          Muhammad Bilal Butt (FA23-BAI-042)<br>
          Muhammad Afnan Khan (FA23-BAI-028)
        </div>
        <div class="meta-item">
          <strong>Project / Scope</strong>
          TexEye AI (BS-AI FYP)<br>
          Exact 1-to-1 Use Case Realizations (25 Total)
        </div>
      </div>
    </div>

    <div class="sec-header">
      Executive Summary &amp; Formal UML Architecture Rationale
      <span class="badge">UML Standards</span>
    </div>
    <p>
      In formal software engineering and UML 2.5 standards, <strong>every Use Case in the system requirements specification (SRS/SRDS) is dynamically realized by a dedicated Sequence Diagram</strong>. While our <i>5 Module Architecture Diagrams</i> capture composite component pipelines, this manual provides the <strong>exhaustive 25 Sequence Diagrams</strong> corresponding exactly to the 25 functional use cases across our 5 system actors:
    </p>

    <table class="summary-table">
      <thead>
        <tr>
          <th>Actor Group</th>
          <th>Use Case IDs</th>
          <th>Count</th>
          <th>Key System Responsibilities Realized</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><b>1. Floor Operator</b></td>
          <td><code>UC-OP-01</code> to <code>UC-OP-05</code></td>
          <td><b>5</b></td>
          <td>Stand login, roll QR code scanning, real-time speed &amp; length telemetry, physical haptic alarm alerts, and floor-level defect thumbnail review.</td>
        </tr>
        <tr>
          <td><b>2. Quality Inspector</b></td>
          <td><code>UC-QI-01</code> to <code>UC-QI-07</code></td>
          <td><b>7</b></td>
          <td>Web QA login, interactive 2D HTML5 canvas fabric map rendering, crop inspection with digital calipers, defect reclassification with immutable audit trails, uninspected span tracking, ASTM grading confirmation, and PDF report export.</td>
        </tr>
        <tr>
          <td><b>3. Production Manager</b></td>
          <td><code>UC-PM-01</code> to <code>UC-PM-04</code></td>
          <td><b>4</b></td>
          <td>Executive portal login, plant-wide shift KPI aggregation, 80/20 Pareto defect root cause distribution, and historical production quality data mining.</td>
        </tr>
        <tr>
          <td><b>4. Inventory Manager</b></td>
          <td><code>UC-IM-01</code> to <code>UC-IM-05</code></td>
          <td><b>5</b></td>
          <td>Warehouse ledger login, roll stock level tracking, physical bay/shelf location reassignment, export order grade verification, and scrap roll quarantine segregation.</td>
        </tr>
        <tr>
          <td><b>5. System Administrator</b></td>
          <td><code>UC-ADMIN-01</code> to <code>UC-ADMIN-04</code></td>
          <td><b>4</b></td>
          <td>Superuser authentication, operator/inspector account management (CRUD), role-based access control (RBAC) scopes, and remote edge stand hardware calibration pushing.</td>
        </tr>
        <tr style="background:#f1f5f9; font-weight:bold;">
          <td>TOTAL COMPREHENSIVE USE CASES</td>
          <td>All 5 Actor Groups</td>
          <td><b>25</b></td>
          <td>Exhaustive 1-to-1 Use Case Dynamic Realization</td>
        </tr>
      </tbody>
    </table>
"""

# Append all 25 sequence diagrams
for item in use_cases:
    uc_id = item[0]
    title = item[1]
    svg_data = svg_dict[uc_id]
    manual_html += f"""
    <div class="page-break"></div>
    <div class="card-frame">
      {svg_data}
    </div>
"""

manual_html += """
  </div>
</body>
</html>
"""

manual_html_path = r"docs\TexEye_AI_25_Use_Case_Sequence_Diagrams_Manual.html"
with open(manual_html_path, "w", encoding="utf-8") as f:
    f.write(manual_html)

print(f"Master 25 Use Case Manual HTML saved to {manual_html_path}")

manual_pdf_path = r"docs\TexEye_AI_25_Use_Case_Sequence_Diagrams_Manual.pdf"
abs_html = os.path.abspath(manual_html_path)
abs_pdf = os.path.abspath(manual_pdf_path)

cmd = [
    edge_exe,
    "--headless",
    "--disable-gpu",
    "--run-all-compositor-stages-before-draw",
    "--no-pdf-header-footer",
    f"--print-to-pdf={abs_pdf}",
    f"file:///{abs_html}"
]

print("Compiling 25 Use Case Sequence Diagrams Master PDF with Edge headless...")
result = subprocess.run(cmd, capture_output=True, text=True)
if os.path.exists(manual_pdf_path):
    print(f"Successfully generated 25 Use Case PDF at {manual_pdf_path} ({os.path.getsize(manual_pdf_path)} bytes)")
else:
    print(f"PDF compilation error: {result.stderr}")

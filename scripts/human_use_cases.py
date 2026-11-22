"""
TexEye AI — Human-Readable Academic UML Use Case Sequences
100% human-written, professional, concise method names matching standard UML specifications.
COMSATS University Islamabad | Final Year Project
"""

human_use_cases = [
    # -------------------------------------------------------------------------
    # Floor Operator (5 Use Cases)
    # -------------------------------------------------------------------------
    (
        "uc_op_01_login_logout",
        "UC-OP-01: Operator Login / Logout",
        "Floor Operator", ":FloorOperator",
        "Mobile App", ":MobileApp",
        "Auth Gateway", ":AuthGateway",
        "Edge Session", ":EdgeSession",
        "Local Database", ":LocalDB",
        [
            ("1. enterOperatorPin(pin)", ":FloorOperator", ":MobileApp", "sync", 1),
            ("2. verifyOperator(pin)", ":MobileApp", ":AuthGateway", "sync", 2),
            ("3. validateLocalAuth()", ":AuthGateway", ":LocalDB", "sync", 3),
            ("return operatorRecord", ":LocalDB", ":AuthGateway", "ret", 4),
            ("4. createFloorSession()", ":AuthGateway", ":EdgeSession", "sync", 5),
            ("return sessionActive", ":EdgeSession", ":MobileApp", "ret", 6),
            ("displayFloorHome()", ":MobileApp", ":FloorOperator", "ret", 7)
        ],
        "Floor operator authenticates at the inspection stand mobile terminal."
    ),
    (
        "uc_op_02_scan_roll_qr",
        "UC-OP-02: Scan Roll QR Code",
        "Floor Operator", ":FloorOperator",
        "Mobile App", ":MobileApp",
        "QR Scanner", ":QRScanner",
        "Edge Engine", ":EdgeEngine",
        "Local Database", ":LocalDB",
        [
            ("1. tapScanRollQr()", ":FloorOperator", ":MobileApp", "sync", 1),
            ("2. openCameraScanner()", ":MobileApp", ":QRScanner", "sync", 2),
            ("return barcode('ROLL-2026')", ":QRScanner", ":MobileApp", "ret", 3),
            ("3. startRollSession(rollId)", ":MobileApp", ":EdgeEngine", "sync", 4),
            ("resetEncoderPulses()", ":EdgeEngine", ":EdgeEngine", "self", 5),
            ("4. initRollSession(rollId)", ":EdgeEngine", ":LocalDB", "sync", 6),
            ("return sessionReady", ":LocalDB", ":MobileApp", "ret", 7),
            ("displayReadyToInspect()", ":MobileApp", ":FloorOperator", "ret", 8)
        ],
        "Scans fabric roll barcode to initialize an automated inspection session."
    ),
    (
        "uc_op_03_view_active_roll",
        "UC-OP-03: View Active Roll Telemetry",
        "Floor Operator", ":FloorOperator",
        "Mobile App", ":MobileApp",
        "Edge FastStream", ":EdgeFastStream",
        "Rotary Encoder", ":RotaryEncoder",
        "Sensor Hub", ":SensorHub",
        [
            ("1. requestTelemetry()", ":FloorOperator", ":MobileApp", "sync", 1),
            ("2. subscribeTelemetry()", ":MobileApp", ":EdgeFastStream", "sync", 2),
            ("3. pollPulseCount()", ":EdgeFastStream", ":RotaryEncoder", "sync", 3),
            ("return pulses(4520)", ":RotaryEncoder", ":EdgeFastStream", "ret", 4),
            ("4. pushMetricSpeed()", ":EdgeFastStream", ":MobileApp", "sync", 5),
            ("refreshMetersGauge()", ":MobileApp", ":FloorOperator", "ret", 6)
        ],
        "Streams live meters inspected, speed, and real-time tension gauges."
    ),
    (
        "uc_op_04_receive_inspection_alerts",
        "UC-OP-04: Receive Inspection Warning Alerts",
        "Floor Operator", ":FloorOperator",
        "Mobile App", ":MobileApp",
        "Edge Sentinel", ":EdgeSentinel",
        "Haptic Engine", ":HapticEngine",
        "Alert Dispatcher", ":AlertDispatcher",
        [
            ("1. detectAnomalyEvent()", ":EdgeSentinel", ":EdgeSentinel", "self", 1),
            ("2. dispatchFloorAlert()", ":EdgeSentinel", ":AlertDispatcher", "sync", 2),
            ("3. emitUrgentAlert('Hole')", ":AlertDispatcher", ":MobileApp", "sync", 3),
            ("4. triggerHapticPulse()", ":MobileApp", ":HapticEngine", "sync", 4),
            ("5. renderWarningModal()", ":MobileApp", ":FloorOperator", "sync", 5),
            ("6. acknowledgeAlert()", ":FloorOperator", ":MobileApp", "sync", 6),
            ("confirmAlertAck()", ":MobileApp", ":AlertDispatcher", "ret", 7)
        ],
        "Dispatches real-time vibration alerts to the operator when flaws appear."
    ),
    (
        "uc_op_05_review_detected_defects",
        "UC-OP-05: Review Detected Defects on Floor",
        "Floor Operator", ":FloorOperator",
        "Mobile App", ":MobileApp",
        "Edge Engine", ":EdgeEngine",
        "Local Database", ":LocalDB",
        "Image Cache", ":ImageCache",
        [
            ("1. tapReviewDefects()", ":FloorOperator", ":MobileApp", "sync", 1),
            ("2. fetchRecentFlaws(rollId)", ":MobileApp", ":EdgeEngine", "sync", 2),
            ("3. queryDefectList()", ":EdgeEngine", ":LocalDB", "sync", 3),
            ("return flawRecords", ":LocalDB", ":EdgeEngine", "ret", 4),
            ("4. fetchDefectThumbnail()", ":EdgeEngine", ":ImageCache", "sync", 5),
            ("return cropBlob", ":ImageCache", ":MobileApp", "ret", 6),
            ("renderFlawCardsList()", ":MobileApp", ":FloorOperator", "ret", 7)
        ],
        "Displays real-time flaw thumbnails on the mobile feed during inspection."
    ),

    # -------------------------------------------------------------------------
    # Quality Inspector (7 Use Cases)
    # -------------------------------------------------------------------------
    (
        "uc_qi_01_login_logout",
        "UC-QI-01: Quality Inspector Login / Logout",
        "Quality Inspector", ":QualityInspector",
        "Web Dashboard", ":WebDashboard",
        "Auth Gateway", ":AuthGateway",
        "User Directory", ":UserDirectory",
        "Token Service", ":TokenService",
        [
            ("1. enterCredentials(user, pass)", ":QualityInspector", ":WebDashboard", "sync", 1),
            ("2. submitInspectorLogin()", ":WebDashboard", ":AuthGateway", "sync", 2),
            ("3. verifyUserRecord()", ":AuthGateway", ":UserDirectory", "sync", 3),
            ("return inspectorData", ":UserDirectory", ":AuthGateway", "ret", 4),
            ("4. issueSignedToken()", ":AuthGateway", ":TokenService", "sync", 5),
            ("return tokenSuccess", ":TokenService", ":WebDashboard", "ret", 6),
            ("renderInspectorHome()", ":WebDashboard", ":QualityInspector", "ret", 7),
            ("requestLogout()", ":QualityInspector", ":WebDashboard", "sync", 8)
        ],
        "Quality inspector securely logs into the central web portal."
    ),
    (
        "uc_qi_02_view_2d_defect_map",
        "UC-QI-02: View Digital 2D Fabric Defect Map",
        "Quality Inspector", ":QualityInspector",
        "Web Dashboard", ":WebDashboard",
        "Map API Server", ":MapServer",
        "Central Database", ":CentralDB",
        "Canvas Renderer", ":CanvasRenderer",
        [
            ("1. selectRollId(rollId)", ":QualityInspector", ":WebDashboard", "sync", 1),
            ("2. requestMapPayload(rollId)", ":WebDashboard", ":MapServer", "sync", 2),
            ("3. queryDefectCoordinates()", ":MapServer", ":CentralDB", "sync", 3),
            ("4. queryUninspectedSpans()", ":MapServer", ":CentralDB", "sync", 4),
            ("return rollMapPayload", ":CentralDB", ":MapServer", "ret", 5),
            ("5. loadCanvasGlyphs()", ":MapServer", ":CanvasRenderer", "sync", 6),
            ("render2DDefectMap()", ":CanvasRenderer", ":WebDashboard", "ret", 7),
            ("displayDefectHeatmap()", ":WebDashboard", ":QualityInspector", "ret", 8)
        ],
        "Interactive 2D digital canvas visualizing defect coordinates along roll length."
    ),
    (
        "uc_qi_03_review_defect_crops",
        "UC-QI-03: Review Defect Images & Calipers",
        "Quality Inspector", ":QualityInspector",
        "Web Dashboard", ":WebDashboard",
        "Defect Service", ":DefectService",
        "Image Store", ":ImageStore",
        "Caliper Tool", ":CaliperTool",
        [
            ("1. clickFlawGlyph(flawId)", ":QualityInspector", ":WebDashboard", "sync", 1),
            ("2. requestFlawDetails(flawId)", ":WebDashboard", ":DefectService", "sync", 2),
            ("3. fetchCropImageBlob()", ":DefectService", ":ImageStore", "sync", 3),
            ("return cropImageData", ":ImageStore", ":DefectService", "ret", 4),
            ("4. computeMetricSize(bbox)", ":DefectService", ":CaliperTool", "sync", 5),
            ("return physicalDimensions", ":CaliperTool", ":WebDashboard", "ret", 6),
            ("showZoomGalleryModal()", ":WebDashboard", ":QualityInspector", "ret", 7)
        ],
        "Examines zoomed photographic defect crops with calibrated millimetric calipers."
    ),
    (
        "uc_qi_04_correct_defect_record",
        "UC-QI-04: Correct Defect Record & Audit Trail",
        "Quality Inspector", ":QualityInspector",
        "Web Dashboard", ":WebDashboard",
        "Audit Service", ":AuditService",
        "Central Database", ":CentralDB",
        "Audit Log Store", ":AuditStore",
        [
            ("1. selectNewClass('Stain')", ":QualityInspector", ":WebDashboard", "sync", 1),
            ("2. submitCorrection(flawId)", ":WebDashboard", ":AuditService", "sync", 2),
            ("3. updateFlawClass()", ":AuditService", ":CentralDB", "sync", 3),
            ("4. writeAuditEntry()", ":AuditService", ":AuditStore", "sync", 4),
            ("return auditCommitted", ":AuditStore", ":AuditService", "ret", 5),
            ("return correctionSuccess", ":AuditService", ":WebDashboard", "ret", 6),
            ("refreshCanvasGlyphColor()", ":WebDashboard", ":QualityInspector", "ret", 7)
        ],
        "Reclassifies misclassified flaws and records an immutable audit log."
    ),
    (
        "uc_qi_05_view_uninspected_intervals",
        "UC-QI-05: View Uninspected Sensor Fault Intervals",
        "Quality Inspector", ":QualityInspector",
        "Web Dashboard", ":WebDashboard",
        "Telemetry API", ":TelemetryAPI",
        "Central Database", ":CentralDB",
        "Span Renderer", ":SpanRenderer",
        [
            ("1. openUninspectedTab()", ":QualityInspector", ":WebDashboard", "sync", 1),
            ("2. requestFaultSpans(rollId)", ":WebDashboard", ":TelemetryAPI", "sync", 2),
            ("3. queryFaultIntervals()", ":TelemetryAPI", ":CentralDB", "sync", 3),
            ("return uninspectedSpans", ":CentralDB", ":TelemetryAPI", "ret", 4),
            ("4. compileSpanTable()", ":TelemetryAPI", ":SpanRenderer", "sync", 5),
            ("return renderedTable", ":SpanRenderer", ":WebDashboard", "ret", 6),
            ("renderAmberFlaggedZones()", ":WebDashboard", ":QualityInspector", "ret", 7)
        ],
        "Highlights uninspected fabric intervals caused by sensor or lighting faults."
    ),
    (
        "uc_qi_06_confirm_roll_grading",
        "UC-QI-06: Confirm ASTM 4-Point Roll Grading",
        "Quality Inspector", ":QualityInspector",
        "Web Dashboard", ":WebDashboard",
        "ASTM Engine", ":ASTMEngine",
        "Central Database", ":CentralDB",
        "Certificate Service", ":CertService",
        [
            ("1. tapFinalizeGrading()", ":QualityInspector", ":WebDashboard", "sync", 1),
            ("2. executeAstmGrading(rollId)", ":WebDashboard", ":ASTMEngine", "sync", 2),
            ("calculatePenaltyPoints()", ":ASTMEngine", ":ASTMEngine", "self", 3),
            ("3. saveRollGrade('Grade A')", ":ASTMEngine", ":CentralDB", "sync", 4),
            ("return gradeSaved", ":CentralDB", ":ASTMEngine", "ret", 5),
            ("4. initCertificateRecord()", ":ASTMEngine", ":CertService", "sync", 6),
            ("return certReady", ":CertService", ":WebDashboard", "ret", 7),
            ("renderGradeConfirmedBadge()", ":WebDashboard", ":QualityInspector", "ret", 8)
        ],
        "Applies ASTM D5430-07 4-point penalty calculations to assign roll grade."
    ),
    (
        "uc_qi_07_generate_inspection_report",
        "UC-QI-07: Generate Digital Inspection Report & PDF",
        "Quality Inspector", ":QualityInspector",
        "Web Dashboard", ":WebDashboard",
        "Report Engine", ":ReportEngine",
        "Crypto Signer", ":CryptoSigner",
        "Object Storage", ":MinIOStore",
        [
            ("1. tapExportReport(rollId)", ":QualityInspector", ":WebDashboard", "sync", 1),
            ("2. requestPdfCompile(rollId)", ":WebDashboard", ":ReportEngine", "sync", 2),
            ("compileReportData()", ":ReportEngine", ":ReportEngine", "self", 3),
            ("3. generateSecurityHash()", ":ReportEngine", ":CryptoSigner", "sync", 4),
            ("return cryptographicSeal", ":CryptoSigner", ":ReportEngine", "ret", 5),
            ("4. uploadReportPdf()", ":ReportEngine", ":MinIOStore", "sync", 6),
            ("return downloadUrl", ":ReportEngine", ":WebDashboard", "ret", 7),
            ("downloadCertifiedPdf()", ":WebDashboard", ":QualityInspector", "ret", 8)
        ],
        "Compiles an export-ready digital inspection report with SHA-256 digital seals."
    ),

    # -------------------------------------------------------------------------
    # Production Manager (4 Use Cases)
    # -------------------------------------------------------------------------
    (
        "uc_pm_01_login_logout",
        "UC-PM-01: Production Manager Login / Logout",
        "Production Manager", ":ProductionManager",
        "Web Dashboard", ":WebDashboard",
        "Auth Gateway", ":AuthGateway",
        "Role Registry", ":RoleRegistry",
        "Session Manager", ":SessionMgr",
        [
            ("1. enterManagerLogin(user, pass)", ":ProductionManager", ":WebDashboard", "sync", 1),
            ("2. verifyManagerAuth()", ":WebDashboard", ":AuthGateway", "sync", 2),
            ("3. checkExecutiveScope()", ":AuthGateway", ":RoleRegistry", "sync", 3),
            ("return scopeApproved", ":RoleRegistry", ":AuthGateway", "ret", 4),
            ("4. issueExecutiveSession()", ":AuthGateway", ":SessionMgr", "sync", 5),
            ("return sessionToken", ":SessionMgr", ":WebDashboard", "ret", 6),
            ("loadProductionPortal()", ":WebDashboard", ":ProductionManager", "ret", 7)
        ],
        "Production manager logs in to monitor plant-wide defect analytics."
    ),
    (
        "uc_pm_02_view_production_dashboard",
        "UC-PM-02: View Production Executive Dashboard",
        "Production Manager", ":ProductionManager",
        "Web Dashboard", ":WebDashboard",
        "Analytics API", ":AnalyticsAPI",
        "Central Database", ":CentralDB",
        "KPI Aggregator", ":KPIAggregator",
        [
            ("1. openShiftOverview()", ":ProductionManager", ":WebDashboard", "sync", 1),
            ("2. requestShiftMetrics()", ":WebDashboard", ":AnalyticsAPI", "sync", 2),
            ("3. queryShiftRolls()", ":AnalyticsAPI", ":CentralDB", "sync", 3),
            ("return rawShiftData", ":CentralDB", ":AnalyticsAPI", "ret", 4),
            ("4. computePlantYield()", ":AnalyticsAPI", ":KPIAggregator", "sync", 5),
            ("return aggregatedKPIs", ":KPIAggregator", ":WebDashboard", "ret", 6),
            ("renderProductionGauges()", ":WebDashboard", ":ProductionManager", "ret", 7)
        ],
        "Executive dashboard displaying live mill throughput, yield %, and roll status."
    ),
    (
        "uc_pm_03_view_defect_pareto_stats",
        "UC-PM-03: View Defect Pareto Statistics & Trends",
        "Production Manager", ":ProductionManager",
        "Web Dashboard", ":WebDashboard",
        "Pareto Service", ":ParetoService",
        "Central Database", ":CentralDB",
        "Chart Engine", ":ChartEngine",
        [
            ("1. selectBatchFilter('B-402')", ":ProductionManager", ":WebDashboard", "sync", 1),
            ("2. requestParetoData('B-402')", ":WebDashboard", ":ParetoService", "sync", 2),
            ("3. aggregateFlawCounts()", ":ParetoService", ":CentralDB", "sync", 3),
            ("return flawHistogram", ":CentralDB", ":ParetoService", "ret", 4),
            ("calculateCumulativeShare()", ":ParetoService", ":ParetoService", "self", 5),
            ("4. renderParetoChart()", ":ParetoService", ":ChartEngine", "sync", 6),
            ("return chartSvgBlob", ":ChartEngine", ":WebDashboard", "ret", 7),
            ("displayPareto8020Graph()", ":WebDashboard", ":ProductionManager", "ret", 8)
        ],
        "Pareto 80/20 defect frequency distribution identifying root quality causes."
    ),
    (
        "uc_pm_04_view_historical_records",
        "UC-PM-04: View Historical Production Quality Records",
        "Production Manager", ":ProductionManager",
        "Web Dashboard", ":WebDashboard",
        "History Service", ":HistoryService",
        "Central Database", ":CentralDB",
        "Export Engine", ":ExportEngine",
        [
            ("1. applyDateRange(start, end)", ":ProductionManager", ":WebDashboard", "sync", 1),
            ("2. requestRollHistory()", ":WebDashboard", ":HistoryService", "sync", 2),
            ("3. queryArchivedRolls()", ":HistoryService", ":CentralDB", "sync", 3),
            ("return rollHistoryBatch", ":CentralDB", ":HistoryService", "ret", 4),
            ("4. populateHistoryGrid()", ":HistoryService", ":WebDashboard", "sync", 5),
            ("5. exportSummarySpreadsheet()", ":WebDashboard", ":ExportEngine", "sync", 6),
            ("return csvDownloadFile", ":ExportEngine", ":ProductionManager", "ret", 7)
        ],
        "Historical search, filtering, and CSV export across all finished fabric rolls."
    ),

    # -------------------------------------------------------------------------
    # Inventory Manager (5 Use Cases)
    # -------------------------------------------------------------------------
    (
        "uc_im_01_login_logout",
        "UC-IM-01: Inventory Manager Login / Logout",
        "Inventory Manager", ":InventoryManager",
        "Warehouse App", ":WarehouseApp",
        "Auth Gateway", ":AuthGateway",
        "User Directory", ":UserDirectory",
        "Warehouse Session", ":WarehouseSession",
        [
            ("1. enterWarehouseLogin(pin)", ":InventoryManager", ":WarehouseApp", "sync", 1),
            ("2. verifyWarehouseAuth()", ":WarehouseApp", ":AuthGateway", "sync", 2),
            ("3. queryInventoryRole()", ":AuthGateway", ":UserDirectory", "sync", 3),
            ("return roleApproved", ":UserDirectory", ":AuthGateway", "ret", 4),
            ("4. initWarehouseSession()", ":AuthGateway", ":WarehouseSession", "sync", 5),
            ("return sessionActive", ":WarehouseSession", ":WarehouseApp", "ret", 6),
            ("loadWarehouseHome()", ":WarehouseApp", ":InventoryManager", "ret", 7)
        ],
        "Inventory manager authenticates on the warehouse terminal."
    ),
    (
        "uc_im_02_view_warehouse_inventory",
        "UC-IM-02: View Warehouse Inventory Records",
        "Inventory Manager", ":InventoryManager",
        "Warehouse App", ":WarehouseApp",
        "Inventory API", ":InventoryAPI",
        "Central Database", ":CentralDB",
        "Catalog Renderer", ":CatalogRenderer",
        [
            ("1. openInventoryCatalog()", ":InventoryManager", ":WarehouseApp", "sync", 1),
            ("2. requestRollInventory('STOCK')", ":WarehouseApp", ":InventoryAPI", "sync", 2),
            ("3. queryStockRecords()", ":InventoryAPI", ":CentralDB", "sync", 3),
            ("return inventoryRecords", ":CentralDB", ":InventoryAPI", "ret", 4),
            ("4. renderStockGrid()", ":InventoryAPI", ":CatalogRenderer", "sync", 5),
            ("return catalogTable", ":CatalogRenderer", ":WarehouseApp", "ret", 6),
            ("displayStockInventory()", ":WarehouseApp", ":InventoryManager", "ret", 7)
        ],
        "Displays real-time fabric roll inventory, grades, and warehouse bin locations."
    ),
    (
        "uc_im_03_update_roll_location",
        "UC-IM-03: Update Roll Warehouse Storage Location",
        "Inventory Manager", ":InventoryManager",
        "Warehouse App", ":WarehouseApp",
        "Location Service", ":LocationService",
        "Central Database", ":CentralDB",
        "Notification Hub", ":NotifyHub",
        [
            ("1. scanRollBarcode('ROLL-102')", ":InventoryManager", ":WarehouseApp", "sync", 1),
            ("2. submitNewBay('Bay-B4-S2')", ":WarehouseApp", ":LocationService", "sync", 2),
            ("3. updateBinLocation()", ":LocationService", ":CentralDB", "sync", 3),
            ("return updateSuccess", ":CentralDB", ":LocationService", "ret", 4),
            ("4. broadcastBinMove()", ":LocationService", ":NotifyHub", "sync", 5),
            ("return moveConfirmed", ":NotifyHub", ":WarehouseApp", "ret", 6),
            ("displayLocationSavedToast()", ":WarehouseApp", ":InventoryManager", "ret", 7)
        ],
        "Assigns and updates physical storage bin coordinates for inspected fabric rolls."
    ),
    (
        "uc_im_04_view_certified_grading",
        "UC-IM-04: View Certified Roll Grading Status",
        "Inventory Manager", ":InventoryManager",
        "Warehouse App", ":WarehouseApp",
        "Cert API Server", ":CertServer",
        "Central Database", ":CentralDB",
        "Seal Verifier", ":SealVerifier",
        [
            ("1. searchCertifiedRolls('Grade A')", ":InventoryManager", ":WarehouseApp", "sync", 1),
            ("2. requestCertifiedStock()", ":WarehouseApp", ":CertServer", "sync", 2),
            ("3. queryGradeCertificates()", ":CertServer", ":CentralDB", "sync", 3),
            ("return certRecords", ":CentralDB", ":CertServer", "ret", 4),
            ("4. verifySha256Digest()", ":CertServer", ":SealVerifier", "sync", 5),
            ("return sealValid", ":SealVerifier", ":WarehouseApp", "ret", 6),
            ("renderExportReadyList()", ":WarehouseApp", ":InventoryManager", "ret", 7)
        ],
        "Verifies tamper-evident cryptographic digital quality certificates for shipping."
    ),
    (
        "uc_im_05_manage_scrap_segregation",
        "UC-IM-05: Manage Scrap & Quarantined Roll Segregation",
        "Inventory Manager", ":InventoryManager",
        "Warehouse App", ":WarehouseApp",
        "Quarantine API", ":QuarantineAPI",
        "Central Database", ":CentralDB",
        "Label Printer", ":LabelPrinter",
        [
            ("1. selectScrapRoll(rollId)", ":InventoryManager", ":WarehouseApp", "sync", 1),
            ("2. requestQuarantineLock()", ":WarehouseApp", ":QuarantineAPI", "sync", 2),
            ("3. setQuarantineStatus()", ":QuarantineAPI", ":CentralDB", "sync", 3),
            ("return lockConfirmed", ":CentralDB", ":QuarantineAPI", "ret", 4),
            ("4. printRedQuarantineTag()", ":QuarantineAPI", ":LabelPrinter", "sync", 5),
            ("return physicalTagPrinted", ":LabelPrinter", ":WarehouseApp", "ret", 6),
            ("confirmScrapSegregation()", ":WarehouseApp", ":InventoryManager", "ret", 7)
        ],
        "Physically and logically isolates defective rolls into quarantine holding areas."
    ),

    # -------------------------------------------------------------------------
    # System Administrator (4 Use Cases)
    # -------------------------------------------------------------------------
    (
        "uc_admin_01_login_logout",
        "UC-ADMIN-01: System Administrator Login / Logout",
        "System Administrator", ":SysAdmin",
        "Admin Portal", ":AdminPortal",
        "Auth Gateway", ":AuthGateway",
        "Superuser Store", ":SuperuserStore",
        "Security Guard", ":SecurityGuard",
        [
            ("1. enterAdminAuth(admin, pass)", ":SysAdmin", ":AdminPortal", "sync", 1),
            ("2. submitAdminLogin()", ":AdminPortal", ":AuthGateway", "sync", 2),
            ("3. verifySuperuserRole()", ":AuthGateway", ":SuperuserStore", "sync", 3),
            ("return superuserValid", ":SuperuserStore", ":AuthGateway", "ret", 4),
            ("4. issueAdminToken()", ":AuthGateway", ":SecurityGuard", "sync", 5),
            ("return adminSessionReady", ":SecurityGuard", ":AdminPortal", "ret", 6),
            ("renderAdminConsole()", ":AdminPortal", ":SysAdmin", "ret", 7)
        ],
        "System administrator authenticates to access plant-wide configuration."
    ),
    (
        "uc_admin_02_manage_user_accounts",
        "UC-ADMIN-02: Manage User Accounts (CRUD)",
        "System Administrator", ":SysAdmin",
        "Admin Portal", ":AdminPortal",
        "User Service", ":UserService",
        "User Database", ":UserDB",
        "Audit Log Store", ":AuditStore",
        [
            ("1. submitNewUser(name, role)", ":SysAdmin", ":AdminPortal", "sync", 1),
            ("2. createAccountRecord()", ":AdminPortal", ":UserService", "sync", 2),
            ("3. insertUserRecord()", ":UserService", ":UserDB", "sync", 3),
            ("4. recordAdminAudit()", ":UserService", ":AuditStore", "sync", 4),
            ("return accountCreated", ":UserDB", ":UserService", "ret", 5),
            ("return opSuccess", ":UserService", ":AdminPortal", "ret", 6),
            ("renderUpdatedUsersTable()", ":AdminPortal", ":SysAdmin", "ret", 7)
        ],
        "Creates, updates, and deactivates plant operator and inspector accounts."
    ),
    (
        "uc_admin_03_assign_roles_scopes",
        "UC-ADMIN-03: Assign Roles & Scopes (RBAC)",
        "System Administrator", ":SysAdmin",
        "Admin Portal", ":AdminPortal",
        "RBAC Engine", ":RBACEngine",
        "Policy Store", ":PolicyStore",
        "Session Broker", ":SessionBroker",
        [
            ("1. selectUserScope('Inspector')", ":SysAdmin", ":AdminPortal", "sync", 1),
            ("2. updatePermissions()", ":AdminPortal", ":RBACEngine", "sync", 2),
            ("3. persistPolicyRules()", ":RBACEngine", ":PolicyStore", "sync", 3),
            ("return policyCommitted", ":PolicyStore", ":RBACEngine", "ret", 4),
            ("4. revokeStaleSessions()", ":RBACEngine", ":SessionBroker", "sync", 5),
            ("return permissionsActive", ":SessionBroker", ":AdminPortal", "ret", 6),
            ("displayRbacUpdatedNotice()", ":AdminPortal", ":SysAdmin", "ret", 7)
        ],
        "Configures role-based access control and granular permission scopes."
    ),
    (
        "uc_admin_04_configure_edge_calibration",
        "UC-ADMIN-04: Configure Edge Calibration & Thresholds",
        "System Administrator", ":SysAdmin",
        "Admin Portal", ":AdminPortal",
        "Config Service", ":ConfigService",
        "Edge Stand Hub", ":EdgeStandHub",
        "Sentinel Guard", ":SentinelGuard",
        [
            ("1. enterCalibrationParams()", ":SysAdmin", ":AdminPortal", "sync", 1),
            ("2. dispatchCalibration()", ":AdminPortal", ":ConfigService", "sync", 2),
            ("3. sendHardwareConfig()", ":ConfigService", ":EdgeStandHub", "sync", 3),
            ("reloadSensorConfig()", ":EdgeStandHub", ":EdgeStandHub", "self", 4),
            ("4. applyLuxThresholds()", ":EdgeStandHub", ":SentinelGuard", "sync", 5),
            ("return calibrationApplied", ":SentinelGuard", ":ConfigService", "ret", 6),
            ("return configConfirmed", ":ConfigService", ":AdminPortal", "ret", 7),
            ("displayCalibrationBanner()", ":AdminPortal", ":SysAdmin", "ret", 8)
        ],
        "Calibrates encoder pulse ratios, camera lux limits, and YOLO confidence gates."
    )
]

# -----------------------------------------------------------------------------
# 5 Core Module Diagram Specifications (Human-Written)
# -----------------------------------------------------------------------------
human_module_diagrams = [
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
            ("1. grabCameraFrame(frameId)", ":CameraStream", ":YOLODetector", "sync", 1),
            ("detectDefectBBox()", ":YOLODetector", ":YOLODetector", "self", 2),
            ("2. readEncoderPulses()", ":YOLODetector", ":RotaryEncoder", "sync", 3),
            ("return pulseCount", ":RotaryEncoder", ":YOLODetector", "ret", 4),
            ("3. computeMetricCoords()", ":YOLODetector", ":MetricMapper", "sync", 5),
            ("return (X_cm, Y_meters)", ":MetricMapper", ":YOLODetector", "ret", 6),
            ("4. trackFlawAcrossFrames()", ":YOLODetector", ":KalmanTracker", "sync", 7),
            ("return isUniqueDefect", ":KalmanTracker", ":YOLODetector", "ret", 8),
            ("5. storeDefectRecord(flaw)", ":YOLODetector", ":SQLiteBuffer", "sync", 9),
            ("confirmDefectLogged", ":SQLiteBuffer", ":YOLODetector", "ret", 10),
            ("6. broadcastDefectFound()", ":YOLODetector", ":SQLiteBuffer", "sync", 11)
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
            ("1. readSensorMetrics(lux)", ":StandSensors", ":ReliabilityGuard", "sync", 1),
            ("evaluateLuxBlurLimits()", ":ReliabilityGuard", ":ReliabilityGuard", "self", 2),
            ("2. sendAlarmSignal(HIGH)", ":ReliabilityGuard", ":USBRelayBox", "sync", 3),
            ("3. activateAmberStrobe()", ":USBRelayBox", ":AmberLightSiren", "sync", 4),
            ("4. startUninspectedSpan()", ":ReliabilityGuard", ":UninspectedLogger", "sync", 5),
            ("5. recordSpan(Y1, Y2)", ":UninspectedLogger", ":SQLiteBuffer", "sync", 6),
            ("confirmSpanRecorded", ":SQLiteBuffer", ":UninspectedLogger", "ret", 7),
            ("6. restoreRelayNormal(LOW)", ":ReliabilityGuard", ":USBRelayBox", "sync", 8),
            ("deactivateAmberStrobe()", ":USBRelayBox", ":AmberLightSiren", "sync", 9)
        ]
    ),
    (
        "03_module_3_mobile_app_sequence",
        "Module 3: Mobile Floor Application",
        "Figure 5.4.3: Sequence Diagram for Module 3 — Mobile Floor App & Vibration Alerts",
        "Module 3: Mobile Floor App",
        [
            ("Floor Operator", ":FloorOperator", True),
            ("Flutter Mobile App", ":FlutterApp", False),
            ("Edge FastStream", ":EdgeFastStream", False),
            ("Local SQLite", ":LocalSQLite", False),
            ("Haptic Actuator", ":HapticActuator", False)
        ],
        [
            ("1. scanRollBarcode('ROLL-2026')", ":FloorOperator", ":FlutterApp", "sync", 1),
            ("2. startFloorSession()", ":FlutterApp", ":EdgeFastStream", "sync", 2),
            ("return sessionToken", ":EdgeFastStream", ":FlutterApp", "ret", 3),
            ("3. cacheLocalSession()", ":FlutterApp", ":LocalSQLite", "sync", 4),
            ("4. subscribeLiveEvents()", ":FlutterApp", ":EdgeFastStream", "sync", 5),
            ("confirmStreamReady", ":EdgeFastStream", ":FlutterApp", "ret", 6),
            ("5. notifyDefectDetected()", ":EdgeFastStream", ":FlutterApp", "sync", 7),
            ("6. triggerHapticPulse()", ":FlutterApp", ":HapticActuator", "sync", 8),
            ("renderDefectNotification()", ":FlutterApp", ":FloorOperator", "sync", 9),
            ("7. pauseFloorSession()", ":FloorOperator", ":FlutterApp", "sync", 10),
            ("confirmSessionPaused", ":FlutterApp", ":FloorOperator", "ret", 11)
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
            ("1. selectActiveRoll(rollId)", ":QualityInspector", ":ReactDashboard", "sync", 1),
            ("2. requestQualityMap(rollId)", ":ReactDashboard", ":FastAPIGateway", "sync", 2),
            ("3. queryDefectsAndSpans()", ":FastAPIGateway", ":PostgreSQLDB", "sync", 3),
            ("return mapDataPayload", ":PostgreSQLDB", ":FastAPIGateway", "ret", 4),
            ("4. drawDefectGlyphs()", ":ReactDashboard", ":Canvas2DMap", "sync", 5),
            ("5. selectDefectItem(#14)", ":QualityInspector", ":ReactDashboard", "sync", 6),
            ("6. fetchCropImageBlob()", ":ReactDashboard", ":MinIOStore", "sync", 7),
            ("return cropImageData", ":MinIOStore", ":ReactDashboard", "ret", 8),
            ("openCropInspectorModal()", ":ReactDashboard", ":QualityInspector", "sync", 9),
            ("7. reclassifyFlaw('Yarn')", ":QualityInspector", ":ReactDashboard", "sync", 10),
            ("8. submitFlawCorrection()", ":ReactDashboard", ":FastAPIGateway", "sync", 11),
            ("9. recordAuditTrail()", ":FastAPIGateway", ":PostgreSQLDB", "sync", 12),
            ("confirmAuditCommitted", ":PostgreSQLDB", ":ReactDashboard", "ret", 13)
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
            ("1. clickFinalizeRoll()", ":QualityManager", ":WebDashboard", "sync", 1),
            ("2. requestAstmGrading()", ":WebDashboard", ":FastAPIServer", "sync", 2),
            ("3. queryVerifiedDefects()", ":FastAPIServer", ":PostgreSQLDB", "sync", 3),
            ("return defectRecords", ":PostgreSQLDB", ":FastAPIServer", "ret", 4),
            ("calculateAstmPoints()", ":FastAPIServer", ":ASTMEngine", "sync", 5),
            ("4. saveCertifiedGrade('A')", ":ASTMEngine", ":PostgreSQLDB", "sync", 6),
            ("5. requestSignedReport()", ":WebDashboard", ":PDFExportService", "sync", 7),
            ("compileReportPdf()", ":PDFExportService", ":PDFExportService", "self", 8),
            ("return reportFileUrl", ":PDFExportService", ":WebDashboard", "ret", 9),
            ("displayQualityCertificate()", ":WebDashboard", ":QualityManager", "ret", 10)
        ]
    )
]

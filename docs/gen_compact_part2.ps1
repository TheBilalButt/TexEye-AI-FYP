# Part 2: Pages 12 to 21 (Compact COMSATS Wah Standard)
function Get-Compact-Pages-12-to-21 {
    $pages = [System.Collections.Generic.List[string]]::new()

    # ==================== PAGE 12: UC-01 & UC-02 ====================
    $p12 = @'
          <h3 class="subsec-heading" style="margin-top: 0;">3.2.4 Fully Dressed Use Cases</h3>
          
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.5mm;">UC-01: Start Roll Inspection Session</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-01: Start Roll Inspection Session</b></td></tr>
            <tr><th>Primary Actor</th><td>Floor Operator (Secondary: Hardware Stand, Industrial Edge Unit)</td></tr>
            <tr><th>Preconditions</th><td>Stand powered, lighting active, camera/encoder recognized by Linux edge kernel, operator signed in.</td></tr>
            <tr><th>Postconditions</th><td>Session initialized in SQLite (WAL) with status IN_PROGRESS, hardware pulse counter zeroed (Y = 0.00 m).</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. Operator mounts fabric roll onto rollers and threads web through optical zone.<br>
              2. Operator opens TexEye Mobile App and selects 'Start New Roll'.<br>
              3. Operator scans roll QR code; app decodes Roll ID, Article Name, Target Length, and Width.<br>
              4. Mobile app sends start request to edge unit via local Wi-Fi REST API (POST /api/v1/session/start).<br>
              5. Edge unit resets rotary encoder hardware pulse accumulator to zero.<br>
              6. Edge unit checks lighting lux levels and frame delivery; confirms operating environment is optimal.<br>
              7. Edge unit creates new session in SQLite (WAL) and returns session_id to mobile app.<br>
              8. Mobile app transitions to Live Inspection Monitor, displaying 'Stand Ready: Move Fabric'.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              3a. Damaged QR code: Operator enters numeric Roll ID manually into mobile form.<br>
              6a. Illumination below 800 lux: Edge unit halts start, illuminates amber stack light, shows error on mobile.
            </td></tr>
            <tr><th>Requirements</th><td>FR-ING-01, FR-ING-02, FR-MOB-01, FR-BUF-01, FR-REL-01, FR-REL-02</td></tr>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2.5mm; margin-bottom: 0.5mm;">UC-02: Monitor Live Optical Feed & Metrology Overlay</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-02: Monitor Live Optical Feed & Metrology Overlay</b></td></tr>
            <tr><th>Primary Actor</th><td>Floor Operator (Secondary: Industrial Edge Unit)</td></tr>
            <tr><th>Preconditions</th><td>An inspection session is currently active (status = IN_PROGRESS).</td></tr>
            <tr><th>Postconditions</th><td>Operator maintains live visual awareness of inspection status, defect alerts, and line speed.</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. Operator starts winder motor; fabric moves through optical zone.<br>
              2. Rotary encoder transmits quadrature pulses; edge unit calculates linear speed (v in m/s).<br>
              3. Edge unit downsamples 1080p frames to lightweight MJPEG / WebRTC stream (720p @ 15 FPS).<br>
              4. Edge unit renders real-time overlays: cumulative length (Y in m), speed (m/s), and active defect boxes.<br>
              5. Operator monitors feed on stand display or tablet, confirming consistent lighting and fabric tracking.<br>
              6. Live feed updates continuously until the session is paused or completed.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              2a. Line speed exceeds 0.50 m/s: Display flashes yellow warning banner, advising operator to reduce speed.<br>
              3a. Network bandwidth drop: Edge unit throttles stream to 10 FPS to ensure zero impact on AI inference.
            </td></tr>
            <tr><th>Requirements</th><td>FR-ING-01, FR-ING-05, FR-MOB-02, FR-REL-03</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 12 -Content $p12))

    # ==================== PAGE 13: UC-03 & UC-04 ====================
    $p13 = @'
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.5mm;">UC-03: Real-Time Defect Detection & Kalman Tracking</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-03: Real-Time Defect Detection & Kalman Tracking</b></td></tr>
            <tr><th>Primary Actor</th><td>Hardware Stand (Autonomous Edge Engine; Secondary: Floor Operator)</td></tr>
            <tr><th>Preconditions</th><td>Inspection session is active; fabric is moving across the optical inspection zone.</td></tr>
            <tr><th>Postconditions</th><td>Confirmed defects saved to SQLite with metric coordinates (X, Y), physical dimensions, and JPEG crop.</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. Encoder pulse count reaches frame advance threshold; camera driver captures rectified frame.<br>
              2. Edge engine submits frame to fine-tuned YOLO defect detection engine.<br>
              3. YOLO detects candidate anomaly bounding boxes [u_min, v_min, u_max, v_max] with confidence &ge; 0.40.<br>
              4. 2D Kalman Filter predicts active track positions and associates detections via Hungarian IoU matching.<br>
              5. When a candidate matches an active track, its trajectory and physical length L (mm) are updated.<br>
              6. Once a track achieves &ge; 3 consecutive frame hits, it is elevated to CONFIRMED_DEFECT status.<br>
              7. When flaw exits the FOV, edge engine calculates finalized coordinates: lateral X (mm) and longitudinal Y (m).<br>
              8. Edge engine extracts high-resolution JPEG crop and writes defect record to local SQLite within 30 ms.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              6a. Anomaly detected in fewer than 3 frames: Track discarded as surface dust or loose lint.<br>
              7a. Continuous flaw (long warp streak): System updates ongoing record, incrementing length without duplicating flaw.
            </td></tr>
            <tr><th>Requirements</th><td>FR-INF-01 to FR-INF-06, FR-TRK-01 to FR-TRK-04, FR-BUF-01, FR-BUF-02</td></tr>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2.5mm; margin-bottom: 0.5mm;">UC-04: Trigger Audio-Visual Alarm on Defect Cluster</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-04: Trigger Audio-Visual Alarm on Defect Cluster</b></td></tr>
            <tr><th>Primary Actor</th><td>Hardware Stand (Edge Engine; Secondary: Floor Operator)</td></tr>
            <tr><th>Preconditions</th><td>A confirmed defect with severity CRITICAL is detected, or penalty points in current meter exceed 4 points.</td></tr>
            <tr><th>Postconditions</th><td>Physical red stack light and buzzer energized; mobile vibration alert dispatched; alarm logged.</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. YOLO detection and ASTM scoring identify critical flaw (hole &gt; 25 mm or multiple flaws in 1 meter).<br>
              2. Edge engine asserts GPIO Pin 17, energizing opto-isolated relay module within 20 ms.<br>
              3. Relay closes 24V DC circuit, illuminating Red Tower Light and sounding 90 dB floor buzzer.<br>
              4. Edge engine broadcasts WebSocket alert to connected mobile floor app.<br>
              5. Operator device vibrates with high-priority audio alarm: 'CRITICAL FLAW DETECTED AT Y = XX.X m'.<br>
              6. Operator stops winding motor, inspects fabric section, and taps 'Acknowledge Alarm' on mobile app.<br>
              7. Edge engine de-asserts GPIO Pin 17, silencing buzzer while keeping visual beacon active until roll resumes.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              6a. No acknowledgment within 10 seconds: If machine pause interlock is wired (Relay Channel 3), edge engine safely de-energizes winder drive motor automatically.
            </td></tr>
            <tr><th>Requirements</th><td>FR-REL-05, FR-MOB-02, FR-GRD-02, FR-GRD-03</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 13 -Content $p13))

    # ==================== PAGE 14: UC-05 & UC-06 ====================
    $p14 = @'
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.5mm;">UC-05: Enforce Reliability Invariant & Mark Uninspected Section</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-05: Enforce Reliability Invariant & Mark Uninspected Section</b></td></tr>
            <tr><th>Primary Actor</th><td>Hardware Stand (Reliability Monitor; Secondary: Floor Operator, Quality Inspector)</td></tr>
            <tr><th>Preconditions</th><td>Inspection session is active; fabric is moving (v &gt; 0.05 m/s).</td></tr>
            <tr><th>Postconditions</th><td>Longitudinal interval [Y_start, Y_end] persisted as UNINSPECTED_SECTION; clean certification blocked.</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. Fabric moves across table; reliability sentinel evaluates every captured frame.<br>
              2. Sentinel detects sensor violation: LED lux &lt; 800, frame interval &gt; 100 ms, or Laplacian variance &lt; 100.<br>
              3. Sentinel immediately sets internal state flag RELIABILITY_HEALTH = FALSE.<br>
              4. System suspends AI classification, refusing to make predictions on degraded optical data.<br>
              5. System records starting position Y_start from rotary encoder counter.<br>
              6. System energizes Amber stack light and sends high-priority warning to mobile app.<br>
              7. Operator adjusts lighting or lens; sensor values return to valid operational limits.<br>
              8. Sentinel records ending position Y_end, writes UNINSPECTED_SECTION record in SQLite, and restores classification.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              7a. Fault persists for more than 5 meters of travel: System triggers red stack light and pauses winding motor automatically, requiring operator intervention.
            </td></tr>
            <tr><th>Requirements</th><td>FR-REL-01 to FR-REL-04, FR-GRD-05, FR-DSH-02</td></tr>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2.5mm; margin-bottom: 0.5mm;">UC-06: Mark Manual Defect by Floor Inspector</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-06: Mark Manual Defect by Floor Inspector</b></td></tr>
            <tr><th>Primary Actor</th><td>Floor Operator / Floor Inspector (Secondary: Industrial Edge Unit)</td></tr>
            <tr><th>Preconditions</th><td>Inspection session is active.</td></tr>
            <tr><th>Postconditions</th><td>Manual defect record with source = MANUAL_OPERATOR persisted in SQLite with current coordinates.</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. Operator visually observes an anomaly on the moving fabric web.<br>
              2. Operator taps 'Tag Defect' action button on mobile floor terminal.<br>
              3. Mobile app queries edge unit for exact current encoder position Y_current.<br>
              4. Mobile app presents selection sheet: Shade Variation, Selvage Curl, Foreign Yarn, Slub, Odor/Moisture.<br>
              5. Operator selects flaw type, enters estimated lateral position (Left, Center, Right), and taps 'Confirm'.<br>
              6. Edge unit stores manual defect entity in SQLite with timestamp, operator ID, and estimated coordinates.<br>
              7. Defect appears on live inspection feed with a distinctive 'Manual Tag' marker icon.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              4a. Quick Tag: Operator taps 'Quick Tag' without specifying class; system logs flaw with class UNSPECIFIED_ANOMALY and current Y for later review.
            </td></tr>
            <tr><th>Requirements</th><td>FR-MOB-04, FR-BUF-01, FR-BUF-02</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 14 -Content $p14))

    # ==================== PAGE 15: UC-07 & UC-08 ====================
    $p15 = @'
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.5mm;">UC-07: Buffer Offline Batches in Transactional Outbox</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-07: Buffer Offline Batches in Transactional Outbox</b></td></tr>
            <tr><th>Primary Actor</th><td>Hardware Stand (Edge Persistence Layer; Secondary: None)</td></tr>
            <tr><th>Preconditions</th><td>Local SQLite database initialized with WAL journaling; free disk space &ge; 5 GB.</td></tr>
            <tr><th>Postconditions</th><td>Data persistently stored on edge NVMe/SSD; completely immune to network failure or Wi-Fi disconnection.</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. An event occurs on edge unit (defect detected, session state changed, or uninspected span flagged).<br>
              2. Local database layer opens atomic SQLite transaction: BEGIN IMMEDIATE TRANSACTION.<br>
              3. System inserts business record into domain table (defects or uninspected_spans).<br>
              4. System inserts corresponding synchronization event into outbox_events table with status = PENDING.<br>
              5. Transaction commits: COMMIT.<br>
              6. SQLite WAL file writes changes sequentially to disk cache; background thread flushes to database file.<br>
              7. System confirms write success within under 5 ms, ready for next inspection frame event.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              2a. SQLite locked or disk write error: System retries using bounded exponential backoff (up to 3 attempts); if persistent, writes emergency recovery JSON to ramdisk.
            </td></tr>
            <tr><th>Requirements</th><td>FR-BUF-01, FR-BUF-02, FR-BUF-03, FR-BUF-05</td></tr>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2.5mm; margin-bottom: 0.5mm;">UC-08: Synchronize Outbox Batches with Central Server</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-08: Synchronize Outbox Batches with Central Server</b></td></tr>
            <tr><th>Primary Actor</th><td>Hardware Stand (Edge Sync Daemon; Secondary: Central FastAPI Server, PostgreSQL, MinIO)</td></tr>
            <tr><th>Preconditions</th><td>Outbox contains records with status = PENDING; central server reachable over HTTPS.</td></tr>
            <tr><th>Postconditions</th><td>Records committed in central PostgreSQL; crops stored in MinIO; local outbox updated to SYNCED.</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. Edge sync daemon performs HTTP GET heartbeat probe to /api/v1/health; receives HTTP 200 OK.<br>
              2. Daemon queries local SQLite for up to 50 oldest PENDING records from outbox_events.<br>
              3. Daemon reads corresponding defect JPEG image crops from local disk storage.<br>
              4. Daemon constructs multipart/form-data payload containing JSON metadata batch and binary JPEG attachments.<br>
              5. Daemon sends HTTPS POST to /api/v1/sync/batch with edge TLS client authentication.<br>
              6. Central FastAPI server receives payload, validates schemas, and opens PostgreSQL transaction.<br>
              7. Server uploads image crops to MinIO S3 bucket, inserts relational records, and commits transaction.<br>
              8. Central server returns HTTP 200 OK with JSON list of committed record UUIDs.<br>
              9. Edge daemon updates local outbox records to status = SYNCED with timestamp.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              5a. Network connection drops mid-transfer: Request times out; records remain PENDING in SQLite; daemon backs off and retries upon reconnection.<br>
              6a. Duplicate record received: Server executes idempotent upsert, confirming the record to prevent sync deadlocks.
            </td></tr>
            <tr><th>Requirements</th><td>FR-SYN-01 to FR-SYN-06, FR-BUF-04</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 15 -Content $p15))

    # ==================== PAGE 16: UC-09 & UC-10 ====================
    $p16 = @'
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.5mm;">UC-09: Review & Correct Defect Classification</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-09: Review & Correct Defect Classification</b></td></tr>
            <tr><th>Primary Actor</th><td>Quality Assurance Inspector (Secondary: Central Cloud Application, PostgreSQL)</td></tr>
            <tr><th>Preconditions</th><td>Roll inspection session has concluded and synchronized with central cloud database.</td></tr>
            <tr><th>Postconditions</th><td>Defect record updated; original AI prediction preserved; change logged in immutable audit trail.</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. Inspector navigates to Roll Defect Review screen on web workstation.<br>
              2. System displays gallery of defect thumbnail crops alongside full-frame context and AI confidence scores.<br>
              3. Inspector selects a defect with moderate confidence (0.40 to 0.65) classified as 'Weft Crack'.<br>
              4. System opens high-resolution inspection modal with zoom and measurement tools.<br>
              5. Inspector determines anomaly is actually an 'Oil Streak'; selects 'Oil Streak' from dropdown.<br>
              6. Inspector enters brief rationale: 'Localized lubricant contamination from loom needle bar'.<br>
              7. System updates defect record in PostgreSQL, recalculating physical width and penalty points.<br>
              8. System writes an entry to defect_audit_log recording inspector ID, old class, new class, and timestamp.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              5a. False positive (loose surface lint): Inspector marks status = DISMISSED_FALSE_POSITIVE; system zeroes penalty contribution while retaining crop for model retraining.
            </td></tr>
            <tr><th>Requirements</th><td>FR-DSH-03, FR-DSH-06, FR-REP-04</td></tr>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2.5mm; margin-bottom: 0.5mm;">UC-10: Compute ASTM D5430 4-Point Penalty Grade</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-10: Compute ASTM D5430 4-Point Penalty Grade</b></td></tr>
            <tr><th>Primary Actor</th><td>Quality Manager (Secondary: Central Grading Engine, PostgreSQL)</td></tr>
            <tr><th>Preconditions</th><td>Roll inspection complete; all inspector reclassifications finalized.</td></tr>
            <tr><th>Postconditions</th><td>Roll updated with final penalty points, points per 100 sq. m, and commercial grade (Grade A, B, C, or Reject).</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. Manager opens Roll Quality Summary screen and triggers 'Finalize Roll Grading'.<br>
              2. Grading engine queries all confirmed defects for the roll, extracting physical lengths L (mm) and defect types.<br>
              3. Engine assigns individual penalty points: 1 pt (&le; 75 mm), 2 pts (&gt; 75 to 150 mm), 3 pts (&gt; 150 to 230 mm), 4 pts (&gt; 230 mm); holes evaluated per ASTM Section 8.<br>
              4. Engine partitions roll into 1-meter longitudinal bins (0 to 1 m, 1 to 2 m, ..., N to N+1 m).<br>
              5. For each linear meter, engine sums defect points; if sum exceeds 4 points, it caps the linear meter penalty at exactly 4 points.<br>
              6. Engine sums capped points across all meters and computes normalized score: Points per 100 sq. m = (Total Points x 100) / (Length in m x Width in m).<br>
              7. Engine checks for uninspected sections; if any exist, sets grade to REJECT (UNINSPECTED); otherwise assigns grade based on threshold matrix (A, B, or C).<br>
              8. System updates roll summary record in PostgreSQL and displays grading scorecard on manager dashboard.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              7a. Roll contains critical flaw exceeding client tolerance (hole &gt; 50 mm): System automatically flags roll as REJECT regardless of point score per 100 square meters.
            </td></tr>
            <tr><th>Requirements</th><td>FR-GRD-01 to FR-GRD-05, FR-DSH-04</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 16 -Content $p16))

    # ==================== PAGE 17: UC-11 & UC-12 ====================
    $p17 = @'
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.5mm;">UC-11: View 2D Roll Defect Map & Quality Analytics</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-11: View 2D Roll Defect Map & Quality Analytics</b></td></tr>
            <tr><th>Primary Actor</th><td>Plant Quality Manager (Secondary: Central Cloud Web Application)</td></tr>
            <tr><th>Preconditions</th><td>User signed in with Quality Manager or Quality Inspector role.</td></tr>
            <tr><th>Postconditions</th><td>User gains actionable visual insights into loom mechanical health and fabric flaw clustering.</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. Manager opens 2D Roll Defect Map view on web client.<br>
              2. System renders HTML5 / WebGL canvas representing fabric web dimensions (e.g., 100 meters x 1.8 meters).<br>
              3. System plots color-coded defect glyphs at exact coordinates: lateral X (mm) and longitudinal Y (m) (Red = Holes, Orange = Oil Stains, Blue = Warp Streaks, Purple = Weft Cracks).<br>
              4. System renders uninspected sections as amber hatched hazard zones across canvas.<br>
              5. Manager uses mouse wheel to zoom into specific longitudinal clusters; canvas dynamically scales millimeter grid lines.<br>
              6. Manager toggles defect class filters (isolate 'Warp Streaks') to determine whether flaws align along a single lateral X coordinate (indicating a damaged reed dent or loom dropper).<br>
              7. System displays aggregated statistics sidebar: defect density per 10 meters, most frequent defect type, and ASTM point contribution breakdown.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              2a. Roll length exceeds 500 meters: System applies level-of-detail (LOD) aggregation, clustering closely spaced flaws into density glyphs until the user zooms in.
            </td></tr>
            <tr><th>Requirements</th><td>FR-DSH-01, FR-DSH-02, FR-DSH-05</td></tr>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2.5mm; margin-bottom: 0.5mm;">UC-12: Export PDF Quality Certificate & ERP Ingestion</div>
          <table class="formal-table">
            <tr><th style="width: 22%;">Use Case ID / Name</th><td style="width: 78%;"><b>UC-12: Export PDF Quality Certificate & ERP Ingestion</b></td></tr>
            <tr><th>Primary Actor</th><td>Plant Quality Manager (Secondary: Central Cloud Application, PostgreSQL, MinIO)</td></tr>
            <tr><th>Preconditions</th><td>Roll grading is finalized (status = COMPLETED).</td></tr>
            <tr><th>Postconditions</th><td>PDF document and JSON/CSV files generated, stored in MinIO, and downloaded to user workstation.</td></tr>
            <tr><th>Main Success Scenario</th><td>
              1. Manager selects 'Export Quality Certificate' from roll details screen.<br>
              2. System compiles roll metadata, inspector credentials, ASTM D5430 scorecard, full defect tabular ledger, and 2D defect map thumbnail.<br>
              3. System computes SHA-256 cryptographic digest over roll inspection record, embedding hash and QR verification code onto document footer.<br>
              4. System compiles document using headless PDF generation engine, creating formal multi-page PDF certificate.<br>
              5. System generates companion CSV/JSON files containing metric flaw coordinates [X, Y, W, L, Class] for downstream CAD marker nesting software.<br>
              6. System saves files in MinIO S3 storage under /certificates/{roll_id}.pdf.<br>
              7. Web browser initiates file download; system logs export event in PostgreSQL audit trail with manager ID and timestamp.
            </td></tr>
            <tr><th>Alternative Flows</th><td>
              2a. Roll contains unresolved uninspected spans: System places prominent 'REJECT / UNINSPECTED SECTION WARNING' watermark across all certificate pages.
            </td></tr>
            <tr><th>Requirements</th><td>FR-REP-01, FR-REP-02, FR-REP-03, FR-REP-04</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 17 -Content $p17))

    # ==================== PAGE 18: 3.3 EXTERNAL INTERFACES ====================
    $p18 = @'
          <h2 class="sec-heading">3.3 External Interface Requirements</h2>
          <h3 class="subsec-heading">3.3.1 User Interfaces</h3>
          <p>
            TexEye AI delivers two graphical interfaces: a high-contrast Flutter mobile app for floor operators and a React web dashboard for quality managers.
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm; font-style: italic;">Table 3.13: Screens of the TexEye AI web and mobile clients</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 10%; text-align: center;">Screen ID</th>
                <th style="width: 14%; text-align: center;">Target Client</th>
                <th style="width: 16%; text-align: center;">Target Users</th>
                <th style="width: 60%;">Purpose and Main User Interface Elements</th>
              </tr>
            </thead>
            <tbody>
              <tr><td style="text-align: center; font-weight: bold;">S-01</td><td style="text-align: center;">Mobile App</td><td style="text-align: center;">Floor Operator</td><td><b>QR Roll Scanner:</b> Viewfinder for scanning roll QR tags, displays Batch ID, Article, GSM, and 'Start' action.</td></tr>
              <tr><td style="text-align: center; font-weight: bold;">S-02</td><td style="text-align: center;">Mobile App</td><td style="text-align: center;">Floor Operator</td><td><b>Live Floor Monitor:</b> Real-time video preview, speed gauge (m/s), length counter, recent flaw thumbnail, pause/stop.</td></tr>
              <tr><td style="text-align: center; font-weight: bold;">S-03</td><td style="text-align: center;">Mobile App</td><td style="text-align: center;">Floor Operator</td><td><b>Alarm Modal:</b> High-contrast full-screen red warning dialog with vibration pulse, defect metrics, and 'Acknowledge' button.</td></tr>
              <tr><td style="text-align: center; font-weight: bold;">S-04</td><td style="text-align: center;">Mobile App</td><td style="text-align: center;">Floor Operator</td><td><b>Manual Flaw Tag Sheet:</b> Modal sheet with buttons for manual defects (Shade variation, Selvage curl, Foreign yarn).</td></tr>
              <tr><td style="text-align: center; font-weight: bold;">S-05</td><td style="text-align: center;">Web Dashboard</td><td style="text-align: center;">All Roles</td><td><b>Sign In &amp; MFA:</b> Username and password form with JWT token issuance and role-based redirect.</td></tr>
              <tr><td style="text-align: center; font-weight: bold;">S-06</td><td style="text-align: center;">Web Dashboard</td><td style="text-align: center;">Inspector, Manager</td><td><b>Rolls Overview Table:</b> Filterable list of inspected rolls, showing Batch ID, date, length, points, grade, and sync status.</td></tr>
              <tr><td style="text-align: center; font-weight: bold;">S-07</td><td style="text-align: center;">Web Dashboard</td><td style="text-align: center;">Inspector, Manager</td><td><b>Interactive 2D Defect Map:</b> Canvas rendering full fabric roll web, color-coded flaw glyphs, uninspected hazard spans.</td></tr>
              <tr><td style="text-align: center; font-weight: bold;">S-08</td><td style="text-align: center;">Web Dashboard</td><td style="text-align: center;">Quality Inspector</td><td><b>Defect Review Gallery:</b> High-resolution crop viewer with zoom, calipers, AI confidence bar, and reclassification selector.</td></tr>
              <tr><td style="text-align: center; font-weight: bold;">S-09</td><td style="text-align: center;">Web Dashboard</td><td style="text-align: center;">Quality Manager</td><td><b>ASTM 4-Point Scorecard:</b> Points breakdown by flaw length, 1-meter capping chart, points/100m2, and Grade widget.</td></tr>
              <tr><td style="text-align: center; font-weight: bold;">S-10</td><td style="text-align: center;">Web Dashboard</td><td style="text-align: center;">Manager, Admin</td><td><b>Certificate &amp; Export Hub:</b> PDF certificate preview with download button, ERP JSON/CSV export, and SHA-256 hash display.</td></tr>
            </tbody>
          </table>

          <h3 class="subsec-heading" style="margin-top: 2.5mm;">3.3.3 Software Interfaces</h3>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm; font-style: italic;">Table 3.14: Software interfaces</div>
          <table class="formal-table">
            <thead>
              <tr><th style="width: 28%;">Component</th><th style="width: 72%;">Purpose and Data Exchanged</th></tr>
            </thead>
            <tbody>
              <tr><td><b>Linux Kernel V4L2 / GenICam</b></td><td>Zero-copy camera frame buffer ingestion; camera exposure and gain register configuration via standard ioctl calls.</td></tr>
              <tr><td><b>Linux GPIO Subsystem (gpiod)</b></td><td>Kernel-level edge hardware interrupt handling on quadrature pulse pins for high-speed displacement tracking.</td></tr>
              <tr><td><b>AI Vision Framework (PyTorch / ONNX)</b></td><td>Execution of fine-tuned YOLO model; memory buffers for real-time frame defect detection and coordinate bounding boxes.</td></tr>
              <tr><td><b>SQLite 3.40+ (WAL Mode)</b></td><td>Local edge ACID storage; stores session headers, outbox queue events, and defect entities with sub-5ms commit latency.</td></tr>
              <tr><td><b>FastAPI (Python 3.11+)</b></td><td>Central enterprise application server; exposes authenticated REST endpoints and WebSocket servers.</td></tr>
              <tr><td><b>PostgreSQL 15+ & SQLAlchemy</b></td><td>Relational enterprise persistence for multi-stand roll histories, defect coordinates, user accounts, and immutable audit logs.</td></tr>
              <tr><td><b>MinIO S3 Object Storage</b></td><td>Stores binary high-resolution defect JPEG crops and generated PDF inspection certificates with authenticated pre-signed URLs.</td></tr>
              <tr><td><b>Redis 7</b></td><td>In-memory pub/sub broker for real-time WebSocket alert broadcasting to floor mobile clients and web dashboards.</td></tr>
            </tbody>
          </table>

          <h3 class="subsec-heading" style="margin-top: 2mm;">3.3.4 Communications Interfaces</h3>
          <p>
            Subsystems communicate via standard industrial protocols: hardware GPIO TTL logic for encoder interrupts and relay actuation, local HTTP/1.1 REST for floor mobile control, encrypted HTTPS (TLS 1.3) for batch cloud synchronization, and persistent WebSockets (WSS) for real-time operator alerts under 50 ms latency.
          </p>
'@
    $pages.Add((New-Page -PageNumber 18 -Content $p18))

    # ==================== PAGE 19: 3.3.2 HARDWARE INTERFACES & FIGURE 4.1 ====================
    $p19 = @'
          <h3 class="subsec-heading" style="margin-top: 0;">3.3.2 Hardware Interfaces & Physical Architecture</h3>
          <p>
            The physical stand integrates four industrial hardware components connected to the edge computing unit:
          </p>
          <ul>
            <li><b>Area-Scan Industrial Camera:</b> Connects via high-speed USB 3.0 / GigE interface using industrial locking connectors, capturing into a zero-copy Linux V4L2 ring buffer.</li>
            <li><b>Rotary Optical Encoder:</b> Coupled to the 100 mm drive roller (1024 PPR). Transmits 24V differential quadrature pulse signals, stepped down to 3.3V TTL via opto-coupler, triggering hardware GPIO interrupts on the edge unit.</li>
            <li><b>Regulated High-CRI LED Lighting Rig:</b> Powered by a 24V constant-current DIN-rail power supply, delivering flicker-free 5500K daylight illumination across the inspection zone.</li>
            <li><b>Opto-Isolated Alarm Relay:</b> 4-channel 5V/24V relay board driven by edge GPIO logic levels, actuating the physical red/amber/green stack light tower and 90 dB floor buzzer.</li>
          </ul>
          <div class="diagram-container" style="margin-top: 2mm;">
            <img class="diagram-img" src="../diagrams/svg/04_hardware_architecture.svg" alt="Hardware Architecture Diagram" style="max-height: 165mm;" />
            <div class="caption">Figure 4.1: Hardware Architecture and Physical Interconnect Diagram</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 19 -Content $p19))

    # ==================== PAGE 20: CHAPTER 4 NON-FUNCTIONAL REQUIREMENTS ====================
    $p20 = @'
          <div class="chapter-bar">4 Other Non-functional Requirements</div>
          <h2 class="sec-heading">4.1 Performance Requirements</h2>
          <p>
            Quantitative performance requirements governing edge real-time response and cloud throughput are compiled in Table 4.1.
          </p>
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.8mm;">Table 4.1: Performance requirements</div>
          <table class="formal-table">
            <thead>
              <tr><th style="width: 12%;">ID</th><th style="width: 25%;">Requirement Specification</th><th style="width: 18%;">Target Metric</th><th style="width: 45%;">Engineering Rationale</th></tr>
            </thead>
            <tbody>
              <tr><td><b>PR-01</b></td><td>AI Inference Latency</td><td>&le; 30 ms / frame</td><td>Guarantees 30+ FPS edge throughput via optimized model inference, exceeding continuous camera capture rate.</td></tr>
              <tr><td><b>PR-02</b></td><td>End-to-End Edge Pipeline Latency</td><td>&le; 60 ms total</td><td>From optical exposure to Kalman tracking and SQLite commit; ensures immediate flaw localization.</td></tr>
              <tr><td><b>PR-03</b></td><td>Alarm Relay Actuation Time</td><td>&le; 50 ms</td><td>From confirmed critical flaw to relay closure; allows operator or emergency stop to halt fabric in 25 mm.</td></tr>
              <tr><td><b>PR-04</b></td><td>Mobile Alert Notification Latency</td><td>&le; 200 ms</td><td>From flaw confirmation to mobile terminal vibration; maintains real-time operator awareness.</td></tr>
              <tr><td><b>PR-05</b></td><td>Maximum Linear Web Speed</td><td>0.50 m/s (30 m/min)</td><td>Encompasses standard industrial inspection speeds in Pakistani weaving mills (typical 0.20 to 0.35 m/s).</td></tr>
              <tr><td><b>PR-06</b></td><td>Local SQLite Buffer Capacity</td><td>&ge; 500,000 frames</td><td>Enables continuous offline buffering for over 4 hours of uninterrupted mill operation (&gt; 5,000 meters).</td></tr>
              <tr><td><b>PR-07</b></td><td>Cloud Batch Ingestion Throughput</td><td>&ge; 100 records / sec</td><td>Allows central FastAPI server to ingest accumulated backlogs from multiple edge stands concurrently.</td></tr>
              <tr><td><b>PR-08</b></td><td>Web 2D Defect Map Render Time</td><td>&le; 1.5 seconds</td><td>WebGL canvas renders up to 5,000 flaw markers smoothly with 60 FPS panning and zooming.</td></tr>
              <tr><td><b>PR-09</b></td><td>PDF Certificate Generation Time</td><td>&le; 3.0 seconds</td><td>Compiles comprehensive multi-page PDF document with embedded defect map and verification hash.</td></tr>
              <tr><td><b>PR-10</b></td><td>Concurrent Stand Scalability</td><td>&ge; 10 active stands</td><td>A single central enterprise server instance supports simultaneous real-time data streaming from 10 lines.</td></tr>
            </tbody>
          </table>

          <h2 class="sec-heading" style="margin-top: 2.5mm;">4.2 Safety and Security Requirements</h2>
          <h3 class="subsec-heading">4.2.1 Safety Requirements</h3>
          <ul>
            <li><b>SR-01 Electrical Isolation:</b> All GPIO inputs (encoder) and outputs (relay) are optically isolated (&ge; 2.5 kV RMS rating) to protect edge electronics from inductive kickback.</li>
            <li><b>SR-02 Fail-Safe Alarm Logic:</b> Relay circuits are wired in fail-safe mode; loss of edge power automatically trips relay into warning alarm state.</li>
            <li><b>SR-03 Non-Contact Optical Sensing:</b> Camera, encoder, and lighting rig maintain zero contact with moving fabric (except low-friction polyurethane encoder wheel).</li>
            <li><b>SR-04 Photobiological Safety:</b> LED lighting rig complies with IEC 62471 standards for continuous human exposure with diffused glare barriers.</li>
            <li><b>SR-05 Thermal Protection:</b> Edge chassis and LED supplies incorporate thermal monitoring; internal temperature exceeding 75 C logs an automatic thermal warning.</li>
            <li><b>SR-06 Emergency Stop Handshake:</b> Provides an isolated dry-contact interlock wired to rolling stand emergency stop circuit for automatic deceleration on tears.</li>
          </ul>

          <h3 class="subsec-heading" style="margin-top: 2mm;">4.2.2 Security and Privacy Requirements</h3>
          <ul>
            <li><b>SC-01 Role-Based Access Control (RBAC):</b> System access partitioned into Floor Operator, Quality Inspector, Quality Manager, and System Admin via signed JWT tokens.</li>
            <li><b>SC-02 Password Hashing:</b> Passwords hashed using Argon2id with per-user cryptographic salts; plain-text passwords never stored or logged.</li>
            <li><b>SC-03 Transport Security:</b> All client-server traffic, edge sync batches, and WebSocket connections mandate TLS 1.3 encryption.</li>
            <li><b>SC-04 Tamper-Evident Verification:</b> Finalized certificates embed a SHA-256 digital signature over roll metadata and ASTM points, verified via QR scan.</li>
            <li><b>SC-05 Immutable Audit Trail:</b> Every inspector relabeling action, grading override, and certificate generation event permanently logged with user ID and timestamp.</li>
          </ul>
'@
    $pages.Add((New-Page -PageNumber 20 -Content $p20))

    # ==================== PAGE 21: QUALITY ATTRIBUTES ====================
    $p21 = @'
          <h2 class="sec-heading">4.3 Software Quality Attributes</h2>
          <h3 class="subsec-heading">4.3.1 Reliability & Invariant Preservation</h3>
          <p>
            Reliability is founded on the <b>Non-Negotiable Inspection Invariant</b>: <i>A fabric roll shall never be certified as defect-free if any segment traversed the inspection zone during an unmonitored or optically degraded state</i>.
          </p>
          <ul>
            <li><b>Atomic State Transitions:</b> Inspection sessions transition through formal deterministic states (INITIALIZING to RUNNING to PAUSED to UNINSPECTED to COMPLETED). No corrupt intermediate state is permissible.</li>
            <li><b>Dual-Storage Fault Tolerance:</b> Every defect event is committed to local SQLite WAL storage prior to network transmission, ensuring zero data loss during plant-wide blackouts or Wi-Fi drops.</li>
            <li><b>Autonomous Hardware Reconnection:</b> If camera USB resets or encoder drops connection, edge daemon re-enumerates hardware within 500 ms without manual restarts.</li>
          </ul>

          <h3 class="subsec-heading">4.3.2 Correctness and Verifiability</h3>
          <ul>
            <li><b>Deterministic ASTM Grading:</b> The ASTM D5430 penalty calculator implements a purely deterministic mathematical formulation verified against published international standards. Given identical flaw inputs, grading output is 100% reproducible.</li>
            <li><b>Metrological Precision:</b> Lateral pixel-to-millimeter calibration factors (kx) are verified using physical calibration grid targets, achieving spatial coordinate accuracy within plus/minus 2 mm.</li>
            <li><b>Deduplication Accuracy:</b> The Kalman-IoU tracker eliminates double-counting of traversing defects with &ge; 98% tracking continuity on continuous streaks up to 10 meters in length.</li>
          </ul>

          <h3 class="subsec-heading">4.3.3 Reproducibility & Traceability</h3>
          <ul>
            <li><b>Traceable Lineage:</b> Every committed defect record stores raw bounding box pixels, normalized physical coordinates, AI model version hash, camera frame timestamp, and encoder pulse index.</li>
            <li><b>Deterministic Replay:</b> Archived raw frame video sequences can be replayed through the AI engine to evaluate updated model weights against historical ground-truth runs.</li>
            <li><b>Audit Compliance:</b> All changes to defect classifications made by human inspectors require an explicit rationale entry, maintaining complete traceability for export compliance audits.</li>
          </ul>

          <h3 class="subsec-heading">4.3.4 Maintainability and Design for Change</h3>
          <ul>
            <li><b>Decoupled Modular Architecture:</b> The hardware ingestion layer, AI inference engine, local storage outbox, and cloud sync daemon operate as decoupled services. Upgrading YOLO from v8 to v11 requires replacing only the TensorRT engine file without altering ingestion or UI code.</li>
            <li><b>Externalized Configuration:</b> Physical parameters (roller circumference, encoder PPR, lighting lux limits, camera resolution) are defined in an external YAML configuration file, enabling rapid stand recalibration without code recompilation.</li>
          </ul>

          <h3 class="subsec-heading">4.3.5 Testability</h3>
          <ul>
            <li><b>Hardware-in-the-Loop (HIL) Simulation:</b> The edge engine includes a virtual camera and simulated encoder pulse generator capable of streaming synthetic fabric video and quadrature pulses for automated regression testing.</li>
            <li><b>Automated Test Coverage:</b> Core algorithms (ASTM penalty capping, coordinate transformation, Kalman tracking, outbox state machine) maintain &ge; 85% automated test coverage using PyTest.</li>
          </ul>

          <h3 class="subsec-heading">4.3.6 Usability, Portability & Interoperability</h3>
          <ul>
            <li><b>High-Contrast Shop-Floor UI:</b> Mobile and stand screens utilize high-contrast themes (&ge; 7:1 ratio) with oversized touch targets (&ge; 48x48 px), enabling seamless operation by workers wearing gloves.</li>
            <li><b>Color-Blind Accessible Overlay:</b> Defect overlays utilize distinct geometric glyphs (squares, diamonds, triangles, circles) in addition to color hues for color-blind operators.</li>
            <li><b>Cross-Platform Edge Deployment:</b> Edge software stack is containerized using Docker, verified on NVIDIA Jetson Linux (aarch64) and standard industrial x86_64 PCs.</li>
            <li><b>Standard Data Exchange:</b> All external API payloads, database exports, and cutting-room integration files adhere strictly to standard JSON and CSV formats.</li>
          </ul>
'@
    $pages.Add((New-Page -PageNumber 21 -Content $p21))

    return $pages
}

Write-Output "Compact Pages 12 to 21 module loaded."


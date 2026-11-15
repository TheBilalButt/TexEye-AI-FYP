# Part 3: Pages 21 to 36
function Get-Pages-21-to-36 {
    $pages = [System.Collections.Generic.List[string]]::new()

    # ==================== PAGE 21: 3.2.2 ACTORS & 3.2.3 USE CASE SUMMARY ====================
    $p21 = @'
          <h3 class="subsec-heading">3.2.2 Actors</h3>
          <p>
            The actors interacting with TexEye AI and their primary responsibilities are detailed in Table 3.11.
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.11: Actors of TexEye AI</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 20%;">Actor Name</th>
                <th style="width: 15%;">Actor Type</th>
                <th style="width: 65%;">Role in the System</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Floor Operator</b></td>
                <td>Primary, human</td>
                <td>Mounts fabric roll on stand, scans QR code, controls inspection runs, acknowledges physical alarms, and views mobile vibration alerts.</td>
              </tr>
              <tr>
                <td><b>Quality Inspector</b></td>
                <td>Primary, human</td>
                <td>Audits defect image crops on web dashboard, corrects AI classifications, verifies uninspected spans, and signs off on preliminary defect logs.</td>
              </tr>
              <tr>
                <td><b>Quality Manager</b></td>
                <td>Primary, human</td>
                <td>Reviews ASTM 4-point penalty scores, evaluates loom defect heatmaps, configures penalty thresholds, and issues certified PDF quality reports.</td>
              </tr>
              <tr>
                <td><b>System Admin</b></td>
                <td>Primary, human</td>
                <td>Performs metric camera calibration ($mm/pixel$), monitors edge health heartbeats, manages user accounts, and maintains database backups.</td>
              </tr>
              <tr>
                <td><b>Hardware Stand</b></td>
                <td>Secondary, system</td>
                <td>Area-scan camera, rotary optical encoder, high-CRI lighting rig, and opto-isolated relay stack light operating continuously at machine level.</td>
              </tr>
            </tbody>
          </table>
          <h3 class="subsec-heading">3.2.3 Use Case Summary</h3>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.12: Use case summary</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 12%;">Use Case ID</th>
                <th style="width: 25%;">Use Case Name</th>
                <th style="width: 18%;">Primary Actor</th>
                <th style="width: 45%;">Short Functional Summary</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>UC-01</b></td>
                <td>Start Inspection Session</td>
                <td>Floor Operator</td>
                <td>Scan roll QR code, validate fabric metadata, zero encoder counter, and initialize local SQLite session.</td>
              </tr>
              <tr>
                <td><b>UC-02</b></td>
                <td>Monitor Live Optical Feed</td>
                <td>Floor Operator</td>
                <td>Stream low-latency video preview with bounding box overlays and real-time linear speed indicators.</td>
              </tr>
              <tr>
                <td><b>UC-03</b></td>
                <td>Real-Time Defect Detection</td>
                <td>Hardware Stand</td>
                <td>Trigger frame analysis on encoder advance, execute YOLO inference, track flaws via Kalman Filter, map metric $(X, Y)$.</td>
              </tr>
              <tr>
                <td><b>UC-04</b></td>
                <td>Trigger Audio-Visual Alarm</td>
                <td>Hardware Stand</td>
                <td>Energize opto-isolated 24V relay for red stack light/buzzer and dispatch mobile WebSocket vibration alerts on severe flaws.</td>
              </tr>
              <tr>
                <td><b>UC-05</b></td>
                <td>Enforce Reliability Invariant</td>
                <td>Hardware Stand</td>
                <td>Detect optical blur, lighting drop, or speed violation; halt defect classification and record <code>UNINSPECTED_SECTION</code>.</td>
              </tr>
              <tr>
                <td><b>UC-06</b></td>
                <td>Mark Manual Defect</td>
                <td>Floor Operator</td>
                <td>Tag an anomaly observed visually from mobile interface, binding current encoder position $Y$ to the record.</td>
              </tr>
              <tr>
                <td><b>UC-07</b></td>
                <td>Buffer Offline Batches</td>
                <td>Hardware Stand</td>
                <td>Commit inspection events and image crop paths into local SQLite WAL transactional outbox during network dropouts.</td>
              </tr>
              <tr>
                <td><b>UC-08</b></td>
                <td>Synchronize Outbox Batches</td>
                <td>Hardware Stand</td>
                <td>Transmit pending outbox batches over HTTPS multipart POST to central FastAPI server and process two-phase ACK.</td>
              </tr>
              <tr>
                <td><b>UC-09</b></td>
                <td>Review & Correct Defect</td>
                <td>Quality Inspector</td>
                <td>Inspect high-res defect crops on web dashboard, modify classification labels, and log changes to the audit trail.</td>
              </tr>
              <tr>
                <td><b>UC-10</b></td>
                <td>Compute ASTM 4-Point Grade</td>
                <td>Quality Manager</td>
                <td>Calculate standardized penalty points per 100 m&sup2; with 4-point/linear-meter cap and assign Grade A, B, C, or Reject.</td>
              </tr>
              <tr>
                <td><b>UC-11</b></td>
                <td>View 2D Roll Defect Map</td>
                <td>Quality Manager</td>
                <td>Explore interactive roll defect spatial map with zooming, filtering by defect class, and uninspected span highlighting.</td>
              </tr>
              <tr>
                <td><b>UC-12</b></td>
                <td>Export PDF Quality Certificate</td>
                <td>Quality Manager</td>
                <td>Generate tamper-evident PDF inspection certificate with SHA-256 cryptographic verification hash and ERP CSV export.</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 21 -Content $p21))

    # ==================== PAGE 22: UC-01 START INSPECTION SESSION ====================
    $p22 = @'
          <h3 class="subsec-heading">3.2.4 Fully Dressed Use Cases</h3>
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-01: Start Roll Inspection Session</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-01</b></td></tr>
            <tr><th>Name</th><td><b>Start Roll Inspection Session</b></td></tr>
            <tr><th>Primary actor</th><td>Floor Operator</td></tr>
            <tr><th>Secondary actors</th><td>Hardware Stand (Camera & Encoder), Industrial Edge Unit</td></tr>
            <tr><th>Description</th><td>Floor operator mounts a new woven fabric roll onto the inspection frame, scans its identifying QR barcode via the mobile app, and initializes an automated inspection session on the local edge rig.</td></tr>
            <tr><th>Preconditions</th><td>1. Physical inspection stand is powered and high-CRI lighting rig is illuminated.<br>2. Industrial camera and rotary encoder are connected and recognized by Linux edge kernel.<br>3. Operator is signed into the mobile terminal.</td></tr>
            <tr><th>Postconditions</th><td>1. A new roll inspection session is created in local SQLite database with status <code>IN_PROGRESS</code>.<br>2. Hardware GPIO interrupt pulse counter is reset to zero ($Y = 0.00 \text{ m}$).<br>3. Camera ingestion pipeline begins continuous ring-buffer acquisition.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. Operator mounts fabric roll onto the mechanical feed rollers and threads the web through the optical inspection zone.<br>
              2. Operator opens TexEye Mobile App and selects 'Start New Roll'.<br>
              3. Operator aims device camera at roll QR code; app scans and decodes Roll ID, Article Name, Target Length, and Nominal Width.<br>
              4. Mobile app transmits session initialization request to edge unit via local Wi-Fi REST API (<code>POST /api/v1/session/start</code>).<br>
              5. Edge unit resets rotary encoder hardware pulse accumulator to zero.<br>
              6. Edge unit checks lighting lux levels and camera frame delivery; confirms operating environment is optimal.<br>
              7. Edge unit creates new session record in SQLite (WAL) and returns <code>session_id</code> to mobile terminal.<br>
              8. Mobile app transitions to Live Inspection Monitor screen, displaying 'Stand Ready - Move Fabric'.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              3a. QR code is damaged or unreadable: Operator manually enters numeric Roll ID into mobile form.<br>
              6a. Camera ingestion fails or illumination is below 800 lux: Edge unit halts initialization, illuminates amber warning stack light, and displays specific hardware diagnostic error on mobile screen.<br>
              4a. Local edge unit unreachable: Mobile app alerts operator to verify local stand Wi-Fi connectivity.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-ING-01, FR-ING-02, FR-MOB-01, FR-BUF-01, FR-REL-01, FR-REL-02</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 22 -Content $p22))

    # ==================== PAGE 23: UC-02 MONITOR LIVE OPTICAL FEED ====================
    $p23 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-02: Monitor Live Optical Feed & Metrology Overlay</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-02</b></td></tr>
            <tr><th>Name</th><td><b>Monitor Live Optical Feed & Metrology Overlay</b></td></tr>
            <tr><th>Primary actor</th><td>Floor Operator</td></tr>
            <tr><th>Secondary actors</th><td>Industrial Edge Unit</td></tr>
            <tr><th>Description</th><td>Operator observes low-latency video stream on the stand display or mobile tablet during winding, observing live bounding box overlays, instantaneous fabric linear velocity, and cumulative inspected length.</td></tr>
            <tr><th>Preconditions</th><td>An inspection session is currently active (status = <code>IN_PROGRESS</code>).</td></tr>
            <tr><th>Postconditions</th><td>Operator maintains continuous visual awareness of automated inspection performance and physical line velocity.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. Operator initiates fabric winding; rolling stand motor pulls fabric forward.<br>
              2. Rotary encoder transmits quadrature pulses; edge unit calculates instantaneous linear speed ($v_{\text{web}}$ in m/s).<br>
              3. Edge unit downsamples 1080p camera frames to lightweight MJPEG / WebRTC stream (720p @ 15 FPS) for UI display.<br>
              4. Edge unit renders real-time visual overlays on stream: cumulative length ($Y$ meters), linear speed (m/s), and active defect bounding boxes with confidence labels.<br>
              5. Operator views the live feed on stand monitor or mobile tablet, verifying consistent illumination and correct fabric tracking.<br>
              6. Live feed updates continuously until operator pauses or concludes the roll session.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              2a. Fabric speed exceeds maximum certified inspection velocity ($v &gt; 0.50 \text{ m/s}$): Edge unit flashes yellow velocity warning banner on display and sounds warning chime, instructing operator to reduce motor speed.<br>
              3a. Network bandwidth constrained: Edge unit reduces streaming frame rate to 10 FPS to ensure zero impact on AI inference execution.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-ING-01, FR-ING-05, FR-MOB-02, FR-REL-03</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 23 -Content $p23))

    # ==================== PAGE 24: UC-03 REAL-TIME DEFECT DETECTION ====================
    $p24 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-03: Real-Time Defect Detection & Kalman Tracking</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-03</b></td></tr>
            <tr><th>Name</th><td><b>Real-Time Defect Detection & Kalman Tracking</b></td></tr>
            <tr><th>Primary actor</th><td>Hardware Stand (Autonomous Edge Engine)</td></tr>
            <tr><th>Secondary actors</th><td>Floor Operator (Notified on Flaw)</td></tr>
            <tr><th>Description</th><td>The edge engine executes real-time AI inference on encoder-synchronized frames, tracks localized defects across overlapping frames using a Kalman Filter to eliminate duplicate counts, maps metric coordinates, and saves flaw records.</td></tr>
            <tr><th>Preconditions</th><td>Inspection session is active; fabric is moving across the optical inspection zone.</td></tr>
            <tr><th>Postconditions</th><td>Confirmed defects are saved to local SQLite database with physical coordinates, dimensions, class label, and crop JPEG image.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. Encoder pulse count reaches frame advance threshold; camera driver captures rectified frame.<br>
              2. Edge engine submits frame tensor to TensorRT YOLO FP16 inference engine.<br>
              3. YOLO detects candidate anomaly bounding boxes $[u_{\text{min}}, v_{\text{min}}, u_{\text{max}}, v_{\text{max}}]$ with confidence $\ge 0.40$.<br>
              4. Multi-frame Kalman Filter predicts positions of existing active tracks and associates candidate detections via IoU matching.<br>
              5. When a candidate detection matches an active track, its spatial trajectory and physical length $L_{\text{mm}}$ are updated.<br>
              6. Once a track achieves &ge; 3 consecutive frame hits, it is elevated to <code>CONFIRMED_DEFECT</code> status.<br>
              7. When the flaw exits the optical FOV, the edge engine calculates finalized physical coordinates: lateral position $X_{\text{mm}}$ and longitudinal position $Y_{\text{meters}}$.<br>
              8. Edge engine extracts high-resolution JPEG crop around flaw and writes defect record to local SQLite outbox within 30 ms.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              6a. Anomaly detected in fewer than 3 frames and disappears: Track is discarded as transient surface dust or loose yarn lint.<br>
              7a. Flaw spans multiple consecutive frames continuously (&gt; 1 meter, e.g. continuous warp streak): System updates ongoing defect record dynamically, incrementing length without generating duplicate flaw entities.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-INF-01 to FR-INF-06, FR-TRK-01 to FR-TRK-04, FR-BUF-01, FR-BUF-02</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 24 -Content $p24))

    # ==================== PAGE 25: UC-04 TRIGGER AUDIO-VISUAL ALARM ====================
    $p25 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-04: Trigger Audio-Visual Alarm on Defect Cluster</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-04</b></td></tr>
            <tr><th>Name</th><td><b>Trigger Audio-Visual Alarm on Defect Cluster</b></td></tr>
            <tr><th>Primary actor</th><td>Hardware Stand (Edge Engine)</td></tr>
            <tr><th>Secondary actors</th><td>Floor Operator</td></tr>
            <tr><th>Description</th><td>When a critical flaw (large hole &gt; 25 mm, continuous warp tear) or a localized cluster of defects is detected, the system actuates physical 24V shop-floor stack lights, sounds an audible buzzer, and delivers mobile vibration alerts.</td></tr>
            <tr><th>Preconditions</th><td>An active defect is confirmed with severity = <code>CRITICAL</code>, or penalty points within current linear meter exceed 4 points.</td></tr>
            <tr><th>Postconditions</th><td>Physical red stack light and buzzer are energized; mobile vibration alert is triggered; alarm timestamp logged.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. YOLO detection and ASTM scoring engine identify a critical defect (e.g., hole &gt; 25 mm or multiple flaws in a 1-meter span).<br>
              2. Edge engine asserts GPIO Pin 17, energizing the opto-isolated relay module within 20 ms.<br>
              3. Relay closes 24V DC circuit, illuminating the physical Red Tower Light and sounding the 90 dB floor buzzer.<br>
              4. Edge engine broadcasts WebSocket alert message to connected mobile application.<br>
              5. Operator's mobile device vibrates continuously with high-priority audio alarm, displaying 'CRITICAL FLAW DETECTED AT Y = XX.X m'.<br>
              6. Operator halts winding motor, inspects the physical fabric section, and taps 'Acknowledge Alarm' on the mobile terminal.<br>
              7. Edge engine de-asserts GPIO Pin 17, silencing the buzzer while leaving the visual beacon active until the roll resumes.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              6a. Operator does not acknowledge within 10 seconds: If machine pause interlock is wired (Relay Channel 3), edge engine safely de-energizes winder drive motor to prevent rolling flawed fabric onto the finished core.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-REL-05, FR-MOB-02, FR-GRD-02, FR-GRD-03</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 25 -Content $p25))

    # ==================== PAGE 26: UC-05 ENFORCE RELIABILITY INVARIANT ====================
    $p26 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-05: Enforce Reliability Invariant & Mark Uninspected Section</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-05</b></td></tr>
            <tr><th>Name</th><td><b>Enforce Reliability Invariant & Mark Uninspected Section</b></td></tr>
            <tr><th>Primary actor</th><td>Hardware Stand (Reliability Monitor)</td></tr>
            <tr><th>Secondary actors</th><td>Floor Operator, Quality Inspector</td></tr>
            <tr><th>Description</th><td>Continuous hardware-software sentinel monitors optical frame health; if lighting drops, frames drop, or blur occurs during motion, defect classification is suspended and the span is recorded as Uninspected.</td></tr>
            <tr><th>Preconditions</th><td>Inspection session is active; fabric is moving ($v &gt; 0.05 \text{ m/s}$).</td></tr>
            <tr><th>Postconditions</th><td>Longitudinal interval $[Y_{\text{start}}, Y_{\text{end}}]$ is persisted as <code>UNINSPECTED_SECTION</code>; clean certification is mathematically blocked.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. Fabric is moving across the table; reliability sentinel evaluates every ingested frame.<br>
              2. Sentinel detects a sensor violation: LED bank lux &lt; 800 lux, or camera frame delivery &gt; 100 ms, or Laplacian variance &lt; 100.<br>
              3. Sentinel immediately sets internal state flag <code>RELIABILITY_HEALTH = FALSE</code>.<br>
              4. System suspends AI defect classification (refusing to make predictions on degraded optical data).<br>
              5. System records starting position $Y_{\text{start}}$ from rotary encoder counter.<br>
              6. System energizes Amber stack light and sends high-priority warning to operator mobile terminal.<br>
              7. Operator adjusts lighting or lens; sensor values return to normal operational limits.<br>
              8. Sentinel records ending position $Y_{\text{end}}$, creates an immutable <code>UNINSPECTED_SECTION</code> record in SQLite, and restores classification.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              7a. Sensor fault persists for more than 5 meters of travel: System triggers red stack light and pauses winding motor automatically, requiring operator intervention before proceeding.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-REL-01 to FR-REL-04, FR-GRD-05, FR-DSH-02</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 26 -Content $p26))

    # ==================== PAGE 27: UC-06 MARK MANUAL DEFECT ====================
    $p27 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-06: Mark Manual Defect by Floor Inspector</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-06</b></td></tr>
            <tr><th>Name</th><td><b>Mark Manual Defect by Floor Inspector</b></td></tr>
            <tr><th>Primary actor</th><td>Floor Operator / Floor Inspector</td></tr>
            <tr><th>Secondary actors</th><td>Industrial Edge Unit</td></tr>
            <tr><th>Description</th><td>Allows a human operator who visually spots a subtle flaw (e.g., selvage curl, subtle dye shade variation, or tactile thickness variation) to record a manual defect bound to current encoder coordinates.</td></tr>
            <tr><th>Preconditions</th><td>Inspection session is active.</td></tr>
            <tr><th>Postconditions</th><td>A manual defect record with source = <code>MANUAL_OPERATOR</code> is persisted in SQLite with current physical coordinates.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. Operator visually observes an anomaly on the moving fabric web.<br>
              2. Operator taps the large 'Tag Defect' action button on the mobile floor terminal.<br>
              3. Mobile app queries edge unit for exact current encoder position $Y_{\text{current}}$.<br>
              4. Mobile app presents quick selection sheet: <i>Shade Variation, Selvage Curl, Foreign Yarn, Slub, Odor/Moisture</i>.<br>
              5. Operator selects flaw type, enters estimated lateral position (Left, Center, Right), and taps 'Confirm'.<br>
              6. Edge unit stores manual defect entity in SQLite with timestamp, operator ID, and estimated coordinates.<br>
              7. Defect appears on the live inspection feed with a distinctive 'Manual Tag' marker icon.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              4a. Operator is in a hurry and taps 'Quick Tag': System logs flaw with class <code>UNSPECIFIED_ANOMALY</code> and current $Y$, allowing inspector to classify it later during post-roll review.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-MOB-04, FR-BUF-01, FR-BUF-02</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 27 -Content $p27))

    # ==================== PAGE 28: UC-07 BUFFER OFFLINE BATCHES ====================
    $p28 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-07: Buffer Offline Batches in Transactional Outbox</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-07</b></td></tr>
            <tr><th>Name</th><td><b>Buffer Offline Batches in Transactional Outbox</b></td></tr>
            <tr><th>Primary actor</th><td>Hardware Stand (Edge Persistence Layer)</td></tr>
            <tr><th>Secondary actors</th><td>None (Internal Autonomous Process)</td></tr>
            <tr><th>Description</th><td>Ensures all inspection frame events, defect records, uninspected intervals, and image crop paths are committed to local disk storage using transactional outbox semantics during network dropouts.</td></tr>
            <tr><th>Preconditions</th><td>Local SQLite database is initialized with WAL journaling; disk space is &ge; 5 GB.</td></tr>
            <tr><th>Postconditions</th><td>Data is persistently stored on edge NVMe/SSD; system is completely immune to network failure or Wi-Fi disconnection.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. An event occurs on the edge unit (defect detected, session state changed, or uninspected span flagged).<br>
              2. Local database layer opens an atomic SQLite transaction: <code>BEGIN IMMEDIATE TRANSACTION</code>.<br>
              3. System inserts business record into domain table (e.g., <code>defects</code> or <code>uninspected_spans</code>).<br>
              4. System inserts corresponding synchronization event into <code>outbox_events</code> table with status = <code>PENDING</code> and payload UUID.<br>
              5. Transaction commits: <code>COMMIT</code>.<br>
              6. SQLite WAL file writes changes sequentially to disk cache; background checkpoint thread flushes to database file.<br>
              7. System confirms write success within &lt; 5 ms, ready for the next inspection frame event.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              2a. SQLite database locked or disk write error: System retries write using bounded exponential backoff (up to 3 attempts); if persistent, writes emergency JSON recovery file to ramdisk.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-BUF-01, FR-BUF-02, FR-BUF-03, FR-BUF-05</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 28 -Content $p28))

    # ==================== PAGE 29: UC-08 SYNCHRONIZE OUTBOX BATCHES ====================
    $p29 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-08: Synchronize Outbox Batches with Central Server</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-08</b></td></tr>
            <tr><th>Name</th><td><b>Synchronize Outbox Batches with Central Server</b></td></tr>
            <tr><th>Primary actor</th><td>Hardware Stand (Edge Sync Daemon)</td></tr>
            <tr><th>Secondary actors</th><td>Central FastAPI Server, PostgreSQL, MinIO S3</td></tr>
            <tr><th>Description</th><td>Edge background daemon detects network availability, batches pending outbox records and associated JPEG crops, transmits them via HTTPS multipart POST, and updates local outbox state on two-phase confirmation.</td></tr>
            <tr><th>Preconditions</th><td>1. Outbox contains records with status = <code>PENDING</code>.<br>2. Central cloud server is reachable over HTTPS.</td></tr>
            <tr><th>Postconditions</th><td>Records are committed in central PostgreSQL; crops stored in MinIO; local outbox status updated to <code>SYNCED</code>.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. Edge sync daemon performs HTTP GET heartbeat probe to <code>/api/v1/health</code>; receives <code>HTTP 200 OK</code>.<br>
              2. Daemon queries local SQLite for up to 50 oldest <code>PENDING</code> records from <code>outbox_events</code>.<br>
              3. Daemon reads corresponding defect JPEG image crops from local disk storage.<br>
              4. Daemon constructs a multipart/form-data payload containing JSON metadata batch and binary JPEG attachments.<br>
              5. Daemon sends HTTPS POST request to <code>/api/v1/sync/batch</code> with edge TLS authentication certificate.<br>
              6. Central FastAPI server receives payload, validates record schemas, and opens PostgreSQL database transaction.<br>
              7. Server uploads image crops to MinIO S3 bucket, inserts relational records into PostgreSQL, and commits transaction.<br>
              8. Central server returns <code>HTTP 200 OK</code> with JSON list of committed record UUIDs.<br>
              9. Edge daemon updates local outbox records to status = <code>SYNCED</code> with timestamp.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              5a. Network connection drops mid-transfer: Request times out; records remain <code>PENDING</code> in SQLite; daemon backs off and retries upon reconnection without data corruption.<br>
              6a. Server detects already-ingested UUID: Server executes idempotent upsert, confirming the record to prevent sync deadlocks.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-SYN-01 to FR-SYN-06, FR-BUF-04</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 29 -Content $p29))

    # ==================== PAGE 30: UC-09 REVIEW & CORRECT DEFECT ====================
    $p30 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-09: Review & Correct Defect Classification</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-09</b></td></tr>
            <tr><th>Name</th><td><b>Review & Correct Defect Classification</b></td></tr>
            <tr><th>Primary actor</th><td>Quality Assurance Inspector</td></tr>
            <tr><th>Secondary actors</th><td>Central Cloud Application, PostgreSQL Database</td></tr>
            <tr><th>Description</th><td>QA inspector logs into the web dashboard to review flagged defect image crops, confirm AI predictions, adjust bounding box extents, or reclassify false positive detections before final grading sign-off.</td></tr>
            <tr><th>Preconditions</th><td>Roll inspection session has concluded and synchronized with the central cloud database.</td></tr>
            <tr><th>Postconditions</th><td>Defect record is updated; original AI prediction is preserved; modification is logged in immutable audit trail.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. Inspector navigates to Roll Defect Review screen on web workstation.<br>
              2. System displays gallery of defect thumbnail crops alongside full-frame context images and AI confidence scores.<br>
              3. Inspector selects a defect with moderate confidence ($0.40 &le; c &le; 0.65$) classified as 'Weft Crack'.<br>
              4. System opens high-resolution inspection modal with zoom and measurement tools.<br>
              5. Inspector determines the anomaly is actually an 'Oil Streak'; selects 'Oil Streak' from reclassification dropdown.<br>
              6. Inspector enters brief rationale: 'Localized lubricant contamination from loom needle bar'.<br>
              7. System updates defect record in PostgreSQL, recalculating defect physical width and penalty points.<br>
              8. System writes an entry to <code>defect_audit_log</code> recording inspector ID, old class, new class, and timestamp.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              5a. Inspector identifies the detection as a false positive (loose lint that blew away): Inspector marks status = <code>DISMISSED_FALSE_POSITIVE</code>; system zeroes its penalty point contribution while retaining image crop for model retraining.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-DSH-03, FR-DSH-06, FR-REP-04</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 30 -Content $p30))

    # ==================== PAGE 31: UC-10 COMPUTE ASTM 4-POINT GRADE ====================
    $p31 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-10: Compute ASTM D5430 4-Point Penalty Grade</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-10</b></td></tr>
            <tr><th>Name</th><td><b>Compute ASTM D5430 4-Point Penalty Grade</b></td></tr>
            <tr><th>Primary actor</th><td>Quality Manager</td></tr>
            <tr><th>Secondary actors</th><td>Central Grading Engine, PostgreSQL Database</td></tr>
            <tr><th>Description</th><td>Executes standardized ASTM D5430-07 4-point penalty calculations over all confirmed defects in a fabric roll, enforces linear meter point capping, evaluates uninspected spans, and assigns the official commercial grade.</td></tr>
            <tr><th>Preconditions</th><td>Roll inspection is complete; all inspector reclassifications are finalized.</td></tr>
            <tr><th>Postconditions</th><td>Roll entity is updated with final penalty points, points per 100 square meters, and commercial grade (Grade A, B, C, or Reject).</td></tr>
            <tr><th>Main success scenario</th><td>
              1. Manager opens Roll Quality Summary screen and triggers 'Finalize Roll Grading'.<br>
              2. Grading engine queries all confirmed defects for the roll, extracting physical lengths $L_{\text{mm}}$ and defect types.<br>
              3. Engine assigns individual penalty points: 1 pt (&le; 75 mm), 2 pts (&gt; 75–150 mm), 3 pts (&gt; 150–230 mm), 4 pts (&gt; 230 mm); holes evaluated per ASTM Section 8.<br>
              4. Engine partitions roll into 1-meter longitudinal bins ($[0–1\text{m}], [1–2\text{m}], \dots, [N–(N+1)\text{m}]$).<br>
              5. For each linear meter, engine sums defect points; if sum exceeds 4 points, it caps the linear meter penalty at exactly 4 points.<br>
              6. Engine sums capped points across all meters and computes normalized score: $\text{Points/100m}^2 = \frac{\text{Total Points} \times 100}{\text{Length} \times \text{Width}}$.<br>
              7. Engine checks for uninspected sections; if any exist, sets grade to <code>REJECT (UNINSPECTED)</code>; otherwise assigns grade based on threshold matrix (A, B, or C).<br>
              8. System updates roll summary record in PostgreSQL and displays grading scorecard on manager dashboard.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              7a. Roll contains critical flaws exceeding client tolerance (e.g., hole &gt; 50 mm): System automatically flags roll as <code>REJECT</code> regardless of point score per 100 square meters.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-GRD-01 to FR-GRD-05, FR-DSH-04</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 31 -Content $p31))

    # ==================== PAGE 32: UC-11 VIEW 2D ROLL DEFECT MAP ====================
    $p32 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-11: View 2D Roll Defect Map & Quality Analytics</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-11</b></td></tr>
            <tr><th>Name</th><td><b>View 2D Roll Defect Map & Quality Analytics</b></td></tr>
            <tr><th>Primary actor</th><td>Plant Quality Manager</td></tr>
            <tr><th>Secondary actors</th><td>Central Cloud Web Application</td></tr>
            <tr><th>Description</th><td>Interactive visualization enabling quality managers to inspect spatial distribution of flaws across the fabric roll width and length, identify recurring mechanical loom defects, and review plant quality trends.</td></tr>
            <tr><th>Preconditions</th><td>User is signed in with Quality Manager or Quality Inspector role.</td></tr>
            <tr><th>Postconditions</th><td>User gains actionable visual insights into loom mechanical health and fabric flaw clustering.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. Manager opens the 2D Roll Defect Map view on the web client.<br>
              2. System renders an HTML5 / WebGL interactive canvas representing the fabric web dimensions (e.g., 100 meters &times; 1.8 meters).<br>
              3. System plots color-coded defect glyphs at exact $(X_{\text{mm}}, Y_{\text{m}})$ coordinates (Red = Holes, Orange = Oil Stains, Blue = Warp Streaks, Purple = Weft Cracks).<br>
              4. System renders uninspected sections as amber hatched hazard zones across the canvas.<br>
              5. Manager uses mouse wheel to zoom into specific longitudinal clusters; canvas dynamically scales millimeter grid lines.<br>
              6. Manager toggles defect class filters (e.g., isolate 'Warp Streaks') to determine whether flaws align along a single lateral $X$ coordinate (indicating a damaged reed dent or loom dropper).<br>
              7. System displays aggregated statistics sidebar: defect density per 10 meters, most frequent defect type, and ASTM point contribution breakdown.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              2a. Roll length exceeds 500 meters: System applies level-of-detail (LOD) aggregation, clustering closely spaced flaws into density glyphs until the user zooms in.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-DSH-01, FR-DSH-02, FR-DSH-05</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 32 -Content $p32))

    # ==================== PAGE 33: UC-12 EXPORT PDF QUALITY CERTIFICATE ====================
    $p33 = @'
          <div style="font-weight: bold; font-size: 9pt; margin-bottom: 1.5mm;">UC-12: Export PDF Quality Certificate & ERP Ingestion</div>
          <table class="formal-table">
            <tr><th style="width: 25%;">Use case ID</th><td style="width: 75%;"><b>UC-12</b></td></tr>
            <tr><th>Name</th><td><b>Export PDF Quality Certificate & ERP Ingestion</b></td></tr>
            <tr><th>Primary actor</th><td>Plant Quality Manager</td></tr>
            <tr><th>Secondary actors</th><td>Central Cloud Application, PostgreSQL, MinIO S3</td></tr>
            <tr><th>Description</th><td>Generates an official, publication-grade PDF Fabric Inspection Certificate with cryptographic verification hash for customer shipment, alongside structured JSON/CSV files for garment cutting-room ERP systems.</td></tr>
            <tr><th>Preconditions</th><td>Roll grading is finalized (status = <code>COMPLETED</code>).</td></tr>
            <tr><th>Postconditions</th><td>PDF document and JSON/CSV files are generated, stored in MinIO, and downloaded to user workstation.</td></tr>
            <tr><th>Main success scenario</th><td>
              1. Manager selects 'Export Quality Certificate' from the roll details screen.<br>
              2. System compiles roll metadata, inspector credentials, ASTM D5430 scorecard, full defect tabular ledger, and 2D defect map thumbnail.<br>
              3. System computes a SHA-256 cryptographic digest over the roll inspection record, embedding the hash and a QR verification code onto the document footer.<br>
              4. System compiles document using headless PDF generation engine, creating a formal multi-page PDF certificate.<br>
              5. System generates companion CSV/JSON files containing metric flaw coordinates $[X, Y, W, L, \text{Class}]$ for downstream CAD marker nesting software.<br>
              6. System saves files in MinIO S3 storage under <code>/certificates/{roll_id}.pdf</code>.<br>
              7. Web browser initiates file download; system logs the export event in PostgreSQL audit trail with manager ID and timestamp.
            </td></tr>
            <tr><th>Alternative & exception flows</th><td>
              2a. Roll contains unresolved uninspected spans: System places prominent 'REJECT / UNINSPECTED SECTION WARNING' watermark across all certificate pages.
            </td></tr>
            <tr><th>Related requirements</th><td>FR-REP-01, FR-REP-02, FR-REP-03, FR-REP-04</td></tr>
          </table>
'@
    $pages.Add((New-Page -PageNumber 33 -Content $p33))

    # ==================== PAGE 34: 3.3 EXTERNAL INTERFACE REQUIREMENTS ====================
    $p34 = @'
          <h2 class="sec-heading">3.3 External Interface Requirements</h2>
          <h3 class="subsec-heading">3.3.1 User Interfaces</h3>
          <p>
            TexEye AI delivers two purpose-built graphical interfaces: an ergonomic Flutter mobile application optimized for high-contrast shop-floor operation, and a comprehensive React web dashboard for desktop workstations.
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.13: Screens of the TexEye AI web and mobile clients</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Screen ID</th>
                <th style="width: 20%;">Target Client</th>
                <th style="width: 22%;">Target Users</th>
                <th style="width: 44%;">Purpose and Main User Interface Elements</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>S-01</b></td>
                <td>Mobile App</td>
                <td>Floor Operator</td>
                <td><b>QR Roll Scanner:</b> Camera viewfinder for scanning roll QR tags, displays extracted Batch ID, Article, GSM, and 'Start Inspection' button.</td>
              </tr>
              <tr>
                <td><b>S-02</b></td>
                <td>Mobile App</td>
                <td>Floor Operator</td>
                <td><b>Live Floor Monitor:</b> Real-time video preview, speed gauge (m/s), cumulative length counter, recent defect thumbnail, and pause/stop controls.</td>
              </tr>
              <tr>
                <td><b>S-03</b></td>
                <td>Mobile App</td>
                <td>Floor Operator</td>
                <td><b>Alarm Acknowledge Modal:</b> High-contrast full-screen red warning dialog with vibration pulse, defect dimensions, and 'Acknowledge' button.</td>
              </tr>
              <tr>
                <td><b>S-04</b></td>
                <td>Mobile App</td>
                <td>Floor Operator</td>
                <td><b>Manual Flaw Tag Sheet:</b> Bottom modal sheet with single-tap buttons for manual defects (Shade variation, Selvage curl, Foreign yarn).</td>
              </tr>
              <tr>
                <td><b>S-05</b></td>
                <td>Web Dashboard</td>
                <td>All Roles</td>
                <td><b>Sign In & MFA:</b> Username and password form with JWT token issuance and role-based redirect.</td>
              </tr>
              <tr>
                <td><b>S-06</b></td>
                <td>Web Dashboard</td>
                <td>Inspector, Manager</td>
                <td><b>Rolls Overview Table:</b> Filterable list of all inspected rolls, showing Batch ID, date, length, total points, grade badge, and sync status.</td>
              </tr>
              <tr>
                <td><b>S-07</b></td>
                <td>Web Dashboard</td>
                <td>Inspector, Manager</td>
                <td><b>Interactive 2D Defect Map:</b> Canvas rendering full fabric roll web, color-coded defect glyphs, uninspected hazard spans, zoom/pan controls.</td>
              </tr>
              <tr>
                <td><b>S-08</b></td>
                <td>Web Dashboard</td>
                <td>Quality Inspector</td>
                <td><b>Defect Review Gallery:</b> High-resolution crop viewer with zoom, measurement calipers, AI confidence bar, and reclassification selector.</td>
              </tr>
              <tr>
                <td><b>S-09</b></td>
                <td>Web Dashboard</td>
                <td>Quality Manager</td>
                <td><b>ASTM 4-Point Scorecard:</b> Points breakdown by flaw length, 1-meter capping chart, normalized points/100m&sup2;, and Grade assignment widget.</td>
              </tr>
              <tr>
                <td><b>S-10</b></td>
                <td>Web Dashboard</td>
                <td>Manager, Admin</td>
                <td><b>Certificate & Export Hub:</b> PDF certificate preview with download button, ERP JSON/CSV export, and SHA-256 verification hash display.</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 34 -Content $p34))

    # ==================== PAGE 35: 3.3.2 HARDWARE INTERFACES & FIGURE 4.1 ====================
    $p35 = @'
          <h3 class="subsec-heading">3.3.2 Hardware Interfaces</h3>
          <p>
            The physical stand integrates four primary industrial hardware components communicating with the edge computing unit as illustrated in Figure 4.1:
          </p>
          <ul>
            <li><b>Area-Scan Industrial Camera:</b> Connects via high-speed USB 3.0 / GigE interface using industrial locking connectors. Ingests raw frames into a zero-copy Linux V4L2 ring buffer.</li>
            <li><b>Rotary Optical Encoder:</b> Mechanically coupled to the 100 mm drive roller (1024 PPR). Transmits 24V differential quadrature pulse signals, stepped down to 3.3V TTL via opto-coupler, directly triggering hardware GPIO interrupts on the edge unit.</li>
            <li><b>Regulated High-CRI LED Lighting Rig:</b> Powered by a 24V constant-current DIN-rail power supply, delivering flicker-free 5500K daylight illumination across the inspection zone.</li>
            <li><b>Opto-Isolated Alarm Relay:</b> 4-channel 5V/24V relay board driven by edge GPIO logic levels, actuating the physical red/amber/green stack light tower and 90 dB floor buzzer.</li>
          </ul>
          <div class="diagram-container" style="margin-top: 2mm;">
            <img class="diagram-img" src="../diagrams/svg/04_hardware_architecture.svg" alt="Hardware Architecture Diagram" style="max-height: 145mm;" />
            <div class="caption">Figure 4.1: Hardware Architecture and Physical Interconnect Diagram</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 35 -Content $p35))

    # ==================== PAGE 36: 3.3.3 SOFTWARE & 3.3.4 COMMUNICATIONS INTERFACES ====================
    $p36 = @'
          <h3 class="subsec-heading">3.3.3 Software Interfaces</h3>
          <p>
            TexEye AI interfaces with underlying operating systems, runtimes, database engines, and third-party libraries as detailed in Table 3.14.
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.14: Software interfaces</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 25%;">Component</th>
                <th style="width: 75%;">Purpose and Data Exchanged</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Linux Kernel V4L2 / GenICam</b></td>
                <td>Zero-copy camera frame buffer ingestion; camera exposure and gain register configuration via standard ioctl calls.</td>
              </tr>
              <tr>
                <td><b>Linux GPIO Subsystem (gpiod)</b></td>
                <td>Kernel-level edge hardware interrupt handling on quadrature pulse pins for high-speed displacement tracking.</td>
              </tr>
              <tr>
                <td><b>NVIDIA TensorRT 8.6+ / CUDA 12</b></td>
                <td>Execution of optimized FP16 YOLO engine; binds GPU memory buffers for batch inference and coordinate tensor output.</td>
              </tr>
              <tr>
                <td><b>SQLite 3.40+ (WAL Mode)</b></td>
                <td>Local edge ACID storage; stores session headers, outbox queue events, and defect entities with sub-5ms commit latency.</td>
              </tr>
              <tr>
                <td><b>FastAPI (Python 3.11+)</b></td>
                <td>Central enterprise application server; exposes authenticated REST endpoints and WebSocket servers.</td>
              </tr>
              <tr>
                <td><b>PostgreSQL 15+ & SQLAlchemy</b></td>
                <td>Relational enterprise persistence for multi-stand roll histories, defect coordinates, user accounts, and immutable audit logs.</td>
              </tr>
              <tr>
                <td><b>MinIO S3 Object Storage</b></td>
                <td>Stores binary high-resolution defect JPEG crops and generated PDF inspection certificates with authenticated pre-signed URLs.</td>
              </tr>
              <tr>
                <td><b>Redis 7</b></td>
                <td>In-memory pub/sub broker for real-time WebSocket alert broadcasting to floor mobile clients and web dashboards.</td>
              </tr>
            </tbody>
          </table>
          <h3 class="subsec-heading">3.3.4 Communications Interfaces</h3>
          <p>
            Communications between distributed subsystems utilize industry-standard protocols:
          </p>
          <ul>
            <li><b>Physical GPIO / TTL:</b> Hardware interrupt signals for encoder pulses (up to 50 kHz) and digital logic lines for relay triggering.</li>
            <li><b>Local Edge REST API (HTTP/1.1):</b> Lightweight local JSON communication between mobile floor app and edge daemon over shop-floor Wi-Fi (<code>http://192.168.1.XX:8000</code>).</li>
            <li><b>Central Enterprise API (HTTPS / TLS 1.3):</b> Secure batch synchronization and web dashboard communication encrypted with modern TLS certificates.</li>
            <li><b>WebSocket Protocol (WSS):</b> Full-duplex persistent connection for streaming real-time defect notifications and alarm events (&lt; 50 ms latency).</li>
          </ul>
'@
    $pages.Add((New-Page -PageNumber 36 -Content $p36))

    return $pages
}

Write-Output "Pages 21 to 36 module loaded."


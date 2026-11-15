# Part 2: Pages 11 to 20
function Get-Pages-11-to-20 {
    $pages = [System.Collections.Generic.List[string]]::new()

    # ==================== PAGE 11: FUNCTIONALITY (CONT) & USER CLASSES ====================
    $p11 = @'
          <ul>
            <li><b>Real-Time Defect Detection:</b> YOLO deep convolutional inference evaluates each captured frame, outputting bounding box coordinates, defect class ID, and confidence score within 25 ms.</li>
            <li><b>Physical Coordinate Metrology:</b> The system transforms image bounding box pixels into real-world coordinates: lateral position $X$ (0 to web width in mm) and longitudinal position $Y$ (continuous linear meters based on encoder pulses).</li>
            <li><b>Flaw Deduplication & Tracking:</b> A multi-frame Kalman Filter associates detections across consecutive frames to track continuous defects (e.g., warp streaks) and prevent redundant counts.</li>
            <li><b>Automatic Alarm Actuation:</b> When severe defects (holes &gt; 50 mm, dense defect clusters) are detected, the edge unit drives an opto-isolated relay triggering a 24V DC red stack light and buzzer.</li>
            <li><b>Inspection Invariant Guard:</b> If illumination drops below 800 lux, frame rate falls below 25 FPS, or image blur exceeds tolerance, the system marks the segment as <code>UNINSPECTED_SECTION</code>.</li>
            <li><b>Offline Outbox Persistence:</b> Inspection events and defect records are committed locally to SQLite WAL tables, buffering up to 500,000 frames during network outages.</li>
            <li><b>Cloud Batch Synchronization:</b> A background sync daemon queries unsynced records, packs them into multipart HTTPS payloads with JPEG crops, and pushes them to the central FastAPI server.</li>
            <li><b>ASTM D5430-07 Grading:</b> The central engine evaluates defect lengths and orientations, computes penalty points per 100 square meters, and assigns official roll grades (A, B, C, Reject).</li>
            <li><b>Dual-Client Interaction:</b> Floor operators receive vibration alerts on mobile devices; quality managers inspect interactive 2D defect roll maps, adjust labels, and export signed PDF certificates.</li>
          </ul>
          <h2 class="sec-heading">2.4 Users and Characteristics</h2>
          <p>
            TexEye AI accommodates four human user classes with differing technical expertise and operational duties on the textile mill floor, alongside one external hardware sensing subsystem.
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 2.2: User classes and their characteristics</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 20%;">User class</th>
                <th style="width: 35%;">Description and functions used</th>
                <th style="width: 20%;">Expertise and frequency</th>
                <th style="width: 15%;">Privileges</th>
                <th style="width: 10%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Floor Operator</b></td>
                <td>Operates rolling stand, scans roll QR codes, starts/stops inspection runs, receives real-time defect vibration alerts, acknowledges stack light alarms, and tags manual defects.</td>
                <td>Basic smartphone literacy; minimal computer training. Continuous daily use during production shifts.</td>
                <td>Mobile app floor operations; own stand session only.</td>
                <td>Primary</td>
              </tr>
              <tr>
                <td><b>Quality Inspector</b></td>
                <td>Reviews flagged defect image crops, validates or corrects AI classification labels, reviews uninspected section alarms, and signs off on preliminary roll defect logs.</td>
                <td>High domain textile fabric knowledge; comfortable with web browser tools. Daily shift reviews.</td>
                <td>Defect annotation and verification across assigned rolls.</td>
                <td>Primary</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 11 -Content $p11))

    # ==================== PAGE 12: USER CLASSES (CONT) & OPERATING ENVIRONMENT ====================
    $p12 = @'
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 20%;">User class</th>
                <th style="width: 35%;">Description and functions used</th>
                <th style="width: 20%;">Expertise and frequency</th>
                <th style="width: 15%;">Privileges</th>
                <th style="width: 10%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Plant Quality Manager</b></td>
                <td>Monitors plant-wide quality KPIs, reviews ASTM 4-point penalty distributions, configures grading thresholds per client contract, and exports official PDF inspection certificates.</td>
                <td>Advanced textile quality management; expert in ASTM/ISO standards. Daily and weekly executive reviews.</td>
                <td>Full managerial access; grading threshold configuration; PDF sign-off.</td>
                <td>Primary</td>
              </tr>
              <tr>
                <td><b>System Admin / Engineer</b></td>
                <td>Manages user credentials, configures hardware GPIO pins, performs camera metric calibration ($mm/pixel$), monitors edge heartbeat health, and manages database backups.</td>
                <td>High technical engineering expertise (Linux, networking, computer vision). Weekly maintenance.</td>
                <td>Superuser / administrative access to edge rigs and cloud backend.</td>
                <td>Secondary</td>
              </tr>
              <tr>
                <td><b>Hardware Stand (System Actor)</b></td>
                <td>Autonomous physical sensor array (camera, encoder, lighting rig, relay). Streams frames, sends hardware interrupts, and receives actuator commands.</td>
                <td>Deterministic embedded electronics; continuous autonomous operation during roll motion.</td>
                <td>Direct GPIO and hardware driver bus access.</td>
                <td>Supporting</td>
              </tr>
            </tbody>
          </table>
          <h2 class="sec-heading">2.5 Operating Environment</h2>
          <p>
            The execution platform for TexEye AI spans the physical mill stand, local edge computer, and enterprise server as detailed in Table 2.3.
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 2.3: Operating environment and minimum platform</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 25%;">Component</th>
                <th style="width: 75%;">Requirement specification</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Physical Stand Environment</b></td>
                <td>Extruded aluminum gantry mounted over standard motorized fabric winding table. Operating temperature: 10&deg;C to 45&deg;C, relative humidity &le; 85% non-condensing (typical Punjab mill ambient conditions). Vibration damping pads at gantry base.</td>
              </tr>
              <tr>
                <td><b>Optical Ingestion Rig</b></td>
                <td>Industrial CMOS area-scan camera (1080p / 1920&times;1080 @ 30–60 FPS, global or high-speed electronic rolling shutter), USB 3.0 / GigE interface. High-CRI (&ge; 90) regulated DC LED array (5500K daylight balance, 1200 lux surface illumination).</td>
              </tr>
              <tr>
                <td><b>Displacement Metrology</b></td>
                <td>Incremental optical rotary encoder (1024 pulses/revolution) mechanically coupled to fabric drive roller (&empty; = 100 mm, resolution &approx; 0.307 mm/pulse). Dual-channel quadrature outputs connected to edge hardware GPIO interrupt pins.</td>
              </tr>
              <tr>
                <td><b>Edge Computing Unit</b></td>
                <td>NVIDIA Jetson Orin Nano (8 GB) or Industrial x86 PC (Intel Core i5 11th Gen, 16 GB RAM, NVIDIA RTX 3050/A2000). OS: Ubuntu 22.04 LTS (x86_64 or aarch64). TensorRT 8.6+, OpenCV 4.8+, CUDA 12.0+.</td>
              </tr>
              <tr>
                <td><b>Alarm Actuator Relay</b></td>
                <td>Opto-isolated 4-channel 5V/24V DC relay board. Channel 1: Red Stack Light + 90 dB Buzzer; Channel 2: Yellow Warning Light; Channel 3: Machine Slowdown / Pause Interlock.</td>
              </tr>
              <tr>
                <td><b>Central Server & Database</b></td>
                <td>Linux Server (Ubuntu 22.04 LTS), 8 CPU cores, 16 GB RAM, 500 GB NVMe SSD. Python 3.11+, FastAPI, PostgreSQL 15+ (relational data), MinIO / AWS S3 (image crops), Redis 7 (caching & WebSocket pub/sub).</td>
              </tr>
              <tr>
                <td><b>Client Workstations</b></td>
                <td>Web: Chrome, Edge, Firefox on 1080p+ displays. Mobile: Android 10+ / iOS 15+ smartphone or ruggedized industrial tablet with camera (for QR scanner) and vibration motor.</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 12 -Content $p12))

    # ==================== PAGE 13: CHAPTER 3 SPECIFIC REQUIREMENTS & FR-ING ====================
    $p13 = @'
          <div class="chapter-bar">3 Specific Requirements</div>
          <h2 class="sec-heading">3.1 Functional Requirements</h2>
          <p>
            Functional requirements are classified into ten core engineering subsystems. Each requirement is assigned a unique tracking identifier, an architectural description, and a development priority: <b>High</b> (mission-critical for core inspection and safety invariants) or <b>Medium</b> (operational enhancements for reporting and ergonomics).
          </p>
          <h3 class="subsec-heading">3.1.1 Optical Ingestion & Synchronization (FR-ING)</h3>
          <p>
            <i>Module: Hardware Interfacing & Edge Ingestion Subsystem (Muhammad Bilal Butt).</i>
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.1: Optical Ingestion & Synchronization requirements (FR-ING)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Requirement ID</th>
                <th style="width: 20%;">Requirement Name</th>
                <th style="width: 54%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FR-ING-01</b></td>
                <td>Continuous Frame Stream</td>
                <td>The system shall ingest optical video frames from the industrial area-scan camera via V4L2 / GenICam API at a minimum steady rate of 30 frames per second at 1920&times;1080 resolution.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-ING-02</b></td>
                <td>Hardware GPIO Counter</td>
                <td>The system shall bind a kernel-level hardware interrupt service routine (ISR) to the GPIO quadrature pins to count pulses from the rotary optical encoder without missing pulses up to 50 kHz.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-ING-03</b></td>
                <td>Encoder-Locked Frame Gate</td>
                <td>The system shall trigger frame analysis only when the rotary encoder indicates a linear fabric displacement equal to the calibrated optical frame advance distance ($Y_{\text{step}} = H_{\text{FOV}} \times (1 - \text{Overlap})$), guaranteeing uniform longitudinal sampling.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-ING-04</b></td>
                <td>Distortion Correction</td>
                <td>The system shall apply pre-computed camera intrinsic matrix parameters to rectify wide-angle lens radial and tangential barrel distortion prior to AI inference.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-ING-05</b></td>
                <td>Variable Speed Adaptation</td>
                <td>The system shall maintain constant physical inspection resolution across line velocity fluctuations between 0.05 m/s and 0.50 m/s by dynamically modulating the frame analysis trigger interval according to encoder pulse frequency.</td>
                <td>High</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 13 -Content $p13))

    # ==================== PAGE 14: FR-INF & FR-REL ====================
    $p14 = @'
          <h3 class="subsec-heading">3.1.2 Real-Time AI Inference & Metrology (FR-INF)</h3>
          <p>
            <i>Module: Deep Learning Vision & Metrology Subsystem (Muhammad Bilal Butt).</i>
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.2: Real-Time AI Inference & Metrology requirements (FR-INF)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Requirement ID</th>
                <th style="width: 20%;">Requirement Name</th>
                <th style="width: 54%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FR-INF-01</b></td>
                <td>TensorRT Inference Engine</td>
                <td>The system shall execute a fine-tuned YOLO single-stage convolutional model converted to TensorRT FP16 engine format with an end-to-end inference latency &le; 25 ms per frame.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-INF-02</b></td>
                <td>Multi-Class Defect Detection</td>
                <td>The AI model shall detect and classify six core fabric defect classes: <i>Hole, Oil Stain, Warp Streak, Weft Crack, Float, and Stitching Tear</i> with an overall $mAP@0.5 \ge 88\%$.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-INF-03</b></td>
                <td>Bounding Box Pixel Extraction</td>
                <td>The model shall output normalized pixel coordinates $[u_{\text{min}}, v_{\text{min}}, u_{\text{max}}, v_{\text{max}}]$ and a softmax confidence score $[0.0, 1.0]$ for each detected anomaly.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-INF-04</b></td>
                <td>Metric Width Calibration</td>
                <td>The system shall map lateral pixel span $(u_{\text{max}} - u_{\text{min}})$ into physical millimeters ($W_{\text{mm}}$) using a calibrated physical scale factor ($k_x \text{ mm/pixel}$).</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-INF-05</b></td>
                <td>Longitudinal Displacement</td>
                <td>The system shall calculate the absolute longitudinal position $Y_{\text{meters}}$ of each defect by multiplying cumulative encoder pulse counts by the calibrated distance-per-pulse constant ($C_p$).</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-INF-06</b></td>
                <td>High-Resolution Defect Crop</td>
                <td>For each confirmed defect, the system shall extract a bounding-box image crop with a 20% margin, compress it as a high-quality JPEG (&le; 100 KB), and cache it with its UUID.</td>
                <td>High</td>
              </tr>
            </tbody>
          </table>
          <h3 class="subsec-heading">3.1.3 Inspection Reliability Invariant (FR-REL)</h3>
          <p>
            <i>Module: Reliability Guard & Physical Fail-Safe Subsystem (Muhammad Bilal Butt).</i>
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.3: Inspection Reliability Invariant requirements (FR-REL)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Requirement ID</th>
                <th style="width: 20%;">Requirement Name</th>
                <th style="width: 54%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FR-REL-01</b></td>
                <td>Frame Delivery Heartbeat</td>
                <td>The system shall continuously track camera ingestion interval; if no frame is delivered within 100 ms during active roll motion, a <code>CAMERA_DROP</code> fault shall be triggered.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-REL-02</b></td>
                <td>Illumination Lux Monitor</td>
                <td>The system shall compute average frame brightness; if mean luminance falls below 800 lux or exceeds 2500 lux (indicating LED failure or ambient glare), a <code>LIGHTING_FAULT</code> shall be raised.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-REL-03</b></td>
                <td>Sharpness / Blur Detection</td>
                <td>The system shall compute the variance of the Laplacian over each captured frame; if the variance falls below threshold $\tau_{\text{blur}} = 100$, an <code>IMAGE_BLUR</code> condition shall be flagged.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-REL-04</b></td>
                <td>Uninspected Section Guard</td>
                <td>Whenever any reliability fault is active, the system shall suspend defect classification and record the longitudinal span $[Y_{\text{start}}, Y_{\text{end}}]$ as an <code>UNINSPECTED_SECTION</code>, forbidding clean roll certification.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-REL-05</b></td>
                <td>Relay Alarm Actuation</td>
                <td>On uninspected fault or severe defect detection, the system shall actuate the 24V DC opto-isolated relay to illuminate the red stack light and sound the audible floor buzzer within 50 ms.</td>
                <td>High</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 14 -Content $p14))

    # ==================== PAGE 15: FR-TRK & FR-GRD ====================
    $p15 = @'
          <h3 class="subsec-heading">3.1.4 Multi-Frame Tracking & Deduplication (FR-TRK)</h3>
          <p>
            <i>Module: Tracking & Temporal Metrology Subsystem (Muhammad Bilal Butt).</i>
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.4: Multi-Frame Tracking & Deduplication requirements (FR-TRK)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Requirement ID</th>
                <th style="width: 20%;">Requirement Name</th>
                <th style="width: 54%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FR-TRK-01</b></td>
                <td>Kalman Filter Association</td>
                <td>The system shall track detected bounding boxes across successive overlapping frames using a 2D Kalman Filter with state vector $[x, y, a, h, \dot{x}, \dot{y}, \dot{a}, \dot{h}]$, associating tracks via Hungarian IoU matching.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-TRK-02</b></td>
                <td>Continuous Flaw Merging</td>
                <td>For defects that extend across multiple frames (e.g., longitudinal warp streaks or long oil lines), the tracker shall merge detections into a single continuous defect record with cumulative length $L_{\text{total}}$.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-TRK-03</b></td>
                <td>Track Confirmation Gate</td>
                <td>An anomaly must be detected in at least 3 consecutive frames ($\ge 3$ hits) before being committed as a confirmed defect, effectively suppressing transient optical dust or yarn lint noise.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-TRK-04</b></td>
                <td>Track Expiration & Commit</td>
                <td>When a tracked flaw moves beyond the bottom optical boundary ($v &gt; H_{\text{FOV}}$) for more than 5 frames, its track shall be closed and its finalized physical dimensions committed to local storage.</td>
                <td>High</td>
              </tr>
            </tbody>
          </table>
          <h3 class="subsec-heading">3.1.5 ASTM D5430-07 4-Point Grading (FR-GRD)</h3>
          <p>
            <i>Module: ASTM Grading & Quality Metrics Subsystem (Muhammad Afnan Khan).</i>
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.5: ASTM D5430 4-Point Grading requirements (FR-GRD)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Requirement ID</th>
                <th style="width: 20%;">Requirement Name</th>
                <th style="width: 54%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FR-GRD-01</b></td>
                <td>Defect Length Categorization</td>
                <td>The system shall assign penalty points based on defect maximum dimension: 1 point for length &le; 75 mm (3 inches); 2 points for &gt; 75 mm to 150 mm (6 in); 3 points for &gt; 150 mm to 230 mm (9 in); 4 points for &gt; 230 mm (9 in).</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-GRD-02</b></td>
                <td>Hole Penalty Rule</td>
                <td>Any fabric hole or tear shall be penalized according to size: 2 points for opening &le; 25 mm (1 inch); 4 points for opening &gt; 25 mm (1 inch), in strict compliance with ASTM D5430 Section 8.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-GRD-03</b></td>
                <td>Maximum Linear Meter Cap</td>
                <td>No single linear meter of fabric shall be penalized more than 4 points, regardless of the number or size of individual defects detected within that meter.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-GRD-04</b></td>
                <td>Points per 100 m&sup2; Formula</td>
                <td>The system shall compute total points per 100 square meters using formula: $\text{Points/100m}^2 = \frac{\text{Total Penalty Points} \times 100}{\text{Total Roll Length (m)} \times \text{Fabric Width (m)}}$.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-GRD-05</b></td>
                <td>Commercial Roll Grade</td>
                <td>The system shall assign final quality classification: Grade A (&le; 20 points/100m&sup2;), Grade B (21–28 points/100m&sup2;), Grade C (29–40 points/100m&sup2;), or Reject (&gt; 40 points/100m&sup2; or contains uninspected spans).</td>
                <td>High</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 15 -Content $p15))

    # ==================== PAGE 16: FR-BUF & FR-SYN ====================
    $p16 = @'
          <h3 class="subsec-heading">3.1.6 Offline Local Buffering & Transactional Outbox (FR-BUF)</h3>
          <p>
            <i>Module: Local Outbox & SQLite Storage Subsystem (Muhammad Afnan Khan).</i>
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.6: Offline Local Buffering requirements (FR-BUF)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Requirement ID</th>
                <th style="width: 20%;">Requirement Name</th>
                <th style="width: 54%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FR-BUF-01</b></td>
                <td>Transactional SQLite WAL</td>
                <td>The edge unit shall store inspection session headers, frame metrics, and defect records in a local SQLite database configured with <code>journal_mode = WAL</code> and <code>synchronous = NORMAL</code>.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-BUF-02</b></td>
                <td>Transactional Outbox Pattern</td>
                <td>Every defect record and uninspected span shall be atomically inserted into an <code>outbox_events</code> table within the same database transaction, ensuring zero data loss on abrupt power cuts.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-BUF-03</b></td>
                <td>Local Disk Ring Buffer</td>
                <td>JPEG defect image crops shall be stored in an organized local directory structure (<code>/data/crops/{roll_id}/</code>); a ring-buffer disk monitor shall verify &ge; 5 GB free disk space prior to each run.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-BUF-04</b></td>
                <td>Network State Detection</td>
                <td>An edge background daemon shall probe the central cloud server endpoint (<code>GET /api/v1/health</code>) every 5 seconds to determine live network connectivity status.</td>
                <td>Medium</td>
              </tr>
              <tr>
                <td><b>FR-BUF-05</b></td>
                <td>Crash Recovery Replay</td>
                <td>On unexpected system reboot or power restoration, the edge daemon shall inspect SQLite WAL recovery logs, finalize any unclosed roll sessions, and resume the outbox sync dispatcher.</td>
                <td>High</td>
              </tr>
            </tbody>
          </table>
          <h3 class="subsec-heading">3.1.7 Cloud Synchronization & Ingestion API (FR-SYN)</h3>
          <p>
            <i>Module: Cloud Backend & Sync Protocol Subsystem (Muhammad Afnan Khan).</i>
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.7: Cloud Synchronization & Ingestion API requirements (FR-SYN)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Requirement ID</th>
                <th style="width: 20%;">Requirement Name</th>
                <th style="width: 54%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FR-SYN-01</b></td>
                <td>Batch Transmission Dispatcher</td>
                <td>When cloud connectivity is active, the edge daemon shall query up to 50 pending outbox records and transmit them in a single compressed HTTPS multipart POST request to <code>/api/v1/sync/batch</code>.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-SYN-02</b></td>
                <td>Idempotent Cloud Ingestion</td>
                <td>The central FastAPI ingestion service shall enforce idempotency using unique UUIDs for all defect and session records, safely ignoring duplicate batch resends.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-SYN-03</b></td>
                <td>PostgreSQL Central Storage</td>
                <td>All synchronized roll headers, defect records, and grading summaries shall be persisted into a central relational PostgreSQL 15 database with full ACID compliance.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-SYN-04</b></td>
                <td>Object Storage Image Upload</td>
                <td>The central server shall ingest multipart binary JPEG payloads and store them in MinIO (S3-compatible) object storage with access paths indexed in PostgreSQL.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-SYN-05</b></td>
                <td>Two-Phase Acknowledgment</td>
                <td>The edge daemon shall mark local outbox records as <code>SYNCED</code> only after receiving an explicit <code>HTTP 200 OK</code> confirmation containing the committed record UUIDs from the central server.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-SYN-06</b></td>
                <td>Local Cache Garbage Collection</td>
                <td>Defect JPEG image crops confirmed as synced by the central server shall be eligible for local deletion after 48 hours to conserve edge SSD storage space.</td>
                <td>Medium</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 16 -Content $p16))

    # ==================== PAGE 17: FR-MOB & FR-DSH ====================
    $p17 = @'
          <h3 class="subsec-heading">3.1.8 Floor Operator Mobile Application (FR-MOB)</h3>
          <p>
            <i>Module: Mobile Client & Alerting Subsystem (Muhammad Afnan Khan).</i>
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.8: Floor Operator Mobile Application requirements (FR-MOB)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Requirement ID</th>
                <th style="width: 20%;">Requirement Name</th>
                <th style="width: 54%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FR-MOB-01</b></td>
                <td>QR Code Roll Registration</td>
                <td>The mobile app shall scan physical QR codes attached to fabric rolls using the mobile camera to extract Roll ID, Fabric Article, Target Length, and GSM, initiating a new inspection run.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-MOB-02</b></td>
                <td>Real-Time Haptic / Sound Alert</td>
                <td>The app shall deliver immediate vibration pulses and audible alarm tones upon receiving a high-severity defect notification from the edge WebSocket server (&lt; 200 ms latency).</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-MOB-03</b></td>
                <td>Defect Crop Preview</td>
                <td>The app shall display the cropped image of the most recently detected flaw along with its physical position ($X_{\text{mm}}, Y_{\text{m}}$) and predicted defect class.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-MOB-04</b></td>
                <td>Manual Defect Tagging</td>
                <td>The operator shall be able to tap a single 'Tag Manual Defect' button to flag an anomaly observed visually that may have occurred outside the camera's field of view.</td>
                <td>Medium</td>
              </tr>
              <tr>
                <td><b>FR-MOB-05</b></td>
                <td>Session Control Actions</td>
                <td>The operator shall be able to pause, resume, and terminate the current roll inspection session directly from the mobile interface.</td>
                <td>High</td>
              </tr>
            </tbody>
          </table>
          <h3 class="subsec-heading">3.1.9 Quality Management Web Dashboard (FR-DSH)</h3>
          <p>
            <i>Module: Web Dashboard & Analytics Subsystem (Muhammad Afnan Khan).</i>
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.9: Quality Management Web Dashboard requirements (FR-DSH)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Requirement ID</th>
                <th style="width: 20%;">Requirement Name</th>
                <th style="width: 54%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FR-DSH-01</b></td>
                <td>Interactive 2D Roll Defect Map</td>
                <td>The web client shall render an interactive 2D canvas representing the full fabric roll length and width, plotting every defect at its exact metric coordinates $(X_{\text{mm}}, Y_{\text{m}})$.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-DSH-02</b></td>
                <td>Uninspected Span Visualization</td>
                <td>Any uninspected longitudinal sections shall be rendered as shaded amber hazard zones on the 2D roll map, with tooltips detailing the trigger cause (e.g., lighting drop, camera drop).</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-DSH-03</b></td>
                <td>Defect Inspector & Relabeling</td>
                <td>Clicking a defect marker shall open a modal display with the high-resolution crop, full-frame context, AI confidence score, and controls allowing authorized inspectors to modify the defect class.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-DSH-04</b></td>
                <td>ASTM 4-Point Summary Widget</td>
                <td>The dashboard shall display live calculated total penalty points, points per 100 square meters, points per linear meter distribution chart, and the assigned commercial Roll Grade.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-DSH-05</b></td>
                <td>Plant-Wide Quality Heatmap</td>
                <td>The manager view shall aggregate defect frequencies across multiple looms, shifts, and fabric constructions, identifying recurrent loom mechanical defects (e.g., repeating warp streaks).</td>
                <td>Medium</td>
              </tr>
              <tr>
                <td><b>FR-DSH-06</b></td>
                <td>Role-Based Access Control (RBAC)</td>
                <td>The web UI shall restrict administrative actions (threshold editing, user provisioning, grade override) to authorized Quality Managers via JWT claims.</td>
                <td>High</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 17 -Content $p17))

    # ==================== PAGE 18: FR-REP & 3.2 BEHAVIOUR REQUIREMENTS ====================
    $p18 = @'
          <h3 class="subsec-heading">3.1.10 Reporting, Export & Audit Trail (FR-REP)</h3>
          <p>
            <i>Module: Reporting & Audit Trail Subsystem (Muhammad Afnan Khan).</i>
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 3.10: Reporting, Export & Audit Trail requirements (FR-REP)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Requirement ID</th>
                <th style="width: 20%;">Requirement Name</th>
                <th style="width: 54%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FR-REP-01</b></td>
                <td>Official PDF Certificate Export</td>
                <td>The system shall generate a publication-grade PDF Fabric Quality Certificate containing roll metadata, ASTM D5430 point breakdown, 2D defect map thumbnail, and cryptographic verification hash.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-REP-02</b></td>
                <td>ERP Data Ingestion Export</td>
                <td>The system shall export structured JSON and CSV roll inspection logs formatted for direct ingestion into textile ERP cutting-room software (containing full spatial flaw coordinates).</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-REP-03</b></td>
                <td>Cryptographic Hash Verification</td>
                <td>Every finalized inspection certificate shall compute a SHA-256 hash over roll ID, defect records, and final grade, preventing post-inspection tampering.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-REP-04</b></td>
                <td>Immutable Audit Log</td>
                <td>The system shall record an immutable log entry in PostgreSQL whenever an inspector overrides an AI defect label, changes a roll grade, or exports a certificate, logging user ID and timestamp.</td>
                <td>High</td>
              </tr>
              <tr>
                <td><b>FR-REP-05</b></td>
                <td>Batch Archival Storage</td>
                <td>Completed roll records older than 90 days shall be marked for cold archival storage, maintaining queryable metadata while moving bulk image crops to compressed archives.</td>
                <td>Medium</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 18 -Content $p18))

    # ==================== PAGE 19: 3.2 BEHAVIOUR REQUIREMENTS ====================
    $p19 = @'
          <h2 class="sec-heading">3.2 Behaviour Requirements</h2>
          <p>
            This section defines the operational behaviour of TexEye AI in response to human actors and physical hardware events. System behaviour is formalized through an overall Use Case Diagram, actor specifications, a comprehensive use case summary, and fully dressed use case specifications conforming to the Cockburn methodology.
          </p>
          <h3 class="subsec-heading">3.2.1 Use Case Diagram for TexEye AI</h3>
          <p>
            Figure 3.1 depicts the complete use case model for TexEye AI. The primary human actors are positioned on the left and top flanks:
          </p>
          <ul>
            <li><b>Floor Operator:</b> Interacts directly with the physical stand and mobile terminal, responsible for initiating sessions (UC-01), monitoring the optical feed (UC-02), receiving vibration alerts (UC-04), acknowledging alarms, and tagging manual anomalies (UC-06).</li>
            <li><b>Quality Assurance Inspector:</b> Interacts with the web workstation to review defect crops (UC-09), validate or correct classifications, and verify uninspected sections.</li>
            <li><b>Plant Quality Manager:</b> Analyzes ASTM D5430 roll grades (UC-10), investigates 2D defect maps (UC-11), configures grading thresholds, and authorizes PDF certificate exports (UC-12).</li>
            <li><b>System Administrator:</b> Manages system calibration parameters, user roles, and edge hardware health diagnostics.</li>
            <li><b>Hardware Sensing Subsystem (Secondary System Actor):</b> Streams video frames, fires rotary encoder interrupts (UC-01, UC-03), triggers opto-isolated relay stack lights (UC-04), and executes offline outbox sync (UC-07, UC-08).</li>
          </ul>
          <p>
            Key UML relationships in Figure 3.1 include:
          </p>
          <ul>
            <li><code>&laquo;include&raquo;</code> relationships: <i>Start Inspection Session</i> always includes <i>Scan Roll QR Code</i>; <i>Detect Fabric Defects</i> always includes <i>Read Encoder Pulses</i> and <i>Calculate Metric Coordinates</i>; <i>Compute ASTM 4-Point Grade</i> always includes <i>Categorize Defect Length</i> and <i>Cap Linear Meter Points</i>.</li>
            <li><code>&laquo;extend&raquo;</code> relationships: <i>Mark Uninspected Section</i> conditionally extends <i>Monitor Inspection Reliability</i> when sensor thresholds fail; <i>Trigger Alarm Relay</i> conditionally extends <i>Detect Fabric Defects</i> when critical flaws are flagged.</li>
          </ul>
'@
    $pages.Add((New-Page -PageNumber 19 -Content $p19))

    # ==================== PAGE 20: FIGURE 3.1 USE CASE DIAGRAM ====================
    $p20 = @'
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/06_use_case_overall.svg" alt="Use case diagram of TexEye AI" />
            <div class="caption">Figure 3.1: Use case diagram of TexEye AI</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 20 -Content $p20))

    return $pages
}

Write-Output "Pages 11 to 20 module loaded."


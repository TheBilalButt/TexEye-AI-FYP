# Part 4: Pages 37 to 50
function Get-Pages-37-to-50 {
    $pages = [System.Collections.Generic.List[string]]::new()

    # ==================== PAGE 37: CHAPTER 4 & PERFORMANCE REQUIREMENTS ====================
    $p37 = @'
          <div class="chapter-bar">4 Other Non-functional Requirements</div>
          <h2 class="sec-heading">4.1 Performance Requirements</h2>
          <p>
            TexEye AI operates in a demanding industrial real-time environment. Fabric webs move at linear speeds up to 0.50 meters per second (30 meters per minute); therefore, edge latency and timing predictability are mission-critical. The quantitative performance targets are compiled in Table 4.1.
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 4.1: Performance requirements</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 12%;">ID</th>
                <th style="width: 25%;">Requirement Specification</th>
                <th style="width: 18%;">Target Metric</th>
                <th style="width: 45%;">Engineering Rationale</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>PR-01</b></td>
                <td>AI Inference Latency</td>
                <td>&le; 25 ms / frame</td>
                <td>Guarantees 40+ FPS edge throughput via TensorRT FP16, easily exceeding 30 FPS camera capture rate without frame buffer overrun.</td>
              </tr>
              <tr>
                <td><b>PR-02</b></td>
                <td>End-to-End Edge Pipeline Latency</td>
                <td>&le; 60 ms total</td>
                <td>From optical exposure to Kalman tracking and SQLite commit; ensures immediate detection while fabric is still in view.</td>
              </tr>
              <tr>
                <td><b>PR-03</b></td>
                <td>Alarm Relay Actuation Time</td>
                <td>&le; 50 ms</td>
                <td>From confirmed critical flaw to relay closure; allows operator or emergency stop to halt fabric within 25 mm of travel.</td>
              </tr>
              <tr>
                <td><b>PR-04</b></td>
                <td>Mobile Alert Notification Latency</td>
                <td>&le; 200 ms</td>
                <td>From flaw confirmation to mobile terminal vibration; maintains real-time operator awareness across shop-floor Wi-Fi.</td>
              </tr>
              <tr>
                <td><b>PR-05</b></td>
                <td>Maximum Linear Web Speed</td>
                <td>0.50 m/s (30 m/min)</td>
                <td>Encompasses standard industrial inspection speeds in Pakistani weaving mills (typical range 0.20 to 0.35 m/s).</td>
              </tr>
              <tr>
                <td><b>PR-06</b></td>
                <td>Local SQLite Buffer Capacity</td>
                <td>&ge; 500,000 frames</td>
                <td>Enables continuous offline buffering for over 4 hours of uninterrupted mill operation (&gt; 5,000 meters of fabric).</td>
              </tr>
              <tr>
                <td><b>PR-07</b></td>
                <td>Cloud Batch Ingestion Throughput</td>
                <td>&ge; 100 records / sec</td>
                <td>Allows central FastAPI server to ingest accumulated backlogs from multiple edge stands concurrently upon network restore.</td>
              </tr>
              <tr>
                <td><b>PR-08</b></td>
                <td>Web 2D Defect Map Render Time</td>
                <td>&le; 1.5 seconds</td>
                <td>WebGL canvas renders up to 5,000 flaw markers smoothly with 60 FPS panning and zooming on standard desktop browsers.</td>
              </tr>
              <tr>
                <td><b>PR-09</b></td>
                <td>PDF Certificate Generation Time</td>
                <td>&le; 3.0 seconds</td>
                <td>Compiles comprehensive multi-page PDF document with embedded defect map thumbnail and cryptographic verification hash.</td>
              </tr>
              <tr>
                <td><b>PR-10</b></td>
                <td>Concurrent Stand Scalability</td>
                <td>&ge; 10 active stands</td>
                <td>A single central enterprise server instance supports simultaneous real-time data streaming from 10 inspection lines.</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 37 -Content $p37))

    # ==================== PAGE 38: SAFETY & SECURITY REQUIREMENTS ====================
    $p38 = @'
          <h2 class="sec-heading">4.2 Safety and Security Requirements</h2>
          <h3 class="subsec-heading">4.2.1 Safety Requirements</h3>
          <p>
            Operating in close proximity to high-voltage industrial machinery requires strict hardware-software safety boundaries:
          </p>
          <ul>
            <li><b>SR-01 Opto-Isolated Electrical Isolation:</b> All GPIO inputs (encoder lines) and outputs (relay coils) must be galvanic/optically isolated (&ge; 2.5 kV RMS isolation rating) to protect edge electronics from industrial inductive kickback and ground loops.</li>
            <li><b>SR-02 Fail-Safe Alarm Logic:</b> Alarm relay circuits must be wired in a fail-safe configuration; loss of power to the edge unit automatically trips the relay into a warning alarm state.</li>
            <li><b>SR-03 Non-Contact Optical Sensing:</b> The camera, encoder, and lighting rig must maintain zero physical contact with the moving fabric web (except for the low-friction polyurethane encoder follower wheel), preventing fabric snagging or thread pulling.</li>
            <li><b>SR-04 Photobiological Optical Safety:</b> The LED illumination rig must comply with IEC 62471 photobiological safety standards for continuous human exposure, utilizing diffused light barriers to prevent ocular glare to operators.</li>
            <li><b>SR-05 Thermal Protection:</b> The industrial edge unit and LED power supplies must incorporate thermal monitoring; if internal chassis temperature exceeds 75&deg;C, an automatic thermal warning shall be logged.</li>
            <li><b>SR-06 Emergency Stop Handshake:</b> The system shall provide an isolated dry-contact interlock wired directly to the rolling stand emergency stop circuit, enabling automatic winder deceleration on severe catastrophic tears.</li>
          </ul>
          <h3 class="subsec-heading">4.2.2 Security and Privacy Requirements</h3>
          <ul>
            <li><b>SC-01 Role-Based Access Control (RBAC):</b> System access is strictly partitioned into Floor Operator, Quality Inspector, Quality Manager, and System Administrator, enforced via signed JWT bearer tokens.</li>
            <li><b>SC-02 Password Hashing:</b> All user passwords must be hashed using Argon2id with per-user cryptographic salts; plain-text passwords must never be stored, logged, or transmitted.</li>
            <li><b>SC-03 End-to-End Transport Security:</b> All communications between edge daemons, mobile clients, web workstations, and the cloud server must mandate TLS 1.3 encryption.</li>
            <li><b>SC-04 Edge Device Authentication:</b> Edge units must authenticate to the central cloud using unique hardware-bound X.509 client certificates or cryptographically secure API tokens.</li>
            <li><b>SC-05 Input Sanitization:</b> All REST API payloads, QR scan inputs, and file upload parameters must be validated against strict Pydantic schemas, blocking SQL injection and path traversal attacks.</li>
            <li><b>SC-06 Tamper-Evident Verification:</b> Finalized inspection certificates must embed a SHA-256 digital signature over roll metadata and ASTM point tallies, enabling third-party verification via QR scan.</li>
            <li><b>SC-07 Immutable Audit Trail:</b> Every inspector relabeling action, grading override, and certificate generation event must be permanently recorded with timestamp, user ID, and prior values.</li>
            <li><b>SC-08 Secret Segregation:</b> Database credentials, JWT signing secrets, and cloud storage keys must be held exclusively in environment variables, never hardcoded in source code or client bundles.</li>
          </ul>
'@
    $pages.Add((New-Page -PageNumber 38 -Content $p38))

    # ==================== PAGE 39: SOFTWARE QUALITY ATTRIBUTES ====================
    $p39 = @'
          <h2 class="sec-heading">4.3 Software Quality Attributes</h2>
          <h3 class="subsec-heading">4.3.1 Reliability & Invariant Preservation</h3>
          <p>
            Reliability in TexEye AI is founded on the <b>Non-Negotiable Inspection Invariant</b>: <i>A fabric roll shall never be certified as defect-free if any segment traversed the inspection zone during an unmonitored or optically degraded state</i>.
          </p>
          <ul>
            <li><b>Atomic State Transitions:</b> Inspection sessions transition through formal deterministic states (<code>INITIALIZING &rarr; RUNNING &rarr; PAUSED &rarr; UNINSPECTED &rarr; COMPLETED</code>). No intermediate or corrupt state is permissible.</li>
            <li><b>Dual-Storage Fault Tolerance:</b> Every defect event is committed to local SQLite WAL storage prior to network transmission, ensuring that plant-wide electrical blackouts or Wi-Fi drops result in zero data loss.</li>
            <li><b>Autonomous Hardware Reconnection:</b> If the camera USB bus resets or the encoder drops connection, the edge daemon attempts automatic hardware re-enumeration within 500 ms without requiring manual application restarts.</li>
          </ul>
          <h3 class="subsec-heading">4.3.2 Correctness and Verifiability</h3>
          <ul>
            <li><b>Deterministic ASTM Grading:</b> The ASTM D5430 penalty calculator implements a purely deterministic, mathematical formulation verified against published international test standards. Given identical flaw inputs, grading output is 100% reproducible.</li>
            <li><b>Metrological Precision:</b> Lateral pixel-to-millimeter calibration factors ($k_x$) are verified using physical calibration grid targets with known millimeter spacing, achieving physical coordinate accuracy within &plusmn; 2 mm.</li>
            <li><b>Deduplication Accuracy:</b> The Kalman-IoU tracker eliminates double-counting of traversing defects with &ge; 98% tracking continuity on continuous streaks up to 10 meters in length.</li>
          </ul>
          <h3 class="subsec-heading">4.3.3 Reproducibility & Traceability</h3>
          <ul>
            <li><b>Traceable Lineage:</b> Every committed defect record stores raw bounding box pixels, normalized physical coordinates, AI model version hash, camera frame timestamp, and current encoder pulse index.</li>
            <li><b>Deterministic Replay:</b> Archived raw frame video sequences can be replayed through the AI engine to evaluate updated model weights against historical ground-truth inspection runs.</li>
            <li><b>Audit Compliance:</b> All changes to defect classifications made by human inspectors require an explicit rationale entry, maintaining complete traceability for export compliance audits.</li>
          </ul>
'@
    $pages.Add((New-Page -PageNumber 39 -Content $p39))

    # ==================== PAGE 40: QUALITY ATTRIBUTES (CONT) ====================
    $p40 = @'
          <h3 class="subsec-heading">4.3.4 Maintainability and Design for Change</h3>
          <ul>
            <li><b>Decoupled Modular Architecture:</b> The hardware ingestion layer, AI inference engine, local storage outbox, and cloud synchronization daemon operate as decoupled services communicating via versioned interfaces. Updating the YOLO model from v8 to v11 requires replacing only the TensorRT engine file without altering ingestion or UI code.</li>
            <li><b>Configuration Parameter Externalization:</b> All physical parameters (roller circumference, encoder PPR, lighting lux limits, camera resolution) are defined in an external YAML configuration file, enabling rapid stand recalibration without recompiling software.</li>
          </ul>
          <h3 class="subsec-heading">4.3.5 Testability</h3>
          <ul>
            <li><b>Hardware-in-the-Loop (HIL) Simulation:</b> The edge engine includes a virtual camera and simulated encoder pulse generator capable of streaming synthetic fabric video and quadrature pulses for offline regression testing.</li>
            <li><b>Automated Unit & Integration Test Suites:</b> Core algorithms (ASTM penalty capping, coordinate transformation, Kalman tracking, outbox state machine) maintain &ge; 85% automated test coverage using PyTest.</li>
          </ul>
          <h3 class="subsec-heading">4.3.6 Usability and Accessibility</h3>
          <ul>
            <li><b>High-Contrast Shop-Floor UI:</b> Mobile and stand screens utilize high-contrast visual themes (&ge; 7:1 contrast ratio) with oversized touch targets (&ge; 48&times;48 px), enabling seamless operation by workers wearing industrial safety gloves in varying mill ambient lighting.</li>
            <li><b>Color-Blind Accessible Overlay:</b> Defect classification overlays utilize distinct geometric glyphs (squares, diamonds, triangles, circles) in addition to color hues to ensure accessibility for color-blind operators.</li>
          </ul>
          <h3 class="subsec-heading">4.3.7 Portability</h3>
          <ul>
            <li><b>Cross-Platform Edge Deployment:</b> The edge software stack is containerized using Docker, verified on NVIDIA Jetson Linux (aarch64) and standard industrial x86_64 PCs with dedicated NVIDIA GPUs.</li>
            <li><b>Client Portability:</b> The web workstation runs seamlessly across modern web browsers (Chrome, Edge, Firefox, Safari) without proprietary plugins; the mobile client targets standard Android and iOS devices.</li>
          </ul>
          <h3 class="subsec-heading">4.3.8 Interoperability</h3>
          <ul>
            <li><b>Standard Data Exchange Formats:</b> All external API payloads, database exports, and cutting-room integration files adhere strictly to standard JSON, CSV, and multipart HTTPS formats, ensuring frictionless integration with commercial ERP platforms (SAP, Oracle, local textile management software).</li>
          </ul>
'@
    $pages.Add((New-Page -PageNumber 40 -Content $p40))

    # ==================== PAGE 41: CHAPTER 5 DESIGN DESCRIPTION & 5.1.1 PACKAGE DIAGRAM ====================
    $p41 = @'
          <div class="chapter-bar">5 Design Description</div>
          <h2 class="sec-heading">5.1 Composite Viewpoint</h2>
          <h3 class="subsec-heading">5.1.1 Package Diagram (Logical)</h3>
          <p>
            TexEye AI is structured into three logical architectural tiers: the <b>Physical Ingestion & Edge Sensing Tier</b>, the <b>Edge Processing & Persistence Tier</b>, and the <b>Central Enterprise & Cloud Tier</b>. Figure 5.1 displays the package diagram, and Table 5.1 lists the module responsibilities.
          </p>
          <div class="diagram-container" style="margin-top: 1mm; margin-bottom: 2mm;">
            <img class="diagram-img" src="../diagrams/svg/10_component_diagram.svg" alt="Package Diagram" style="max-height: 125mm;" />
            <div class="caption">Figure 5.1: Package and component diagram of TexEye AI</div>
          </div>
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 1mm;">Table 5.1: Modules and their development owners</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 25%;">Module Name</th>
                <th style="width: 55%;">Responsibility and Internal Packages</th>
                <th style="width: 20%;">Author / Owner</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Hardware Ingestion Driver</b></td>
                <td>V4L2 camera capture, GPIO quadrature pulse interrupts, opto-isolated relay triggers, and distortion rectification.</td>
                <td>Muhammad Bilal Butt</td>
              </tr>
              <tr>
                <td><b>AI Vision & Metrology</b></td>
                <td>TensorRT YOLO FP16 inference, physical $(X, Y)$ coordinate calibration, and multi-frame Kalman flaw tracking.</td>
                <td>Muhammad Bilal Butt</td>
              </tr>
              <tr>
                <td><b>Reliability Sentinel</b></td>
                <td>Illumination lux monitoring, camera frame drop detection, blur detection, and uninspected span gating.</td>
                <td>Muhammad Bilal Butt</td>
              </tr>
              <tr>
                <td><b>Edge Local Storage (WAL)</b></td>
                <td>Transactional SQLite persistence, outbox event queue, and defect image crop disk buffer.</td>
                <td>Muhammad Afnan Khan</td>
              </tr>
              <tr>
                <td><b>Edge Cloud Sync Daemon</b></td>
                <td>Heartbeat probing, multipart HTTPS batch dispatcher, two-phase acknowledgment, and local cache eviction.</td>
                <td>Muhammad Afnan Khan</td>
              </tr>
              <tr>
                <td><b>Central API & ASTM Engine</b></td>
                <td>FastAPI application server, PostgreSQL relational persistence, MinIO S3 storage, and ASTM D5430-07 4-point grading.</td>
                <td>Muhammad Afnan Khan</td>
              </tr>
              <tr>
                <td><b>Web Workstation & Mobile App</b></td>
                <td>Interactive 2D roll defect heatmap, defect review gallery, PDF certificate generator, and operator mobile terminal.</td>
                <td>Muhammad Afnan Khan</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 41 -Content $p41))

    # ==================== PAGE 42: 5.1.2 DEPLOYMENT DIAGRAM ====================
    $p42 = @'
          <h3 class="subsec-heading">5.1.2 Deployment Diagram (Physical)</h3>
          <p>
            The physical deployment of TexEye AI spans three distinct computing tiers: the Stand Edge Rig, the Central Enterprise Server, and the Client Devices as depicted in Figure 5.2.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/11_deployment_diagram.svg" alt="Deployment Diagram" style="max-height: 205mm;" />
            <div class="caption">Figure 5.2: Deployment diagram of edge-cloud architecture</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 42 -Content $p42))

    # ==================== PAGE 43: 5.2 LOGICAL VIEWPOINT (CLASS DIAGRAM) ====================
    $p43 = @'
          <h2 class="sec-heading">5.2 Logical Viewpoint</h2>
          <p>
            The domain model of TexEye AI captures the lifecycle of fabric rolls, inspection sessions, real-time sensor events, defect entities, and ASTM quality grade calculations. Figure 5.3 displays the complete UML class diagram.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/05_software_architecture.svg" alt="Class Diagram" style="max-height: 205mm;" />
            <div class="caption">Figure 5.3: Class diagram of TexEye AI domain model</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 43 -Content $p43))

    # ==================== PAGE 44: TABLE 5.2 CLASSES AND RESPONSIBILITIES ====================
    $p44 = @'
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1.5mm;">Table 5.2: Classes and responsibilities</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 20%;">Class Name</th>
                <th style="width: 50%;">Responsibilities</th>
                <th style="width: 30%;">Key Attributes & Operations</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>FabricRoll</b></td>
                <td>Represents a physical fabric roll undergoing quality inspection; maintains batch origin, nominal specifications, and final grade.</td>
                <td><code>roll_id, batch_number, article_name, target_length, width_mm, gsm, final_grade, total_points</code><br><code>calculateASTMGrade(), getDefectMap()</code></td>
              </tr>
              <tr>
                <td><b>InspectionSession</b></td>
                <td>Manages the runtime state and parameters of an active edge inspection run on a specific fabric roll.</td>
                <td><code>session_id, roll_id, stand_id, operator_id, start_time, end_time, status, total_meters</code><br><code>startSession(), pauseSession(), finalizeSession()</code></td>
              </tr>
              <tr>
                <td><b>DefectEntity</b></td>
                <td>Encapsulates a confirmed fabric anomaly, its spatial coordinates, physical dimensions, class label, and crop image reference.</td>
                <td><code>defect_id, session_id, class_label, confidence, x_mm, y_meter, width_mm, length_mm, penalty_points</code><br><code>assignPoints(), reclassifyDefect()</code></td>
              </tr>
              <tr>
                <td><b>UninspectedSection</b></td>
                <td>Records an unmonitored fabric span caused by sensor fault, preventing false-clean certification.</td>
                <td><code>section_id, session_id, y_start, y_end, length_m, trigger_reason, timestamp</code><br><code>getSpanLength(), isRollInvalidated()</code></td>
              </tr>
              <tr>
                <td><b>EncoderTracker</b></td>
                <td>Interacts with hardware GPIO ISR to accumulate quadrature pulses and map displacement to linear meters.</td>
                <td><code>pulse_count, ppr, roller_circumference_mm, current_y_meters</code><br><code>onInterruptPulse(), getDisplacement(), reset()</code></td>
              </tr>
              <tr>
                <td><b>CameraDriver</b></td>
                <td>Manages V4L2 video ingestion buffer, camera exposure registers, and lens distortion rectification.</td>
                <td><code>device_path, fps, frame_width, frame_height, exposure_us</code><br><code>captureFrame(), getSharpness(), setExposure()</code></td>
              </tr>
              <tr>
                <td><b>KalmanFlawTracker</b></td>
                <td>Maintains multi-frame spatial continuity of defects traversing overlapping frames to prevent duplicate counts.</td>
                <td><code>active_tracks, max_disappeared_frames, iou_threshold</code><br><code>predict(), update(detections), finalizeTracks()</code></td>
              </tr>
              <tr>
                <td><b>ASTMCalculator</b></td>
                <td>Calculates ASTM D5430-07 4-point penalty scores, applies 1-meter capping, and evaluates commercial roll grades.</td>
                <td><code>point_matrix, max_meter_points, grade_thresholds</code><br><code>calculateDefectPoints(), computeRollGrade()</code></td>
              </tr>
              <tr>
                <td><b>OutboxEvent</b></td>
                <td>Represents an atomic offline sync queue entity persisted in local SQLite WAL storage.</td>
                <td><code>event_id, aggregate_type, payload_json, status, retry_count</code><br><code>markSynced(), getPendingBatches()</code></td>
              </tr>
              <tr>
                <td><b>AuditLogRecord</b></td>
                <td>Stores an immutable historical record of user overrides, grade adjustments, and PDF exports.</td>
                <td><code>audit_id, entity_id, user_id, action_type, old_value, new_value, timestamp</code><br><code>recordAuditEntry(), getRollAuditTrail()</code></td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 44 -Content $p44))

    # ==================== PAGE 45: 5.3 INFORMATION VIEWPOINT (ERD) ====================
    $p45 = @'
          <h2 class="sec-heading">5.3 Information Viewpoint</h2>
          <p>
            TexEye AI manages persistent relational data across the local SQLite edge buffer and the central PostgreSQL enterprise database. Figure 5.4 displays the Entity Relationship Diagram (ERD) in Crow's Foot notation, capturing relational cardinality and foreign key associations.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/14_entity_relationship_diagram.svg" alt="Entity Relationship Diagram" style="max-height: 205mm;" />
            <div class="caption">Figure 5.4: Entity relationship diagram of TexEye AI</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 45 -Content $p45))

    # ==================== PAGE 46: TABLE 5.3 MAIN ENTITIES ====================
    $p46 = @'
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1.5mm;">Table 5.3: Main entities of TexEye AI</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 18%;">Entity Name</th>
                <th style="width: 15%;">Storage Location</th>
                <th style="width: 67%;">Description and Key Relational Constraints</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>users</b></td>
                <td>Central PostgreSQL</td>
                <td>User accounts (operators, inspectors, managers, admins). Fields: <code>user_id (PK), username, email, password_hash, role, created_at</code>. Enforces RBAC permissions.</td>
              </tr>
              <tr>
                <td><b>fabric_rolls</b></td>
                <td>Central PostgreSQL</td>
                <td>Master fabric roll entity. Fields: <code>roll_id (PK), batch_number, article_name, width_mm, target_length, gsm, final_grade, total_points, status, created_at</code>.</td>
              </tr>
              <tr>
                <td><b>inspection_sessions</b></td>
                <td>SQLite & PostgreSQL</td>
                <td>Inspection execution run. Fields: <code>session_id (PK), roll_id (FK), stand_id, operator_id (FK), start_time, end_time, actual_length_m, status</code>.</td>
              </tr>
              <tr>
                <td><b>defects</b></td>
                <td>SQLite & PostgreSQL</td>
                <td>Confirmed fabric anomalies. Fields: <code>defect_id (PK), session_id (FK), class_label, confidence, x_mm, y_meter, width_mm, length_mm, penalty_points, crop_path, source</code>.</td>
              </tr>
              <tr>
                <td><b>uninspected_sections</b></td>
                <td>SQLite & PostgreSQL</td>
                <td>Sensor fault intervals. Fields: <code>section_id (PK), session_id (FK), y_start_m, y_end_m, trigger_reason, timestamp</code>. Invalidation trigger for clean certification.</td>
              </tr>
              <tr>
                <td><b>outbox_events</b></td>
                <td>Local SQLite (WAL)</td>
                <td>Offline transactional sync queue. Fields: <code>event_id (PK), aggregate_type, aggregate_id, payload_json, status, retry_count, created_at, synced_at</code>.</td>
              </tr>
              <tr>
                <td><b>astm_grading_records</b></td>
                <td>Central PostgreSQL</td>
                <td>Formal grading scorecard. Fields: <code>grading_id (PK), roll_id (FK), points_total, points_per_100sqm, max_linear_meter_points, assigned_grade, finalized_by (FK), timestamp</code>.</td>
              </tr>
              <tr>
                <td><b>defect_audit_log</b></td>
                <td>Central PostgreSQL</td>
                <td>Immutable historical audit trail. Fields: <code>audit_id (PK), defect_id (FK), user_id (FK), action_type, old_class, new_class, reason_text, timestamp</code>.</td>
              </tr>
              <tr>
                <td><b>inspection_certificates</b></td>
                <td>PostgreSQL & MinIO</td>
                <td>Archived PDF certificate documents. Fields: <code>cert_id (PK), roll_id (FK), pdf_storage_path, sha256_hash, issued_by (FK), issued_at</code>.</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 46 -Content $p46))

    # ==================== PAGE 47: 5.4 INTERACTION VIEWPOINT & FIGURE 5.5 ====================
    $p47 = @'
          <h2 class="sec-heading">5.4 Interaction Viewpoint</h2>
          <p>
            The interaction viewpoint specifies dynamic message exchanges between system participants across key operational use cases. Each sequence diagram depicts participants, their active execution lifelines, synchronous/asynchronous messages, and return confirmations.
          </p>
          <h3 class="subsec-heading">5.4.1 Sequence Diagram for Start Inspection Session (UC-01)</h3>
          <p>
            Figure 5.5 illustrates the sequence of actions when an operator scans a roll QR code and initializes the edge stand hardware.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/07_context_diagram.svg" alt="Context Diagram" style="max-height: 185mm;" />
            <div class="caption">Figure 5.5: Sequence diagram for UC-01 Start Inspection Session</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 47 -Content $p47))

    # ==================== PAGE 48: FIGURE 5.6 SEQUENCE REAL-TIME DETECTION ====================
    $p48 = @'
          <h3 class="subsec-heading">5.4.2 Sequence Diagram for Real-Time Defect Detection & Tracking (UC-03)</h3>
          <p>
            Figure 5.6 depicts the high-speed loop between the rotary encoder, camera driver, TensorRT YOLO engine, Kalman tracker, and local SQLite buffer during active fabric winding.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/12_sequence_inspection.svg" alt="Sequence Diagram: Inspection" style="max-height: 205mm;" />
            <div class="caption">Figure 5.6: Sequence diagram for UC-03 Real-Time Defect Detection & Tracking</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 48 -Content $p48))

    # ==================== PAGE 49: FIGURE 5.7 SEQUENCE RELIABILITY GATING ====================
    $p49 = @'
          <h3 class="subsec-heading">5.4.3 Sequence Diagram for Reliability Gating & Uninspected Mark (UC-05)</h3>
          <p>
            Figure 5.7 details the enforcement of the reliability invariant: detection of optical sensor faults, suspension of AI classification, actuation of the amber stack light, and recording of uninspected spans.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/02_ai_inspection_workflow.svg" alt="AI Inspection Workflow" style="max-height: 205mm;" />
            <div class="caption">Figure 5.7: Sequence diagram for UC-05 Reliability Gating & Uninspected Mark</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 49 -Content $p49))

    # ==================== PAGE 50: FIGURE 5.8 SEQUENCE OFFLINE SYNC ====================
    $p50 = @'
          <h3 class="subsec-heading">5.4.4 Sequence Diagram for Offline Buffering & Resilient Cloud Sync (UC-08)</h3>
          <p>
            Figure 5.8 shows the edge sync daemon probing cloud connectivity, assembling multipart JSON/JPEG batch payloads from the SQLite outbox, and processing two-phase commit acknowledgments.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/13_sequence_sync.svg" alt="Sequence Diagram: Sync" style="max-height: 205mm;" />
            <div class="caption">Figure 5.8: Sequence diagram for UC-08 Offline Buffering & Resilient Cloud Sync</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 50 -Content $p50))

    return $pages
}

Write-Output "Pages 37 to 50 module loaded."


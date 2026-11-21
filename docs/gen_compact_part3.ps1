# Compact, Clean, Professional COMSATS Wah Capstone SRDS - Part 3 (Pages 22 to 31)
function Get-Compact-Pages-22-to-31 {
    $pages = [System.Collections.Generic.List[string]]::new()

    # ==================== PAGE 22: CHAPTER 5 DESIGN DESCRIPTION & 5.1 COMPOSITE VIEWPOINT ====================
    $p22 = @'
          <div class="chapter-bar">5 Design Description</div>
          <p class="body-p">
            Chapter 5 presents the formal architectural design of TexEye AI following the IEEE 1016 Recommended Practice for Software Design Descriptions. The system is documented across six complementary viewpoints: Composite, Logical, Information, Interaction, State Dynamics, and Algorithm Viewpoints.
          </p>

          <h2 class="sec-heading">5.1 Composite Viewpoint</h2>
          <p class="body-p">
            The composite viewpoint partitions the system into autonomous, loosely coupled subsystems communicating over explicit network and hardware interfaces. Edge stands operate autonomously without continuous cloud connectivity, while central servers aggregate enterprise data.
          </p>

          <div style="display: flex; gap: 4mm; margin-bottom: 2.5mm;">
            <!-- Subsystem Decomposition -->
            <div style="flex: 1; border: 1px solid #000; padding: 2.5mm; background: #ffffff;">
              <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 2mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
                Figure 5.1: Subsystem Package Decomposition
              </div>
              <svg viewBox="0 0 480 230" width="100%" height="135" style="background: #ffffff; font-family: Arial, sans-serif;">
                <!-- Edge Unit Package -->
                <rect x="10" y="10" width="220" height="210" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
                <rect x="10" y="10" width="100" height="18" fill="#eee" stroke="#000" stroke-width="1"/>
                <text x="60" y="23" font-size="8.5" font-weight="bold" text-anchor="middle">texeye-edge</text>
                
                <rect x="25" y="40" width="190" height="26" fill="#fff" stroke="#000" stroke-width="0.8"/>
                <text x="120" y="57" font-size="8" font-weight="bold" text-anchor="middle">Camera &amp; Ingestion Subsystem</text>

                <rect x="25" y="75" width="190" height="26" fill="#fff" stroke="#000" stroke-width="0.8"/>
                <text x="120" y="92" font-size="8" font-weight="bold" text-anchor="middle">YOLO Inference &amp; Kalman Tracker</text>

                <rect x="25" y="110" width="190" height="26" fill="#fff" stroke="#000" stroke-width="0.8"/>
                <text x="120" y="127" font-size="8" font-weight="bold" text-anchor="middle">Reliability Guard &amp; Relay Actuation</text>

                <rect x="25" y="145" width="190" height="26" fill="#fff" stroke="#000" stroke-width="0.8"/>
                <text x="120" y="162" font-size="8" font-weight="bold" text-anchor="middle">SQLite WAL Buffer &amp; Outbox Daemon</text>

                <rect x="25" y="180" width="190" height="26" fill="#fff" stroke="#000" stroke-width="0.8"/>
                <text x="120" y="197" font-size="8" font-weight="bold" text-anchor="middle">Local WebSocket Alert Service</text>

                <!-- Central Package -->
                <rect x="250" y="10" width="220" height="210" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
                <rect x="250" y="10" width="100" height="18" fill="#eee" stroke="#000" stroke-width="1"/>
                <text x="300" y="23" font-size="8.5" font-weight="bold" text-anchor="middle">texeye-cloud</text>

                <rect x="265" y="40" width="190" height="26" fill="#fff" stroke="#000" stroke-width="0.8"/>
                <text x="360" y="57" font-size="8" font-weight="bold" text-anchor="middle">FastAPI Ingestion &amp; Batch Sync</text>

                <rect x="265" y="75" width="190" height="26" fill="#fff" stroke="#000" stroke-width="0.8"/>
                <text x="360" y="92" font-size="8" font-weight="bold" text-anchor="middle">ASTM D5430 Automated Grading</text>

                <rect x="265" y="110" width="190" height="26" fill="#fff" stroke="#000" stroke-width="0.8"/>
                <text x="360" y="127" font-size="8" font-weight="bold" text-anchor="middle">PostgreSQL Relational Persistence</text>

                <rect x="265" y="145" width="190" height="26" fill="#fff" stroke="#000" stroke-width="0.8"/>
                <text x="360" y="162" font-size="8" font-weight="bold" text-anchor="middle">MinIO Image Object Store</text>

                <rect x="265" y="180" width="190" height="26" fill="#fff" stroke="#000" stroke-width="0.8"/>
                <text x="360" y="197" font-size="8" font-weight="bold" text-anchor="middle">React Dashboard &amp; Report Hub</text>
              </svg>
            </div>

            <!-- Deployment Diagram -->
            <div style="flex: 1; border: 1px solid #000; padding: 2.5mm; background: #ffffff;">
              <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 2mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
                Figure 5.2: Physical Deployment Nodes
              </div>
              <svg viewBox="0 0 480 230" width="100%" height="135" style="background: #ffffff; font-family: Arial, sans-serif;">
                <!-- Node 1: Stand -->
                <rect x="15" y="20" width="125" height="185" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
                <text x="77" y="40" font-size="8.5" font-weight="bold" text-anchor="middle">&lt;&lt;device&gt;&gt;</text>
                <text x="77" y="55" font-size="8.5" font-weight="bold" text-anchor="middle">Inspection Stand</text>
                <line x1="25" y1="62" x2="130" y2="62" stroke="#aaa" stroke-width="0.8"/>
                <text x="77" y="80" font-size="7.5" text-anchor="middle">Industrial Camera</text>
                <text x="77" y="100" font-size="7.5" text-anchor="middle">Rotary Encoder</text>
                <text x="77" y="120" font-size="7.5" text-anchor="middle">LED Lighting Rig</text>
                <text x="77" y="140" font-size="7.5" text-anchor="middle">24V Stack Light</text>
                <text x="77" y="160" font-size="7.5" text-anchor="middle">Audio Buzzer Relay</text>

                <!-- Connector 1 -->
                <line x1="140" y1="110" x2="175" y2="110" stroke="#000" stroke-width="1.2"/>
                <rect x="141" y="96" width="34" height="14" fill="#ffffff" rx="2"/>
                <text x="158" y="106" font-size="6.5" font-weight="bold" text-anchor="middle">USB/GPIO</text>

                <!-- Node 2: Edge Unit -->
                <rect x="175" y="20" width="130" height="185" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
                <text x="240" y="40" font-size="8.5" font-weight="bold" text-anchor="middle">&lt;&lt;execution node&gt;&gt;</text>
                <text x="240" y="55" font-size="8.5" font-weight="bold" text-anchor="middle">Edge Computer</text>
                <line x1="185" y1="62" x2="295" y2="62" stroke="#aaa" stroke-width="0.8"/>
                <text x="240" y="80" font-size="7.5" text-anchor="middle">Ubuntu Linux 22.04</text>
                <text x="240" y="100" font-size="7.5" text-anchor="middle">AI Defect Engine</text>
                <text x="240" y="120" font-size="7.5" text-anchor="middle">Python Ingestion</text>
                <text x="240" y="140" font-size="7.5" text-anchor="middle">SQLite WAL Database</text>
                <text x="240" y="160" font-size="7.5" text-anchor="middle">Systemd Sync Service</text>

                <!-- Connector 2 -->
                <line x1="305" y1="110" x2="340" y2="110" stroke="#000" stroke-width="1.2"/>
                <rect x="307" y="96" width="32" height="14" fill="#ffffff" rx="2"/>
                <text x="323" y="106" font-size="6.5" font-weight="bold" text-anchor="middle">HTTPS</text>

                <!-- Node 3: Cloud -->
                <rect x="340" y="20" width="125" height="185" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
                <text x="402" y="40" font-size="8.5" font-weight="bold" text-anchor="middle">&lt;&lt;cloud cluster&gt;&gt;</text>
                <text x="402" y="55" font-size="8.5" font-weight="bold" text-anchor="middle">Enterprise Server</text>
                <line x1="350" y1="62" x2="455" y2="62" stroke="#aaa" stroke-width="0.8"/>
                <text x="402" y="80" font-size="7.5" text-anchor="middle">FastAPI Application</text>
                <text x="402" y="100" font-size="7.5" text-anchor="middle">PostgreSQL Database</text>
                <text x="402" y="120" font-size="7.5" text-anchor="middle">MinIO Object Store</text>
                <text x="402" y="140" font-size="7.5" text-anchor="middle">Nginx Web Proxy</text>
                <text x="402" y="160" font-size="7.5" text-anchor="middle">Docker Compose Hub</text>
              </svg>
            </div>
          </div>

          <p class="body-p" style="font-weight: bold; margin-bottom: 1.5mm;">
            Table 5.1: Subsystem Responsibilities and Module Ownership
          </p>
          <table class="req-table">
            <thead>
              <tr>
                <th style="width: 22%;">Subsystem Name</th>
                <th style="width: 48%;">Architectural Responsibilities</th>
                <th style="width: 30%;">Lead Developer</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Edge Ingestion &amp; Vision</b></td>
                <td>Frame grab, quadrature count accumulation, real-time YOLO defect inference, Kalman tracking, and coordinate mapping.</td>
                <td>Muhammad Bilal Butt (AI / Pipeline)</td>
              </tr>
              <tr>
                <td><b>Reliability &amp; Hardware Guard</b></td>
                <td>Exposure checking, blur gating, speed invariant verification, stack light / buzzer relay actuation, and uninspected span tracking.</td>
                <td>Muhammad Bilal Butt (AI / Pipeline)</td>
              </tr>
              <tr>
                <td><b>Offline Sync &amp; Storage</b></td>
                <td>SQLite local WAL outbox, multipart HTTP batch payload assembly, exponential backoff retries, and local image purging.</td>
                <td>Muhammad Afnan Khan (Full-Stack / Core)</td>
              </tr>
              <tr>
                <td><b>Central API &amp; ASTM Grading</b></td>
                <td>FastAPI endpoints, JWT authentication, ASTM D5430 4-point penalty evaluation, PostgreSQL relational storage, and MinIO storage.</td>
                <td>Muhammad Afnan Khan (Full-Stack / Core)</td>
              </tr>
              <tr>
                <td><b>Web &amp; Mobile Clients</b></td>
                <td>React management dashboard, 2D defect roll heatmaps, PDF report generation engine, and shop floor operator mobile alert UI.</td>
                <td>Muhammad Afnan Khan (Full-Stack / Core)</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 22 -Content $p22))

    # ==================== PAGE 23: 5.2 LOGICAL VIEWPOINT ====================
    $p23 = @'
          <h2 class="sec-heading" style="margin-top: 0;">5.2 Logical Viewpoint</h2>
          <p class="body-p">
            The logical viewpoint defines the domain entity classes, service layers, and boundary interfaces of TexEye AI. Object models encapsulate the lifecycle of inspection runs, metric defect coordinates, ASTM penalty accumulation, and transactional synchronization events.
          </p>

          <div style="border: 1px solid #000; padding: 2.5mm; margin-bottom: 3mm; background: #ffffff;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 2mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.3: Domain Class Model Diagram
            </div>
            <svg viewBox="0 0 760 300" width="100%" height="205" style="background: #ffffff; font-family: Arial, sans-serif;">
              <!-- Class 1: InspectionSession -->
              <rect x="15" y="15" width="220" height="125" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <text x="125" y="32" font-size="9" font-weight="bold" text-anchor="middle">InspectionSession</text>
              <line x1="15" y1="38" x2="235" y2="38" stroke="#000" stroke-width="0.8"/>
              <text x="22" y="52" font-size="7.5">+ session_id: UUID</text>
              <text x="22" y="66" font-size="7.5">+ roll_id: String</text>
              <text x="22" y="80" font-size="7.5">+ start_time / end_time: DateTime</text>
              <text x="22" y="94" font-size="7.5">+ total_length_meters: Float</text>
              <text x="22" y="108" font-size="7.5">+ state: SessionState</text>
              <line x1="15" y1="114" x2="235" y2="114" stroke="#000" stroke-width="0.8"/>
              <text x="22" y="128" font-size="7.5">+ start() / pause() / finalize()</text>

              <!-- Class 2: DefectRecord -->
              <rect x="280" y="15" width="220" height="125" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <text x="390" y="32" font-size="9" font-weight="bold" text-anchor="middle">DefectRecord</text>
              <line x1="280" y1="38" x2="500" y2="38" stroke="#000" stroke-width="0.8"/>
              <text x="287" y="52" font-size="7.5">+ defect_id: UUID</text>
              <text x="287" y="66" font-size="7.5">+ flaw_type: FlawCategory</text>
              <text x="287" y="80" font-size="7.5">+ confidence: Float [0.0 - 1.0]</text>
              <text x="287" y="94" font-size="7.5">+ coord_x_mm / coord_y_m: Float</text>
              <text x="287" y="108" font-size="7.5">+ length_mm / width_mm: Float</text>
              <line x1="280" y1="114" x2="500" y2="114" stroke="#000" stroke-width="0.8"/>
              <text x="287" y="128" font-size="7.5">+ compute_astm_points(): Int</text>

              <!-- Class 3: ASTMPenaltyCalculator -->
              <rect x="545" y="15" width="200" height="125" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <text x="645" y="32" font-size="9" font-weight="bold" text-anchor="middle">ASTMPenaltyCalculator</text>
              <line x1="545" y1="38" x2="745" y2="38" stroke="#000" stroke-width="0.8"/>
              <text x="552" y="52" font-size="7.5">+ standard: String = "D5430-07"</text>
              <text x="552" y="66" font-size="7.5">+ max_penalty_per_linear_meter: 4</text>
              <text x="552" y="80" font-size="7.5">+ grade_a_cutoff: Float = 20.0</text>
              <text x="552" y="94" font-size="7.5">+ grade_b_cutoff: Float = 40.0</text>
              <line x1="545" y1="114" x2="745" y2="114" stroke="#000" stroke-width="0.8"/>
              <text x="552" y="128" font-size="7.5">+ evaluate_roll(records): GradeReport</text>

              <!-- Associations Line 1 -->
              <line x1="235" y1="75" x2="280" y2="75" stroke="#000" stroke-width="1.2"/>
              <text x="245" y="70" font-size="8">1</text>
              <text x="268" y="70" font-size="8">*</text>

              <line x1="500" y1="75" x2="545" y2="75" stroke="#000" stroke-width="1.2"/>
              <text x="510" y="70" font-size="8">*</text>
              <text x="532" y="70" font-size="8">1</text>

              <!-- Class 4: UninspectedSpan -->
              <rect x="15" y="165" width="220" height="115" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <text x="125" y="182" font-size="9" font-weight="bold" text-anchor="middle">UninspectedSpan</text>
              <line x1="15" y1="188" x2="235" y2="188" stroke="#000" stroke-width="0.8"/>
              <text x="22" y="202" font-size="7.5">+ span_id: UUID</text>
              <text x="22" y="216" font-size="7.5">+ start_meter / end_meter: Float</text>
              <text x="22" y="230" font-size="7.5">+ reason: FaultType</text>
              <line x1="15" y1="244" x2="235" y2="244" stroke="#000" stroke-width="0.8"/>
              <text x="22" y="258" font-size="7.5">+ get_span_length(): Float</text>

              <!-- Class 5: OutboxEvent -->
              <rect x="280" y="165" width="220" height="115" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <text x="390" y="182" font-size="9" font-weight="bold" text-anchor="middle">OutboxEvent</text>
              <line x1="280" y1="188" x2="500" y2="188" stroke="#000" stroke-width="0.8"/>
              <text x="287" y="202" font-size="7.5">+ event_id: UUID</text>
              <text x="287" y="216" font-size="7.5">+ event_type: String</text>
              <text x="287" y="230" font-size="7.5">+ payload_json: Text</text>
              <text x="287" y="244" font-size="7.5">+ sync_status: SyncState</text>
              <line x1="280" y1="250" x2="500" y2="250" stroke="#000" stroke-width="0.8"/>
              <text x="287" y="264" font-size="7.5">+ mark_synced() / increment_retry()</text>

              <!-- Class 6: UserAccount -->
              <rect x="545" y="165" width="200" height="115" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <text x="645" y="182" font-size="9" font-weight="bold" text-anchor="middle">UserAccount</text>
              <line x1="545" y1="188" x2="745" y2="188" stroke="#000" stroke-width="0.8"/>
              <text x="552" y="202" font-size="7.5">+ user_id: UUID</text>
              <text x="552" y="216" font-size="7.5">+ username / password_hash: String</text>
              <text x="552" y="230" font-size="7.5">+ role: RoleEnum (Operator | QA | Admin)</text>
              <line x1="545" y1="244" x2="745" y2="244" stroke="#000" stroke-width="0.8"/>
              <text x="552" y="258" font-size="7.5">+ verify_jwt() / has_permission()</text>

              <!-- Associations Line 2 -->
              <line x1="125" y1="140" x2="125" y2="165" stroke="#000" stroke-width="1.2"/>
              <line x1="390" y1="140" x2="390" y2="165" stroke="#000" stroke-width="1.2"/>
            </svg>
          </div>

          <p class="body-p" style="font-weight: bold; margin-bottom: 1.5mm;">
            Table 5.2: Class Responsibilities, Attributes, and Key Methods
          </p>
          <table class="req-table">
            <thead>
              <tr>
                <th style="width: 20%;">Class Name</th>
                <th style="width: 25%;">Core Attributes</th>
                <th style="width: 25%;">Primary Methods</th>
                <th style="width: 30%;">Responsibility Summary</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>InspectionSession</b></td>
                <td>session_id, roll_id, total_length, state, start/end timestamps</td>
                <td>start_session(), pause_session(), finalize_session()</td>
                <td>Manages inspection lifecycle, accumulates roll length, and guards state transitions.</td>
              </tr>
              <tr>
                <td><b>DefectRecord</b></td>
                <td>defect_id, flaw_type, confidence, coord_x_mm, coord_y_m</td>
                <td>compute_penalty(), crop_image_patch(), get_metric_coords()</td>
                <td>Encapsulates detected flaw attributes, physical spatial coordinates, and bounding boxes.</td>
              </tr>
              <tr>
                <td><b>ASTMPenaltyCalculator</b></td>
                <td>standard, max_penalty_per_m, grade_cutoffs</td>
                <td>accumulate_linear_bins(), compute_roll_points(), assign_grade()</td>
                <td>Implements ASTM D5430-07 4-point penalty aggregation and 100 sq. meter normalization.</td>
              </tr>
              <tr>
                <td><b>OutboxEvent</b></td>
                <td>event_id, payload_json, sync_status, retry_count, last_error</td>
                <td>mark_synced(), increment_backoff(), purge_expired()</td>
                <td>Guarantees transactional at-least-once message delivery to central servers during outages.</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 23 -Content $p23))

    # ==================== PAGE 24: 5.3 INFORMATION VIEWPOINT ====================
    $p24 = @'
          <h2 class="sec-heading" style="margin-top: 0;">5.3 Information Viewpoint</h2>
          <p class="body-p">
            The information viewpoint specifies the relational schema, constraints, keys, and persistence mechanisms. Central enterprise data resides in PostgreSQL 15, while local edge caching employs SQLite 3 configured with Write-Ahead Logging (WAL) for fault-tolerant local buffering.
          </p>

          <div style="border: 1px solid #000; padding: 2.5mm; margin-bottom: 3mm; background: #ffffff;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 2mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.4: Relational Entity-Relationship Diagram (ERD)
            </div>
            <svg viewBox="0 0 760 300" width="100%" height="205" style="background: #ffffff; font-family: Arial, sans-serif;">
              <!-- Table 1: users -->
              <rect x="15" y="15" width="190" height="120" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <rect x="15" y="15" width="190" height="20" fill="#eee" stroke="#000" stroke-width="0.8"/>
              <text x="110" y="29" font-size="8.5" font-weight="bold" text-anchor="middle">users</text>
              <text x="22" y="47" font-size="7.5">PK user_id : UUID</text>
              <text x="22" y="61" font-size="7.5">&nbsp;&nbsp;&nbsp;username : VARCHAR(50)</text>
              <text x="22" y="75" font-size="7.5">&nbsp;&nbsp;&nbsp;password_hash : VARCHAR(255)</text>
              <text x="22" y="89" font-size="7.5">&nbsp;&nbsp;&nbsp;role : user_role_enum</text>
              <text x="22" y="103" font-size="7.5">&nbsp;&nbsp;&nbsp;full_name : VARCHAR(100)</text>
              <text x="22" y="117" font-size="7.5">&nbsp;&nbsp;&nbsp;created_at : TIMESTAMP</text>

              <!-- Table 2: inspection_rolls -->
              <rect x="270" y="15" width="220" height="135" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <rect x="270" y="15" width="220" height="20" fill="#eee" stroke="#000" stroke-width="0.8"/>
              <text x="380" y="29" font-size="8.5" font-weight="bold" text-anchor="middle">inspection_rolls</text>
              <text x="277" y="47" font-size="7.5">PK roll_id : VARCHAR(50)</text>
              <text x="277" y="61" font-size="7.5">FK operator_id : UUID -&gt; users</text>
              <text x="277" y="75" font-size="7.5">&nbsp;&nbsp;&nbsp;fabric_type : VARCHAR(100)</text>
              <text x="277" y="89" font-size="7.5">&nbsp;&nbsp;&nbsp;total_length_m : NUMERIC(8,2)</text>
              <text x="277" y="103" font-size="7.5">&nbsp;&nbsp;&nbsp;fabric_width_mm : NUMERIC(6,1)</text>
              <text x="277" y="117" font-size="7.5">&nbsp;&nbsp;&nbsp;total_points : INTEGER</text>
              <text x="277" y="131" font-size="7.5">&nbsp;&nbsp;&nbsp;final_grade : grade_enum (A, B, C, Reject)</text>

              <!-- Table 3: defect_records -->
              <rect x="540" y="15" width="205" height="135" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <rect x="540" y="15" width="205" height="20" fill="#eee" stroke="#000" stroke-width="0.8"/>
              <text x="642" y="29" font-size="8.5" font-weight="bold" text-anchor="middle">defect_records</text>
              <text x="547" y="47" font-size="7.5">PK defect_id : UUID</text>
              <text x="547" y="61" font-size="7.5">FK roll_id : VARCHAR(50) -&gt; rolls</text>
              <text x="547" y="75" font-size="7.5">&nbsp;&nbsp;&nbsp;flaw_type : defect_category_enum</text>
              <text x="547" y="89" font-size="7.5">&nbsp;&nbsp;&nbsp;confidence : NUMERIC(4,3)</text>
              <text x="547" y="103" font-size="7.5">&nbsp;&nbsp;&nbsp;coord_x_mm : NUMERIC(6,1)</text>
              <text x="547" y="117" font-size="7.5">&nbsp;&nbsp;&nbsp;coord_y_m : NUMERIC(8,3)</text>
              <text x="547" y="131" font-size="7.5">&nbsp;&nbsp;&nbsp;penalty_points : INTEGER [1-4]</text>

              <!-- Table 4: uninspected_spans -->
              <rect x="270" y="175" width="220" height="105" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <rect x="270" y="175" width="220" height="20" fill="#eee" stroke="#000" stroke-width="0.8"/>
              <text x="380" y="189" font-size="8.5" font-weight="bold" text-anchor="middle">uninspected_spans</text>
              <text x="277" y="207" font-size="7.5">PK span_id : UUID</text>
              <text x="277" y="221" font-size="7.5">FK roll_id : VARCHAR(50) -&gt; rolls</text>
              <text x="277" y="235" font-size="7.5">&nbsp;&nbsp;&nbsp;start_y_m : NUMERIC(8,3)</text>
              <text x="277" y="249" font-size="7.5">&nbsp;&nbsp;&nbsp;end_y_m : NUMERIC(8,3)</text>
              <text x="277" y="263" font-size="7.5">&nbsp;&nbsp;&nbsp;fault_cause : VARCHAR(50)</text>

              <!-- Table 5: outbox_events -->
              <rect x="540" y="175" width="205" height="105" fill="#fcfcfc" stroke="#000" stroke-width="1.2"/>
              <rect x="540" y="175" width="205" height="20" fill="#eee" stroke="#000" stroke-width="0.8"/>
              <text x="642" y="189" font-size="8.5" font-weight="bold" text-anchor="middle">outbox_events (Edge Local)</text>
              <text x="547" y="207" font-size="7.5">PK event_id : UUID</text>
              <text x="547" y="221" font-size="7.5">&nbsp;&nbsp;&nbsp;event_type : VARCHAR(50)</text>
              <text x="547" y="235" font-size="7.5">&nbsp;&nbsp;&nbsp;payload_json : JSONB / TEXT</text>
              <text x="547" y="249" font-size="7.5">&nbsp;&nbsp;&nbsp;sync_state : VARCHAR(20)</text>
              <text x="547" y="263" font-size="7.5">&nbsp;&nbsp;&nbsp;retry_count : INTEGER</text>

              <!-- Relations -->
              <line x1="205" y1="75" x2="270" y2="75" stroke="#000" stroke-width="1.2"/>
              <line x1="490" y1="75" x2="540" y2="75" stroke="#000" stroke-width="1.2"/>
              <line x1="380" y1="150" x2="380" y2="175" stroke="#000" stroke-width="1.2"/>
            </svg>
          </div>

          <p class="body-p" style="font-weight: bold; margin-bottom: 1.5mm;">
            Table 5.3: Database Entities, Data Types, and Foreign Key Integrity
          </p>
          <table class="req-table">
            <thead>
              <tr>
                <th style="width: 22%;">Table Name</th>
                <th style="width: 18%;">Primary Key</th>
                <th style="width: 25%;">Foreign Key References</th>
                <th style="width: 35%;">Integrity Constraints &amp; Indexing</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>users</b></td>
                <td>user_id (UUID)</td>
                <td>None</td>
                <td>UNIQUE (username); bcrypt password hashing; role ENUM ('operator', 'qa_manager', 'admin').</td>
              </tr>
              <tr>
                <td><b>inspection_rolls</b></td>
                <td>roll_id (VARCHAR)</td>
                <td>operator_id -&gt; users(user_id)</td>
                <td>CHECK (total_length_m &gt;= 0); final_grade ENUM ('A', 'B', 'C', 'Reject'); INDEX on (created_at).</td>
              </tr>
              <tr>
                <td><b>defect_records</b></td>
                <td>defect_id (UUID)</td>
                <td>roll_id -&gt; rolls(roll_id) ON DELETE CASCADE</td>
                <td>CHECK (penalty_points BETWEEN 1 AND 4); INDEX on (roll_id, coord_y_m); spatial ordering.</td>
              </tr>
              <tr>
                <td><b>uninspected_spans</b></td>
                <td>span_id (UUID)</td>
                <td>roll_id -&gt; rolls(roll_id) ON DELETE CASCADE</td>
                <td>CHECK (end_y_m &gt; start_y_m); prevents false defect-free roll certification.</td>
              </tr>
              <tr>
                <td><b>outbox_events</b></td>
                <td>event_id (UUID)</td>
                <td>Local SQLite Stand Buffer</td>
                <td>CHECK (sync_state IN ('PENDING', 'IN_FLIGHT', 'SYNCED')); indexed on (created_at ASC).</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 24 -Content $p24))

    # ==================== PAGE 25: 5.4 INTERACTION VIEWPOINT (PART 1) ====================
    $p25 = @'
          <h2 class="sec-heading" style="margin-top: 0;">5.4 Interaction Viewpoint: Real-Time Edge Processing</h2>
          <p class="body-p">
            The interaction viewpoint specifies dynamic message sequencing across system boundaries. Figure 5.5 models normal real-time frame acquisition and defect tracking. Figure 5.6 models safety invariant violation and stack light actuation.
          </p>

          <div style="border: 1px solid #000; padding: 2mm; margin-bottom: 3mm; background: #ffffff;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1.5mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.5: Sequence Diagram: Real-Time Inspection &amp; Defect Detection
            </div>
            <svg viewBox="0 0 740 200" width="100%" height="135" style="background: #ffffff; font-family: Arial, sans-serif;">
              <defs>
                <marker id="seq55-arr" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polygon points="0 1, 8 4, 0 7" fill="#000000"/>
                </marker>
                <marker id="seq55-ret" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polyline points="2 1, 7 4, 2 7" fill="none" stroke="#000000" stroke-width="1.2"/>
                </marker>
              </defs>

              <!-- Participants -->
              <rect x="20" y="10" width="110" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="75" y="26" font-size="8" font-weight="bold" text-anchor="middle">Floor Operator</text>
              <line x1="75" y1="35" x2="75" y2="190" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="180" y="10" width="120" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="240" y="26" font-size="8" font-weight="bold" text-anchor="middle">Edge Ingestion</text>
              <line x1="240" y1="35" x2="240" y2="190" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="350" y="10" width="130" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="415" y="26" font-size="8" font-weight="bold" text-anchor="middle">Camera &amp; Encoder</text>
              <line x1="415" y1="35" x2="415" y2="128" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>
              <line x1="415" y1="160" x2="415" y2="190" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="530" y="10" width="120" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="590" y="26" font-size="8" font-weight="bold" text-anchor="middle">Local SQLite Outbox</text>
              <line x1="590" y1="35" x2="590" y2="190" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <!-- Message 1 -->
              <line x1="75" y1="55" x2="240" y2="55" stroke="#000" stroke-width="1.2" marker-end="url(#seq55-arr)"/>
              <text x="157" y="47" font-size="7.5" font-weight="bold" text-anchor="middle">StartRollSession(roll_id)</text>

              <!-- Message 2 -->
              <line x1="240" y1="75" x2="75" y2="75" stroke="#000" stroke-width="1" stroke-dasharray="4 2" marker-end="url(#seq55-ret)"/>
              <text x="157" y="67" font-size="7" text-anchor="middle">SessionInitialized</text>

              <!-- Message 3 -->
              <line x1="415" y1="95" x2="240" y2="95" stroke="#000" stroke-width="1.2" marker-end="url(#seq55-arr)"/>
              <text x="327" y="87" font-size="7.5" font-weight="bold" text-anchor="middle">FrameReady(frame_id, pulses)</text>

              <!-- Internal Processing -->
              <path d="M 240 115 L 270 115 L 270 130 L 240 130" fill="none" stroke="#000" stroke-width="1" marker-end="url(#seq55-arr)"/>
              <text x="278" y="125" font-size="7">AI Inference &amp; Kalman Track</text>

              <!-- Message 4: Across intermediate lifeline at x=415 -->
              <rect x="330" y="132" width="220" height="15" fill="#ffffff"/>
              <text x="440" y="144" font-size="7.5" font-weight="bold" text-anchor="middle" paint-order="stroke fill" stroke="#ffffff" stroke-width="6px" stroke-linejoin="round">InsertDefect(flaw, X_mm, Y_m)</text>
              <line x1="240" y1="150" x2="590" y2="150" stroke="#000" stroke-width="1.2" marker-end="url(#seq55-arr)"/>

              <!-- Message 5 -->
              <line x1="240" y1="175" x2="75" y2="175" stroke="#000" stroke-width="1.2" marker-end="url(#seq55-arr)"/>
              <text x="157" y="167" font-size="7.5" font-weight="bold" text-anchor="middle">PushVibrationAlert(flaw_type)</text>
            </svg>
          </div>

          <div style="border: 1px solid #000; padding: 2mm; margin-bottom: 2mm; background: #ffffff;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1.5mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.6: Sequence Diagram: Inspection Reliability &amp; Hardware Invariant Gating
            </div>
            <svg viewBox="0 0 740 195" width="100%" height="132" style="background: #ffffff; font-family: Arial, sans-serif;">
              <defs>
                <marker id="seq56-arr" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polygon points="0 1, 8 4, 0 7" fill="#000000"/>
                </marker>
              </defs>

              <!-- Participants -->
              <rect x="20" y="10" width="120" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="80" y="26" font-size="8" font-weight="bold" text-anchor="middle">Camera &amp; Encoder</text>
              <line x1="80" y1="35" x2="80" y2="185" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="200" y="10" width="130" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="265" y="26" font-size="8" font-weight="bold" text-anchor="middle">Reliability Guard</text>
              <line x1="265" y1="35" x2="265" y2="185" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="390" y="10" width="130" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="455" y="26" font-size="8" font-weight="bold" text-anchor="middle">Relay Actuator</text>
              <line x1="455" y1="35" x2="455" y2="114" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>
              <line x1="455" y1="142" x2="455" y2="156" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>
              <line x1="455" y1="184" x2="455" y2="185" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="580" y="10" width="120" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="640" y="26" font-size="8" font-weight="bold" text-anchor="middle">Local SQLite WAL</text>
              <line x1="640" y1="35" x2="640" y2="185" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <!-- Message 1 -->
              <line x1="80" y1="55" x2="265" y2="55" stroke="#000" stroke-width="1.2" marker-end="url(#seq56-arr)"/>
              <text x="172" y="47" font-size="7.5" font-weight="bold" text-anchor="middle">SensorTelemetry(lux=420, v=0.62m/s)</text>

              <!-- Internal Evaluation -->
              <path d="M 265 75 L 295 75 L 295 90 L 265 90" fill="none" stroke="#000" stroke-width="1" marker-end="url(#seq56-arr)"/>
              <text x="300" y="85" font-size="7">EvaluateInvariants() -&gt; FAULT</text>

              <!-- Message 2 -->
              <line x1="265" y1="110" x2="455" y2="110" stroke="#000" stroke-width="1.2" marker-end="url(#seq56-arr)"/>
              <text x="360" y="102" font-size="7.5" font-weight="bold" text-anchor="middle">ActuateRelay(AMBER_LIGHT, ON)</text>

              <!-- Message 3: Across intermediate lifeline at x=455 -->
              <rect x="340" y="117" width="230" height="15" fill="#ffffff"/>
              <text x="455" y="128" font-size="7.5" font-weight="bold" text-anchor="middle" paint-order="stroke fill" stroke="#ffffff" stroke-width="6px" stroke-linejoin="round">RecordUninspectedSpan(Y_start=14.2m)</text>
              <line x1="265" y1="135" x2="640" y2="135" stroke="#000" stroke-width="1.2" marker-end="url(#seq56-arr)"/>

              <!-- Recovery Telemetry -->
              <line x1="80" y1="158" x2="265" y2="158" stroke="#000" stroke-width="1.2" marker-end="url(#seq56-arr)"/>
              <text x="172" y="150" font-size="7.5" font-weight="bold" text-anchor="middle">SensorTelemetry(lux=950, v=0.35m/s)</text>

              <!-- Message 5: Across intermediate lifeline at x=455 -->
              <rect x="345" y="160" width="220" height="15" fill="#ffffff"/>
              <text x="455" y="171" font-size="7.5" font-weight="bold" text-anchor="middle" paint-order="stroke fill" stroke="#ffffff" stroke-width="6px" stroke-linejoin="round">CloseUninspectedSpan(Y_end=15.8m)</text>
              <line x1="265" y1="178" x2="640" y2="178" stroke="#000" stroke-width="1.2" marker-end="url(#seq56-arr)"/>
            </svg>
          </div>
'@
    $pages.Add((New-Page -PageNumber 25 -Content $p25))

    # ==================== PAGE 26: 5.4 INTERACTION VIEWPOINT (PART 2) ====================
    $p26 = @'
          <h2 class="sec-heading" style="margin-top: 0;">5.4 Interaction Viewpoint: Sync &amp; Review (Continued)</h2>
          <p class="body-p">
            Figure 5.7 models offline buffering and multipart outbox dispatch to central cloud storage. Figure 5.8 models quality manager review, defect validation, and final ASTM D5430 roll grading.
          </p>

          <div style="border: 1px solid #000; padding: 2mm; margin-bottom: 3mm; background: #ffffff;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1.5mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.7: Sequence Diagram: Offline Buffering &amp; Outbox Synchronization
            </div>
            <svg viewBox="0 0 740 195" width="100%" height="135" style="background: #ffffff; font-family: Arial, sans-serif;">
              <defs>
                <marker id="seq57-arr" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polygon points="0 1, 8 4, 0 7" fill="#000000"/>
                </marker>
                <marker id="seq57-ret" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polyline points="2 1, 7 4, 2 7" fill="none" stroke="#000000" stroke-width="1.2"/>
                </marker>
              </defs>

              <!-- Participants -->
              <rect x="20" y="10" width="120" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="80" y="26" font-size="8" font-weight="bold" text-anchor="middle">Sync Daemon</text>
              <line x1="80" y1="35" x2="80" y2="185" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="190" y="10" width="120" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="250" y="26" font-size="8" font-weight="bold" text-anchor="middle">Local SQLite WAL</text>
              <line x1="250" y1="35" x2="250" y2="78" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>
              <line x1="250" y1="108" x2="250" y2="128" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>
              <line x1="250" y1="158" x2="250" y2="185" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="360" y="10" width="130" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="425" y="26" font-size="8" font-weight="bold" text-anchor="middle">Central FastAPI</text>
              <line x1="425" y1="35" x2="425" y2="185" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="540" y="10" width="130" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="605" y="26" font-size="8" font-weight="bold" text-anchor="middle">PostgreSQL / S3</text>
              <line x1="605" y1="35" x2="605" y2="185" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <!-- Message 1 -->
              <line x1="80" y1="55" x2="250" y2="55" stroke="#000" stroke-width="1.2" marker-end="url(#seq57-arr)"/>
              <text x="165" y="47" font-size="7.5" font-weight="bold" text-anchor="middle">QueryPendingBatches(limit=50)</text>

              <!-- Response 1 -->
              <line x1="250" y1="75" x2="80" y2="75" stroke="#000" stroke-width="1" stroke-dasharray="4 2" marker-end="url(#seq57-ret)"/>
              <text x="165" y="67" font-size="7" text-anchor="middle">PendingEventsList</text>

              <!-- Message 2: Across intermediate lifeline at x=250 -->
              <rect x="135" y="82" width="235" height="15" fill="#ffffff"/>
              <text x="252" y="93" font-size="7.5" font-weight="bold" text-anchor="middle" paint-order="stroke fill" stroke="#ffffff" stroke-width="6px" stroke-linejoin="round">POST /api/v1/sync/batch (Multipart JSON + Crops)</text>
              <line x1="80" y1="100" x2="425" y2="100" stroke="#000" stroke-width="1.2" marker-end="url(#seq57-arr)"/>

              <!-- Message 3 -->
              <line x1="425" y1="125" x2="605" y2="125" stroke="#000" stroke-width="1.2" marker-end="url(#seq57-arr)"/>
              <text x="515" y="117" font-size="7.5" font-weight="bold" text-anchor="middle">CommitTransaction()</text>

              <!-- Message 4: Across intermediate lifeline at x=250 -->
              <rect x="180" y="132" width="145" height="15" fill="#ffffff"/>
              <text x="252" y="143" font-size="7" text-anchor="middle" paint-order="stroke fill" stroke="#ffffff" stroke-width="6px" stroke-linejoin="round">HTTP 200 OK (synced_ids)</text>
              <line x1="425" y1="150" x2="80" y2="150" stroke="#000" stroke-width="1" stroke-dasharray="4 2" marker-end="url(#seq57-ret)"/>

              <!-- Message 5 -->
              <line x1="80" y1="172" x2="250" y2="172" stroke="#000" stroke-width="1.2" marker-end="url(#seq57-arr)"/>
              <text x="165" y="164" font-size="7.5" font-weight="bold" text-anchor="middle">MarkOutboxSynced(synced_ids)</text>
            </svg>
          </div>

          <div style="border: 1px solid #000; padding: 2mm; margin-bottom: 2mm; background: #ffffff;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1.5mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.8: Sequence Diagram: Central Review &amp; ASTM 4-Point Grading Finalization
            </div>
            <svg viewBox="0 0 740 190" width="100%" height="130" style="background: #ffffff; font-family: Arial, sans-serif;">
              <defs>
                <marker id="seq58-arr" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polygon points="0 1, 8 4, 0 7" fill="#000000"/>
                </marker>
                <marker id="seq58-ret" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polyline points="2 1, 7 4, 2 7" fill="none" stroke="#000000" stroke-width="1.2"/>
                </marker>
              </defs>

              <!-- Participants -->
              <rect x="20" y="10" width="120" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="80" y="26" font-size="8" font-weight="bold" text-anchor="middle">QA Manager</text>
              <line x1="80" y1="35" x2="80" y2="180" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="190" y="10" width="120" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="250" y="26" font-size="8" font-weight="bold" text-anchor="middle">React Dashboard</text>
              <line x1="250" y1="35" x2="250" y2="180" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="360" y="10" width="130" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="425" y="26" font-size="8" font-weight="bold" text-anchor="middle">Central FastAPI</text>
              <line x1="425" y1="35" x2="425" y2="180" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="540" y="10" width="130" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="605" y="26" font-size="8" font-weight="bold" text-anchor="middle">ASTM Grading Engine</text>
              <line x1="605" y1="35" x2="605" y2="180" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <!-- Message 1 -->
              <line x1="80" y1="55" x2="250" y2="55" stroke="#000" stroke-width="1.2" marker-end="url(#seq58-arr)"/>
              <text x="165" y="47" font-size="7.5" font-weight="bold" text-anchor="middle">OpenRollReview(roll_id)</text>

              <!-- Message 2 -->
              <line x1="250" y1="78" x2="425" y2="78" stroke="#000" stroke-width="1.2" marker-end="url(#seq58-arr)"/>
              <text x="337" y="70" font-size="7.5" font-weight="bold" text-anchor="middle">GET /api/v1/rolls/{id}/defects</text>

              <!-- Message 3 -->
              <line x1="80" y1="105" x2="250" y2="105" stroke="#000" stroke-width="1.2" marker-end="url(#seq58-arr)"/>
              <text x="165" y="97" font-size="7.5" font-weight="bold" text-anchor="middle">UpdateDefect(id, confirmed=True)</text>

              <!-- Message 4 -->
              <line x1="250" y1="130" x2="425" y2="130" stroke="#000" stroke-width="1.2" marker-end="url(#seq58-arr)"/>
              <text x="337" y="122" font-size="7.5" font-weight="bold" text-anchor="middle">POST /api/v1/rolls/{id}/finalize</text>

              <!-- Message 5 -->
              <line x1="425" y1="152" x2="605" y2="152" stroke="#000" stroke-width="1.2" marker-end="url(#seq58-arr)"/>
              <text x="515" y="144" font-size="7.5" font-weight="bold" text-anchor="middle">CalculateD5430Points(defects)</text>

              <!-- Response -->
              <line x1="605" y1="172" x2="425" y2="172" stroke="#000" stroke-width="1" stroke-dasharray="4 2" marker-end="url(#seq58-ret)"/>
              <text x="515" y="164" font-size="7" text-anchor="middle">RollGradeResult (Grade A, 8.4 pts / 100m²)</text>
            </svg>
          </div>
'@
    $pages.Add((New-Page -PageNumber 26 -Content $p26))

    # ==================== PAGE 27: 5.4 INTERACTION VIEWPOINT (PART 3) ====================
    $p27 = @'
          <h2 class="sec-heading" style="margin-top: 0;">5.4 Interaction Viewpoint: Reporting &amp; Protocols (Continued)</h2>
          <p class="body-p">
            Figure 5.9 models server-side production inspection certificate compilation and secure PDF delivery. Table 5.4 defines core inter-component API signatures, HTTP methods, authorization scopes, and status codes.
          </p>

          <div style="border: 1px solid #000; padding: 2mm; margin-bottom: 3mm; background: #ffffff;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1.5mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.9: Sequence Diagram: Production Inspection PDF Export
            </div>
            <svg viewBox="0 0 740 185" width="100%" height="125" style="background: #ffffff; font-family: Arial, sans-serif;">
              <defs>
                <marker id="seq59-arr" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polygon points="0 1, 8 4, 0 7" fill="#000000"/>
                </marker>
                <marker id="seq59-ret" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polyline points="2 1, 7 4, 2 7" fill="none" stroke="#000000" stroke-width="1.2"/>
                </marker>
              </defs>

              <!-- Participants -->
              <rect x="20" y="10" width="120" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="80" y="26" font-size="8" font-weight="bold" text-anchor="middle">Plant Client</text>
              <line x1="80" y1="35" x2="80" y2="175" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="190" y="10" width="130" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="255" y="26" font-size="8" font-weight="bold" text-anchor="middle">FastAPI Gateway</text>
              <line x1="255" y1="35" x2="255" y2="175" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="370" y="10" width="130" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="435" y="26" font-size="8" font-weight="bold" text-anchor="middle">ReportLab Engine</text>
              <line x1="435" y1="35" x2="435" y2="175" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <rect x="550" y="10" width="120" height="25" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="610" y="26" font-size="8" font-weight="bold" text-anchor="middle">MinIO S3 Store</text>
              <line x1="610" y1="35" x2="610" y2="175" stroke="#000" stroke-width="0.8" stroke-dasharray="3 3"/>

              <!-- Message 1 -->
              <line x1="80" y1="55" x2="255" y2="55" stroke="#000" stroke-width="1.2" marker-end="url(#seq59-arr)"/>
              <text x="167" y="47" font-size="7.5" font-weight="bold" text-anchor="middle">GET /api/v1/reports/{roll_id}/pdf</text>

              <!-- Message 2 -->
              <line x1="255" y1="80" x2="435" y2="80" stroke="#000" stroke-width="1.2" marker-end="url(#seq59-arr)"/>
              <text x="345" y="72" font-size="7.5" font-weight="bold" text-anchor="middle">BuildInspectionPDF(roll_metadata, defects)</text>

              <!-- Message 3 -->
              <line x1="435" y1="105" x2="610" y2="105" stroke="#000" stroke-width="1.2" marker-end="url(#seq59-arr)"/>
              <text x="522" y="97" font-size="7.5" font-weight="bold" text-anchor="middle">StorePDFArchive(filename, bytes)</text>

              <!-- Message 4 -->
              <line x1="435" y1="130" x2="255" y2="130" stroke="#000" stroke-width="1" stroke-dasharray="4 2" marker-end="url(#seq59-ret)"/>
              <text x="345" y="122" font-size="7" text-anchor="middle">BinaryPDFStream</text>

              <!-- Message 5 -->
              <line x1="255" y1="155" x2="80" y2="155" stroke="#000" stroke-width="1" stroke-dasharray="4 2" marker-end="url(#seq59-ret)"/>
              <text x="167" y="147" font-size="7" text-anchor="middle">HTTP 200 (application/pdf attachment)</text>
            </svg>
          </div>

          <p class="body-p" style="font-weight: bold; margin-bottom: 1.5mm;">
            Table 5.4: Inter-Component API Protocol and Message Signatures
          </p>
          <table class="req-table">
            <thead>
              <tr>
                <th style="width: 14%;">Method</th>
                <th style="width: 28%;">Endpoint URI</th>
                <th style="width: 22%;">Payload / Params</th>
                <th style="width: 18%;">Auth Scope</th>
                <th style="width: 18%;">Status Codes</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>POST</b></td>
                <td><code>/api/v1/auth/token</code></td>
                <td>username, password</td>
                <td>Public</td>
                <td>200 OK, 401 Unauthorized</td>
              </tr>
              <tr>
                <td><b>POST</b></td>
                <td><code>/api/v1/rolls/session</code></td>
                <td>roll_id, fabric_type, width</td>
                <td>Operator, QA</td>
                <td>201 Created, 409 Conflict</td>
              </tr>
              <tr>
                <td><b>POST</b></td>
                <td><code>/api/v1/sync/batch</code></td>
                <td>Multipart: JSON records + JPEG crops</td>
                <td>Edge Machine Token</td>
                <td>200 OK, 400 Bad Req, 503 Busy</td>
              </tr>
              <tr>
                <td><b>GET</b></td>
                <td><code>/api/v1/rolls/{id}/defects</code></td>
                <td>roll_id (path parameter)</td>
                <td>Operator, QA, Admin</td>
                <td>200 OK, 404 Not Found</td>
              </tr>
              <tr>
                <td><b>PATCH</b></td>
                <td><code>/api/v1/defects/{id}</code></td>
                <td>is_confirmed, user_flaw_type</td>
                <td>QA Manager</td>
                <td>200 OK, 403 Forbidden</td>
              </tr>
              <tr>
                <td><b>POST</b></td>
                <td><code>/api/v1/rolls/{id}/finalize</code></td>
                <td>roll_id (path parameter)</td>
                <td>QA Manager</td>
                <td>200 OK, 400 Incomplete</td>
              </tr>
              <tr>
                <td><b>GET</b></td>
                <td><code>/api/v1/reports/{id}/pdf</code></td>
                <td>roll_id (path parameter)</td>
                <td>All Roles</td>
                <td>200 OK, 404 Not Found</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 27 -Content $p27))

    # ==================== PAGE 28: 5.5 STATE DYNAMICS VIEWPOINT ====================
    $p28 = @'
          <h2 class="sec-heading" style="margin-top: 0;">5.5 State Dynamics Viewpoint</h2>
          <p class="body-p">
            The state dynamics viewpoint captures event-driven lifecycle behaviors. Figure 5.10 models the Edge Inspection Stand Finite State Machine with safety invariant transitions. Figure 5.11 models the Transactional Offline Outbox FSM.
          </p>

          <div style="border: 1px solid #000; padding: 2.5mm; margin-bottom: 2.5mm; background: #ffffff;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 2mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.10: State Machine Diagram: Roll Inspection Run FSM
            </div>
            <!-- Clean, professional UML layout: unbroken whole arrows, solid arrowheads, spacious pills -->
            <svg viewBox="0 0 840 380" width="100%" height="220" style="background:#ffffff; font-family:Arial, sans-serif;">
              <defs>
                <marker id="fsm-arr" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polygon points="0 1, 8 4, 0 7" fill="#000000"/>
                </marker>
                <marker id="fsm-arr-red" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polygon points="0 1, 8 4, 0 7" fill="#dc2626"/>
                </marker>
                <marker id="fsm-arr-green" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polygon points="0 1, 8 4, 0 7" fill="#16a34a"/>
                </marker>
              </defs>

              <!-- Initial State (Solid Circle) -->
              <circle cx="420" cy="20" r="7" fill="#000000"/>
              
              <!-- Transition: Start -> INITIALIZING -->
              <line x1="420" y1="27" x2="420" y2="52" stroke="#000000" stroke-width="1.3" marker-end="url(#fsm-arr)"/>
              <rect x="435" y="32" width="70" height="15" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
              <text x="470" y="43" font-size="7.5" font-weight="bold" fill="#000000" text-anchor="middle">scan_qr</text>

              <!-- State 1: INITIALIZING -->
              <rect x="290" y="52" width="260" height="38" rx="5" fill="#ffffff" stroke="#000000" stroke-width="1.3"/>
              <text x="420" y="66" font-size="8.5" font-weight="bold" text-anchor="middle">INITIALIZING</text>
              <text x="420" y="79" font-size="7" text-anchor="middle">entry / Zero encoder; POST /session/start</text>

              <!-- Transition: INITIALIZING -> RUNNING -->
              <line x1="420" y1="90" x2="420" y2="115" stroke="#000000" stroke-width="1.3" marker-end="url(#fsm-arr)"/>
              <rect x="435" y="96" width="75" height="15" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
              <text x="472" y="107" font-size="7.5" font-weight="bold" fill="#000000" text-anchor="middle">sensors_ok</text>

              <!-- State 2: RUNNING (Center Core) -->
              <rect x="270" y="115" width="300" height="46" rx="5" fill="#ffffff" stroke="#000000" stroke-width="1.5"/>
              <text x="420" y="130" font-size="9" font-weight="bold" text-anchor="middle">RUNNING</text>
              <text x="420" y="143" font-size="7" text-anchor="middle">do / Ingest 30fps frames &amp; count optical pulses</text>
              <text x="420" y="154" font-size="7" text-anchor="middle">infer YOLO defect bboxes &amp; Kalman track (X, Y)</text>

              <!-- Left Branch: RUNNING -> PAUSED -->
              <path d="M 270 128 L 140 128 L 140 195" fill="none" stroke="#000000" stroke-width="1.3" marker-end="url(#fsm-arr)"/>
              <rect x="155" y="120" width="95" height="15" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
              <text x="202" y="131" font-size="7.5" font-weight="bold" fill="#000000" text-anchor="middle">operator_pause</text>

              <!-- State 3: PAUSED -->
              <rect x="25" y="195" width="225" height="42" rx="5" fill="#ffffff" stroke="#000000" stroke-width="1.3"/>
              <text x="137" y="210" font-size="8.5" font-weight="bold" text-anchor="middle">PAUSED</text>
              <text x="137" y="224" font-size="7" text-anchor="middle">do / Freeze displacement counter</text>

              <!-- Resume: PAUSED -> RUNNING -->
              <path d="M 220 195 L 220 152 L 270 152" fill="none" stroke="#16a34a" stroke-width="1.3" marker-end="url(#fsm-arr-green)"/>
              <rect x="175" y="162" width="90" height="15" fill="#f0fdf4" stroke="#86efac" rx="3"/>
              <text x="220" y="173" font-size="7.5" font-weight="bold" fill="#15803d" text-anchor="middle">operator_resume</text>

              <!-- Right Branch: RUNNING -> UNINSPECTED_FAULT -->
              <path d="M 570 128 L 700 128 L 700 195" fill="none" stroke="#dc2626" stroke-width="1.3" marker-end="url(#fsm-arr-red)"/>
              <rect x="585" y="120" width="130" height="15" fill="#fff1f2" stroke="#fca5a5" rx="3"/>
              <text x="650" y="131" font-size="7.5" font-weight="bold" fill="#9f1239" text-anchor="middle">sensor_fault [lux&lt;800|blur]</text>

              <!-- State 4: UNINSPECTED_FAULT -->
              <rect x="585" y="195" width="235" height="46" rx="5" fill="#fff1f2" stroke="#dc2626" stroke-width="1.3"/>
              <text x="702" y="209" font-size="8.5" font-weight="bold" fill="#991b1b" text-anchor="middle">UNINSPECTED_FAULT</text>
              <text x="702" y="222" font-size="7" fill="#be123c" text-anchor="middle">entry / Actuate Amber stack light &amp; buzzer</text>
              <text x="702" y="233" font-size="7" fill="#be123c" text-anchor="middle">do / Suspend AI; record span [Y1, Y2]</text>

              <!-- Recovery: UNINSPECTED_FAULT -> RUNNING -->
              <path d="M 620 195 L 620 152 L 570 152" fill="none" stroke="#16a34a" stroke-width="1.3" marker-end="url(#fsm-arr-green)"/>
              <rect x="575" y="162" width="95" height="15" fill="#f0fdf4" stroke="#86efac" rx="3"/>
              <text x="622" y="173" font-size="7.5" font-weight="bold" fill="#15803d" text-anchor="middle">sensors_recovered</text>

              <!-- Center Branch: RUNNING -> ALARM_ACTIVE -->
              <line x1="420" y1="161" x2="420" y2="202" stroke="#dc2626" stroke-width="1.4" marker-end="url(#fsm-arr-red)"/>
              <rect x="340" y="174" width="160" height="15" fill="#fff1f2" stroke="#fca5a5" rx="3"/>
              <text x="420" y="185" font-size="7.5" font-weight="bold" fill="#9f1239" text-anchor="middle">critical_defect [hole&gt;25mm]</text>

              <!-- State 5: ALARM_ACTIVE -->
              <rect x="290" y="202" width="260" height="40" rx="5" fill="#ffffff" stroke="#dc2626" stroke-width="1.3"/>
              <text x="420" y="217" font-size="8.5" font-weight="bold" fill="#991b1b" text-anchor="middle">ALARM_ACTIVE</text>
              <text x="420" y="231" font-size="7" text-anchor="middle">entry / Actuate Red light &amp; buzzer; push WS haptic</text>

              <!-- Transition: ALARM_ACTIVE -> Bullseye -->
              <line x1="420" y1="242" x2="420" y2="265" stroke="#000000" stroke-width="1.2" marker-end="url(#fsm-arr)"/>
              <rect x="435" y="247" width="80" height="15" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
              <text x="475" y="258" font-size="7.5" font-weight="bold" fill="#000000" text-anchor="middle">operator_ack</text>

              <!-- Terminal State (Bullseye) -->
              <circle cx="420" cy="275" r="8" fill="none" stroke="#000000" stroke-width="1.3"/>
              <circle cx="420" cy="275" r="4.5" fill="#000000"/>
            </svg>
          </div>

          <div style="border: 1px solid #000; padding: 2.5mm; margin-bottom: 2mm; background: #ffffff;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 2mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.11: State Machine Diagram: Offline Sync Outbox FSM
            </div>
            <!-- Clean, professional layout: whole arrows, solid arrowheads, labels strictly above lines -->
            <svg viewBox="0 0 760 120" width="100%" height="80" style="background: #ffffff; font-family: Arial, sans-serif;">
              <defs>
                <marker id="sync-arr" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
                  <polygon points="0 1, 8 4, 0 7" fill="#000000"/>
                </marker>
              </defs>

              <!-- Start Circle -->
              <circle cx="35" cy="46" r="7" fill="#000000"/>
              
              <!-- Transition 1: insert_event -->
              <line x1="42" y1="46" x2="135" y2="46" stroke="#000000" stroke-width="1.2" marker-end="url(#sync-arr)"/>
              <text x="88" y="36" font-size="7.5" font-weight="bold" text-anchor="middle">insert_event</text>

              <!-- State 1: PENDING -->
              <rect x="135" y="26" width="150" height="40" rx="5" fill="#ffffff" stroke="#000000" stroke-width="1.2"/>
              <text x="210" y="42" font-size="8.5" font-weight="bold" text-anchor="middle">PENDING</text>
              <text x="210" y="55" font-size="7" text-anchor="middle">Committed in SQLite</text>

              <!-- Transition 2: net_online & send -->
              <line x1="285" y1="46" x2="395" y2="46" stroke="#000000" stroke-width="1.2" marker-end="url(#sync-arr)"/>
              <text x="340" y="36" font-size="7.5" font-weight="bold" text-anchor="middle">net_online &amp; send</text>

              <!-- State 2: IN_FLIGHT -->
              <rect x="395" y="26" width="150" height="40" rx="5" fill="#ffffff" stroke="#000000" stroke-width="1.2"/>
              <text x="470" y="42" font-size="8.5" font-weight="bold" text-anchor="middle">IN_FLIGHT</text>
              <text x="470" y="55" font-size="7" text-anchor="middle">HTTPS POST active</text>

              <!-- Transition 3: HTTP 200 OK -->
              <line x1="545" y1="46" x2="655" y2="46" stroke="#000000" stroke-width="1.2" marker-end="url(#sync-arr)"/>
              <text x="600" y="36" font-size="7.5" font-weight="bold" text-anchor="middle">HTTP 200 OK</text>

              <!-- State 3: SYNCED -->
              <rect x="655" y="26" width="90" height="40" rx="5" fill="#ffffff" stroke="#000000" stroke-width="1.2"/>
              <text x="700" y="42" font-size="8.5" font-weight="bold" text-anchor="middle">SYNCED</text>
              <text x="700" y="55" font-size="7" text-anchor="middle">Marked complete</text>

              <!-- Transition 4: Retry Loop -->
              <path d="M 470 66 L 470 98 L 210 98 L 210 66" fill="none" stroke="#000000" stroke-width="1.2" marker-end="url(#sync-arr)"/>
              <text x="340" y="90" font-size="7.5" font-weight="bold" text-anchor="middle">timeout / net_fail [backoff retry &lt; 5]</text>
            </svg>
          </div>

          <p class="body-p" style="font-weight: bold; margin-bottom: 1.5mm;">
            Table 5.5: State Transition Guard Conditions and Safety Actions
          </p>
          <table class="req-table">
            <thead>
              <tr>
                <th style="width: 18%;">Current State</th>
                <th style="width: 24%;">Trigger Event</th>
                <th style="width: 28%;">Guard Condition</th>
                <th style="width: 15%;">Next State</th>
                <th style="width: 15%;">Safety Action</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>INITIALIZING</b></td>
                <td>sensors_ok</td>
                <td>lux &gt;= 800 &amp;&amp; camera_ready &amp;&amp; enc_zeroed</td>
                <td>RUNNING</td>
                <td>Clear warning lights</td>
              </tr>
              <tr>
                <td><b>RUNNING</b></td>
                <td>sensor_fault</td>
                <td>lux &lt; 800 || blur_score &lt; 100 || v &gt; 0.5m/s</td>
                <td>UNINSPECTED_FAULT</td>
                <td>Turn on Amber Light, log span start</td>
              </tr>
              <tr>
                <td><b>UNINSPECTED_FAULT</b></td>
                <td>sensors_recovered</td>
                <td>lux &gt;= 800 &amp;&amp; blur_score &gt;= 100 &amp;&amp; v &lt;= 0.5m/s</td>
                <td>RUNNING</td>
                <td>Turn off Amber Light, log span end</td>
              </tr>
              <tr>
                <td><b>RUNNING</b></td>
                <td>critical_defect</td>
                <td>hole_diam &gt; 25mm || cluster_density &gt; 3</td>
                <td>ALARM_ACTIVE</td>
                <td>Red light ON, sound buzzer 1.5s</td>
              </tr>
              <tr>
                <td><b>IN_FLIGHT</b></td>
                <td>timeout / net_fail</td>
                <td>HTTP status &gt;= 500 || network_unreachable</td>
                <td>PENDING</td>
                <td>Exponential backoff (2^k seconds)</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 28 -Content $p28))

    # ==================== PAGE 29: 5.6 ALGORITHM VIEWPOINT (ACTIVITY & PERFORMANCE) ====================
    $p29 = @'
          <h2 class="sec-heading" style="margin-top: 0;">5.6 Algorithm Viewpoint</h2>
          <p class="body-p">
            The algorithm viewpoint formalizes the mathematical and computational methods that guarantee real-time defect localization, tracking, and ASTM D5430 compliance. Figure 5.12 models the end-to-end execution activity flow.
          </p>

          <div style="border: 1px solid #000; padding: 2.5mm; margin-bottom: 3mm; background: #ffffff;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 2mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.12: Activity Diagram: End-to-End Autonomous Inspection Pipeline
            </div>
            <svg viewBox="0 0 820 250" width="100%" height="165" style="background: #ffffff; font-family: Arial, sans-serif;">
              <!-- Activity 1 -->
              <circle cx="35" cy="50" r="8" fill="#000"/>
              <line x1="43" y1="50" x2="70" y2="50" stroke="#000" stroke-width="1.2"/>

              <rect x="70" y="32" width="125" height="36" rx="10" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="132" y="47" font-size="8" font-weight="bold" text-anchor="middle">Read Encoder Pulses</text>
              <text x="132" y="58" font-size="7" text-anchor="middle">&amp; Grab Video Frame</text>

              <line x1="195" y1="50" x2="225" y2="50" stroke="#000" stroke-width="1.2"/>

              <!-- Decision 1: Reliable? (Spacious 70px wide diamond) -->
              <polygon points="225,50 260,28 295,50 260,72" fill="#ffffff" stroke="#000" stroke-width="1.2"/>
              <text x="260" y="53" font-size="7.5" font-weight="bold" text-anchor="middle">Reliable?</text>

              <!-- Branch: Fault [No] -->
              <line x1="260" y1="72" x2="260" y2="105" stroke="#000" stroke-width="1.2"/>
              <text x="268" y="90" font-size="7.5" font-weight="bold">[No]</text>
              <rect x="195" y="105" width="130" height="34" rx="8" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="260" y="119" font-size="7.5" font-weight="bold" text-anchor="middle">Actuate Amber Relay</text>
              <text x="260" y="131" font-size="7" text-anchor="middle">&amp; Record Uninspected</text>

              <!-- Branch: Normal [Yes] (Huge 50px clearance from 295 to 345, zero overlap!) -->
              <line x1="295" y1="50" x2="345" y2="50" stroke="#000" stroke-width="1.2"/>
              <text x="320" y="42" font-size="7.5" font-weight="bold" text-anchor="middle">[Yes]</text>

              <!-- Activity 2 -->
              <rect x="345" y="32" width="125" height="36" rx="10" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="407" y="47" font-size="8" font-weight="bold" text-anchor="middle">Execute YOLO Model</text>
              <text x="407" y="58" font-size="7" text-anchor="middle">Bounding Box Inference</text>

              <line x1="470" y1="50" x2="500" y2="50" stroke="#000" stroke-width="1.2"/>

              <!-- Activity 3 -->
              <rect x="500" y="32" width="125" height="36" rx="10" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="562" y="47" font-size="8" font-weight="bold" text-anchor="middle">Kalman Filter Tracker</text>
              <text x="562" y="58" font-size="7" text-anchor="middle">&amp; Metric Deduplication</text>

              <line x1="625" y1="50" x2="655" y2="50" stroke="#000" stroke-width="1.2"/>

              <!-- Decision 2: Critical? (Spacious 70px wide diamond) -->
              <polygon points="655,50 690,28 725,50 690,72" fill="#ffffff" stroke="#000" stroke-width="1.2"/>
              <text x="690" y="53" font-size="7.5" font-weight="bold" text-anchor="middle">Critical?</text>

              <!-- Branch: Critical [Yes] -->
              <line x1="690" y1="72" x2="690" y2="105" stroke="#000" stroke-width="1.2"/>
              <text x="698" y="90" font-size="7.5" font-weight="bold">[Yes]</text>
              <rect x="625" y="105" width="130" height="34" rx="8" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="690" y="119" font-size="7.5" font-weight="bold" text-anchor="middle">Sound Buzzer Relay</text>
              <text x="690" y="131" font-size="7" text-anchor="middle">&amp; Red Stack Light</text>

              <!-- Branch: Non-Critical [No] (Spacious 50px line to 775) -->
              <line x1="725" y1="50" x2="775" y2="50" stroke="#000" stroke-width="1.2"/>
              <text x="750" y="42" font-size="7.5" font-weight="bold" text-anchor="middle">[No]</text>

              <!-- Activity 4: Local SQLite WAL Insert -->
              <rect x="490" y="175" width="135" height="36" rx="10" fill="#fff" stroke="#000" stroke-width="1.2"/>
              <text x="557" y="190" font-size="8" font-weight="bold" text-anchor="middle">Commit to SQLite WAL</text>
              <text x="557" y="201" font-size="7" text-anchor="middle">&amp; Trigger Web Alert</text>

              <!-- Paths connecting down to SQLite WAL -->
              <path d="M 775 50 L 775 193 L 625 193" fill="none" stroke="#000" stroke-width="1.2"/>
              <path d="M 690 139 L 690 193 L 625 193" fill="none" stroke="#000" stroke-width="1.2"/>
              <path d="M 260 139 L 260 193 L 490 193" fill="none" stroke="#000" stroke-width="1.2"/>

              <line x1="490" y1="193" x2="445" y2="193" stroke="#000" stroke-width="1.2"/>

              <!-- End Circle -->
              <circle cx="430" cy="193" r="9" fill="none" stroke="#000" stroke-width="1.2"/>
              <circle cx="430" cy="193" r="5" fill="#000"/>
            </svg>
          </div>

          <p class="body-p" style="font-weight: bold; margin-bottom: 1.5mm;">
            Table 5.6: Computational Complexity and Execution Budget per Pipeline Stage
          </p>
          <table class="req-table">
            <thead>
              <tr>
                <th style="width: 22%;">Pipeline Stage</th>
                <th style="width: 25%;">Underlying Algorithm</th>
                <th style="width: 18%;">Time Complexity</th>
                <th style="width: 18%;">Space Complexity</th>
                <th style="width: 17%;">Latency Budget</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Frame Ingestion</b></td>
                <td>V4L2 DMA-BUF zero-copy memory ring</td>
                <td>O(1) memory pointer</td>
                <td>O(W * H) buffer pool</td>
                <td>&lt; 5 ms</td>
              </tr>
              <tr>
                <td><b>Reliability Guard</b></td>
                <td>Laplacian Variance Blur + Mean Lux</td>
                <td>O(W * H)</td>
                <td>O(1) auxiliary</td>
                <td>&lt; 4 ms</td>
              </tr>
              <tr>
                <td><b>AI Inference</b></td>
                <td>TensorRT INT8 / FP16 YOLO engine</td>
                <td>O(C * K * K) conv ops</td>
                <td>O(M) weight memory</td>
                <td>&lt; 25 ms</td>
              </tr>
              <tr>
                <td><b>Kalman Tracking</b></td>
                <td>State prediction + IoU Hungarian match</td>
                <td>O(N * M) tracker pairs</td>
                <td>O(N) track state cache</td>
                <td>&lt; 3 ms</td>
              </tr>
              <tr>
                <td><b>Outbox WAL Write</b></td>
                <td>SQLite append transaction</td>
                <td>O(log B) B-tree insert</td>
                <td>O(1) per record</td>
                <td>&lt; 5 ms</td>
              </tr>
              <tr>
                <td><b>Total Pipeline</b></td>
                <td>Deterministic real-time execution loop</td>
                <td>Guaranteed bounded</td>
                <td>Bounded RAM pool</td>
                <td><b>&lt; 42 ms total</b></td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 29 -Content $p29))

    # ==================== PAGE 30: 5.6.2 SYSTEM ALGORITHMS ====================
    $p30 = @'
          <h2 class="sec-heading" style="margin-top: 0;">5.6.2 System Algorithms</h2>
          <p class="body-p">
            This section details the primary algorithms governing metric coordinate tracking, safety gating, and automated ASTM D5430 4-point penalty accumulation.
          </p>

          <!-- Algorithm 5.1 -->
          <div style="border: 1px solid #000; padding: 2mm; margin-bottom: 2.5mm; background: #fafafa;">
            <div style="font-weight: bold; font-size: 8pt; margin-bottom: 1mm; color: #000;">
              Algorithm 5.1: Encoder Quadrature Metric Coordinate Tracker
            </div>
            <pre style="margin: 0; font-family: 'Consolas', monospace; font-size: 7.2pt; line-height: 1.3; background: #fff; border: 1px solid #ddd; padding: 1.5mm;">
Input:  Delta_P (quadrature pulse delta), PPR = 1024 (pulses/rev), D_roller = 100 mm (diameter)
Output: Y_current (absolute longitudinal meters along roll)
1: Resolution_mm_per_pulse = (pi * D_roller) / (4 * PPR)
2: Distance_delta_mm = Delta_P * Resolution_mm_per_pulse
3: Y_current = Y_previous + (Distance_delta_mm / 1000.0)
4: Return Y_current
            </pre>
          </div>

          <!-- Algorithm 5.2 -->
          <div style="border: 1px solid #000; padding: 2mm; margin-bottom: 2.5mm; background: #fafafa;">
            <div style="font-weight: bold; font-size: 8pt; margin-bottom: 1mm; color: #000;">
              Algorithm 5.2: Real-Time Lighting &amp; Motion Blur Invariant Guard
            </div>
            <pre style="margin: 0; font-family: 'Consolas', monospace; font-size: 7.2pt; line-height: 1.3; background: #fff; border: 1px solid #ddd; padding: 1.5mm;">
Input:  Frame I (grayscale image), v_fabric (current fabric speed in m/s)
Output: Status in {RELIABLE, FAULT_LIGHTING, FAULT_BLUR, FAULT_OVERSPEED}
1: Mean_Illuminance_Lux = ComputeMeanPixelIntensity(I) * LuxCalibrationFactor
2: If Mean_Illuminance_Lux &lt; 800:
3:     Return FAULT_LIGHTING
4: Blur_Score = VarianceOfLaplacian(I)
5: If Blur_Score &lt; 100.0:
6:     Return FAULT_BLUR
7: If v_fabric &gt; 0.50:
8:     Return FAULT_OVERSPEED
9: Return RELIABLE
            </pre>
          </div>

          <!-- Algorithm 5.3 -->
          <div style="border: 1px solid #000; padding: 2mm; margin-bottom: 2.5mm; background: #fafafa;">
            <div style="font-weight: bold; font-size: 8pt; margin-bottom: 1mm; color: #000;">
              Algorithm 5.3: Multi-Frame Kalman Defect Associator
            </div>
            <pre style="margin: 0; font-family: 'Consolas', monospace; font-size: 7.2pt; line-height: 1.3; background: #fff; border: 1px solid #ddd; padding: 1.5mm;">
Input:  ActiveTracks T, Detections D = {b_1, b_2, ... b_k}, IoU_Threshold = 0.45
Output: UpdatedTracks T_updated, NewDefectRecords R_new
1: For each track t in T: Predict Kalman state [x, y, vx, vy] forward by dt
2: CostMatrix = Compute_IoU_Distance_Matrix(T, D)
3: Matches, UnmatchedDetections, UnmatchedTracks = LinearAssignment(CostMatrix, IoU_Threshold)
4: For each (t, d) in Matches: UpdateKalman(t, d.bbox)
5: For each d in UnmatchedDetections: CreateNewTrack(d)
6: For each t in UnmatchedTracks: If t.missed_frames &gt; 3: FinalizeAndSaveDefect(t); Remove(t)
7: Return T_updated, R_new
            </pre>
          </div>

          <!-- Algorithm 5.4 -->
          <div style="border: 1px solid #000; padding: 2mm; margin-bottom: 1.5mm; background: #fafafa;">
            <div style="font-weight: bold; font-size: 8pt; margin-bottom: 1mm; color: #000;">
              Algorithm 5.4: ASTM D5430 4-Point Penalty Accumulator
            </div>
            <pre style="margin: 0; font-family: 'Consolas', monospace; font-size: 7.2pt; line-height: 1.3; background: #fff; border: 1px solid #ddd; padding: 1.5mm;">
Input:  DefectList D, RollLength_Meters L, FabricWidth_Meters W
Output: TotalPoints, PointsPer100SqMeters, FinalGrade in {Grade A, Grade B, Reject}
1: Partition roll length into 1-meter linear bins: Bins = [0 to 1m, 1 to 2m, ..., L-1 to Lm]
2: For each defect d in D:
3:     L_mm = d.physical_length_mm
4:     If L_mm &lt;= 75.0: Points = 1
5:     Else if L_mm &lt;= 150.0: Points = 2
6:     Else if L_mm &lt;= 230.0: Points = 3
7:     Else: Points = 4
8:     If d.type == HOLE: Points = (d.diameter_mm &lt;= 25.0) ? 2 : 4
9:     Bin_Index = Floor(d.coord_y_m)
10:    Bins[Bin_Index].accumulate_points(Points)
11: For each bin b in Bins: b.points = Min(b.points, 4) // ASTM cap: max 4 points per linear meter
12: TotalPoints = Sum(b.points for b in Bins)
13: Area_SqM = L * W
14: PointsPer100SqM = (TotalPoints * 100.0) / Area_SqM
15: If PointsPer100SqM &lt;= 20.0 and MaxConsecutiveFaults &lt; 3: FinalGrade = "Grade A"
16: Else if PointsPer100SqM &lt;= 40.0: FinalGrade = "Grade B"
17: Else: FinalGrade = "Reject"
18: Return TotalPoints, PointsPer100SqM, FinalGrade
            </pre>
          </div>
'@
    $pages.Add((New-Page -PageNumber 30 -Content $p30))

    # ==================== PAGE 31: 5.6.3 DECISION TABLES & CHAPTER 6 CONCLUSION ====================
    $p31 = @'
          <h2 class="sec-heading" style="margin-top: 0;">5.6.3 Decision Tables</h2>
          <p class="body-p">
            Decision tables specify the deterministic mapping from defect physical metrics and sensor inputs to ASTM penalty scoring and hardware relay triggers.
          </p>

          <p class="body-p" style="font-weight: bold; margin-bottom: 1mm;">
            Table 5.7: ASTM D5430 4-Point Defect Penalty Decision Table
          </p>
          <table class="req-table" style="margin-bottom: 2mm;">
            <thead>
              <tr>
                <th style="width: 25%;">Defect Physical Dimension</th>
                <th style="width: 25%;">Defect Category / Pattern</th>
                <th style="width: 25%;">Assigned Penalty Points</th>
                <th style="width: 25%;">ASTM Standard Section</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Length &lt;= 75 mm (3 inches)</td>
                <td>Warp / weft float, slub, oil spot</td>
                <td><b>1 Point</b></td>
                <td>ASTM D5430 Section 8.1.1</td>
              </tr>
              <tr>
                <td>75 mm &lt; Length &lt;= 150 mm (6 in)</td>
                <td>Coarse pick, broken end, snarl</td>
                <td><b>2 Points</b></td>
                <td>ASTM D5430 Section 8.1.2</td>
              </tr>
              <tr>
                <td>150 mm &lt; Length &lt;= 230 mm (9 in)</td>
                <td>Draw-back, color streak, scratch</td>
                <td><b>3 Points</b></td>
                <td>ASTM D5430 Section 8.1.3</td>
              </tr>
              <tr>
                <td>Length &gt; 230 mm (9 inches)</td>
                <td>Tear, continuous ladder, miss-pick</td>
                <td><b>4 Points</b></td>
                <td>ASTM D5430 Section 8.1.4</td>
              </tr>
              <tr>
                <td>Hole / Opening &lt;= 25 mm (1 in)</td>
                <td>Puncture, small needle hole</td>
                <td><b>2 Points</b></td>
                <td>ASTM D5430 Section 8.2.1</td>
              </tr>
              <tr>
                <td>Hole / Opening &gt; 25 mm (1 in)</td>
                <td>Large tear, cutout, blow-out</td>
                <td><b>4 Points</b></td>
                <td>ASTM D5430 Section 8.2.2</td>
              </tr>
            </tbody>
          </table>

          <p class="body-p" style="font-weight: bold; margin-bottom: 1mm;">
            Table 5.8: Stand Alarm Actuation Decision Matrix
          </p>
          <table class="req-table" style="margin-bottom: 2.5mm;">
            <thead>
              <tr>
                <th style="width: 20%;">Inspection Condition</th>
                <th style="width: 15%;">Amber Light</th>
                <th style="width: 15%;">Red Light</th>
                <th style="width: 15%;">Audio Buzzer</th>
                <th style="width: 35%;">System Action &amp; Roll Status</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Nominal Inspection</b></td>
                <td>OFF</td>
                <td>OFF</td>
                <td>OFF</td>
                <td>Real-time AI inferencing active; encoder accumulation continuous.</td>
              </tr>
              <tr>
                <td><b>Sensor Fault (Lux / Blur)</b></td>
                <td><b>ON</b></td>
                <td>OFF</td>
                <td>OFF</td>
                <td>Inference suspended; uninspected longitudinal interval logged.</td>
              </tr>
              <tr>
                <td><b>Critical Defect (Hole &gt; 25mm)</b></td>
                <td>OFF</td>
                <td><b>ON</b></td>
                <td><b>ON (1.5s)</b></td>
                <td>Halt stand recommendation; operator vibration notification sent.</td>
              </tr>
              <tr>
                <td><b>Roll Completed / Grading</b></td>
                <td>OFF</td>
                <td>OFF</td>
                <td>OFF</td>
                <td>Audit trail finalized; outbox synced; inspection certificate compiled.</td>
              </tr>
            </tbody>
          </table>

          <div class="chapter-bar" style="margin-top: 1.5mm;">6 Conclusion and Project Sign-Off</div>
          <p class="body-p">
            This Software Requirement and Design Specification establishes the authoritative technical blueprint for <b>TexEye AI</b>. By uniting edge AI vision (YOLO), hardware-synchronized rotary encoding, offline-first transactional outbox synchronization, and strict compliance with the ASTM D5430 standard, TexEye AI replaces manual, error-prone fabric inspection with an autonomous, high-throughput, and publication-grade industrial quality management system.
          </p>

          <div style="border: 1.5px solid #000; padding: 2.5mm; background: #ffffff; margin-top: 2.5mm;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 2mm; text-transform: uppercase;">
              Final Year Capstone Project Endorsement and Sign-Off
            </div>
            <div style="display: flex; justify-content: space-between; font-size: 8pt; line-height: 1.4;">
              <div style="flex: 1; padding-right: 3mm;">
                <b>Student Developers:</b><br/>
                Muhammad Afnan Khan (FA23-BAI-028)<br/>
                Muhammad Bilal Butt (FA23-BAI-042)<br/>
                Bachelor of Science in Artificial Intelligence
              </div>
              <div style="flex: 1; border-left: 1px solid #ccc; padding-left: 3mm;">
                <b>Project Supervisor:</b><br/>
                <b>Dr. Tassawar Iqbal</b><br/>
                Department of Computer Science<br/>
                COMSATS University Islamabad, Wah Cantt Campus
              </div>
            </div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 31 -Content $p31))

    return $pages
}

Write-Output "Compact Pages 22 to 31 module loaded."



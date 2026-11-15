# Part 5: Pages 51 to 62
function Get-Pages-51-to-62 {
    $pages = [System.Collections.Generic.List[string]]::new()

    # ==================== PAGE 51: FIGURE 5.9 REVIEW & CORRECT DEFECT ====================
    $p51 = @'
          <h3 class="subsec-heading">5.4.5 Sequence Diagram for Review & Correct Defect Classification (UC-09)</h3>
          <p>
            Figure 5.9 illustrates the interaction when a Quality Inspector reviews flagged flaw crops on the web dashboard, verifies or modifies the AI defect class, and records an immutable audit log entry.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/08_dfd_level_0.svg" alt="DFD Level 0" style="max-height: 200mm;" />
            <div class="caption">Figure 5.9: Sequence diagram for UC-09 Review & Correct Defect Classification</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 51 -Content $p51))

    # ==================== PAGE 52: FIGURE 5.10 COMPUTE ASTM 4-POINT GRADE ====================
    $p52 = @'
          <h3 class="subsec-heading">5.4.6 Sequence Diagram for Compute ASTM D5430 4-Point Grade (UC-10)</h3>
          <p>
            Figure 5.10 depicts the calculation workflow: querying confirmed roll defects, evaluating flaw lengths, applying the 4-point linear meter cap, calculating points per 100 m&sup2;, and assigning official roll grades.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/09_dfd_level_1.svg" alt="DFD Level 1" style="max-height: 200mm;" />
            <div class="caption">Figure 5.10: Sequence diagram for UC-10 Compute ASTM D5430 4-Point Grade</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 52 -Content $p52))

    # ==================== PAGE 53: FIGURE 5.11 EXPORT PDF QUALITY CERTIFICATE ====================
    $p53 = @'
          <h3 class="subsec-heading">5.4.7 Sequence Diagram for Export PDF Quality Certificate (UC-12)</h3>
          <p>
            Figure 5.11 details the generation of tamper-evident PDF inspection certificates: compiling scorecard data, computing the SHA-256 cryptographic verification digest, and uploading to MinIO object storage.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/03_offline_sync_workflow.svg" alt="Offline Sync Workflow" style="max-height: 200mm;" />
            <div class="caption">Figure 5.11: Sequence diagram for UC-12 Export PDF Quality Certificate</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 53 -Content $p53))

    # ==================== PAGE 54: 5.5 STATE DYNAMICS & FIGURE 5.12 ====================
    $p54 = @'
          <h2 class="sec-heading">5.5 State Dynamics Viewpoint</h2>
          <h3 class="subsec-heading">5.5.1 State Machine Diagram: Roll Inspection Run</h3>
          <p>
            The lifecycle of an edge inspection session is governed by a strict deterministic finite state machine (FSM). Figure 5.12 details the operational states, sensor event triggers, and state transitions.
          </p>
          <div class="diagram-container">
            <!-- Custom High-Fidelity SVG State Chart for Roll Lifecycle -->
            <svg viewBox="0 0 700 480" width="100%" height="100%" style="background:#fff; font-family:Arial, sans-serif;">
              <!-- Start Node -->
              <circle cx="350" cy="30" r="12" fill="#000" />
              <line x1="350" y1="42" x2="350" y2="70" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="360" y="58" font-size="9" font-weight="bold">scan_qr</text>

              <!-- State: INITIALIZING -->
              <rect x="260" y="70" width="180" height="40" rx="8" fill="#fff" stroke="#000" stroke-width="1.5" />
              <text x="350" y="88" font-size="11" font-weight="bold" text-anchor="middle">INITIALIZING</text>
              <text x="350" y="102" font-size="8.5" text-anchor="middle">Do: Zero encoder, check sensors</text>

              <line x1="350" y1="110" x2="350" y2="145" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="360" y="130" font-size="9" font-weight="bold">sensors_ok</text>

              <!-- State: RUNNING -->
              <rect x="250" y="145" width="200" height="48" rx="8" fill="#fff" stroke="#000" stroke-width="1.5" />
              <text x="350" y="165" font-size="12" font-weight="bold" text-anchor="middle">RUNNING</text>
              <text x="350" y="180" font-size="8.5" text-anchor="middle">Do: Ingest, infer YOLO, track Kalman</text>

              <!-- Transition to PAUSED -->
              <path d="M 250 160 L 140 160 L 140 230" fill="none" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="180" y="152" font-size="9" font-weight="bold">operator_pause</text>

              <!-- State: PAUSED -->
              <rect x="60" y="230" width="160" height="45" rx="8" fill="#fff" stroke="#000" stroke-width="1.5" />
              <text x="140" y="250" font-size="11" font-weight="bold" text-anchor="middle">PAUSED</text>
              <text x="140" y="264" font-size="8.5" text-anchor="middle">Do: Freeze encoder accumulator</text>

              <path d="M 160 230 L 160 185 L 250 185" fill="none" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="170" y="198" font-size="9" font-weight="bold">operator_resume</text>

              <!-- Transition to UNINSPECTED_FAULT -->
              <path d="M 450 160 L 560 160 L 560 230" fill="none" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="465" y="152" font-size="9" font-weight="bold">sensor_fault [lux&lt;800 | blur]</text>

              <!-- State: UNINSPECTED_FAULT -->
              <rect x="470" y="230" width="180" height="50" rx="8" fill="#fff" stroke="#000" stroke-width="1.5" />
              <text x="560" y="250" font-size="11" font-weight="bold" text-anchor="middle">UNINSPECTED_FAULT</text>
              <text x="560" y="264" font-size="8.5" text-anchor="middle">Do: Suspend AI, record [Y_start, Y_end]</text>
              <text x="560" y="274" font-size="8" text-anchor="middle">Actuate Amber Stack Light</text>

              <!-- Return from fault -->
              <path d="M 540 230 L 540 185 L 450 185" fill="none" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="465" y="198" font-size="9" font-weight="bold">sensors_recovered</text>

              <!-- Transition to ALARM_ACTIVE -->
              <line x1="350" y1="193" x2="350" y2="240" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="360" y="218" font-size="9" font-weight="bold">critical_defect [hole&gt;25mm | cluster]</text>

              <!-- State: ALARM_ACTIVE -->
              <rect x="250" y="240" width="200" height="48" rx="8" fill="#fff" stroke="#000" stroke-width="1.5" />
              <text x="350" y="260" font-size="11" font-weight="bold" text-anchor="middle">ALARM_ACTIVE</text>
              <text x="350" y="274" font-size="8.5" text-anchor="middle">Do: Relay Red light, sound buzzer</text>

              <line x1="350" y1="288" x2="350" y2="330" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="360" y="310" font-size="9" font-weight="bold">operator_ack</text>

              <!-- State: FINALIZING -->
              <rect x="260" y="330" width="180" height="42" rx="8" fill="#fff" stroke="#000" stroke-width="1.5" />
              <text x="350" y="348" font-size="11" font-weight="bold" text-anchor="middle">FINALIZING</text>
              <text x="350" y="362" font-size="8.5" text-anchor="middle">Do: Close tracks, compute ASTM</text>

              <line x1="350" y1="372" x2="350" y2="415" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="360" y="395" font-size="9" font-weight="bold">grading_done</text>

              <!-- End Node -->
              <circle cx="350" cy="435" r="14" fill="#fff" stroke="#000" stroke-width="1.5" />
              <circle cx="350" cy="435" r="9" fill="#000" />
            </svg>
            <div class="caption">Figure 5.12: State machine diagram: roll inspection run</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 54 -Content $p54))

    # ==================== PAGE 55: TABLE 5.4 STATE TRANSITION TABLE ====================
    $p55 = @'
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1.5mm;">Table 5.4: State transition table: roll inspection run</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 18%;">Current State</th>
                <th style="width: 25%;">Trigger Event / Guard Condition</th>
                <th style="width: 18%;">Next State</th>
                <th style="width: 39%;">Action Executed on Transition</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>STANDBY</b></td>
                <td><code>scan_qr_code(roll_id)</code></td>
                <td><b>INITIALIZING</b></td>
                <td>Validate roll metadata; create session in SQLite; zero encoder hardware counter.</td>
              </tr>
              <tr>
                <td><b>INITIALIZING</b></td>
                <td><code>sensors_verified(lux &gt; 800, fps &gt; 28)</code></td>
                <td><b>RUNNING</b></td>
                <td>Illuminate green status indicator; enable V4L2 frame ring buffer.</td>
              </tr>
              <tr>
                <td><b>INITIALIZING</b></td>
                <td><code>sensor_init_failure</code></td>
                <td><b>STANDBY</b></td>
                <td>Log diagnostic error; actuate amber tower beacon; notify operator.</td>
              </tr>
              <tr>
                <td><b>RUNNING</b></td>
                <td><code>encoder_advance(step)</code></td>
                <td><b>RUNNING</b></td>
                <td>Execute YOLO inference; update Kalman tracks; log metric coordinates $(X, Y)$.</td>
              </tr>
              <tr>
                <td><b>RUNNING</b></td>
                <td><code>critical_flaw_detected</code></td>
                <td><b>ALARM_ACTIVE</b></td>
                <td>Assert GPIO Pin 17 (close 24V relay); sound buzzer; dispatch mobile vibration alert.</td>
              </tr>
              <tr>
                <td><b>RUNNING</b></td>
                <td><code>sensor_fault(lux &lt; 800 | blur)</code></td>
                <td><b>UNINSPECTED</b></td>
                <td>Record $Y_{\text{start}}$; suspend AI classification; actuate amber warning beacon.</td>
              </tr>
              <tr>
                <td><b>RUNNING</b></td>
                <td><code>operator_pause_button</code></td>
                <td><b>PAUSED</b></td>
                <td>Freeze pulse accumulator; pause frame capture; update UI status.</td>
              </tr>
              <tr>
                <td><b>UNINSPECTED</b></td>
                <td><code>sensors_recovered</code></td>
                <td><b>RUNNING</b></td>
                <td>Record $Y_{\text{end}}$; write <code>uninspected_section</code> entity to SQLite; resume AI inference.</td>
              </tr>
              <tr>
                <td><b>PAUSED</b></td>
                <td><code>operator_resume_button</code></td>
                <td><b>RUNNING</b></td>
                <td>Re-enable encoder pulse ISR; resume optical ingestion.</td>
              </tr>
              <tr>
                <td><b>ALARM_ACTIVE</b></td>
                <td><code>operator_ack_button</code></td>
                <td><b>RUNNING</b></td>
                <td>De-assert buzzer relay; log acknowledgment timestamp; keep visual beacon on.</td>
              </tr>
              <tr>
                <td><b>RUNNING</b></td>
                <td><code>end_of_roll_detected</code></td>
                <td><b>FINALIZING</b></td>
                <td>Flush remaining Kalman tracks; commit last frame metrics; invoke ASTM grading.</td>
              </tr>
              <tr>
                <td><b>FINALIZING</b></td>
                <td><code>grading_complete</code></td>
                <td><b>COMPLETED</b></td>
                <td>Assign Grade A/B/C/Reject; push outbox batch to central cloud; export report.</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 55 -Content $p55))

    # ==================== PAGE 56: 5.5.2 STATE MACHINE OFFLINE SYNC OUTBOX ====================
    $p56 = @'
          <h3 class="subsec-heading">5.5.2 State Machine Diagram: Offline Sync Outbox Queue</h3>
          <p>
            The offline transactional outbox operates an independent daemon state machine managing resilient batch dispatch to the central cloud. Figure 5.13 and Table 5.5 specify outbox queue states and transitions.
          </p>
          <div class="diagram-container" style="max-height: 80mm; margin-bottom: 2mm;">
            <svg viewBox="0 0 650 160" width="100%" height="100%" style="background:#fff; font-family:Arial, sans-serif;">
              <circle cx="40" cy="80" r="10" fill="#000" />
              <line x1="50" y1="80" x2="100" y2="80" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="60" y="72" font-size="8.5" font-weight="bold">insert_event</text>

              <rect x="100" y="55" width="110" height="50" rx="6" fill="#fff" stroke="#000" stroke-width="1.5" />
              <text x="155" y="78" font-size="11" font-weight="bold" text-anchor="middle">PENDING</text>
              <text x="155" y="93" font-size="8" text-anchor="middle">Committed in SQLite</text>

              <line x1="210" y1="80" x2="280" y2="80" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="220" y="72" font-size="8.5" font-weight="bold">net_online &amp; post</text>

              <rect x="280" y="55" width="120" height="50" rx="6" fill="#fff" stroke="#000" stroke-width="1.5" />
              <text x="340" y="78" font-size="11" font-weight="bold" text-anchor="middle">IN_FLIGHT</text>
              <text x="340" y="93" font-size="8" text-anchor="middle">HTTPS POST active</text>

              <!-- Success Transition -->
              <line x1="400" y1="80" x2="480" y2="80" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="415" y="72" font-size="8.5" font-weight="bold">HTTP 200 OK</text>

              <rect x="480" y="55" width="110" height="50" rx="6" fill="#fff" stroke="#000" stroke-width="1.5" />
              <text x="535" y="78" font-size="11" font-weight="bold" text-anchor="middle">SYNCED</text>
              <text x="535" y="93" font-size="8" text-anchor="middle">Marked complete</text>

              <!-- Failure Loop -->
              <path d="M 340 105 L 340 140 L 155 140 L 155 105" fill="none" stroke="#000" stroke-width="1.5" marker-end="url(#arr)" />
              <text x="210" y="133" font-size="8.5" font-weight="bold">timeout / net_fail [backoff retry]</text>
            </svg>
            <div class="caption">Figure 5.13: State machine diagram: offline sync outbox queue</div>
          </div>
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 1mm;">Table 5.5: State transition table: offline sync outbox queue</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 20%;">Current State</th>
                <th style="width: 25%;">Trigger Event / Guard</th>
                <th style="width: 20%;">Next State</th>
                <th style="width: 35%;">Action Executed</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>(New Event)</b></td>
                <td>Defect or section committed</td>
                <td><b>PENDING</b></td>
                <td>Insert into <code>outbox_events</code> within atomic SQLite transaction.</td>
              </tr>
              <tr>
                <td><b>PENDING</b></td>
                <td>Server reachable & batch ready</td>
                <td><b>IN_FLIGHT</b></td>
                <td>Assemble multipart payload; send HTTPS POST to <code>/api/v1/sync/batch</code>.</td>
              </tr>
              <tr>
                <td><b>IN_FLIGHT</b></td>
                <td>Received <code>HTTP 200 OK</code></td>
                <td><b>SYNCED</b></td>
                <td>Record <code>synced_at</code> timestamp; mark crop files eligible for 48h cleanup.</td>
              </tr>
              <tr>
                <td><b>IN_FLIGHT</b></td>
                <td>Connection dropped / timeout</td>
                <td><b>PENDING</b></td>
                <td>Increment <code>retry_count</code>; calculate exponential backoff interval (5s to 60s).</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 56 -Content $p56))

    # ==================== PAGE 57: 5.6 ALGORITHM VIEWPOINT & FIGURE 5.14 ====================
    $p57 = @'
          <h2 class="sec-heading">5.6 Algorithm Viewpoint</h2>
          <h3 class="subsec-heading">5.6.1 Activity Diagram of the System</h3>
          <p>
            The activity diagram in Figure 5.14 traces the end-to-end operational execution of TexEye AI, from raw roll QR scanning to optical inspection, invariant gating, ASTM grading, and cloud synchronization.
          </p>
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/01_system_workflow.svg" alt="System Workflow Activity Diagram" style="max-height: 205mm;" />
            <div class="caption">Figure 5.14: Activity diagram of the overall inspection and grading system</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 57 -Content $p57))

    # ==================== PAGE 58: 5.6.2 SYSTEM ALGORITHMS (PART 1) ====================
    $p58 = @'
          <h3 class="subsec-heading">5.6.2 Pseudocode of the System</h3>
          <p>
            The mission-critical logic governing edge ingestion, YOLO tracking, metrology, grading, and offline synchronization is specified formally in Algorithms 5.1 through 5.6.
          </p>
          <div style="font-weight: bold; font-size: 8.5pt;">Algorithm 5.1: High-Speed Ingestion & Encoder Synchronous Frame Gate</div>
          <pre class="code-block">
procedure ON_ENCODER_QUADRATURE_INTERRUPT(channel_state)
    pulses_accumulated &larr; pulses_accumulated + 1
    displacement_current_m &larr; pulses_accumulated &times; (PI &times; ROLLER_DIAMETER_MM) / (PPR &times; 1000.0)
    
    // Check if fabric has advanced by the calibrated step distance
    if (displacement_current_m - displacement_last_trigger_m) &ge; CALIBRATED_FRAME_STEP_M then
        displacement_last_trigger_m &larr; displacement_current_m
        frame &larr; CAMERA_DRIVER.GET_LATEST_RECTIFIED_FRAME()
        
        // Push frame to processing queue with current metric timestamp
        FRAME_QUEUE.PUSH({
            frame_id: GENERATE_UUID(),
            timestamp: GET_MONOTONIC_TIME(),
            y_meters: displacement_current_m,
            image_buffer: frame
        })
    end if
end procedure
          </pre>
          <div style="font-weight: bold; font-size: 8.5pt; margin-top: 2mm;">Algorithm 5.2: Real-Time Defect Inference & Multi-Frame Kalman Tracking</div>
          <pre class="code-block">
procedure PROCESS_EDGE_INSPECTION_FRAME(frame_item)
    // Step 1: Execute TensorRT FP16 YOLO Inference
    detections &larr; TENSORRT_YOLO_ENGINE.INFER(frame_item.image_buffer)
    
    // Step 2: Multi-Frame Kalman Association
    KALMAN_TRACKER.PREDICT_ALL_TRACKS()
    matched_tracks, unmatched_dets, lost_tracks &larr; KALMAN_TRACKER.HUNGARIAN_MATCH(detections, IOU_THRESHOLD=0.35)
    
    for each (track, det) in matched_tracks do
        track.UPDATE(det.bbox, det.confidence, frame_item.y_meters)
        if track.consecutive_hits &ge; 3 and not track.is_confirmed then
            track.is_confirmed &larr; TRUE
        end if
    end for
    
    for each det in unmatched_dets do
        KALMAN_TRACKER.INIT_NEW_TRACK(det, frame_item.y_meters)
    end for
    
    // Step 3: Finalize closed tracks exiting the field of view
    for each track in lost_tracks do
        if track.is_confirmed and track.frames_lost &gt; MAX_LOST_FRAMES then
            defect_record &larr; COMPUTE_PHYSICAL_METROLOGY(track, frame_item)
            LOCAL_OUTBOX.INSERT_DEFECT(defect_record)
            if defect_record.penalty_points &ge; 4 then
                TRIGGER_RELAY_ALARM(SEVERITY_CRITICAL)
            end if
            KALMAN_TRACKER.DELETE_TRACK(track)
        end if
    end for
end procedure
          </pre>
'@
    $pages.Add((New-Page -PageNumber 58 -Content $p58))

    # ==================== PAGE 59: SYSTEM ALGORITHMS (PART 2) ====================
    $p59 = @'
          <div style="font-weight: bold; font-size: 8.5pt;">Algorithm 5.3: Metric Physical Coordinate Mapping ($X, Y$)</div>
          <pre class="code-block">
procedure COMPUTE_PHYSICAL_METROLOGY(track, current_frame)
    // Map lateral pixel coordinates to physical millimeters across fabric web
    u_center &larr; (track.bbox.u_min + track.bbox.u_max) / 2.0
    x_physical_mm &larr; u_center &times; CALIBRATION_KX_MM_PER_PIXEL
    width_physical_mm &larr; (track.bbox.u_max - track.bbox.u_min) &times; CALIBRATION_KX_MM_PER_PIXEL
    
    // Map longitudinal encoder displacement to continuous meters
    y_physical_meters &larr; track.start_y_meters
    length_physical_mm &larr; MAX((track.end_y_meters - track.start_y_meters) &times; 1000.0, 
                             (track.bbox.v_max - track.bbox.v_min) &times; CALIBRATION_KY_MM_PER_PIXEL)
    
    return {
        defect_id: track.uuid,
        class_label: track.majority_class,
        confidence: track.mean_confidence,
        x_mm: x_physical_mm,
        y_meters: y_physical_meters,
        width_mm: width_physical_mm,
        length_mm: length_physical_mm,
        penalty_points: ASTM_ASSIGN_POINTS(track.majority_class, MAX(width_physical_mm, length_physical_mm))
    }
end procedure
          </pre>
          <div style="font-weight: bold; font-size: 8.5pt; margin-top: 2mm;">Algorithm 5.4: ASTM D5430-07 4-Point Penalty Calculation & Roll Grading</div>
          <pre class="code-block">
procedure COMPUTE_ASTM_ROLL_GRADE(roll_id, defects_list, uninspected_list, roll_length_m, fabric_width_m)
    // Non-Negotiable Invariant Check
    if uninspected_list.LENGTH &gt; 0 then
        return { grade: "REJECT", reason: "CONTAINS_UNINSPECTED_SECTIONS", points_per_100sqm: NULL }
    end if
    
    // Partition roll into 1-meter longitudinal bins
    meter_bins &larr; ARRAY(SIZE = CEIL(roll_length_m), INITIAL_VALUE = 0)
    for each defect in defects_list do
        bin_index &larr; FLOOR(defect.y_meters)
        meter_bins[bin_index] &larr; meter_bins[bin_index] + defect.penalty_points
    end for
    
    // Enforce ASTM D5430 Rule: Maximum 4 points per linear meter
    total_capped_points &larr; 0
    for each meter_points in meter_bins do
        total_capped_points &larr; total_capped_points + MIN(meter_points, 4)
    end for
    
    // Normalize to points per 100 square meters
    total_area_sqm &larr; roll_length_m &times; fabric_width_m
    points_per_100sqm &larr; (total_capped_points &times; 100.0) / total_area_sqm
    
    // Assign Commercial Roll Grade
    if points_per_100sqm &le; 20.0 then grade &larr; "GRADE_A"
    else if points_per_100sqm &le; 28.0 then grade &larr; "GRADE_B"
    else if points_per_100sqm &le; 40.0 then grade &larr; "GRADE_C"
    else grade &larr; "REJECT"
    
    return { grade: grade, total_points: total_capped_points, points_per_100sqm: points_per_100sqm }
end procedure
          </pre>
'@
    $pages.Add((New-Page -PageNumber 59 -Content $p59))

    # ==================== PAGE 60: SYSTEM ALGORITHMS (PART 3) ====================
    $p60 = @'
          <div style="font-weight: bold; font-size: 8.5pt;">Algorithm 5.5: Reliability Monitoring & Uninspected Section Invariant Guard</div>
          <pre class="code-block">
procedure EVALUATE_RELIABILITY_INVARIANT(frame, current_y_meters, last_frame_time)
    current_time &larr; GET_MONOTONIC_TIME()
    time_delta_ms &larr; (current_time - last_frame_time) &times; 1000.0
    
    // Sensor Metric Calculations
    mean_luminance &larr; COMPUTE_MEAN_BRIGHTNESS(frame)
    laplacian_var &larr; COMPUTE_LAPLACIAN_VARIANCE(frame)
    
    fault_detected &larr; FALSE
    reason &larr; "HEALTHY"
    
    if time_delta_ms &gt; 100.0 then
        fault_detected &larr; TRUE; reason &larr; "CAMERA_FRAME_DROP"
    else if mean_luminance &lt; 800.0 or mean_luminance &gt; 2500.0 then
        fault_detected &larr; TRUE; reason &larr; "LIGHTING_OUT_OF_TOLERANCE"
    else if laplacian_var &lt; 100.0 then
        fault_detected &larr; TRUE; reason &larr; "OPTICAL_MOTION_BLUR"
    end if
    
    // Invariant Enforcement State Machine
    if fault_detected and not IS_FAULT_ACTIVE then
        IS_FAULT_ACTIVE &larr; TRUE
        ACTIVE_FAULT_START_Y &larr; current_y_meters
        ACTUATE_RELAY(PIN_AMBER_LIGHT, TRUE)
        DISABLE_AI_CLASSIFICATION()
    else if not fault_detected and IS_FAULT_ACTIVE then
        IS_FAULT_ACTIVE &larr; FALSE
        LOCAL_OUTBOX.RECORD_UNINSPECTED_SECTION(ACTIVE_FAULT_START_Y, current_y_meters, reason)
        ACTUATE_RELAY(PIN_AMBER_LIGHT, FALSE)
        ENABLE_AI_CLASSIFICATION()
    end if
end procedure
          </pre>
          <div style="font-weight: bold; font-size: 8.5pt; margin-top: 2mm;">Algorithm 5.6: Transactional Outbox Batch Dispatcher & Resilient Cloud Ingestion</div>
          <pre class="code-block">
procedure DISPATCH_OUTBOX_BATCHES()
    loop forever
        if CHECK_SERVER_CONNECTIVITY("/api/v1/health") then
            pending_events &larr; SQLITE_DB.QUERY("SELECT * FROM outbox_events WHERE status = 'PENDING' LIMIT 50")
            if pending_events.LENGTH &gt; 0 then
                payload &larr; CONSTRUCT_MULTIPART_BATCH(pending_events)
                response &larr; HTTP_POST("/api/v1/sync/batch", payload, TIMEOUT=15.0)
                
                if response.status_code == 200 then
                    synced_ids &larr; response.json().committed_uuids
                    SQLITE_DB.EXECUTE("UPDATE outbox_events SET status = 'SYNCED', synced_at = ? WHERE id IN (?)", 
                                      GET_CURRENT_TIMESTAMP(), synced_ids)
                else
                    EXPONENTIAL_BACKOFF(retry_count++)
                end if
            end if
        end if
        SLEEP(POLLING_INTERVAL_SECONDS = 5)
    end loop
end procedure
          </pre>
'@
    $pages.Add((New-Page -PageNumber 60 -Content $p60))

    # ==================== PAGE 61: 5.6.3 DECISION TABLES ====================
    $p61 = @'
          <h3 class="subsec-heading">5.6.3 Decision Tables</h3>
          <p>
            Complex conditional decision rules for physical alarm actuation and ASTM D5430 penalty assignment are formalized in Tables 5.6 and 5.7.
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 5.6: Decision table: inspection reliability gating and alarm actuation</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 45%;">Condition / Action</th>
                <th style="width: 9%; text-align: center;">R1</th>
                <th style="width: 9%; text-align: center;">R2</th>
                <th style="width: 9%; text-align: center;">R3</th>
                <th style="width: 9%; text-align: center;">R4</th>
                <th style="width: 9%; text-align: center;">R5</th>
                <th style="width: 10%; text-align: center;">R6</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Illumination lux in range [800, 2500]</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">N</td>
              </tr>
              <tr>
                <td>Camera delivery interval &le; 100 ms</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">–</td>
              </tr>
              <tr>
                <td>Laplacian variance &ge; 100 (sharp)</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">–</td>
              </tr>
              <tr>
                <td>Critical flaw detected (Hole &gt; 25mm | Cluster)</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">–</td>
              </tr>
              <tr style="background-color: #f7fafc; font-weight: bold;">
                <td>&rarr; Execute normal YOLO inference & tracking</td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;"></td>
              </tr>
              <tr style="background-color: #f7fafc; font-weight: bold;">
                <td>&rarr; Suspend classification & log UNINSPECTED</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;">X</td>
              </tr>
              <tr style="background-color: #f7fafc; font-weight: bold;">
                <td>&rarr; Actuate Amber Warning Beacon</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;">X</td>
              </tr>
              <tr style="background-color: #f7fafc; font-weight: bold;">
                <td>&rarr; Actuate Red Stack Light + Buzzer</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;"></td>
              </tr>
            </tbody>
          </table>
          <div style="font-weight: bold; font-size: 8.5pt; margin-top: 2.5mm; margin-bottom: 1mm;">Table 5.7: Decision table: defect penalty point assignment (ASTM D5430-07)</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 45%;">Condition / Defect Dimension</th>
                <th style="width: 11%; text-align: center;">R1</th>
                <th style="width: 11%; text-align: center;">R2</th>
                <th style="width: 11%; text-align: center;">R3</th>
                <th style="width: 11%; text-align: center;">R4</th>
                <th style="width: 11%; text-align: center;">R5</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Defect type is Hole or Tear</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">Y</td>
              </tr>
              <tr>
                <td>Maximum defect dimension &le; 75 mm (3 inches)</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">–</td>
              </tr>
              <tr>
                <td>Dimension &gt; 75 mm and &le; 150 mm (6 inches)</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">–</td>
              </tr>
              <tr>
                <td>Dimension &gt; 150 mm and &le; 230 mm (9 inches)</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">N</td>
                <td style="text-align: center;">–</td>
              </tr>
              <tr>
                <td>Dimension &gt; 230 mm (9 inches)</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">Y</td>
                <td style="text-align: center;">–</td>
              </tr>
              <tr>
                <td>Hole dimension &gt; 25 mm (1 inch)</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">–</td>
                <td style="text-align: center;">Y</td>
              </tr>
              <tr style="background-color: #f7fafc; font-weight: bold;">
                <td>&rarr; Assign 1 Penalty Point</td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
              </tr>
              <tr style="background-color: #f7fafc; font-weight: bold;">
                <td>&rarr; Assign 2 Penalty Points</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;">(if &le; 25mm)</td>
              </tr>
              <tr style="background-color: #f7fafc; font-weight: bold;">
                <td>&rarr; Assign 3 Penalty Points</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
              </tr>
              <tr style="background-color: #f7fafc; font-weight: bold;">
                <td>&rarr; Assign 4 Penalty Points (Maximum per flaw)</td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;"></td>
                <td style="text-align: center;">X</td>
                <td style="text-align: center;">X</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 61 -Content $p61))

    # ==================== PAGE 62: CHAPTER 6 CONCLUSION ====================
    $p62 = @'
          <div class="chapter-bar">6 Conclusion</div>
          <p>
            This Software Requirements and Design Specification (SRDS) has articulated the comprehensive engineering foundation for <b>TexEye AI</b>, an industrial-grade edge-cloud automated fabric defect inspection and digitized quality management system developed as a capstone project at COMSATS University Islamabad, Wah Campus.
          </p>
          <p>
            By rigorously analyzing the acute operational vulnerabilities of manual fabric inspection in Pakistani textile manufacturing plants—specifically visual accommodation fatigue, unrecorded spatial defect coordinates, paper-bound roll logs, and subjective grading inconsistencies—TexEye AI provides a scientifically grounded, cyber-physical solution. The system couples high-frequency optical ingestion with hardware rotary encoder displacement metrology, achieving real-time TensorRT YOLO defect localization and multi-frame Kalman deduplication at sub-25ms edge latencies.
          </p>
          <p>
            Crucially, the architecture resolves the industry's pervasive problem of false-clean grading through the mathematical enforcement of the <b>Non-Negotiable Inspection Reliability Invariant</b>. By treating illumination, frame ingestion intervals, and optical blur as strict precondition gates, TexEye AI guarantees that uninspected fabric is never falsely certified as prime quality. Furthermore, the transactional SQLite Write-Ahead Logging outbox guarantees complete offline data resilience during frequent industrial mill network outages, with automated two-phase synchronization once connectivity is restored.
          </p>
          <p>
            The software design models specified herein—encompassing detailed package, deployment, class, entity-relationship, sequence, state machine, and algorithmic viewpoints—establish the authoritative blueprint for production implementation, bench testing, and subsequent industrial shop-floor deployment. TexEye AI demonstrates how modern artificial intelligence, when integrated with robust embedded hardware design and rigorous software engineering standards, can tangibly elevate quality assurance across Pakistan's industrial textile manufacturing sector.
          </p>
          <div style="margin-top: 25mm; border-top: 1.5pt solid #000000; padding-top: 6mm; text-align: center;">
            <div style="font-size: 11pt; font-weight: bold; color: #1a202c;">Department of Computer Science</div>
            <div style="font-size: 10pt; color: #4a5568; margin-top: 1mm;">COMSATS University Islamabad, Wah Campus &bull; Session 2026&ndash;2027</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 62 -Content $p62))

    return $pages
}

Write-Output "Pages 51 to 62 module loaded."


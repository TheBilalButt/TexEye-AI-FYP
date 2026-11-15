# Part 1: Pages 1 to 11 (Compact COMSATS Wah Standard)
function Get-Compact-Pages-1-to-11 {
    $pages = [System.Collections.Generic.List[string]]::new()

    # ==================== PAGE 1: COVER PAGE ====================
    $p1 = @'
          <div style="height: 100%; display: flex; flex-direction: column; justify-content: space-between; padding: 6mm 4mm;">
            <!-- Top Dark Banner (Exact ReDez Standard) -->
            <div style="display: flex; height: 11mm; border: 1px solid #2d3748;">
              <div style="flex: 1; background-color: #2d3748; color: #ffffff; display: flex; align-items: center; padding-left: 5mm; font-size: 13pt; font-weight: bold; letter-spacing: 0.5px;">
                FYP Document &ldquo;TexEye AI&rdquo;
              </div>
              <div style="width: 28mm; background-color: #cbd5e0; color: #000000; display: flex; align-items: center; justify-content: center; font-size: 12pt; font-weight: bold;">
                2026
              </div>
            </div>

            <!-- University & Department Header -->
            <div style="text-align: center; margin-top: 14mm;">
              <div style="font-size: 14.5pt; font-weight: bold; color: #000000;">COMSATS University Islamabad, Wah Campus</div>
              <div style="font-size: 12pt; color: #2d3748; margin-top: 2mm;">Department of Computer Science</div>
            </div>

            <!-- Main Title & Subtitle -->
            <div style="text-align: center; margin-top: 20mm;">
              <div style="font-size: 38pt; font-weight: bold; color: #000000; letter-spacing: 0.5px;">TexEye AI</div>
              <div style="font-size: 13pt; color: #1a202c; margin-top: 4mm; max-width: 145mm; margin-left: auto; margin-right: auto; line-height: 1.45;">
                An AI-Based Fabric Defect Detection and Quality Management System
              </div>
            </div>

            <!-- Supervisor Block -->
            <div style="text-align: center; margin-top: 18mm;">
              <div style="font-size: 11pt; font-style: italic; color: #4a5568;">Supervised by</div>
              <div style="font-size: 13.5pt; font-weight: bold; color: #000000; margin-top: 2mm;">Dr. Tassawar Iqbal</div>
              <div style="font-size: 10pt; color: #4a5568; margin-top: 1mm;">Department of Computer Science, COMSATS University Islamabad, Wah Cantt Campus</div>
            </div>

            <!-- Bottom Title & Authors Block (Exact ReDez Standard) -->
            <div style="margin-top: 28mm; margin-bottom: 6mm;">
              <div style="font-size: 23pt; font-weight: bold; color: #000000; line-height: 1.25;">
                Software Requirement and<br/>
                Design Specification
              </div>
              <div style="margin-top: 7mm; font-size: 10.5pt; font-weight: bold; color: #000000; letter-spacing: 0.4px;">
                MUHAMMAD AFNAN KHAN (FA23-BAI-028) &nbsp;|&nbsp; MUHAMMAD BILAL BUTT (FA23-BAI-042)
              </div>
            </div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 1 -Content $p1 -IsCover $true))

    # ==================== PAGE 2: TABLE OF CONTENTS ====================
    $p2 = @'
          <div class="chapter-bar">Table of Contents</div>
          <div class="toc-line"><b>1 Introduction</b><span class="toc-dots"></span><b>4</b></div>
          <div class="toc-line" style="padding-left: 4mm;">1.1 System Introduction<span class="toc-dots"></span>4</div>
          <div class="toc-line" style="padding-left: 4mm;">1.2 Background and Problem Statement<span class="toc-dots"></span>4</div>
          <div class="toc-line" style="padding-left: 4mm;">1.3 System Objectives<span class="toc-dots"></span>4</div>
          <div class="toc-line" style="padding-left: 4mm;">1.4 Industrial Significance<span class="toc-dots"></span>4</div>
          
          <div class="toc-line" style="margin-top: 1.5mm;"><b>2 Overall Description</b><span class="toc-dots"></span><b>5</b></div>
          <div class="toc-line" style="padding-left: 4mm;">2.1 Product Perspective<span class="toc-dots"></span>5</div>
          <div class="toc-line" style="padding-left: 4mm;">2.2 Product Scope Boundaries (Table 2.1)<span class="toc-dots"></span>5</div>
          <div class="toc-line" style="padding-left: 4mm;">2.3 Product Major Functions<span class="toc-dots"></span>5</div>
          <div class="toc-line" style="padding-left: 4mm;">Figure 2.1: System Block Diagram of TexEye AI<span class="toc-dots"></span>6</div>
          <div class="toc-line" style="padding-left: 4mm;">2.4 User Classes and Characteristics (Table 2.2)<span class="toc-dots"></span>7</div>
          <div class="toc-line" style="padding-left: 4mm;">2.5 Operating Environment and Hardware Stack (Table 2.3)<span class="toc-dots"></span>7</div>

          <div class="toc-line" style="margin-top: 1.5mm;"><b>3 Specific Requirements</b><span class="toc-dots"></span><b>8</b></div>
          <div class="toc-line" style="padding-left: 4mm;">3.1 Functional Requirements (FR-ING, FR-INF, FR-REL)<span class="toc-dots"></span>8</div>
          <div class="toc-line" style="padding-left: 4mm;">3.1 Functional Requirements (FR-TRK, FR-GRD, FR-BUF, FR-SYN)<span class="toc-dots"></span>9</div>
          <div class="toc-line" style="padding-left: 4mm;">3.1 Functional Requirements (FR-MOB, FR-DSH, FR-REP)<span class="toc-dots"></span>10</div>
          <div class="toc-line" style="padding-left: 4mm;">3.2 Behaviour Requirements & Use Case Diagram (Figure 3.1, Tables 3.11, 3.12)<span class="toc-dots"></span>11</div>
          <div class="toc-line" style="padding-left: 4mm;">3.2.4 Fully Dressed Use Cases (UC-01 to UC-12)<span class="toc-dots"></span>12 - 17</div>
          <div class="toc-line" style="padding-left: 4mm;">3.3 External Interface Requirements (UI Screens, Software, Communications)<span class="toc-dots"></span>18</div>
          <div class="toc-line" style="padding-left: 4mm;">Figure 4.1: Hardware Architecture and Physical Interconnect Diagram<span class="toc-dots"></span>19</div>

          <div class="toc-line" style="margin-top: 1.5mm;"><b>4 Other Non-functional Requirements</b><span class="toc-dots"></span><b>20</b></div>
          <div class="toc-line" style="padding-left: 4mm;">4.1 Performance Requirements (Table 4.1)<span class="toc-dots"></span>20</div>
          <div class="toc-line" style="padding-left: 4mm;">4.2 Safety and Security Requirements (SR-01 to 06, SC-01 to 08)<span class="toc-dots"></span>20</div>
          <div class="toc-line" style="padding-left: 4mm;">4.3 Software Quality Attributes (Reliability Invariant, Metrology, Testability)<span class="toc-dots"></span>21</div>

          <div class="toc-line" style="margin-top: 1.5mm;"><b>5 Design Description</b><span class="toc-dots"></span><b>22</b></div>
          <div class="toc-line" style="padding-left: 4mm;">5.1 Composite Viewpoint (Figure 5.1 Package Diagram & Figure 5.2 Deployment)<span class="toc-dots"></span>22</div>
          <div class="toc-line" style="padding-left: 4mm;">5.2 Logical Viewpoint (Figure 5.3 Class Diagram & Table 5.2 Responsibilities)<span class="toc-dots"></span>23</div>
          <div class="toc-line" style="padding-left: 4mm;">5.3 Information Viewpoint (Figure 5.4 ERD & Table 5.3 Main Entities)<span class="toc-dots"></span>24</div>
          <div class="toc-line" style="padding-left: 4mm;">5.4 Interaction Viewpoint: Inspection & Detection Sequences (Figures 5.5, 5.6)<span class="toc-dots"></span>25</div>
          <div class="toc-line" style="padding-left: 4mm;">5.4 Interaction Viewpoint: Reliability Gating & Sync Sequences (Figures 5.7, 5.8)<span class="toc-dots"></span>26</div>
          <div class="toc-line" style="padding-left: 4mm;">5.4 Interaction Viewpoint: Review, Grading & Export (Figures 5.9, 5.10, 5.11)<span class="toc-dots"></span>27</div>
          <div class="toc-line" style="padding-left: 4mm;">5.5 State Dynamics Viewpoint (Figures 5.12, 5.13 & Tables 5.4, 5.5)<span class="toc-dots"></span>28</div>
          <div class="toc-line" style="padding-left: 4mm;">5.6 Algorithm Viewpoint: System Activity Diagram (Figure 5.14)<span class="toc-dots"></span>29</div>
          <div class="toc-line" style="padding-left: 4mm;">5.6.2 System Algorithms (Pseudocode Algorithms 5.1 to 5.6)<span class="toc-dots"></span>30</div>
          <div class="toc-line" style="padding-left: 4mm;">5.6.3 Decision Tables (Tables 5.6, 5.7) & <b>6 Conclusion</b><span class="toc-dots"></span><b>31</b></div>
'@
    $pages.Add((New-Page -PageNumber 2 -Content $p2))

    # ==================== PAGE 3: LIST OF FIGURES & TABLES ====================
    $p3 = @'
          <div class="chapter-bar">List of Figures & Tables</div>
          <h2 class="sec-heading" style="margin-top: 1mm;">List of Figures</h2>
          <div class="toc-line">Figure 2.1: System block diagram of TexEye AI<span class="toc-dots"></span>6</div>
          <div class="toc-line">Figure 3.1: Use case diagram of TexEye AI<span class="toc-dots"></span>11</div>
          <div class="toc-line">Figure 4.1: Hardware Architecture and Physical Interconnect Diagram<span class="toc-dots"></span>19</div>
          <div class="toc-line">Figure 5.1: Package and component diagram of TexEye AI<span class="toc-dots"></span>22</div>
          <div class="toc-line">Figure 5.2: Deployment diagram of edge-cloud architecture<span class="toc-dots"></span>22</div>
          <div class="toc-line">Figure 5.3: Class diagram of TexEye AI domain model<span class="toc-dots"></span>23</div>
          <div class="toc-line">Figure 5.4: Entity relationship diagram of TexEye AI<span class="toc-dots"></span>24</div>
          <div class="toc-line">Figure 5.5: Sequence diagram for UC-01 Start Inspection Session<span class="toc-dots"></span>25</div>
          <div class="toc-line">Figure 5.6: Sequence diagram for UC-03 Real-Time Defect Detection & Tracking<span class="toc-dots"></span>25</div>
          <div class="toc-line">Figure 5.7: Sequence diagram for UC-05 Reliability Gating & Uninspected Mark<span class="toc-dots"></span>26</div>
          <div class="toc-line">Figure 5.8: Sequence diagram for UC-08 Offline Buffering & Resilient Cloud Sync<span class="toc-dots"></span>26</div>
          <div class="toc-line">Figure 5.9: Sequence diagram for UC-09 Review & Correct Defect Classification<span class="toc-dots"></span>27</div>
          <div class="toc-line">Figure 5.10: Sequence diagram for UC-10 Compute ASTM D5430 4-Point Grade<span class="toc-dots"></span>27</div>
          <div class="toc-line">Figure 5.11: Sequence diagram for UC-12 Export PDF Quality Certificate<span class="toc-dots"></span>27</div>
          <div class="toc-line">Figure 5.12: State machine diagram: roll inspection run<span class="toc-dots"></span>28</div>
          <div class="toc-line">Figure 5.13: State machine diagram: offline sync outbox queue<span class="toc-dots"></span>28</div>
          <div class="toc-line">Figure 5.14: Activity diagram of the overall inspection and grading system<span class="toc-dots"></span>29</div>

          <h2 class="sec-heading" style="margin-top: 3.5mm;">List of Tables</h2>
          <div class="toc-line">Table 2.1: Scope boundaries of TexEye AI<span class="toc-dots"></span>5</div>
          <div class="toc-line">Table 2.2: User classes and their characteristics<span class="toc-dots"></span>7</div>
          <div class="toc-line">Table 2.3: Operating environment and minimum platform<span class="toc-dots"></span>7</div>
          <div class="toc-line">Table 3.1: Optical Ingestion & Synchronization requirements (FR-ING)<span class="toc-dots"></span>8</div>
          <div class="toc-line">Table 3.2: Real-Time AI Inference & Metrology requirements (FR-INF)<span class="toc-dots"></span>8</div>
          <div class="toc-line">Table 3.3: Inspection Reliability Invariant requirements (FR-REL)<span class="toc-dots"></span>8</div>
          <div class="toc-line">Table 3.4: Multi-Frame Tracking & Deduplication requirements (FR-TRK)<span class="toc-dots"></span>9</div>
          <div class="toc-line">Table 3.5: ASTM D5430 4-Point Grading requirements (FR-GRD)<span class="toc-dots"></span>9</div>
          <div class="toc-line">Table 3.6: Offline Local Buffering requirements (FR-BUF)<span class="toc-dots"></span>9</div>
          <div class="toc-line">Table 3.7: Cloud Synchronization & Ingestion API requirements (FR-SYN)<span class="toc-dots"></span>9</div>
          <div class="toc-line">Table 3.8: Floor Operator Mobile Application requirements (FR-MOB)<span class="toc-dots"></span>10</div>
          <div class="toc-line">Table 3.9: Quality Management Web Dashboard requirements (FR-DSH)<span class="toc-dots"></span>10</div>
          <div class="toc-line">Table 3.10: Reporting, Export & Audit Trail requirements (FR-REP)<span class="toc-dots"></span>10</div>
          <div class="toc-line">Table 3.11: Actors of TexEye AI<span class="toc-dots"></span>11</div>
          <div class="toc-line">Table 3.12: Use case summary<span class="toc-dots"></span>11</div>
          <div class="toc-line">Table 3.13: Screens of the TexEye AI web and mobile clients<span class="toc-dots"></span>18</div>
          <div class="toc-line">Table 3.14: Software interfaces<span class="toc-dots"></span>18</div>
          <div class="toc-line">Table 4.1: Performance requirements<span class="toc-dots"></span>20</div>
          <div class="toc-line">Table 5.1: Modules and their development owners<span class="toc-dots"></span>22</div>
          <div class="toc-line">Table 5.2: Classes and responsibilities<span class="toc-dots"></span>23</div>
          <div class="toc-line">Table 5.3: Main entities of TexEye AI<span class="toc-dots"></span>24</div>
          <div class="toc-line">Table 5.4: State transition table: roll inspection run<span class="toc-dots"></span>28</div>
          <div class="toc-line">Table 5.5: State transition table: offline sync outbox queue<span class="toc-dots"></span>28</div>
          <div class="toc-line">Table 5.6: Decision table: inspection reliability gating and alarm actuation<span class="toc-dots"></span>31</div>
          <div class="toc-line">Table 5.7: Decision table: defect penalty point assignment (ASTM D5430)<span class="toc-dots"></span>31</div>
'@
    $pages.Add((New-Page -PageNumber 3 -Content $p3))

    # ==================== PAGE 4: CHAPTER 1 INTRODUCTION ====================
    $p4 = @'
          <div class="chapter-bar">1 Introduction</div>
          <h2 class="sec-heading">1.1 Project Title and Overview</h2>
          <p class="body-p">
            <b>TexEye AI: AI-Based Fabric Defect Detection and Quality Management System</b> is an automated fabric inspection and quality management system developed to replace error-prone manual inspection with modern computer vision, hardware integration, a mobile floor application, and a centralized web management dashboard.
          </p>
          <p class="body-p">
            During production, a camera captures continuous fabric images while a rotary encoder precisely measures fabric movement to calculate the exact physical locations of defects. The AI model detects fabric flaws and tracks them across consecutive frames, preventing duplicate records of the same defect.
          </p>
          <p class="body-p">
            A central feature of TexEye AI is its proactive inspection reliability monitoring. The system continuously verifies camera connectivity, lighting conditions, image clarity, and frame capture rates. When any condition falls below reliable thresholds, the system alerts operators and marks those fabric sections as uninspected. During network outages, all defect data, images, and roll records are buffered locally on the edge unit and synchronized automatically once connectivity is restored.
          </p>

          <h2 class="sec-heading">1.2 Problem Statement</h2>
          <p class="body-p">
            Manual fabric inspection during high-speed production frequently misses defects due to human fatigue and visual strain, leading to severe fabric waste, customer returns, and financial losses. Furthermore, manual inspection lacks precise defect location tracking, real-time alerting, and reliable digital records.
          </p>
          <p class="body-p">
            In existing setups, unforeseen camera disconnections, poor lighting, dropped frames, or blurred optical conditions can cause sections of fabric to pass completely uninspected without the operator being aware. TexEye AI solves these critical challenges by detecting and locating defects in real time, actively monitoring inspection reliability, clearly recording uninspected sections, and providing complete digital review, grading, and quality reporting.
          </p>

          <h2 class="sec-heading">1.3 System Capabilities and Objectives</h2>
          <ul>
            <li><b>Automated Defect Detection:</b> Identify surface defects (holes, stains, thread flaws) using computer vision.</li>
            <li><b>Metric Location Tracking:</b> Estimate physical defect positions (X in mm, Y in meters) using rotary encoder pulses.</li>
            <li><b>Multi-Frame Deduplication:</b> Track moving defects across consecutive frames to avoid redundant flaw counting.</li>
            <li><b>Reliability Sentinel:</b> Monitor camera connectivity, lux levels, and image quality; flag uninspected sections on failure.</li>
            <li><b>Offline Resilience:</b> Securely buffer inspection sessions locally on the stand during network disconnects.</li>
            <li><b>Mobile Operator App:</b> Enable workers to receive floor alerts, scan roll QR codes, and review detected flaws.</li>
            <li><b>Web Quality Management:</b> Display 2D defect maps, roll grading records, inventory summaries, and PDF reports.</li>
            <li><b>Secure Access Control:</b> Enforce authentication and role-based authorization across web and mobile interfaces.</li>
          </ul>
'@
    $pages.Add((New-Page -PageNumber 4 -Content $p4))

    # ==================== PAGE 5: CHAPTER 2 OVERALL DESCRIPTION ====================
    $p5 = @'
          <div class="chapter-bar">2 Overall Description</div>
          <h2 class="sec-heading">2.1 Name and Detail of System Modules</h2>
          <p class="body-p">
            TexEye AI is partitioned into five specialized, cohesive modules that coordinate between the physical inspection stand, edge processing, mobile floor clients, and web management systems:
          </p>
          <ul>
            <li><b>1. AI Defect Detection and Location Module:</b> Detects fabric defects using computer vision, estimates their physical locations along the roll using rotary encoder measurements, and tracks defects across consecutive frames to eliminate duplicate records.</li>
            <li><b>2. Hardware and Inspection Monitoring Module:</b> Integrates the camera, LED lighting, rotary encoder, and audio-visual alert mechanisms. Continuously monitors camera connectivity, lighting conditions, image sharpness, and dropped frames, identifying and marking fabric sections that were not successfully inspected.</li>
            <li><b>3. Mobile Floor Application:</b> Equips shop-floor workers with tools to receive instant defect and inspection alerts, scan roll QR codes, view roll specifications, and review or manually correct detected flaws directly at the machine stand.</li>
            <li><b>4. Web Quality Management and Digital Fabric Map:</b> Displays full roll defect maps, inspection statuses, quality grading, and inventory records. Supports automated digital inspection report generation and handles local storage synchronization when internet connectivity returns.</li>
            <li><b>5. Smart Operations Module:</b> Maintains long-term quality records, roll inventory data, scrap logs, and defect occurrence statistics to support production auditing, decision making, and compliance reporting.</li>
          </ul>

          <h2 class="sec-heading">2.2 Member-Wise Module Ownership</h2>
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 1mm;">Table 2.1: Member-wise Development Responsibilities</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 28%;">Team Member</th>
                <th style="width: 72%;">Assigned System Modules &amp; Core Responsibilities</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Muhammad Afnan Khan</b><br/>(FA23-BAI-028)</td>
                <td>
                  <b>Mobile Floor Application &amp; Web Quality Management Modules:</b><br/>
                  Development of the mobile application and web quality management modules, including QR code scanning, defect review and correction interfaces, the web management dashboard, interactive digital fabric defect maps, roll management, inventory and grading records, digital inspection report generation, and local data synchronization when internet connectivity returns.
                </td>
              </tr>
              <tr>
                <td><b>Muhammad Bilal Butt</b><br/>(FA23-BAI-042)</td>
                <td>
                  <b>AI Defect Detection &amp; Hardware Integration Modules:</b><br/>
                  Development of the AI defect detection and hardware integration modules, including fabric defect dataset preparation, AI model training and evaluation, real-time defect detection and tracking across consecutive frames, rotary encoder-based location estimation, camera integration, lighting and image quality monitoring, camera disconnection and dropped frame detection, hardware alerts, and identification of uninspected fabric sections.
                </td>
              </tr>
            </tbody>
          </table>

          <h2 class="sec-heading" style="margin-top: 2mm;">2.3 System Prototype Scope</h2>
          <p class="body-p">
            The project focuses on creating a fully functional end-to-end prototype demonstration for fabric rolling tables. The scope encompasses synchronized image acquisition, real-time defect detection, rotary encoder coordinate measurement, offline buffering, and multi-user web and mobile interfaces with secure authentication.
          </p>
'@
    $pages.Add((New-Page -PageNumber 5 -Content $p5))

    # ==================== PAGE 6: FIGURE 2.1 SYSTEM BLOCK DIAGRAM ====================
    $p6 = @'
          <div class="diagram-container" style="padding-top: 1mm;">
            <img class="diagram-img" src="../diagrams/svg/01_system_workflow.svg" alt="System block diagram of TexEye AI" style="max-height: 220mm;" />
            <div class="caption">Figure 2.1: System block diagram of TexEye AI</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 6 -Content $p6))

    # ==================== PAGE 7: USERS & OPERATING ENVIRONMENT ====================
    $p7 = @'
          <h2 class="sec-heading">2.4 Users and Characteristics</h2>
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.8mm;">Table 2.2: User classes and their characteristics</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 20%;">User Class</th>
                <th style="width: 36%;">Description & Functions Used</th>
                <th style="width: 20%;">Expertise & Frequency</th>
                <th style="width: 14%;">Privileges</th>
                <th style="width: 10%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Floor Operator</b></td>
                <td>Operates rolling stand, scans QR code, starts/stops inspection runs, receives vibration alerts, acknowledges alarms.</td>
                <td>Basic smartphone literacy. Continuous daily shift operation.</td>
                <td>Mobile app floor operations; own session.</td>
                <td>Primary</td>
              </tr>
              <tr>
                <td><b>Quality Inspector</b></td>
                <td>Audits defect crops on web dashboard, validates or corrects AI classifications, verifies uninspected spans.</td>
                <td>High textile fabric expertise. Daily shift reviews.</td>
                <td>Defect annotation and verification across rolls.</td>
                <td>Primary</td>
              </tr>
              <tr>
                <td><b>Plant Quality Manager</b></td>
                <td>Reviews ASTM 4-point penalty distributions, configures grading thresholds, exports official PDF inspection certificates.</td>
                <td>Advanced quality management; ASTM/ISO expert. Daily reviews.</td>
                <td>Managerial access; threshold configuration; PDF sign-off.</td>
                <td>Primary</td>
              </tr>
              <tr>
                <td><b>System Admin</b></td>
                <td>Manages user credentials, configures GPIO pins, performs camera calibration (mm/pixel), monitors hardware health.</td>
                <td>Engineering expertise (Linux, networking, vision). Weekly maintenance.</td>
                <td>Superuser access to edge rigs and cloud backend.</td>
                <td>Secondary</td>
              </tr>
              <tr>
                <td><b>Hardware Stand</b></td>
                <td>Camera, rotary optical encoder, high-CRI lighting rig, and opto-isolated relay stack light operating continuously.</td>
                <td>Deterministic embedded electronics; continuous autonomous operation.</td>
                <td>Direct GPIO and hardware driver bus access.</td>
                <td>Supporting</td>
              </tr>
            </tbody>
          </table>
          <h2 class="sec-heading" style="margin-top: 2.5mm;">2.5 Operating Environment</h2>
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.8mm;">Table 2.3: Operating environment and minimum platform</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 25%;">Component</th>
                <th style="width: 75%;">Requirement Specification</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><b>Physical Stand Environment</b></td>
                <td>Extruded aluminum gantry mounted over motorized rolling table. Temperature: 10 C to 45 C, relative humidity &le; 85% non-condensing (typical Punjab mill ambient conditions). Vibration damping pads at gantry base.</td>
              </tr>
              <tr>
                <td><b>Optical Ingestion Rig</b></td>
                <td>Industrial CMOS area-scan camera (1080p @ 30 to 60 FPS, global or high-speed electronic rolling shutter), USB 3.0 / GigE interface. High-CRI (&ge; 90) regulated DC LED array (5500K daylight balance, 1200 lux surface illumination).</td>
              </tr>
              <tr>
                <td><b>Displacement Metrology</b></td>
                <td>Incremental optical rotary encoder (1024 pulses/revolution) mechanically coupled to fabric drive roller (diameter 100 mm, resolution approx. 0.307 mm/pulse). Dual-channel quadrature outputs connected to edge hardware GPIO interrupt pins.</td>
              </tr>
              <tr>
                <td><b>Edge Computing Unit</b></td>
                <td>Standard Edge PC / Workstation (Intel Core i5 / ARM64, 8 GB RAM). OS: Ubuntu Linux 22.04 LTS. Python 3.10+, OpenCV, PyTorch runtime.</td>
              </tr>
              <tr>
                <td><b>Alarm Actuator Relay</b></td>
                <td>Opto-isolated 4-channel 5V/24V DC relay board. Channel 1: Red Stack Light + 90 dB Buzzer; Channel 2: Yellow Warning Light; Channel 3: Machine Slowdown / Pause Interlock.</td>
              </tr>
              <tr>
                <td><b>Central Server & Database</b></td>
                <td>Linux Server (Ubuntu 22.04 LTS), 8 CPU cores, 16 GB RAM, 500 GB NVMe SSD. Python 3.11+, FastAPI, PostgreSQL 15+, MinIO S3 object storage, Redis 7 (caching and WebSocket pub/sub).</td>
              </tr>
              <tr>
                <td><b>Client Workstations</b></td>
                <td>Web: Chrome, Edge, Firefox on 1080p+ displays. Mobile: Android 10+ / iOS 15+ smartphone or ruggedized tablet with camera (for QR scanner) and vibration motor.</td>
              </tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 7 -Content $p7))

    # ==================== PAGE 8: CHAPTER 3 SPECIFIC REQUIREMENTS (PART 1) ====================
    $p8 = @'
          <div class="chapter-bar">3 Specific Requirements</div>
          <h2 class="sec-heading">3.1 Functional Requirements</h2>
          <p>
            Functional requirements are classified into ten core engineering subsystems. Each requirement is assigned a unique identifier, an architectural description, and a development priority: <b>High</b> (mission-critical for core inspection and safety invariants) or <b>Medium</b> (operational enhancements for reporting and ergonomics).
          </p>
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.8mm;">Table 3.1: Optical Ingestion & Synchronization requirements (FR-ING) - Owner: Muhammad Bilal Butt</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Req ID</th>
                <th style="width: 22%;">Requirement Name</th>
                <th style="width: 52%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr><td><b>FR-ING-01</b></td><td>Continuous Frame Stream</td><td>Ingest video frames via V4L2 / GenICam at a minimum steady rate of 30 FPS at 1920x1080 resolution.</td><td>High</td></tr>
              <tr><td><b>FR-ING-02</b></td><td>Hardware GPIO Counter</td><td>Bind kernel interrupt service routine (ISR) to GPIO quadrature pins to count encoder pulses up to 50 kHz.</td><td>High</td></tr>
              <tr><td><b>FR-ING-03</b></td><td>Encoder Frame Gate</td><td>Trigger frame analysis on fixed fabric advance (calibrated optical step), guaranteeing uniform longitudinal sampling.</td><td>High</td></tr>
              <tr><td><b>FR-ING-04</b></td><td>Distortion Rectification</td><td>Apply pre-computed camera matrix parameters to rectify wide-angle lens radial and tangential distortion prior to AI.</td><td>High</td></tr>
              <tr><td><b>FR-ING-05</b></td><td>Speed Adaptation</td><td>Maintain constant physical resolution across line velocity fluctuations between 0.05 m/s and 0.50 m/s.</td><td>High</td></tr>
            </tbody>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2mm; margin-bottom: 0.8mm;">Table 3.2: Real-Time AI Inference & Metrology requirements (FR-INF) - Owner: Muhammad Bilal Butt</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Req ID</th>
                <th style="width: 22%;">Requirement Name</th>
                <th style="width: 52%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr><td><b>FR-INF-01</b></td><td>AI Inference Engine</td><td>Execute fine-tuned YOLO model with real-time inference latency under 30 ms per frame.</td><td>High</td></tr>
              <tr><td><b>FR-INF-02</b></td><td>Multi-Class Detection</td><td>Detect six fabric classes: Hole, Oil Stain, Warp Streak, Weft Crack, Float, Stitching Tear (mAP@0.5 &ge; 88%).</td><td>High</td></tr>
              <tr><td><b>FR-INF-03</b></td><td>Bounding Box Extraction</td><td>Output normalized coordinates [u_min, v_min, u_max, v_max] and confidence scores [0.0, 1.0] for each flaw.</td><td>High</td></tr>
              <tr><td><b>FR-INF-04</b></td><td>Metric Width Mapping</td><td>Map lateral pixel span to physical millimeters (W in mm) using calibrated optical scale factor (kx mm/pixel).</td><td>High</td></tr>
              <tr><td><b>FR-INF-05</b></td><td>Longitudinal Position</td><td>Calculate absolute longitudinal position (Y in meters) by multiplying cumulative encoder pulses by distance constant Cp.</td><td>High</td></tr>
              <tr><td><b>FR-INF-06</b></td><td>Defect Image Crop</td><td>Extract high-resolution image crop around flaw with 20% margin, compress as JPEG (&le; 100 KB), and cache locally.</td><td>High</td></tr>
            </tbody>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2mm; margin-bottom: 0.8mm;">Table 3.3: Inspection Reliability Invariant requirements (FR-REL) - Owner: Muhammad Bilal Butt</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Req ID</th>
                <th style="width: 22%;">Requirement Name</th>
                <th style="width: 52%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr><td><b>FR-REL-01</b></td><td>Frame Delivery Heartbeat</td><td>Track camera ingestion interval; if no frame delivered within 100 ms during roll motion, trigger CAMERA_DROP fault.</td><td>High</td></tr>
              <tr><td><b>FR-REL-02</b></td><td>Illumination Monitor</td><td>If frame luminance falls below 800 lux or exceeds 2500 lux (LED failure/glare), trigger LIGHTING_FAULT.</td><td>High</td></tr>
              <tr><td><b>FR-REL-03</b></td><td>Blur Detection</td><td>Compute Laplacian variance over each frame; if variance falls below threshold 100, flag IMAGE_BLUR.</td><td>High</td></tr>
              <tr><td><b>FR-REL-04</b></td><td>Uninspected Section Guard</td><td>On active fault, suspend classification and record span [Y_start, Y_end] as UNINSPECTED_SECTION, blocking clean grade.</td><td>High</td></tr>
              <tr><td><b>FR-REL-05</b></td><td>Relay Alarm Actuation</td><td>On uninspected fault or severe flaw, actuate 24V opto-isolated relay to illuminate red stack light and sound buzzer within 50 ms.</td><td>High</td></tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 8 -Content $p8))

    # ==================== PAGE 9: FUNCTIONAL REQUIREMENTS (PART 2) ====================
    $p9 = @'
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.8mm;">Table 3.4: Multi-Frame Tracking & Deduplication (FR-TRK) - Owner: Muhammad Bilal Butt</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Req ID</th>
                <th style="width: 22%;">Requirement Name</th>
                <th style="width: 52%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr><td><b>FR-TRK-01</b></td><td>Kalman Filter Association</td><td>Track bounding boxes across frames using 2D Kalman Filter with state vector, associating tracks via Hungarian IoU.</td><td>High</td></tr>
              <tr><td><b>FR-TRK-02</b></td><td>Continuous Flaw Merging</td><td>For flaws extending across multiple frames (warp streaks), merge detections into a single continuous record with total length.</td><td>High</td></tr>
              <tr><td><b>FR-TRK-03</b></td><td>Track Confirmation Gate</td><td>Require detection in at least 3 consecutive frames (&ge; 3 hits) before committing flaw, suppressing surface dust noise.</td><td>High</td></tr>
              <tr><td><b>FR-TRK-04</b></td><td>Track Expiration & Commit</td><td>When a flaw exits the optical FOV for more than 5 frames, close track and commit finalized physical dimensions to SQLite.</td><td>High</td></tr>
            </tbody>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2mm; margin-bottom: 0.8mm;">Table 3.5: ASTM D5430 4-Point Grading (FR-GRD) - Owner: Muhammad Afnan Khan</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Req ID</th>
                <th style="width: 22%;">Requirement Name</th>
                <th style="width: 52%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr><td><b>FR-GRD-01</b></td><td>Length Categorization</td><td>Assign penalty points: 1 pt (&le; 75 mm), 2 pts (&gt; 75 to 150 mm), 3 pts (&gt; 150 to 230 mm), 4 pts (&gt; 230 mm).</td><td>High</td></tr>
              <tr><td><b>FR-GRD-02</b></td><td>Hole Penalty Rule</td><td>Penalize holes: 2 points for opening &le; 25 mm (1 inch); 4 points for opening &gt; 25 mm, strictly complying with ASTM Section 8.</td><td>High</td></tr>
              <tr><td><b>FR-GRD-03</b></td><td>Linear Meter Cap</td><td>Cap penalty points at a maximum of 4 points for any single linear meter of fabric, regardless of flaw count.</td><td>High</td></tr>
              <tr><td><b>FR-GRD-04</b></td><td>Points per 100 sq. m</td><td>Calculate points per 100 sq. m = (Total Capped Points x 100) / (Roll Length in m x Fabric Width in m).</td><td>High</td></tr>
              <tr><td><b>FR-GRD-05</b></td><td>Commercial Roll Grade</td><td>Assign quality tier: Grade A (&le; 20 pts/100m2), Grade B (21 to 28), Grade C (29 to 40), or Reject (&gt; 40 or uninspected spans).</td><td>High</td></tr>
            </tbody>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2mm; margin-bottom: 0.8mm;">Table 3.6: Offline Local Buffering (FR-BUF) - Owner: Muhammad Afnan Khan</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Req ID</th>
                <th style="width: 22%;">Requirement Name</th>
                <th style="width: 52%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr><td><b>FR-BUF-01</b></td><td>Transactional SQLite WAL</td><td>Store session headers, frame metrics, and defect records in local SQLite configured with journal_mode = WAL.</td><td>High</td></tr>
              <tr><td><b>FR-BUF-02</b></td><td>Transactional Outbox</td><td>Atomically insert defect and uninspected events into an outbox_events table within the same transaction.</td><td>High</td></tr>
              <tr><td><b>FR-BUF-03</b></td><td>Local Disk Ring Buffer</td><td>Store defect JPEG crops in organized local directory (/data/crops/{roll_id}/); monitor free disk space (&ge; 5 GB).</td><td>High</td></tr>
              <tr><td><b>FR-BUF-04</b></td><td>Network State Detection</td><td>Probe central server endpoint (GET /api/v1/health) every 5 seconds to determine live connectivity.</td><td>Medium</td></tr>
              <tr><td><b>FR-BUF-05</b></td><td>Crash Recovery Replay</td><td>On unexpected reboot, inspect SQLite WAL recovery logs, finalize unclosed sessions, and resume outbox sync.</td><td>High</td></tr>
            </tbody>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2mm; margin-bottom: 0.8mm;">Table 3.7: Cloud Synchronization & Ingestion API (FR-SYN) - Owner: Muhammad Afnan Khan</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Req ID</th>
                <th style="width: 22%;">Requirement Name</th>
                <th style="width: 52%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr><td><b>FR-SYN-01</b></td><td>Batch Dispatcher</td><td>When online, query up to 50 pending outbox records and transmit via HTTPS multipart POST to /api/v1/sync/batch.</td><td>High</td></tr>
              <tr><td><b>FR-SYN-02</b></td><td>Idempotent Ingestion</td><td>Central FastAPI service enforces idempotency using unique record UUIDs, safely handling duplicate batch resends.</td><td>High</td></tr>
              <tr><td><b>FR-SYN-03</b></td><td>PostgreSQL Storage</td><td>Persist synchronized roll headers, defect records, and grading summaries into central relational PostgreSQL 15 database.</td><td>High</td></tr>
              <tr><td><b>FR-SYN-04</b></td><td>Object Storage Upload</td><td>Ingest binary JPEG payloads and store in MinIO (S3-compatible) storage with access paths indexed in PostgreSQL.</td><td>High</td></tr>
              <tr><td><b>FR-SYN-05</b></td><td>Two-Phase Acknowledgment</td><td>Mark local outbox records as SYNCED only after receiving HTTP 200 OK confirmation with committed UUID list.</td><td>High</td></tr>
              <tr><td><b>FR-SYN-06</b></td><td>Cache Cleanup</td><td>Defect JPEG crops confirmed as synced by central server are eligible for local deletion after 48 hours.</td><td>Medium</td></tr>
            </tbody>
          </table>
'@
    $pages.Add((New-Page -PageNumber 9 -Content $p9))

    # ==================== PAGE 10: FUNCTIONAL REQUIREMENTS (PART 3) ====================
    $p10 = @'
          <div style="font-weight: bold; font-size: 8pt; margin-bottom: 0.8mm;">Table 3.8: Floor Operator Mobile Application (FR-MOB) - Owner: Muhammad Afnan Khan</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Req ID</th>
                <th style="width: 22%;">Requirement Name</th>
                <th style="width: 52%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr><td><b>FR-MOB-01</b></td><td>QR Roll Registration</td><td>Scan physical QR code on fabric roll using device camera to extract Batch ID, Article, Length, and GSM.</td><td>High</td></tr>
              <tr><td><b>FR-MOB-02</b></td><td>Real-Time Haptic Alert</td><td>Deliver immediate vibration pulses and audible alarm tones upon receiving defect alerts via WebSocket (&lt; 200 ms).</td><td>High</td></tr>
              <tr><td><b>FR-MOB-03</b></td><td>Defect Crop Preview</td><td>Display cropped image of most recently detected flaw along with physical coordinates (X in mm, Y in m) and class.</td><td>High</td></tr>
              <tr><td><b>FR-MOB-04</b></td><td>Manual Defect Tagging</td><td>Enable operator to tap 'Tag Manual Defect' to record a visual anomaly observed outside the camera FOV.</td><td>Medium</td></tr>
              <tr><td><b>FR-MOB-05</b></td><td>Session Control</td><td>Enable operator to pause, resume, and terminate the active inspection session directly from the mobile UI.</td><td>High</td></tr>
            </tbody>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2mm; margin-bottom: 0.8mm;">Table 3.9: Quality Management Web Dashboard (FR-DSH) - Owner: Muhammad Afnan Khan</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Req ID</th>
                <th style="width: 22%;">Requirement Name</th>
                <th style="width: 52%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr><td><b>FR-DSH-01</b></td><td>2D Roll Defect Map</td><td>Render interactive 2D canvas representing full roll length and width, plotting flaws at exact metric coordinates (X, Y).</td><td>High</td></tr>
              <tr><td><b>FR-DSH-02</b></td><td>Uninspected Hazard Spans</td><td>Render uninspected longitudinal spans as amber hazard zones on the 2D map with tooltips detailing root causes.</td><td>High</td></tr>
              <tr><td><b>FR-DSH-03</b></td><td>Defect Relabeling</td><td>Enable authorized inspectors to inspect high-res flaw crops and adjust AI classifications with an audit justification.</td><td>High</td></tr>
              <tr><td><b>FR-DSH-04</b></td><td>ASTM 4-Point Scorecard</td><td>Display live penalty points, points per 100 sq. m, linear meter distribution charts, and commercial Roll Grade.</td><td>High</td></tr>
              <tr><td><b>FR-DSH-05</b></td><td>Plant-Wide Heatmap</td><td>Aggregate defect frequencies across looms, shifts, and fabric types to identify recurring mechanical weaving flaws.</td><td>Medium</td></tr>
              <tr><td><b>FR-DSH-06</b></td><td>Role-Based Access (RBAC)</td><td>Enforce role permissions (threshold editing, user provisioning, grade override) via signed JWT claims.</td><td>High</td></tr>
            </tbody>
          </table>

          <div style="font-weight: bold; font-size: 8pt; margin-top: 2mm; margin-bottom: 0.8mm;">Table 3.10: Reporting, Export & Audit Trail (FR-REP) - Owner: Muhammad Afnan Khan</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 14%;">Req ID</th>
                <th style="width: 22%;">Requirement Name</th>
                <th style="width: 52%;">Engineering Description</th>
                <th style="width: 12%;">Priority</th>
              </tr>
            </thead>
            <tbody>
              <tr><td><b>FR-REP-01</b></td><td>PDF Certificate Export</td><td>Generate publication-grade PDF Fabric Inspection Certificate with ASTM scorecard and SHA-256 verification hash.</td><td>High</td></tr>
              <tr><td><b>FR-REP-02</b></td><td>ERP Data Ingestion Export</td><td>Export structured JSON and CSV roll inspection logs formatted for direct ingestion into textile cutting-room software.</td><td>High</td></tr>
              <tr><td><b>FR-REP-03</b></td><td>Cryptographic Integrity</td><td>Compute SHA-256 hash over roll ID, defect records, and final grade, preventing post-inspection tampering.</td><td>High</td></tr>
              <tr><td><b>FR-REP-04</b></td><td>Immutable Audit Log</td><td>Record an immutable log entry in PostgreSQL whenever an inspector overrides a label or changes a roll grade.</td><td>High</td></tr>
              <tr><td><b>FR-REP-05</b></td><td>Batch Archival Storage</td><td>Completed roll records older than 90 days are archived, moving bulk crops to cold storage while preserving metadata.</td><td>Medium</td></tr>
            </tbody>
          </table>

          <h2 class="sec-heading" style="margin-top: 2.5mm;">3.2 Behaviour Requirements</h2>
          <p>
            System behaviour is formalized through an overall Use Case Diagram (Figure 3.1), actor definitions (Table 3.11), a use case summary (Table 3.12), and fully dressed use case specifications conforming to Cockburn methodology.
          </p>
'@
    $pages.Add((New-Page -PageNumber 10 -Content $p10))

    # ==================== PAGE 11: FIGURE 3.1 USE CASE DIAGRAM & ACTORS ====================
    $p11 = @'
          <div class="diagram-container" style="max-height: 145mm;">
            <img class="diagram-img" src="../diagrams/svg/06_use_case_overall.svg" alt="Use case diagram of TexEye AI" style="max-height: 140mm;" />
            <div class="caption">Figure 3.1: Use case diagram of TexEye AI</div>
          </div>
          <div style="display: flex; gap: 4mm; margin-top: 2mm;">
            <div style="flex: 1;">
              <div style="font-weight: bold; font-size: 7.8pt; margin-bottom: 0.5mm;">Table 3.11: Actors</div>
              <table class="formal-table">
                <thead><tr><th>Actor</th><th>Role in System</th></tr></thead>
                <tbody>
                  <tr><td><b>Floor Operator</b></td><td>Scans QR code, controls inspection, acknowledges alarms, views alerts.</td></tr>
                  <tr><td><b>Quality Inspector</b></td><td>Audits defect crops, corrects AI labels, verifies uninspected spans.</td></tr>
                  <tr><td><b>Quality Manager</b></td><td>Reviews ASTM grades, analyzes heatmaps, issues PDF certificates.</td></tr>
                  <tr><td><b>System Admin</b></td><td>Maintains camera calibration (mm/pixel), GPIO pins, and user accounts.</td></tr>
                  <tr><td><b>Hardware Stand</b></td><td>Autonomous camera, encoder, lighting rig, and relay stack light.</td></tr>
                </tbody>
              </table>
            </div>
            <div style="flex: 1.2;">
              <div style="font-weight: bold; font-size: 7.8pt; margin-bottom: 0.5mm;">Table 3.12: Use Case Summary</div>
              <table class="formal-table">
                <thead><tr><th>ID</th><th>Use Case Name</th><th>Primary Actor</th></tr></thead>
                <tbody>
                  <tr><td><b>UC-01</b></td><td>Start Inspection Session</td><td>Floor Operator</td></tr>
                  <tr><td><b>UC-02</b></td><td>Monitor Live Optical Feed</td><td>Floor Operator</td></tr>
                  <tr><td><b>UC-03</b></td><td>Real-Time Defect Detection</td><td>Hardware Stand</td></tr>
                  <tr><td><b>UC-04</b></td><td>Trigger Audio-Visual Alarm</td><td>Hardware Stand</td></tr>
                  <tr><td><b>UC-05</b></td><td>Enforce Reliability Invariant</td><td>Hardware Stand</td></tr>
                  <tr><td><b>UC-06</b></td><td>Mark Manual Defect</td><td>Floor Operator</td></tr>
                  <tr><td><b>UC-07</b></td><td>Buffer Offline Batches</td><td>Hardware Stand</td></tr>
                  <tr><td><b>UC-08</b></td><td>Synchronize Outbox Batches</td><td>Hardware Stand</td></tr>
                  <tr><td><b>UC-09</b></td><td>Review & Correct Defect</td><td>Quality Inspector</td></tr>
                  <tr><td><b>UC-10</b></td><td>Compute ASTM 4-Point Grade</td><td>Quality Manager</td></tr>
                  <tr><td><b>UC-11</b></td><td>View 2D Roll Defect Map</td><td>Quality Manager</td></tr>
                  <tr><td><b>UC-12</b></td><td>Export PDF Certificate</td><td>Quality Manager</td></tr>
                </tbody>
              </table>
            </div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 11 -Content $p11))

    return $pages
}

Write-Output "Compact Pages 1 to 11 module loaded."


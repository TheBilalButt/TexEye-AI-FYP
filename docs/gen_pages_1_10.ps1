# Part 1: Pages 1 to 10
function Get-Pages-1-to-10 {
    $pages = [System.Collections.Generic.List[string]]::new()

    # ==================== PAGE 1: COVER PAGE ====================
    $p1 = @'
          <div style="height: 100%; display: flex; flex-direction: column; justify-content: space-between; padding: 10mm 5mm;">
            <!-- Top Dark Banner -->
            <div style="background-color: #2d3748; color: #ffffff; display: flex; justify-content: space-between; align-items: center; padding: 8px 16px; border-radius: 2px;">
              <span style="font-size: 13pt; font-weight: bold; letter-spacing: 0.5px;">FYP Document &ldquo;TexEye AI&rdquo;</span>
              <span style="background-color: #cbd5e1; color: #000000; padding: 2px 14px; font-weight: bold; font-size: 12pt; border-radius: 2px;">2026</span>
            </div>

            <!-- University & Department Header -->
            <div style="text-align: center; margin-top: 18mm;">
              <div style="font-size: 15pt; font-weight: bold; color: #1a202c; letter-spacing: 0.3px;">COMSATS University Islamabad, Wah Campus</div>
              <div style="font-size: 12.5pt; color: #4a5568; margin-top: 3mm;">Department of Computer Science</div>
            </div>

            <!-- Main Title & Subtitle -->
            <div style="text-align: center; margin-top: 15mm;">
              <div style="font-size: 34pt; font-weight: 900; color: #000000; letter-spacing: 1px;">TexEye AI</div>
              <div style="font-size: 12pt; color: #2d3748; margin-top: 5mm; max-width: 140mm; margin-left: auto; margin-right: auto; line-height: 1.5;">
                An Industrial Edge-Cloud System for Real-Time Fabric Defect Detection, Metrology, and ASTM D5430 Quality Grading
              </div>
            </div>

            <!-- Supervisor Block -->
            <div style="text-align: center; margin-top: 15mm;">
              <div style="font-size: 10.5pt; font-style: italic; color: #4a5568;">Supervised by</div>
              <div style="font-size: 13pt; font-weight: bold; color: #1a202c; margin-top: 2mm;">Dr. Muhammad Tariq</div>
              <div style="font-size: 10pt; color: #4a5568; margin-top: 1mm;">Department of Computer Science</div>
            </div>

            <!-- Document Category Title & Authors Block -->
            <div style="margin-top: 20mm; border-top: 1.5pt solid #000000; padding-top: 8mm;">
              <div style="font-size: 22pt; font-weight: 900; color: #000000; line-height: 1.25;">
                Software Requirement and<br>Design Specification
              </div>
              <div style="font-size: 10pt; font-weight: bold; color: #2d3748; margin-top: 6mm; letter-spacing: 0.5px;">
                MUHAMMAD AFNAN KHAN (FA23-BAI-028) &nbsp;|&nbsp; MUHAMMAD BILAL BUTT (FA23-BAI-042)
              </div>
            </div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 1 -Content $p1 -IsCover $true))

    # ==================== PAGE 2: TABLE OF CONTENTS (PART 1) ====================
    $p2 = @'
          <div class="chapter-bar">Table of Contents</div>
          <div class="toc-line"><b>1 Introduction</b><span class="toc-dots"></span><b>6</b></div>
          <div class="toc-line" style="padding-left: 5mm;">1.1 System Introduction<span class="toc-dots"></span>6</div>
          <div class="toc-line" style="padding-left: 5mm;">1.2 Background of the System<span class="toc-dots"></span>6</div>
          <div class="toc-line" style="padding-left: 5mm;">1.3 Objectives of the System<span class="toc-dots"></span>7</div>
          <div class="toc-line" style="padding-left: 5mm;">1.4 Significance of the System<span class="toc-dots"></span>7</div>
          
          <div class="toc-line" style="margin-top: 2.5mm;"><b>2 Overall Description</b><span class="toc-dots"></span><b>8</b></div>
          <div class="toc-line" style="padding-left: 5mm;">2.1 Product Perspective<span class="toc-dots"></span>8</div>
          <div class="toc-line" style="padding-left: 5mm;">2.2 Product Scope<span class="toc-dots"></span>10</div>
          <div class="toc-line" style="padding-left: 5mm;">2.3 Product Functionality<span class="toc-dots"></span>10</div>
          <div class="toc-line" style="padding-left: 5mm;">2.4 Users and Characteristics<span class="toc-dots"></span>11</div>
          <div class="toc-line" style="padding-left: 5mm;">2.5 Operating Environment<span class="toc-dots"></span>12</div>
          
          <div class="toc-line" style="margin-top: 2.5mm;"><b>3 Specific Requirements</b><span class="toc-dots"></span><b>13</b></div>
          <div class="toc-line" style="padding-left: 5mm;">3.1 Functional Requirements<span class="toc-dots"></span>13</div>
          <div class="toc-line" style="padding-left: 10mm;">3.1.1 Optical Ingestion & Synchronization (FR-ING)<span class="toc-dots"></span>13</div>
          <div class="toc-line" style="padding-left: 10mm;">3.1.2 Real-Time AI Inference & Metrology (FR-INF)<span class="toc-dots"></span>14</div>
          <div class="toc-line" style="padding-left: 10mm;">3.1.3 Inspection Reliability Invariant (FR-REL)<span class="toc-dots"></span>14</div>
          <div class="toc-line" style="padding-left: 10mm;">3.1.4 Multi-Frame Tracking & Deduplication (FR-TRK)<span class="toc-dots"></span>15</div>
          <div class="toc-line" style="padding-left: 10mm;">3.1.5 ASTM D5430 4-Point Grading (FR-GRD)<span class="toc-dots"></span>15</div>
          <div class="toc-line" style="padding-left: 10mm;">3.1.6 Offline Local Buffering & Transactional Outbox (FR-BUF)<span class="toc-dots"></span>16</div>
          <div class="toc-line" style="padding-left: 10mm;">3.1.7 Cloud Synchronization & Ingestion API (FR-SYN)<span class="toc-dots"></span>16</div>
          <div class="toc-line" style="padding-left: 10mm;">3.1.8 Floor Operator Mobile Application (FR-MOB)<span class="toc-dots"></span>17</div>
          <div class="toc-line" style="padding-left: 10mm;">3.1.9 Quality Management Web Dashboard (FR-DSH)<span class="toc-dots"></span>17</div>
          <div class="toc-line" style="padding-left: 10mm;">3.1.10 Reporting, Export & Audit Trail (FR-REP)<span class="toc-dots"></span>18</div>
          <div class="toc-line" style="padding-left: 5mm;">3.2 Behaviour Requirements<span class="toc-dots"></span>19</div>
          <div class="toc-line" style="padding-left: 10mm;">3.2.1 Use Case Diagram for TexEye AI<span class="toc-dots"></span>20</div>
          <div class="toc-line" style="padding-left: 10mm;">3.2.2 Actors<span class="toc-dots"></span>21</div>
          <div class="toc-line" style="padding-left: 10mm;">3.2.3 Use Case Summary<span class="toc-dots"></span>21</div>
          <div class="toc-line" style="padding-left: 10mm;">3.2.4 Fully Dressed Use Cases (UC-01 to UC-12)<span class="toc-dots"></span>22</div>
          <div class="toc-line" style="padding-left: 5mm;">3.3 External Interface Requirements<span class="toc-dots"></span>34</div>
          <div class="toc-line" style="padding-left: 10mm;">3.3.1 User Interfaces<span class="toc-dots"></span>34</div>
          <div class="toc-line" style="padding-left: 10mm;">3.3.2 Hardware Interfaces<span class="toc-dots"></span>35</div>
          <div class="toc-line" style="padding-left: 10mm;">3.3.3 Software Interfaces<span class="toc-dots"></span>36</div>
          <div class="toc-line" style="padding-left: 10mm;">3.3.4 Communications Interfaces<span class="toc-dots"></span>36</div>
'@
    $pages.Add((New-Page -PageNumber 2 -Content $p2))

    # ==================== PAGE 3: TABLE OF CONTENTS (PART 2) ====================
    $p3 = @'
          <div class="chapter-bar">Table of Contents (Continued)</div>
          <div class="toc-line"><b>4 Other Non-functional Requirements</b><span class="toc-dots"></span><b>37</b></div>
          <div class="toc-line" style="padding-left: 5mm;">4.1 Performance Requirements<span class="toc-dots"></span>37</div>
          <div class="toc-line" style="padding-left: 5mm;">4.2 Safety and Security Requirements<span class="toc-dots"></span>38</div>
          <div class="toc-line" style="padding-left: 10mm;">4.2.1 Safety Requirements<span class="toc-dots"></span>38</div>
          <div class="toc-line" style="padding-left: 10mm;">4.2.2 Security and Privacy Requirements<span class="toc-dots"></span>38</div>
          <div class="toc-line" style="padding-left: 5mm;">4.3 Software Quality Attributes<span class="toc-dots"></span>39</div>
          <div class="toc-line" style="padding-left: 10mm;">4.3.1 Reliability & Invariant Preservation<span class="toc-dots"></span>39</div>
          <div class="toc-line" style="padding-left: 10mm;">4.3.2 Correctness and Verifiability<span class="toc-dots"></span>39</div>
          <div class="toc-line" style="padding-left: 10mm;">4.3.3 Reproducibility & Traceability<span class="toc-dots"></span>39</div>
          <div class="toc-line" style="padding-left: 10mm;">4.3.4 Maintainability and Design for Change<span class="toc-dots"></span>40</div>
          <div class="toc-line" style="padding-left: 10mm;">4.3.5 Testability<span class="toc-dots"></span>40</div>
          <div class="toc-line" style="padding-left: 10mm;">4.3.6 Usability and Accessibility<span class="toc-dots"></span>40</div>
          <div class="toc-line" style="padding-left: 10mm;">4.3.7 Portability<span class="toc-dots"></span>40</div>
          <div class="toc-line" style="padding-left: 10mm;">4.3.8 Interoperability<span class="toc-dots"></span>40</div>

          <div class="toc-line" style="margin-top: 3mm;"><b>5 Design Description</b><span class="toc-dots"></span><b>41</b></div>
          <div class="toc-line" style="padding-left: 5mm;">5.1 Composite Viewpoint<span class="toc-dots"></span>41</div>
          <div class="toc-line" style="padding-left: 10mm;">5.1.1 Package Diagram (Logical)<span class="toc-dots"></span>41</div>
          <div class="toc-line" style="padding-left: 10mm;">5.1.2 Deployment Diagram (Physical)<span class="toc-dots"></span>42</div>
          <div class="toc-line" style="padding-left: 5mm;">5.2 Logical Viewpoint (Class Diagram & Responsibilities)<span class="toc-dots"></span>43</div>
          <div class="toc-line" style="padding-left: 5mm;">5.3 Information Viewpoint (Entity Relationship Diagram)<span class="toc-dots"></span>45</div>
          <div class="toc-line" style="padding-left: 5mm;">5.4 Interaction Viewpoint<span class="toc-dots"></span>47</div>
          <div class="toc-line" style="padding-left: 10mm;">5.4.1 Sequence Diagram for Start Inspection Session<span class="toc-dots"></span>47</div>
          <div class="toc-line" style="padding-left: 10mm;">5.4.2 Sequence Diagram for Real-Time Defect Detection & Tracking<span class="toc-dots"></span>48</div>
          <div class="toc-line" style="padding-left: 10mm;">5.4.3 Sequence Diagram for Reliability Gating & Uninspected Mark<span class="toc-dots"></span>49</div>
          <div class="toc-line" style="padding-left: 10mm;">5.4.4 Sequence Diagram for Offline Buffering & Resilient Cloud Sync<span class="toc-dots"></span>50</div>
          <div class="toc-line" style="padding-left: 10mm;">5.4.5 Sequence Diagram for Review & Correct Defect Classification<span class="toc-dots"></span>51</div>
          <div class="toc-line" style="padding-left: 10mm;">5.4.6 Sequence Diagram for Compute ASTM D5430 4-Point Grade<span class="toc-dots"></span>52</div>
          <div class="toc-line" style="padding-left: 10mm;">5.4.7 Sequence Diagram for Export PDF Quality Certificate<span class="toc-dots"></span>53</div>
          <div class="toc-line" style="padding-left: 5mm;">5.5 State Dynamics Viewpoint<span class="toc-dots"></span>54</div>
          <div class="toc-line" style="padding-left: 10mm;">5.5.1 State Machine Diagram: Roll Inspection Run<span class="toc-dots"></span>54</div>
          <div class="toc-line" style="padding-left: 10mm;">5.5.2 State Machine Diagram: Offline Sync Outbox Queue<span class="toc-dots"></span>56</div>
          <div class="toc-line" style="padding-left: 5mm;">5.6 Algorithm Viewpoint<span class="toc-dots"></span>57</div>
          <div class="toc-line" style="padding-left: 10mm;">5.6.1 Activity Diagram of the System<span class="toc-dots"></span>57</div>
          <div class="toc-line" style="padding-left: 10mm;">5.6.2 Pseudocode of the System (Algorithms 5.1 to 5.6)<span class="toc-dots"></span>58</div>
          <div class="toc-line" style="padding-left: 10mm;">5.6.3 Decision Tables (Tables 5.6 and 5.7)<span class="toc-dots"></span>61</div>

          <div class="toc-line" style="margin-top: 3mm;"><b>6 Conclusion</b><span class="toc-dots"></span><b>62</b></div>
'@
    $pages.Add((New-Page -PageNumber 3 -Content $p3))

    # ==================== PAGE 4: LIST OF FIGURES ====================
    $p4 = @'
          <div class="chapter-bar">List of Figures</div>
          <div class="toc-line">Figure 2.1: System block diagram of TexEye AI<span class="toc-dots"></span>9</div>
          <div class="toc-line">Figure 3.1: Use case diagram of TexEye AI<span class="toc-dots"></span>20</div>
          <div class="toc-line">Figure 4.1: Hardware Architecture and Physical Interconnect Diagram<span class="toc-dots"></span>35</div>
          <div class="toc-line">Figure 5.1: Package and component diagram of TexEye AI<span class="toc-dots"></span>41</div>
          <div class="toc-line">Figure 5.2: Deployment diagram of edge-cloud architecture<span class="toc-dots"></span>42</div>
          <div class="toc-line">Figure 5.3: Class diagram of TexEye AI domain model<span class="toc-dots"></span>43</div>
          <div class="toc-line">Figure 5.4: Entity relationship diagram of TexEye AI<span class="toc-dots"></span>45</div>
          <div class="toc-line">Figure 5.5: Sequence diagram for UC-01 Start Inspection Session<span class="toc-dots"></span>47</div>
          <div class="toc-line">Figure 5.6: Sequence diagram for UC-03 Real-Time Defect Detection & Tracking<span class="toc-dots"></span>48</div>
          <div class="toc-line">Figure 5.7: Sequence diagram for UC-05 Reliability Gating & Uninspected Mark<span class="toc-dots"></span>49</div>
          <div class="toc-line">Figure 5.8: Sequence diagram for UC-08 Offline Buffering & Resilient Cloud Sync<span class="toc-dots"></span>50</div>
          <div class="toc-line">Figure 5.9: Sequence diagram for UC-09 Review & Correct Defect Classification<span class="toc-dots"></span>51</div>
          <div class="toc-line">Figure 5.10: Sequence diagram for UC-10 Compute ASTM D5430 4-Point Grade<span class="toc-dots"></span>52</div>
          <div class="toc-line">Figure 5.11: Sequence diagram for UC-12 Export PDF Quality Certificate<span class="toc-dots"></span>53</div>
          <div class="toc-line">Figure 5.12: State machine diagram: roll inspection run<span class="toc-dots"></span>54</div>
          <div class="toc-line">Figure 5.13: State machine diagram: offline sync outbox queue<span class="toc-dots"></span>56</div>
          <div class="toc-line">Figure 5.14: Activity diagram of the overall inspection and grading system<span class="toc-dots"></span>57</div>
'@
    $pages.Add((New-Page -PageNumber 4 -Content $p4))

    # ==================== PAGE 5: LIST OF TABLES ====================
    $p5 = @'
          <div class="chapter-bar">List of Tables</div>
          <div class="toc-line">Table 2.1: Scope boundaries of TexEye AI<span class="toc-dots"></span>10</div>
          <div class="toc-line">Table 2.2: User classes and their characteristics<span class="toc-dots"></span>11</div>
          <div class="toc-line">Table 2.3: Operating environment and minimum platform<span class="toc-dots"></span>12</div>
          <div class="toc-line">Table 3.1: Optical Ingestion & Synchronization requirements (FR-ING)<span class="toc-dots"></span>13</div>
          <div class="toc-line">Table 3.2: Real-Time AI Inference & Metrology requirements (FR-INF)<span class="toc-dots"></span>14</div>
          <div class="toc-line">Table 3.3: Inspection Reliability Invariant requirements (FR-REL)<span class="toc-dots"></span>14</div>
          <div class="toc-line">Table 3.4: Multi-Frame Tracking & Deduplication requirements (FR-TRK)<span class="toc-dots"></span>15</div>
          <div class="toc-line">Table 3.5: ASTM D5430 4-Point Grading requirements (FR-GRD)<span class="toc-dots"></span>15</div>
          <div class="toc-line">Table 3.6: Offline Local Buffering requirements (FR-BUF)<span class="toc-dots"></span>16</div>
          <div class="toc-line">Table 3.7: Cloud Synchronization & Ingestion API requirements (FR-SYN)<span class="toc-dots"></span>16</div>
          <div class="toc-line">Table 3.8: Floor Operator Mobile Application requirements (FR-MOB)<span class="toc-dots"></span>17</div>
          <div class="toc-line">Table 3.9: Quality Management Web Dashboard requirements (FR-DSH)<span class="toc-dots"></span>17</div>
          <div class="toc-line">Table 3.10: Reporting, Export & Audit Trail requirements (FR-REP)<span class="toc-dots"></span>18</div>
          <div class="toc-line">Table 3.11: Actors of TexEye AI<span class="toc-dots"></span>21</div>
          <div class="toc-line">Table 3.12: Use case summary<span class="toc-dots"></span>21</div>
          <div class="toc-line">Table 3.13: Screens of the TexEye AI web and mobile clients<span class="toc-dots"></span>34</div>
          <div class="toc-line">Table 3.14: Software interfaces<span class="toc-dots"></span>36</div>
          <div class="toc-line">Table 4.1: Performance requirements<span class="toc-dots"></span>37</div>
          <div class="toc-line">Table 5.1: Modules and their development owners<span class="toc-dots"></span>41</div>
          <div class="toc-line">Table 5.2: Classes and responsibilities<span class="toc-dots"></span>44</div>
          <div class="toc-line">Table 5.3: Main entities of TexEye AI<span class="toc-dots"></span>46</div>
          <div class="toc-line">Table 5.4: State transition table: roll inspection run<span class="toc-dots"></span>55</div>
          <div class="toc-line">Table 5.5: State transition table: offline sync outbox queue<span class="toc-dots"></span>56</div>
          <div class="toc-line">Table 5.6: Decision table: inspection reliability gating and alarm actuation<span class="toc-dots"></span>61</div>
          <div class="toc-line">Table 5.7: Decision table: defect penalty point assignment (ASTM D5430-07)<span class="toc-dots"></span>61</div>
'@
    $pages.Add((New-Page -PageNumber 5 -Content $p5))

    # ==================== PAGE 6: CHAPTER 1 INTRODUCTION ====================
    $p6 = @'
          <div class="chapter-bar">1 Introduction</div>
          <h2 class="sec-heading">1.1 System Introduction</h2>
          <p>
            <b>TexEye AI</b> is an industrial edge-cloud hybrid automated fabric defect inspection and digitized quality management system engineered specifically for high-throughput textile manufacturing mills. Operating downstream of fabric weaving looms and unrolling stands, TexEye AI consumes continuous high-resolution optical video streams synchronized directly with physical mill movement via a hardware rotary optical encoder. Rather than relying on cloud-dependent vision APIs that introduce latency and network fragility, TexEye AI executes real-time defect segmentation, classification, multi-frame Kalman tracking, and physical millimeter metrology locally on an industrial edge computing unit (NVIDIA Jetson / Linux x86 edge rig) stationed directly beside the inspection table.
          </p>
          <p>
            The system identifies and categorizes the primary structural and superficial fabric defects encountered in Pakistani textile production—including broken warp threads, broken weft picks, oil streaks, holes, floats, dirty spots, and stitching irregularities. Concurrently, it maintains a strict mathematical invariant: <i>fabric sections subjected to optical degradation, camera drops, or speed violations are explicitly flagged as Uninspected Sections and forbidden from being certified clean</i>. Verified inspection batches are stored in an offline-resilient local SQLite Write-Ahead Logging (WAL) outbox queue and pushed automatically to an enterprise cloud backend (FastAPI, PostgreSQL, MinIO) whenever network connectivity permits, enabling executive quality analytics, interactive 2D defect heatmaps, and automated ASTM D5430-07 4-point penalty grading.
          </p>
          <h2 class="sec-heading">1.2 Background of the System</h2>
          <p>
            In Pakistan's industrial textile sector—centered around major weaving hubs in Wah, Taxila, Rawalpindi, and Faisalabad—fabric quality assurance remains overwhelmingly manual. Human inspectors stand over motorized rolling frames where fabric moves continuously at linear velocities between 0.2 and 0.5 meters per second (12 to 30 meters per minute). Human physiological limits, eye fatigue, and visual accommodation fatigue cause defect escape rates of 30% to 40% after just 45 to 60 minutes of uninterrupted work.
          </p>
          <p>
            Furthermore, traditional manual inspection produces handwritten paper roll logs that completely fail to record exact metric coordinates $(X_{\text{lateral}}, Y_{\text{longitudinal}})$. Inspectors mark defects using temporary chalk or paper stickers that regularly fall off during winding, packing, and shipment. The resulting disconnect between shop-floor quality inspection and computerized Enterprise Resource Planning (ERP) databases causes costly fabric rejections at international export ports and leaves downstream garment cutting rooms unable to optimize computerized marker placement around known flaws. Existing commercial automated optical inspection (AOI) machines are imported proprietary monoliths costing tens of thousands of dollars, completely inaccessible to small-to-medium Pakistani weaving units. TexEye AI solves this critical national challenge by delivering an accessible, open-standard, edge-first AI inspection ecosystem tailored to local industrial realities.
          </p>
'@
    $pages.Add((New-Page -PageNumber 6 -Content $p6))

    # ==================== PAGE 7: 1.3 OBJECTIVES & 1.4 SIGNIFICANCE ====================
    $p7 = @'
          <h2 class="sec-heading">1.3 Objectives of the System</h2>
          <ul>
            <li><b>Real-Time Edge Optical Ingestion:</b> Capture continuous area-scan video at &ge; 30 frames per second at 1080p resolution, synchronized with mill fabric speed via hardware GPIO quadrature pulses.</li>
            <li><b>Millimeter-Accurate Physical Metrology:</b> Map localized pixel coordinates $(u, v)$ to true physical coordinates $(X_{\text{mm}}, Y_{\text{meters}})$ on the moving fabric web, independent of motor acceleration or slippage.</li>
            <li><b>High-Precision Defect Classification & Localization:</b> Fine-tune single-stage convolutional detection models (YOLOv8/v11) to achieve &ge; 88% mean Average Precision ($mAP@0.5$) across standard textile defect categories under TensorRT FP16 acceleration (&lt; 25 ms inference latency per frame).</li>
            <li><b>Multi-Frame Tracking & Deduplication:</b> Associate defect bounding boxes across sequential overlapping frames using a Kalman Filter and IoU tracker (ByteTrack) to eliminate duplicate counts of traversing flaws.</li>
            <li><b>Non-Negotiable Reliability Invariant Enforcement:</b> Continuously monitor camera frame delivery, illumination lux levels, and image sharpness; immediately flag degraded spans as <code>UNINSPECTED_SECTION</code> to mathematically guarantee that uninspected fabric is never falsely graded clean.</li>
            <li><b>Automated ASTM D5430-07 4-Point Grading:</b> Calculate standardized penalty points (1 to 4 points based on defect length and direction) per 100 square meters, automatically assigning commercial Roll Grades (Grade A, Grade B, Grade C, or Reject).</li>
            <li><b>Offline-Resilient Transactional Outbox:</b> Persist all frame metadata and defect records to a local SQLite WAL buffer, guaranteeing zero inspection data loss during mill network disconnections, with auto-resume HTTPS batch synchronization.</li>
            <li><b>Shop-Floor Audio-Visual Alarming & Dual UI:</b> Actuate a physical 24V industrial stack light and buzzer via opto-isolated relay on critical defects, while serving real-time alerts to a Flutter floor mobile app and an executive React web dashboard.</li>
          </ul>
          <h2 class="sec-heading">1.4 Significance of the System</h2>
          <p>
            TexEye AI delivers immediate measurable significance across three fundamental operational dimensions:
          </p>
          <ul>
            <li><b>Industrial & Economic Impact:</b> Eliminates manual visual fatigue bottlenecks, reducing fabric defect escape rates from 35% down to under 5%. Automating the ASTM 4-point calculation eliminates human grading bias, protects Pakistani textile mills against international chargebacks, and cuts annual post-export rejection claims.</li>
            <li><b>Cutting-Room Optimization (Industry 4.0):</b> By storing high-precision spatial coordinates $(X, Y)$ for every flaw in a digital database, garment manufacturing cut-plans can automatically arrange CAD marker patterns to avoid flawed areas, converting otherwise rejected fabric into usable sub-panels.</li>
            <li><b>Academic & Engineering Rigor:</b> Demonstrates a production-grade cyber-physical system integrating hardware interrupt drivers, opto-isolated industrial relays, TensorRT-accelerated edge AI, formal state-machine fault tolerance, and offline-first distributed cloud architectures in a real-world BS-AI capstone.</li>
          </ul>
'@
    $pages.Add((New-Page -PageNumber 7 -Content $p7))

    # ==================== PAGE 8: CHAPTER 2 OVERALL DESCRIPTION ====================
    $p8 = @'
          <div class="chapter-bar">2 Overall Description</div>
          <h2 class="sec-heading">2.1 Product Perspective</h2>
          <p>
            <b>TexEye AI</b> is a complete, self-contained cyber-physical quality assurance ecosystem designed to operate directly within textile weaving, knitting, and fabric inspection lines. The system does not attempt to replace mechanical rolling tables; rather, it mounts non-invasively onto existing motorized inspection frames (e.g., COTS inspection frames commonly found in Wah and Taxila weaving mills).
          </p>
          <p>
            The physical environment consists of an extruded aluminum structural arch spanning across the width of the fabric table (typically 1.6 to 2.2 meters wide). An overhead industrial area-scan camera (USB 3.0 / GigE) and a regulated high-CRI LED lighting bar are rigidly suspended above the moving fabric. Below, a roller-coupled incremental rotary optical encoder transmits quadrature pulses into the hardware GPIO pins of an industrial edge computing unit, generating hardware interrupts that trigger frame captures synchronously with physical linear web displacement.
          </p>
          <p>
            Internally, TexEye AI implements a decoupled two-tier architecture:
          </p>
          <ul>
            <li><b>Industrial Edge Tier:</b> Stationed at the machine stand, running Linux, OpenCV, TensorRT, and a lightweight edge daemon. It handles high-frequency physical ingestion (30+ FPS), metric coordinate mapping, YOLO inference, Kalman defect tracking, stack-light relay actuation, reliability invariant checks, and local persistence in a transactional SQLite (WAL) buffer.</li>
            <li><b>Central Cloud / Enterprise Tier:</b> Hosted on a centralized server or cloud instance (FastAPI, PostgreSQL, MinIO S3, Redis). It consumes validated inspection batches from the edge daemons via HTTPS REST endpoints, computes enterprise ASTM D5430 roll grading metrics, manages role-based access control (RBAC), and serves WebSocket push notifications to floor mobile devices and web workstation clients.</li>
          </ul>
          <p>
            Figure 2.1 displays the complete system block diagram, illustrating physical sensor inputs, the edge ingestion and tracking pipeline, offline outbox storage, cloud persistence, and client interfaces.
          </p>
'@
    $pages.Add((New-Page -PageNumber 8 -Content $p8))

    # ==================== PAGE 9: FIGURE 2.1 SYSTEM BLOCK DIAGRAM ====================
    $p9 = @'
          <div class="diagram-container">
            <img class="diagram-img" src="../diagrams/svg/01_system_workflow.svg" alt="System block diagram of TexEye AI" />
            <div class="caption">Figure 2.1: System block diagram of TexEye AI</div>
          </div>
'@
    $pages.Add((New-Page -PageNumber 9 -Content $p9))

    # ==================== PAGE 10: 2.2 PRODUCT SCOPE & 2.3 PRODUCT FUNCTIONALITY ====================
    $p10 = @'
          <h2 class="sec-heading">2.2 Product Scope</h2>
          <p>
            TexEye AI is purposefully bounded to automated defect detection, metrology, grading, and reporting on woven and knitted fabric webs. The explicit boundaries between in-scope features and out-of-scope enterprise functions are summarized in Table 2.1.
          </p>
          <div style="font-weight: bold; font-size: 8.5pt; margin-bottom: 1mm;">Table 2.1: Scope boundaries of TexEye AI</div>
          <table class="formal-table">
            <thead>
              <tr>
                <th style="width: 50%;">In scope</th>
                <th style="width: 50%;">Out of scope</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Single-web optical surface inspection on woven and plain-knitted fabrics up to 2.2 meters wide moving at 0.2 to 0.5 m/s.</td>
                <td>Double-sided inspection (requiring simultaneous bottom-illuminated cameras) or non-woven industrial composite materials.</td>
              </tr>
              <tr>
                <td>Detection and localization of standard structural and superficial defects: holes, oil stains, warp streaks, weft cracks, dirty spots, and stitching tears.</td>
                <td>Spectrophotometric chemical dye analysis, thread count density verification under high-magnification microscopy, or yarn tensile strength testing.</td>
              </tr>
              <tr>
                <td>Millimeter-accurate coordinate mapping $(X, Y)$ using roller-coupled rotary optical encoder quadrature pulse interrupts.</td>
                <td>Motor speed PID regulation or direct mechanical winder tension feedback control (the system senses displacement, it does not drive motors).</td>
              </tr>
              <tr>
                <td>Local edge inference (&lt; 25 ms latency via TensorRT FP16) and multi-frame Kalman tracking for flaw deduplication.</td>
                <td>On-device retraining or continuous gradient backpropagation on edge hardware during live inspection runs.</td>
              </tr>
              <tr>
                <td>Automated ASTM D5430-07 4-point penalty calculation and commercial roll grading (Grade A, B, C, Reject).</td>
                <td>Automated fabric cut-plan pattern nesting or direct control of CNC laser cutting machinery.</td>
              </tr>
              <tr>
                <td>Offline-first local SQLite (WAL) buffering guaranteeing zero data loss during plant-wide network dropouts.</td>
                <td>Full multi-tenant cloud SaaS billing, payment gateways, or enterprise human resource payroll integrations.</td>
              </tr>
              <tr>
                <td>Floor mobile alerting (Flutter) and executive web dashboard (React) with 2D defect heatmaps and PDF export.</td>
                <td>Proprietary legacy ERP protocol converters (communication is handled via standard REST/JSON and CSV exports).</td>
              </tr>
            </tbody>
          </table>
          <h2 class="sec-heading">2.3 Product Functionality</h2>
          <p>
            The major functional capabilities of TexEye AI are summarized below and fully specified in Chapter 3:
          </p>
          <ul>
            <li><b>Roll Initialization:</b> Floor operators scan a physical QR code on the raw fabric roll to bind roll metadata (Batch ID, Fabric Construction, Target Length, GSM, Warp/Weft Density) into the local inspection session.</li>
            <li><b>Synchronized Optical Capture:</b> Camera frame acquisition is triggered synchronously with optical encoder pulses, eliminating motion blur and geometric distortion across varying machine speeds.</li>
          </ul>
'@
    $pages.Add((New-Page -PageNumber 10 -Content $p10))

    return $pages
}

Write-Output "Pages 1 to 10 module loaded."


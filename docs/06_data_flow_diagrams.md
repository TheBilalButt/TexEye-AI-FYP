# TexEye AI — Data Flow Diagrams (Context, Level 0 & Level 1)

## 1. Context Diagram (System Level 0 Context)

The Context Diagram outlines the external boundaries of TexEye AI, showing how factory operators, hardware sensors, and cloud infrastructure communicate with our core system.

```mermaid
flowchart TB
    TEXEYE[["TexEye AI System Core"]]

    CAM["Industrial Camera"] -- "High-Speed Video Stream" --> TEXEYE
    ENC["Rotary Encoder"] -- "Quadrature Pulse Train" --> TEXEYE
    TEXEYE -.->|Strobe / Lux Monitor| LIGHT["Lighting System"]
    TEXEYE -- "Relay Trigger / Fault Alarm" --> ALERT["Stack Beacon"]

    OP["Floor Operator (Mobile)"] <-->|QR Scan / Alerts / Thumbnails| TEXEYE
    QI["Quality Inspector (Web)"] <-->|Defect Corrections / Grading / Reports| TEXEYE
    PM["Production Manager (Web)"] <-->|Defect Pareto Stats & Trends| TEXEYE
    IM["Inventory Manager (Web)"] <-->|Bay Stock / Scrap Quarantine| TEXEYE
    ADMIN["System Admin (Web)"] <-->|User RBAC & Calibration Rules| TEXEYE

    TEXEYE <== "Idempotent Batch Sync (HTTPS / TLS 1.3)" ==> CLOUD["Enterprise Cloud DB & S3"]
```

---

## 2. Level 0 Data Flow Diagram (DFD L0)

The Level 0 Data Flow Diagram breaks TexEye AI into five primary processes, showing the data flowing between processes and data stores:

```mermaid
flowchart TB
    P1["1.0 Ingest & Validate Hardware Signals"]
    P2["2.0 Process AI Detection, Tracking & Metrology"]
    P3["3.0 Manage Edge Persistence & Sync Queue"]
    P4["4.0 Manage Central Quality, Grading & Reports"]
    P5["5.0 Serve User Applications & Dispatch Alerts"]

    D1[("D1: Local SQLite DB")]
    D2[("D2: Offline Sync Queue")]
    D3[("D3: Central PostgreSQL DB")]
    D4[("D4: Cloud Object Storage")]

    CAM["Industrial Camera"] -->|Raw Frames| P1
    ENC["Rotary Encoder"] -->|Encoder Pulses| P1
    P1 -->|Reliable Frames + Delta L| P2
    P1 -->|Uninspected Span [L1, L2]| P3
    P2 -->|Unique Defect Records (X, Y)| P3

    P3 <--> D1
    P3 <--> D2
    P3 == "HTTPS Batch Sync" ==> P4
    P3 == "Upload Defect Crops" ==> D4

    P4 <--> D3
    P4 --> P5

    P5 <--> OP["Floor Operator"]
    P5 <--> QI["Quality Inspector"]
    P5 <--> PM["Production Manager"]
    P5 <--> IM["Inventory Manager"]
    P5 <--> ADMIN["System Admin"]
```

### Data Stores Description:
- **D1 (Local SQLite DB):** Local edge database storing active sessions, real-time defect entries, and uninspected intervals.
- **D2 (Offline Sync Queue):** Local outbox table tracking ordered, idempotent transactions waiting to upload to the cloud.
- **D3 (Central PostgreSQL DB):** Central database holding final roll data, verified defect logs, 4-point grades, user accounts, and audit records.
- **D4 (Cloud Object Storage - MinIO/S3):** Cloud file store archiving compressed defect crop images and generated PDF inspection certificates.

---

## 3. Level 1 Data Flow Diagram (DFD L1)

The Level 1 Data Flow Diagram zooms into the sub-processes within each module:

```mermaid
flowchart TB
    subgraph P1_SUBSYS ["1.0 Hardware Ingestion & Reliability Subsystem"]
        P1_1["1.1 Frame Capture & Timestamp Buffer"]
        P1_2["1.2 Encoder Pulse Integration Engine"]
        P1_3["1.3 Quality & Health Reliability Monitor"]
        P1_4["1.4 Uninspected Section Span Calculator"]
    end

    subgraph P2_SUBSYS ["2.0 AI Vision & Metrology Subsystem"]
        P2_1["2.1 ROI Conditioning & CLAHE Contrast"]
        P2_2["2.2 AI Object Detection (YOLO Inference)"]
        P2_3["2.3 Multi-Frame Tracker & Deduplication"]
        P2_4["2.4 Metric Coordinate Mapping (X_cm, Y_m)"]
    end

    subgraph P3_SUBSYS ["3.0 Edge Data Storage & Sync"]
        P3_1["3.1 Local SQLite Writer & Image Store"]
        P3_2["3.2 Connectivity Probe & Sync Dispatcher"]
    end

    subgraph P4_5_SUBSYS ["4.0 & 5.0 Central Quality & User Presentation"]
        P4_1["4.1 Defect Review & Correction Manager"]
        P4_2["4.2 4-Point Fabric Grading Calculator"]
        P4_3["4.3 Report & Quality Statistics Engine"]
        P5_1["5.1 Real-Time Alert Broadcaster (WebSocket)"]
        P5_2["5.2 Digital Fabric Defect Map Renderer"]
    end

    CAM["Industrial Camera"] --> P1_1
    ENC["Rotary Encoder"] --> P1_2

    P1_1 --> P1_3
    P1_2 --> P1_3
    P1_2 -- "Delta L" --> P2_4

    P1_3 -- "Degraded Anomaly" --> P1_4
    P1_4 -- "Uninspected Span [L1, L2]" --> P3_1

    P1_3 -- "Clean Frame Stream" --> P2_1
    P2_1 --> P2_2 --> P2_3 --> P2_4
    P2_4 -- "Defect {ID, Class, X, Y, Img}" --> P3_1

    P3_1 --> P3_2
    P3_2 == "HTTPS Ingestion" ==> P4_1
    P4_1 --> P4_2 --> P4_3

    P3_2 -.->|Warning / Critical Defect| P5_1
    P4_1 --> P5_2

    P5_1 --> OP["Floor Operator"]
    P4_1 <--> QI["Quality Inspector"]
    P4_2 --> IM["Inventory Manager"]
    P4_3 --> PM["Production Manager"]
    P5_2 --> QI
```

### Detailed Sub-Process Logic:
- **1.3 Quality & Health Reliability Monitor:** Compares frame timestamps against fabric speed ($\Delta t_{frame} \approx \Delta L / v_{fabric}$), checks Laplacian variance for blur, and verifies average brightness.
- **1.4 Uninspected Section Span Calculator:** Saves starting encoder count when a sensor issue occurs; monitors until resolved; calculates meters of fabric missed; logs failure reason (e.g., `DROPPED_FRAMES` or `CAMERA_DISCONNECTED`).
- **2.3 Multi-Frame Tracker & Deduplication:** Matches defect bounding boxes across consecutive frames using IoU tracking. Makes sure a single physical flaw isn't counted multiple times as it passes through the field of view.
- **2.4 Metric Coordinate Mapping:** Converts pixel locations $(u, v)$ to width $X_{cm}$ using camera calibration and converts encoder pulses into length $Y_m$.
- **4.2 4-Point Fabric Grading Calculator:** Standard ASTM D5430 penalty scale:
  - Defect length up to 3 inches: **1 point**
  - Defect length over 3 to 6 inches: **2 points**
  - Defect length over 6 to 9 inches: **3 points**
  - Defect length over 9 inches / holes over 1 inch: **4 points**
  - Formula:
    $$\text{Points per } 100\text{ m}^2 = \frac{\text{Total Penalty Points} \times 10,000}{\text{Total Length (m)} \times \text{Fabric Width (cm)}} \times 100$$

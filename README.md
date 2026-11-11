# TexEye AI: AI-Based Fabric Defect Detection and Quality Management System

[![Academic Year](https://img.shields.io/badge/FYP-2026-blue.svg)](https://github.com/TheBilalButt/TexEye-AI-FYP)
[![Degree](https://img.shields.io/badge/BS-Artificial%20Intelligence-emerald.svg)](https://github.com/TheBilalButt/TexEye-AI-FYP)
[![Architecture](https://img.shields.io/badge/Edge%20AI-Real--Time%20Inference-purple.svg)](https://github.com/TheBilalButt/TexEye-AI-FYP)
[![Status](https://img.shields.io/badge/Status-Complete%20Analysis%20%26%20Design-success.svg)](https://github.com/TheBilalButt/TexEye-AI-FYP)

> **Final Year Project (BS Artificial Intelligence)**  
> **Project Members:**  
> 1. **Muhammad Afnan Khan** &mdash; FA23-BAI-028 (*Mobile Application, Web Dashboard, Defect Mapping, Grading & Sync*)  
> 2. **Muhammad Bilal Butt** &mdash; FA23-BAI-042 (*AI Vision, Model Training, Hardware Integration & Edge Reliability*)  

---

## 1. Executive Summary & Problem Statement

In textile manufacturing, quality inspection is still done manually on inspection rolling stands. At speeds of 20 to 60+ meters per minute, human inspectors face eye fatigue and regularly miss 30% to 40% of small defects (like broken yarns, small holes, or oil drops). When flawed fabric gets shipped, mills face heavy financial penalties and wasted inventory. On top of that, manual logs are handwritten on paper and don't record physical defect coordinates.

Furthermore, automated camera systems often suffer from real-world hardware issues:
- Camera cables disconnecting due to machine vibration
- Lighting fluctuations or LED failures
- Lint or dust gathering on the lens, causing blur
- Dropped frames during high-speed data transfer

### The Non-Negotiable Invariant
> **Core System Invariant:** If inspection reliability is compromised due to a disconnected camera, poor lighting, lens blur, or dropped frames, the affected stretch of fabric $[L_{start}, L_{end}]$ is explicitly recorded and flagged as **`UNINSPECTED`**. Under no circumstances is uninspected fabric treated as clean or defect-free.

---

## 2. Visual Architecture & Key Diagrams

All system diagrams are available in **editable Draw.io XML (`diagrams/drawio/`)**, **vector SVG (`diagrams/svg/`)**, **high-resolution PNG (`diagrams/png/`)**, and **Mermaid source (`diagrams/mermaid/`)**.

| Diagram | Description | Formats |
| :--- | :--- | :--- |
| **01. System Workflow** | Complete operational flow with the Reliability Decision Gate | [Draw.io](diagrams/drawio/01_system_workflow.drawio) &bull; [SVG](diagrams/svg/01_system_workflow.svg) &bull; [PNG](diagrams/png/01_system_workflow.png) |
| **02. AI Inspection Pipeline** | Preprocessing, YOLO detection, Kalman tracking, deduplication &amp; metric mapping | [Draw.io](diagrams/drawio/02_ai_inspection_workflow.drawio) &bull; [SVG](diagrams/svg/02_ai_inspection_workflow.svg) &bull; [PNG](diagrams/png/02_ai_inspection_workflow.png) |
| **03. Offline/Online Sync** | Edge-first storage, offline sync queue &amp; cloud batch updates | [Draw.io](diagrams/drawio/03_offline_sync_workflow.drawio) &bull; [SVG](diagrams/svg/03_offline_sync_workflow.svg) &bull; [PNG](diagrams/png/03_offline_sync_workflow.png) |
| **04. Hardware Architecture** | Camera, rotary encoder, lighting driver, alert beacon &amp; edge computer | [Draw.io](diagrams/drawio/04_hardware_architecture.drawio) &bull; [SVG](diagrams/svg/04_hardware_architecture.svg) &bull; [PNG](diagrams/png/04_hardware_architecture.png) |
| **05. Software Architecture** | 5-Tier layered architecture &amp; inter-service protocols | [Draw.io](diagrams/drawio/05_software_architecture.drawio) &bull; [SVG](diagrams/svg/05_software_architecture.svg) &bull; [PNG](diagrams/png/05_software_architecture.png) |
| **06. UML Use Cases** | System boundary, 5 human actors, and automated edge subsystem | [Draw.io](diagrams/drawio/06_use_case_overall.drawio) &bull; [SVG](diagrams/svg/06_use_case_overall.svg) &bull; [PNG](diagrams/png/06_use_case_overall.png) |
| **07. Context Diagram** | System boundaries and data flows with external entities | [Draw.io](diagrams/drawio/07_context_and_dfd.drawio) &bull; [SVG](diagrams/svg/07_context_diagram.svg) &bull; [PNG](diagrams/png/07_context_diagram.png) |
| **08. DFD Level 0** | 5 major system processes and 4 data stores (D1 to D4) | [Draw.io](diagrams/drawio/07_context_and_dfd.drawio) &bull; [SVG](diagrams/svg/08_dfd_level_0.svg) &bull; [PNG](diagrams/png/08_dfd_level_0.png) |
| **09. DFD Level 1** | Sub-process decomposition: ingestion, AI metrology &amp; 4-point grading | [Draw.io](diagrams/drawio/07_context_and_dfd.drawio) &bull; [SVG](diagrams/svg/09_dfd_level_1.svg) &bull; [PNG](diagrams/png/09_dfd_level_1.png) |
| **10. Component Diagram** | Software components, exposed interfaces &amp; socket dependencies | [Draw.io](diagrams/drawio/08_component_and_deployment.drawio) &bull; [SVG](diagrams/svg/10_component_diagram.svg) &bull; [PNG](diagrams/png/10_component_diagram.png) |
| **11. Deployment Diagram** | Execution environments, physical nodes, network buses &amp; protocols | [Draw.io](diagrams/drawio/08_component_and_deployment.drawio) &bull; [SVG](diagrams/svg/11_deployment_diagram.svg) &bull; [PNG](diagrams/png/11_deployment_diagram.png) |
| **12. Sequence: Inspection** | Real-time sensor stream, reliability checks &amp; uninspected span handling | [Draw.io](diagrams/drawio/09_sequence_diagrams.drawio) &bull; [SVG](diagrams/svg/12_sequence_inspection.svg) &bull; [PNG](diagrams/png/12_sequence_inspection.png) |
| **13. Sequence: Offline Sync** | Heartbeat check, chunked batch sync &amp; idempotent cloud updates | [Draw.io](diagrams/drawio/09_sequence_diagrams.drawio) &bull; [SVG](diagrams/svg/13_sequence_sync.svg) &bull; [PNG](diagrams/png/13_sequence_sync.png) |
| **14. Entity Relationship** | 9 relational entities, primary/foreign keys &amp; complete data dictionary | [Draw.io](diagrams/drawio/10_entity_relationship_diagram.drawio) &bull; [SVG](diagrams/svg/14_entity_relationship_diagram.svg) &bull; [PNG](diagrams/png/14_entity_relationship_diagram.png) |

---

## 3. Hardware Architecture & Proposed Interfaces

| Hardware Component | Connected To | Proposed Medium / Interface | Purpose | Selection Status |
| :--- | :--- | :--- | :--- | :--- |
| **Industrial Camera** | Edge Computer | USB 3.0 Vision / GigE Vision / MIPI-CSI2 | Real-time continuous video frame capture. | **Confirmed Subsystem** (Model proposed) |
| **Camera Lens** | Industrial Camera | C-Mount Low-Distortion Lens (8mm / 12mm / 16mm) | Uniform optical focus across fabric width. | **Confirmed Subsystem** (Focal length proposed) |
| **Rotary Encoder** | Measurement Roller &bull; Edge | Shielded GPIO Counter / TTL / Opto DAQ | Measures physical fabric movement ($\Delta L$). | **Confirmed Subsystem** (PPR proposed) |
| **Lighting Rig** | Inspection Area &bull; Driver | High-CRI Linear White LED Array | Uniform, flicker-free fabric illumination. | **Confirmed Subsystem** (Angle proposed) |
| **Lighting Driver** | Lighting Rig &bull; Edge Unit | Constant-Current 24V DC Driver / PWM Strobe | Prevents LED thermal drift and light ripple. | **Proposed Alternative** |
| **Alert Beacon** | Edge Computer Relay Output | Industrial 3-Color Stack Light &bull; Audible Buzzer | Immediate shop-floor visual and sound alarms. | **Proposed Alternative** |
| **Edge Computer** | Sensors, Storage &amp; Network | NVIDIA Jetson Orin / Industrial Mini-PC with GPU | Runs AI detection, tracking &amp; local SQLite. | **Confirmed Subsystem** (Form factor proposed) |
| **Network Uplink** | Edge Unit to Central Cloud | Industrial Cat6 Ethernet / Dual-Band Wi-Fi | Transmits HTTPS REST batches &amp; WebSockets. | **Proposed Alternative** |

*Explicit Out-of-Scope Notice:* Automatic fabric cutting, machine emergency stops, remote motor inverter controls, and physical fabric ink-stampers are **strictly excluded**.

---

## 4. Software Technology Stack (Proposed Recommendations)

- **Edge Layer:** Python 3.10+, OpenCV, V4L2/GenICam, SQLite 3 (WAL Mode), Linux POSIX timers.
- **AI Processing Layer:** PyTorch, ONNX Runtime / NVIDIA TensorRT (YOLOv8 / RT-DETR), NumPy, SciPy (Kalman Filter).
- **Backend / API Layer:** FastAPI (Python 3.11+), Uvicorn ASGI, Pydantic v2, PyJWT, WebSockets.
- **Data Persistence Layer:** PostgreSQL 16 (Central DB), MinIO / AWS S3 (Defect Image Object Store), SQLite (Edge DB).
- **Mobile Application:** Flutter (Dart) or React Native (TypeScript) with Mobile Camera QR Scanner.
- **Web Dashboard:** React 18+, TypeScript, Tailwind CSS, HTML5 Canvas 2D Defect Map.

---

## 5. Team Division of Responsibilities

### Muhammad Afnan Khan (FA23-BAI-028)
- Cross-platform Mobile Application (Flutter/React Native) with Camera QR code scanner.
- Floor operator alert reception and thumbnail defect review interfaces.
- Web Dashboard (React + TypeScript) with interactive 2D **Digital Fabric Defect Map**.
- Roll lifecycle management, batch metadata, and inventory warehouse allocation.
- Automated ASTM D5430 **4-Point Fabric Inspection Grading Engine**.
- Automated PDF digital inspection report certificate generator.
- Application-side local offline data synchronization and client state caching.

### Muhammad Bilal Butt (FA23-BAI-042)
- Fabric defect dataset collection, domain annotation, and synthetic augmentation.
- AI defect detection model training, transfer learning, and quantization (YOLO).
- Real-time high-throughput edge GPU inference pipeline.
- Multi-frame defect tracking (Kalman Filter + IoU matching) across consecutive frames.
- Spatial-temporal deduplication gate to eliminate repeat defect counting.
- Incremental rotary encoder hardware integration and displacement pulse counting.
- Industrial camera driver integration with zero-copy memory ring buffers.
- Optical illumination, focus blur, and dropped-frame watchdog monitors.
- **Inspection Reliability Gate** and mathematical isolation of uninspected fabric sections.

---

## 6. Repository File Structure

```text
TexEye-AI-FYP/
├── README.md                                  # Master FYP Documentation & Quickstart
├── docs/                                      # Detailed University Documentation
│   ├── 01_project_overview.md                 # Project Overview & Real-World Problem
│   ├── 02_system_workflow.md                  # System Workflow & Decision Pipeline
│   ├── 03_hardware_architecture.md            # Hardware Interconnects & Component Table
│   ├── 04_software_architecture.md            # Layered Software Architecture & Protocols
│   ├── 05_actors_and_use_cases.md             # Actor Specifications & Use Case Tables
│   ├── 06_data_flow_diagrams.md               # Context, DFD Level 0 & Level 1
│   ├── 07_component_and_deployment.md         # UML Component & Deployment Architecture
│   ├── 08_sequence_diagrams.md                # Real-Time Inspection & Offline Sync Flows
│   ├── 09_entity_relationship_diagram.md      # ERD Schema & Relational Data Dictionary
│   ├── 10_team_responsibilities.md            # Member Task Matrix (Afnan & Bilal)
│   ├── 11_hardware_selection_checklist.md     # Decision Matrix for Physical Procurement
│   ├── 12_assumptions_and_limitations.md      # System Constraints & Scope Boundaries
│   └── roman_urdu_defense_guide.md            # Complete Supervisor Viva Script in Roman Urdu
├── diagrams/                                  # Complete Multi-Format Diagram Package
│   ├── drawio/                                # Editable diagrams.net / draw.io XML files (10 files)
│   ├── svg/                                   # Standalone Scalable Vector Graphics (14 files)
│   ├── png/                                   # High-Resolution Rendered PNGs (14 files)
│   └── mermaid/                               # Raw Mermaid.js diagram source codes (14 files)
├── website/                                   # Interactive Documentation & Preview Portal
│   ├── index.html                             # Responsive Multi-tab Architecture Portal
│   ├── style.css                              # Custom Modern Dark/Light Design
│   └── app.js                                 # Tab Navigation & Dynamic SVG/Mermaid Viewer
└── scripts/
    ├── export_diagrams.ps1                    # Headless Edge Automated SVG-to-PNG Renderer
    └── serve_website.ps1                      # Lightweight PowerShell Local HTTP Server
```

---

## 7. Interactive Documentation Preview Portal

You can view the documentation and all diagrams interactively:
- **Locally:** Run `start_website.bat` or execute `powershell -ExecutionPolicy Bypass -File scripts\serve_website.ps1` to open the local portal at `http://localhost:8080`.
- **Online (GitHub Pages):** Enable GitHub Pages pointing to the root or `website/` directory to share a live link with supervisors and evaluators.

---

## 8. Supervisor Viva Guide in Roman Urdu

Both project members can review `docs/roman_urdu_defense_guide.md` for a complete, step-by-step presentation script in Roman Urdu covering every diagram and answering tough supervisor questions on:
- Uninspected section handling vs. defect detection
- Camera disconnection vs. internet outage handling
- Multi-frame deduplication logic
- Optical-to-physical coordinate calibration equations

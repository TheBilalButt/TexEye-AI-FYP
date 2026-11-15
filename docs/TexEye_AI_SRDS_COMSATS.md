# Software Requirements and Design Specification (SRDS)

## TexEye AI: AI-Based Fabric Defect Detection & Quality Management System

---

### Project Identification

- **Project Title:** TexEye AI: AI-Based Fabric Defect Detection and Quality Management System
- **Academic Degree:** Bachelor of Science in Artificial Intelligence (BS-AI)
- **Academic Department:** Department of Computer Science, COMSATS University Islamabad, Wah Campus
- **Academic Session:** 2026 – 2027
- **Course Code:** CSC498 / CSC499 (Final Year Project Capstone)
- **Project Authors & Registration Numbers:**
  1. **Muhammad Afnan Khan** — Registration No: **FA23-BAI-028**  
     *Role:* Mobile Application Development, React Web Dashboard, 2D Defect Map Rendering, ASTM 4-Point Grading Engine, Cloud Synchronization APIs & Reporting Hub.
  2. **Muhammad Bilal Butt** — Registration No: **FA23-BAI-042**  
     *Role:* Deep Learning Computer Vision Pipeline (YOLO), Model Optimization, Hardware Interfacing (Industrial Camera & Rotary Optical Encoder), Shop Floor Reliability Gate & Invariant Enforcement.
- **Project Supervisor:**
  **Dr. Tassawar Iqbal**  
  Department of Computer Science, COMSATS University Islamabad, Wah Cantt Campus
- **Document Version:** 2.0 (Final Academic Defense Edition)
- **Reference Standard:** ReDez Software Requirements and Design Specification Standard (COMSATS University Islamabad, Wah Campus), IEEE Std 830-1998 (Recommended Practice for Software Requirements Specifications), ISO/IEC/IEEE 29148:2018, UML 2.5 Specification.

---

## Executive Summary

Manual quality inspection in textile manufacturing represents one of the most critical and expensive operational bottlenecks in Pakistani textile manufacturing plants. In industrial mills across the Punjab textile belt (Wah, Taxila, Rawalpindi, and Faisalabad), woven fabric rolls move through manual inspection tables at linear velocities ranging between 0.2 and 0.5 meters per second (12 to 30 meters per minute), and often exceed 1.0 m/s on automated winders. Human inspectors, subjected to eye fatigue, visual accommodation breakdown, and attention drift after just 45 to 60 minutes of continuous scanning, routinely miss between 30% and 40% of localized fabric defects—such as broken threads, warp streaks, weft cracks, oil stains, needle drops, holes, and floats.

Furthermore, traditional manual inspection produces handwritten paper roll logs that completely fail to record metric spatial coordinates $(X_{\text{lateral}}, Y_{\text{longitudinal}})$. Defects are marked using temporary chalk or adhesive stickers that frequently detach during winding. Paper reports remain disconnected from warehouse enterprise resource planning (ERP) systems, preventing downstream garment cutting rooms from optimizing marker layouts to avoid flaws.

**TexEye AI** is an industrial-grade, edge-first automated fabric defect inspection and digitized quality management system. The system integrates:
1. **High-Speed Industrial Optical Ingestion:** An overhead industrial area-scan camera housed in an extruded aluminum vibration-damped rig, continuously illuminated by constant-current high-CRI LED arrays.
2. **Millimeter-Accurate Physical Metrology:** An incremental optical rotary encoder coupled directly to the fabric drive roller, transmitting quadrature hardware interrupt pulses over GPIO to track true longitudinal linear displacement ($Y$, in meters) immune to motor slip or speed variance.
3. **Real-Time AI Vision & Tracking Engine:** A fine-tuned YOLO single-stage convolutional detector accelerated via TensorRT FP16 on an industrial Linux edge computer, coupled with a multi-frame Kalman Filter and IoU association tracker (ByteTrack) to eliminate duplicate counts as flaws traverse overlapping video frames.
4. **Non-Negotiable Inspection Reliability Invariant:** An automated hardware-software gate that continuously verifies camera FPS, ambient lighting lux levels, image sharpness (Laplacian variance), and hardware heartbeats. If any sensor degrades, the system halts blind classification and logs that span as an `UNINSPECTED_SECTION`, ensuring uninspected fabric is never falsely certified as defect-free.
5. **Offline-First Transactional Outbox (WAL):** A local SQLite database operating in Write-Ahead Logging (WAL) mode, guaranteeing zero frame-data loss during mill-wide Wi-Fi outages, automatically synced to central cloud storage via HTTPS multipart batches once network connectivity resumes.
6. **Unified Dual-Client Architecture:** A Flutter/React Native mobile terminal for shop floor operators providing instant vibration alerts, QR roll scanner, and audio-visual alarms; paired with an interactive React/Tailwind web workstation for quality managers featuring interactive 2D roll defect heatmaps, ASTM D5430-07 4-point penalty grading, and automated PDF certification export.

---

## Table of Contents

- [Chapter 1: Introduction](#chapter-1-introduction)
  - [1.1 Purpose of the Document](#11-purpose-of-the-document)
  - [1.2 Document Conventions & Academic Standard](#12-document-conventions--academic-standard)
  - [1.3 Intended Audience](#13-intended-audience)
  - [1.4 Project Scope & Boundaries](#14-project-scope--boundaries)
  - [1.5 References & Industry Standards](#15-references--industry-standards)
- [Chapter 2: Overall System Description](#chapter-2-overall-system-description)
  - [2.1 Product Perspective & Context](#21-product-perspective--context)
  - [2.2 Product Major Functions](#22-product-major-functions)
  - [2.3 User Classes and Operating Personas](#23-user-classes-and-operating-personas)
  - [2.4 Operating Environment & Hardware Boundaries](#24-operating-environment--hardware-boundaries)
  - [2.5 Design & Implementation Constraints](#25-design--implementation-constraints)
  - [2.6 Assumptions and Dependencies](#26-assumptions-and-dependencies)
- [Chapter 3: System Features & Functional Requirements](#chapter-3-system-features--functional-requirements)
  - [3.1 Functional Requirement Specifications (FR-01 to FR-25)](#31-functional-requirement-specifications)
  - [3.2 Core Architectural Invariant: Non-Defect-Free Uninspected Section Handling](#32-core-architectural-invariant)
- [Chapter 4: External Interface Requirements](#chapter-4-external-interface-requirements)
  - [4.1 User Interfaces (Mobile & Web)](#41-user-interfaces)
  - [4.2 Hardware Interfaces (Camera, Encoder, Relays, Lighting)](#42-hardware-interfaces)
  - [4.3 Software Interfaces (Edge DB, Cloud PostgreSQL, MinIO Storage, FastAPI)](#43-software-interfaces)
  - [4.4 Communications Interfaces (V4L2, GPIO, HTTPS REST, WebSockets)](#44-communications-interfaces)
- [Chapter 5: Non-Functional Requirements](#chapter-5-non-functional-requirements)
  - [5.1 Performance Requirements](#51-performance-requirements)
  - [5.2 Reliability, Availability & Fault Tolerance](#52-reliability-availability--fault-tolerance)
  - [5.3 Safety & Security Requirements](#53-safety--security-requirements)
  - [5.4 Maintainability and Portability](#54-maintainability-and-portability)
- [Chapter 6: System Analysis & Architecture Design (Academic B&W Figures)](#chapter-6-system-analysis--architecture-design)
  - [6.1 System Workflow & Invariant Gate (Figure 1.1)](#61-system-workflow--invariant-gate)
  - [6.2 AI Vision & Metrology Workflow (Figure 1.2)](#62-ai-vision--metrology-workflow)
  - [6.3 Offline Store-and-Forward Sync Workflow (Figure 1.3)](#63-offline-store-and-forward-sync-workflow)
  - [6.4 Hardware Architecture & Physical Interconnect (Figure 4.1)](#64-hardware-architecture--physical-interconnect)
  - [6.5 System Context Diagram / DFD Level 0 Overview (Figure 4.2)](#65-system-context-diagram--dfd-level-0-overview)
  - [6.6 Data Flow Diagram Level 0 (Figure 4.3)](#66-data-flow-diagram-level-0)
  - [6.7 Data Flow Diagram Level 1 (Figure 4.4)](#67-data-flow-diagram-level-1)
  - [6.8 Layered Software Architecture (Figure 5.1)](#68-layered-software-architecture)
  - [6.9 UML Component Diagram (Figure 5.2)](#69-uml-component-diagram)
  - [6.10 UML Deployment Diagram (Figure 5.3)](#610-uml-deployment-diagram)
  - [6.11 Sequence Diagram: Inspection & Reliability Gating (Figure 5.4)](#611-sequence-diagram-inspection--reliability-gating)
  - [6.12 Sequence Diagram: Edge-to-Cloud Batch Synchronization (Figure 5.5)](#612-sequence-diagram-edge-to-cloud-batch-synchronization)
  - [6.13 Entity Relationship Diagram (Figure 5.6)](#613-entity-relationship-diagram)
  - [6.14 Comprehensive System Use Case Diagram (Figure 6.1)](#614-comprehensive-system-use-case-diagram)
- [Chapter 7: Team Division of Work & Responsibilities](#chapter-7-team-division-of-work--responsibilities)
- [Chapter 8: Traceability Matrix](#chapter-8-traceability-matrix)

---

# Chapter 1: Introduction

### 1.1 Purpose of the Document
This Software Requirements and Design Specification (SRDS) provides a complete, formal, and unambiguous specification of the functional, non-functional, structural, behavioral, and data requirements for **TexEye AI**. It serves as the primary technical baseline for final-year defense evaluation at the Department of Computer Science, COMSATS University Islamabad (Wah Campus), and guides engineering implementation across hardware assembly, edge machine vision pipelines, cloud APIs, and cross-platform clients.

### 1.2 Document Conventions & Academic Standard
This specification strictly adheres to:
1. **COMSATS Wah Capstone Guidelines:** Structured according to university guidelines modeled on institutional templates (`ReDez_SRDS`).
2. **IEEE Std 830-1998 / ISO/IEC/IEEE 29148:2018:** Functional requirements follow standard priority, precondition, processing, and postcondition schemas.
3. **UML 2.5 Standard Notation:** All architectural diagrams use standard academic black-and-white notation with solid black lines (`#000000`), white fills (`#ffffff`), and formal IEEE double frames. Faded secondary text has been completely omitted to ensure presentation quality.
4. **Defect Standard:** Fabric defect penalty scoring conforms to ASTM D5430-07 (Standard Test Methods for Visually Inspecting and Grading Fabrics).

### 1.3 Intended Audience
- **Faculty Evaluation Committee & External Examiners:** To assess structural architecture, engineering rigor, individual contributions, and verification standards.
- **Project Supervisors:** To monitor milestone delivery, requirements traceability, and deployment feasibility.
- **Industrial Partners & Mill Quality Engineers:** As an operational system integration manual detailing hardware interconnects, API payloads, and calibration procedures.

### 1.4 Project Scope & Boundaries
TexEye AI encompasses:
- Hardware interfacing with an area-scan industrial sensor (1080p @ 30–60 FPS) and an incremental optical rotary encoder generating 1000 to 2000 pulses per revolution.
- On-device real-time deep learning inference using YOLOv8/YOLOv11 for 6 standard defect classes: Hole, Stain, Warp Defect, Weft Defect, Float, and Oil Spot.
- Multi-frame object tracking and millimeter-level Euclidean coordinate mapping $(X_{\text{cm}}, Y_{\text{m}})$.
- Shop floor reliability monitoring (lux thresholding, blur variance, connection watchdog).
- Local transactional SQLite outbox buffer with automatic background synchronization.
- Central FastAPI backend deployed on Linux server with PostgreSQL 15 and MinIO S3.
- Shop floor mobile application and web quality dashboard.

*Out of Scope:* Mechanical loom repairs, automated robotic fabric cutter arms, spinning-stage raw cotton fiber grading, and knitting machine circular needle control.

### 1.5 References & Industry Standards
1. *ASTM D5430-07:* Standard Test Methods for Visually Inspecting and Grading Fabrics.
2. *IEEE Std 830-1998:* IEEE Recommended Practice for Software Requirements Specifications.
3. *ISO/IEC/IEEE 29148:2018:* Systems and software engineering — Life cycle processes — Requirements engineering.
4. *Bochkovskiy, A., et al.:* YOLO: Real-Time Object Detection Systems, IEEE CVPR.
5. *Zhang, Y., et al.:* ByteTrack: Multi-Object Tracking by Associating Every Detection Box, ECCV 2022.
6. *ReDez Capstone Specification:* Department of Computer Science, COMSATS University Islamabad, Wah Campus.

---

# Chapter 2: Overall System Description

### 2.1 Product Perspective & Context
TexEye AI is an autonomous cyber-physical quality monitoring system operating at the boundary of industrial shop-floor machinery and enterprise cloud management. Unlike off-the-shelf closed-box foreign inspection systems (such as Uster or Shelton Vision) that cost tens of thousands of dollars and lack local mill ERP integration, TexEye AI is cost-effective, modular, edge-resilient, and built with open-standard architectures.

The system interfaces physically with standard mill rolling/inspection frames via a roller-coupled rotary encoder and a camera arm mounted perpendicular to the moving fabric web.

### 2.2 Product Major Functions
1. **Roll QR Onboarding:** Scanning roll identity, fabric construction type, GSM, target length, and lot number to initialize inspection runs.
2. **Synchronized Signal Ingestion:** Coupling video frames with encoder interrupt ticks to associate each video frame with an absolute linear distance offset $Y_{\text{offset}}$.
3. **Hardware Health & Optical Invariant Guard:** Real-time checking of illumination constancy, image sharpness, and camera link health.
4. **AI Inference & Suppression:** Real-time localized bounding box prediction, Kalman filter trajectory tracking, and duplicate count suppression across overlapping frames.
5. **Physical Coordinate Mapping:** Transforming image pixel coordinates $(u, v)$ to physical fabric coordinates $(X_{\text{cm}}, Y_{\text{m}})$.
6. **ASTM D5430-07 4-Point Grading:** Assigning penalty points (1, 2, 3, or 4 points per flaw) and computing overall roll grade.
7. **Offline Store-and-Forward Outbox:** Committing results to local SQLite WAL queue before dispatching to central cloud.
8. **Interactive Visual Quality Dashboard:** Rendering 2D roll defect heatmaps, enabling manual re-classification, and exporting certified PDF reports.

### 2.3 User Classes and Operating Personas
- **Floor Operator (Persona: Shop Floor Worker):** Uses mobile app on Android terminal. Needs simple, high-contrast, large-button UI with vibration and audio alerts when major flaws are detected.
- **Quality Inspector (Persona: QA Specialist):** Uses desktop web workstation. Reviews flagged defect crops, corrects false positives/negatives, inspects quarantined uninspected spans, and validates ASTM grade.
- **Production Manager (Persona: Operations Head):** Analyzes aggregate metrics across looms, shifts, and suppliers; monitors mill defect heatmaps and export yields.
- **Inventory / Warehouse Manager:** Tracks certified roll statuses, warehouse bay storage assignments, and shipping holds.
- **System Administrator:** Manages users, JWT access keys, camera calibration parameters, and edge hardware diagnostic logs.

### 2.4 Operating Environment & Hardware Boundaries
- **Edge Computing Unit:** Industrial mini PC / NVIDIA Jetson Orin Nano (Linux Ubuntu 22.04 LTS, 8GB/16GB RAM, NVMe storage).
- **Camera Sensor:** Industrial USB 3.0 / GigE Area-Scan Camera (Sony IMX Sensor, global shutter, C-mount lens with fixed focal length $8\text{mm}$ or $12\text{mm}$).
- **Encoder:** Optical quadrature rotary encoder (Autonics or Omron, 1024 PPR, roller-coupled).
- **Illumination Rig:** Regulated constant-current DC LED light bar (Color Rendering Index $\ge 90$, 5500K color temperature).
- **Central Server:** Linux Server running Docker, Python 3.11, FastAPI, PostgreSQL 15, and MinIO S3 Object Storage.

---

# Chapter 3: System Features & Functional Requirements

### 3.1 Functional Requirement Specifications

| Req ID | Requirement Title | Priority | Primary Actor | Description & Precondition |
| :--- | :--- | :--- | :--- | :--- |
| **FR-01** | Scan & Initialize Roll Session | High | Floor Operator | System scans QR code on physical roll, queries roll metadata, and locks session state. |
| **FR-02** | Capture Video Stream | High | Camera Driver | Ingests uncompressed frames via V4L2/GenICam ring buffer at steady frame rate. |
| **FR-03** | Measure Linear Displacement | High | Pulse Counter | Measures encoder quadrature pulses via hardware interrupts to determine fabric movement. |
| **FR-04** | Optical Invariant Gating | Critical | Reliability Monitor | Continuously checks lighting lux levels ($\ge 400\text{ lux}$) and image blur variance ($\ge 85.0$). |
| **FR-05** | Mark Uninspected Section | Critical | Invariant Handler | If reliability checks fail, flags the interval $[L_{start}, L_{end}]$ as quarantined and uninspected. |
| **FR-06** | Real-Time Defect Detection | High | YOLO Inference | Identifies defects, assigns bounding boxes, labels class, and computes confidence score. |
| **FR-07** | Multi-Frame Track Association | High | ByteTrack Engine | Associates defect bounding boxes across consecutive frames using Kalman filtering and IoU. |
| **FR-08** | Duplicate Count Suppression | High | Metrology Engine | Ensures each unique defect is counted exactly once with unified dimensions. |
| **FR-09** | Physical Coordinate Metrology | High | Calibration Service | Converts pixel coordinates $(u, v)$ to $(X_{\text{cm}}, Y_{\text{m}})$ using calibrated camera parameters. |
| **FR-10** | Calculate ASTM 4-Point Penalty | High | Grading Engine | Assigns 1, 2, 3, or 4 penalty points based on defect physical length and computes total score. |
| **FR-11** | Local Outbox Persistence | Critical | SQLite WAL DB | Inserts defect records and image crops into local database with immediate transaction commit. |
| **FR-12** | Background Outbox Sync | High | Edge Sync Daemon | Reads unsynced records from SQLite and transmits multipart payload to central server. |
| **FR-13** | Server Batch Ingestion | High | FastAPI Backend | Ingests batches, commits records to PostgreSQL, and writes image crops to MinIO S3. |
| **FR-14** | Sync Eviction & Cleanup | Medium | SQLite Cleaner | Deletes uploaded image crop files from local storage once HTTP 200 receipt is verified. |
| **FR-15** | Stack Light Relay Actuation | High | Relay Driver | Energizes GPIO opto-coupler relay to trigger red tower light and buzzer upon critical flaws. |
| **FR-16** | Operator Mobile Push Alert | High | Push Hub / WSS | Emits WebSocket notification triggering vibration and audio warning on operator's phone. |
| **FR-17** | Interactive 2D Roll Map | High | Quality Inspector | Renders roll canvas displaying flaw markers and uninspected zones at exact $(X, Y)$ positions. |
| **FR-18** | Inspector Defect Correction | High | Quality Inspector | Allows inspector to reclassify, adjust bounding coordinates, or void false-positive records. |
| **FR-19** | Uninspected Section Override | High | Quality Manager | Permits authorized human review and certification of flagged uninspected sections. |
| **FR-20** | PDF Quality Certificate Export | High | Reporting Engine | Renders publication-grade PDF roll inspection report containing ASTM grade and defect table. |
| **FR-21** | User Authentication & RBAC | High | Auth Service | Authenticates users using JWT Bearer tokens and validates role privileges (RBAC). |
| **FR-22** | Inventory Storage Assignment | Medium | Inventory Manager | Updates roll inventory records with warehouse bay and rack coordinates upon grade approval. |
| **FR-23** | Historical Quality Analytics | Medium | Production Manager | Aggregates defect trends, defect frequency per loom/shift, and supplier grade ratios. |
| **FR-24** | Hardware Watchdog Monitoring | High | System Daemon | Monitors frame dropped counts, camera connectivity, CPU temperature, and disk usage. |
| **FR-25** | System Parameter Calibration | Medium | System Admin | Calibrates pixels-per-centimeter ratio, encoder pulses-per-meter constant, and lux thresholds. |

---

### 3.2 Core Architectural Invariant: Non-Defect-Free Uninspected Section Handling

```
                              [ Incoming Video Frame ]
                                         │
                                         ▼
                     ┌───────────────────────────────────────┐
                     │     Reliability Gating Check          │
                     │  - Camera Connected? (FPS >= 28)      │
                     │  - Illumination OK?  (Lux >= 400)     │
                     │  - Focus Sharp?      (Laplacian >= 85)│
                     │  - Encoder Sync OK?  (Pulse delta > 0)│
                     └───────────────────┬───────────────────┘
                                         │
                        Is Gating Check Satisfied?
                       /                           \
                     YES                            NO
                     /                                \
                    ▼                                  ▼
      ┌───────────────────────────┐      ┌───────────────────────────────┐
      │ Run AI Detection Pipeline │      │ Mark Section as UNINSPECTED   │
      │ - YOLO Bounding Box       │      │   Range: [L_start, L_end]     │
      │ - Multi-Frame Tracking    │      │ - Set Quarantined = TRUE      │
      │ - Coordinate Metrology    │      │ - Trip Audible Relay Warning  │
      │ - ASTM 4-Point Scoring    │      │ - Inhibit Automatic Pass      │
      └─────────────┬─────────────┘      └───────────────┬───────────────┘
                    │                                    │
                    └──────────────────┬─────────────────┘
                                       │
                                       ▼
                       ┌───────────────────────────────┐
                       │   Commit to Local Outbox DB   │
                       │   (Transactional SQLite WAL)  │
                       └───────────────────────────────┘
```

> **Formal Invariant Definition:**
> Let $R$ denote a fabric roll of length $L$. Let $[L_a, L_b] \subset [0, L]$ represent an inspection interval. If during the interval $[L_a, L_b]$ any optical, electrical, or software telemetry check fails:
> $$\text{Health}(t) = 0 \implies \text{Status}([L_a, L_b]) := \text{UNINSPECTED}$$
> The system establishes that:
> $$\text{Defects}([L_a, L_b]) = \emptyset \centernot\implies \text{RollQuality} = \text{CERTIFIED\_PASS}$$
> Under no condition shall an uninspected segment be marked as defect-free. A roll with uninspected sections cannot receive a certified passing grade until every uninspected segment is manually reviewed and signed off by an authorized quality inspector.

---

# Chapter 4: External Interface Requirements

### 4.1 User Interfaces
- **Mobile Floor Terminal (Flutter / React Native):** Designed for single-hand shop floor operation with high-contrast UI, large touch targets, sound/haptic alerts, QR scanning viewfinder, and live defect card feeds.
- **Web Quality Workstation (React.js, Tailwind CSS, HTML5 Canvas):** Comprehensive desktop interface for quality managers featuring an interactive 2D defect map, ASTM 4-point grading breakdown, manual inspection correction dialogs, and one-click PDF report generation.

### 4.2 Hardware Interfaces
- **Industrial Area-Scan Camera:** Connected via USB 3.0 SuperSpeed / GigE Vision interface. Controlled via Linux V4L2 API. Fixed focal length C-mount lens with aperture locked at $f/2.8$.
- **Rotary Optical Encoder:** Coupled to the guide roller with 1024 pulses per revolution. Connected to industrial edge unit GPIO lines with optocoupler isolation.
- **Alarm Stack Light & Buzzer:** Controlled via optoisolated 24V DC industrial relay board switched by edge unit GPIO pins.
- **LED Illumination Rig:** Regulated constant-current DC power supply with manual dimmer lock to eliminate 50Hz/60Hz AC flicker.

### 4.3 Software Interfaces
- **Local Edge Database:** SQLite 3.40+ configured with `PRAGMA journal_mode=WAL;` and `PRAGMA synchronous=NORMAL;` for high-throughput concurrent writes.
- **Central Relational Database:** PostgreSQL 15+ managing relational schemas with UUID primary keys and JSONB payload fields.
- **Object Storage Service:** MinIO S3 object store organizing defect image crops under `/crops/{roll_id}/{defect_id}.jpg`.
- **Backend Application Server:** Python 3.11 with FastAPI, SQLAlchemy ORM, and Pydantic validation.

### 4.4 Communications Interfaces
- **V4L2 Video Streaming:** Frame grabbing into memory ring buffers via memory-mapped buffers (`V4L2_MEMORY_MMAP`).
- **Hardware Interrupts (GPIO):** Linux `sysfs` / `gpiod` interrupt event notification on encoder A/B channel pulse edges.
- **HTTPS REST Ingestion:** JSON payloads sent via TLS 1.3 `POST /api/v1/sync/batch` with multipart JPEG file attachments.
- **WebSockets (WSS):** Full-duplex WebSocket channel `/ws/quality-alerts` for real-time mobile push notifications.

---

# Chapter 5: Non-Functional Requirements

### 5.1 Performance Requirements
- **Inference Latency:** YOLO edge model execution must complete in $\le 30\text{ ms}$ per frame on TensorRT FP16.
- **Camera Frame Rate:** Consistent $\ge 30\text{ FPS}$ capture rate at full resolution ($1920 \times 1080$).
- **Linear Fabric Tracking:** Encoder displacement resolution $\le 1.0\text{ mm}$ per pulse tick.
- **Local Outbox Write Time:** SQLite transaction commit time $\le 5\text{ ms}$.
- **Web Dashboard Render:** 2D defect map must render a 1000-meter roll with up to 500 flaws in $\le 500\text{ ms}$.

### 5.2 Reliability, Availability & Fault Tolerance
- **Continuous Operation:** Edge software designed for $24/7$ industrial operation.
- **Network Resilience:** The edge system can operate fully offline indefinitely, caching up to 10,000 defects in local storage.
- **Zero Loss Guarantee:** Transactional outbox pattern guarantees zero defect records or image crops are lost during network drops or power events.

### 5.3 Safety & Security Requirements
- **Electrical Safety:** Optocoupler isolation on all GPIO lines separating 24V DC industrial voltages from edge logic lines.
- **API Security:** All central endpoints require JSON Web Token (JWT) Bearer authentication signed with HMAC-SHA256.
- **Password Security:** User passwords hashed using Argon2id with random salt.
- **Role-Based Access Control (RBAC):** Strict permission enforcement between Operator, Inspector, Manager, and Admin roles.

### 5.4 Maintainability and Portability
- **Dockerized Deployments:** Central services packaged as Docker containers managed via `docker-compose`.
- **Modular Codebase:** Clean separation between hardware drivers, AI inference, business logic, and UI layers.

---

# Chapter 6: System Analysis & Architecture Design

This chapter presents the 14 formal architectural figures of TexEye AI, formatted according to COMSATS academic standards with double frames and solid black line-work.

---

### 6.1 System Workflow & Invariant Gate
The core end-to-end operational pipeline of TexEye AI, highlighting the non-defect-free invariant gate that flags degraded inspection spans.

```
Figure 1.1: System Workflow and Invariant Gate
[ See diagrams/png/01_system_workflow.png ]
Draw.io: diagrams/drawio/01_system_workflow.drawio
```

---

### 6.2 AI Vision & Metrology Workflow
Detailed computer vision pipeline from frame undistortion, YOLO detection, ByteTrack Kalman association, duplicate suppression, to $(X, Y)$ metric mapping.

```
Figure 1.2: AI Vision and Metrology Workflow
[ See diagrams/png/02_ai_inspection_workflow.png ]
Draw.io: diagrams/drawio/02_ai_inspection_workflow.drawio
```

---

### 6.3 Offline Store-and-Forward Sync Workflow
The transactional outbox pattern implemented via SQLite WAL on the edge unit and synchronized via multipart HTTP batches to the central cloud.

```
Figure 1.3: Offline-First Store-and-Forward Synchronization Workflow
[ See diagrams/png/03_offline_sync_workflow.png ]
Draw.io: diagrams/drawio/03_offline_sync_workflow.drawio
```

---

### 6.4 Hardware Architecture & Physical Interconnect
Physical hardware interconnect diagram showing connections between the Fabric Inspection Stand, Industrial Edge Unit, and Central Cloud Server.

```
Figure 4.1: Hardware Architecture and Physical Interconnect Diagram
[ See diagrams/png/04_hardware_architecture.png ]
Draw.io: diagrams/drawio/04_hardware_architecture.drawio
```

---

### 6.5 System Context Diagram / DFD Level 0 Overview
Context-level data flow diagram showing TexEye AI as a single central system interacting with its 5 external entities.

```
Figure 4.2: System Context Diagram (Level 0 DFD Overview)
[ See diagrams/png/07_context_diagram.png ]
Draw.io: diagrams/drawio/07_context_diagram.drawio
```

---

### 6.6 Data Flow Diagram Level 0
Decomposition of system processing into 4 primary processes (Ingestion, Analysis, Synchronization, Analytics) and 2 major data stores.

```
Figure 4.3: Data Flow Diagram (DFD Level 0)
[ See diagrams/png/08_dfd_level_0.png ]
Draw.io: diagrams/drawio/08_dfd_level_0.drawio
```

---

### 6.7 Data Flow Diagram Level 1
Functional decomposition of Process 2.0 (Analyze Quality & Detect Defects) into its 6 constituent subprocesses (2.1 to 2.6).

```
Figure 4.4: DFD Level 1 (Decomposition of Process 2.0)
[ See diagrams/png/09_dfd_level_1.png ]
Draw.io: diagrams/drawio/09_dfd_level_1.drawio
```

---

### 6.8 Layered Software Architecture
5-tier layered software architecture of TexEye AI, from edge hardware sensing to backend microservices and client presentation layers.

```
Figure 5.1: Layered Software Architecture of TexEye AI
[ See diagrams/png/05_software_architecture.png ]
Draw.io: diagrams/drawio/05_software_architecture.drawio
```

---

### 6.9 UML Component Diagram
Component diagram illustrating the internal modular structure of the edge subsystem, cloud subsystem, and client artifacts.

```
Figure 5.2: UML Component Diagram of TexEye AI
[ See diagrams/png/10_component_diagram.png ]
Draw.io: diagrams/drawio/10_component_diagram.drawio
```

---

### 6.10 UML Deployment Diagram
Physical deployment nodes, hardware execution environments, runtime services, and network communication links across 4 tiers.

```
Figure 5.3: UML Deployment Diagram of TexEye AI
[ See diagrams/png/11_deployment_diagram.png ]
Draw.io: diagrams/drawio/11_deployment_diagram.drawio
```

---

### 6.11 Sequence Diagram: Inspection & Reliability Gating
UML sequence diagram illustrating the operational message flow during live fabric roll inspection and reliability gating.

```
Figure 5.4: Sequence Diagram — Roll Inspection and Defect Detection
[ See diagrams/png/12_sequence_inspection.png ]
Draw.io: diagrams/drawio/12_sequence_inspection.drawio
```

---

### 6.12 Sequence Diagram: Edge-to-Cloud Batch Synchronization
UML sequence diagram depicting the reliable transactional batch upload from the edge SQLite outbox to central PostgreSQL and MinIO S3.

```
Figure 5.5: Sequence Diagram — Edge-to-Cloud Batch Synchronization
[ See diagrams/png/13_sequence_sync.png ]
Draw.io: diagrams/drawio/13_sequence_sync.drawio
```

---

### 6.13 Entity Relationship Diagram
Relational schema diagram modeling all 9 database entities, primary keys, foreign keys, and Crow's Foot cardinality relationships.

```
Figure 5.6: Entity Relationship Diagram (ERD) of TexEye AI
[ See diagrams/png/14_entity_relationship_diagram.png ]
Draw.io: diagrams/drawio/14_entity_relationship_diagram.drawio
```

---

### 6.14 Comprehensive System Use Case Diagram
Complete system use case diagram illustrating all 21 use cases categorized across 4 primary human actors and 2 hardware actors.

```
Figure 6.1: Comprehensive Use Case Diagram (21 Use Cases)
[ See diagrams/png/06_use_case_overall.png ]
Draw.io: diagrams/drawio/06_use_case_overall.drawio
```

---

# Chapter 7: Team Division of Work & Responsibilities

To ensure academic accountability and clear individual ownership during the final-year defense evaluation, project responsibilities are divided between the two team members as follows:

```
┌───────────────────────────────────────────────────────────────────────────────┐
│                      TexEye AI — Team Responsibilities                         │
├───────────────────────────────────────┬───────────────────────────────────────┤
│    Muhammad Afnan Khan                │    Muhammad Bilal Butt                │
│    Registration No: FA23-BAI-028      │    Registration No: FA23-BAI-042      │
├───────────────────────────────────────┼───────────────────────────────────────┤
│ • Shop Floor Mobile Application       │ • Deep Learning Detection Model       │
│   (Flutter / React Native)            │   (YOLOv8 / YOLOv11 Training)         │
│ • Production & Quality Web Dashboard  │ • Multi-Frame Tracking & Metrology    │
│   (React.js, Tailwind CSS)            │   (ByteTrack + Kalman Filter + IoU)   │
│ • Interactive 2D Roll Defect Map      │ • Industrial Camera Ingestion Driver  │
│   (Canvas coordinates X_cm, Y_m)      │   (V4L2 / GenICam Stream Capture)     │
│ • ASTM D5430-07 4-Point Grading Engine│ • Rotary Optical Encoder Telemetry    │
│   (Automated penalty point calculator)│   (GPIO Hardware Interrupt Counter)   │
│ • Central FastAPI Cloud Backend       │ • Shop Floor Reliability Gate         │
│   (REST Ingestion & WebSocket Hub)    │   (Light lux, blur variance, FPS)     │
│ • Relational PostgreSQL Database      │ • Core Invariant Enforcement Engine   │
│   (Schema design, indexes, migrations)│   (Uninspected section handler)       │
│ • Automated PDF Quality Certificates  │ • Edge SQLite WAL Outbox Buffer       │
│   (ReportLab certification engine)    │   (Local transaction persistence)     │
│ • MinIO S3 Object Storage Service     │ • Relay Board Actuation Driver        │
│   (Image crop archival & retrieval)   │   (Stack light & audio buzzer alarm)  │
└───────────────────────────────────────┴───────────────────────────────────────┘
```

---

# Chapter 8: Traceability Matrix

The traceability matrix maps system functional requirements to corresponding use cases, architectural components, and verification methods:

| Requirement ID | Use Case ID | Architecture Component | Primary Database Table | Verification Method |
| :--- | :--- | :--- | :--- | :--- |
| **FR-01** | UC-01 | Mobile Terminal / FastAPI | `FABRIC_ROLLS` | Integration Test (QR Scan) |
| **FR-02** | UC-02 | Camera Ingestion Driver | N/A (Memory Buffer) | Unit Test (V4L2 Capture) |
| **FR-03** | UC-03 | Pulse Counter / GPIO | N/A (Hardware Counter) | Hardware Loop Test |
| **FR-04** | UC-20 | Reliability Monitor | `UNINSPECTED_SECTIONS` | Threshold Invariant Test |
| **FR-05** | UC-21 | Uninspected Handler | `UNINSPECTED_SECTIONS` | Fault Injection Test |
| **FR-06** | UC-04 | YOLO Inference Engine | `DEFECT_RECORDS` | Model Benchmark (mAP@0.5) |
| **FR-07** | UC-05 | Multi-Frame Tracker | N/A (Tracking State) | Video Tracking Test |
| **FR-08** | UC-06 | Duplicate Suppressor | `DEFECT_RECORDS` | Overlap Suppression Test |
| **FR-09** | UC-07 | Coordinate Mapper | `DEFECT_RECORDS` | Metrology Calibration Test |
| **FR-10** | UC-08 | ASTM Grading Engine | `GRADING_REPORTS` | ASTM Formula Verification |
| **FR-11** | UC-09 | Local SQLite DB (WAL) | `SYNC_OUTBOX` | SQLite Concurrency Test |
| **FR-12** | UC-10 | Edge Sync Daemon | `SYNC_OUTBOX` | Offline Recovery Test |
| **FR-13** | UC-11 | Central FastAPI / Postgres | `DEFECT_RECORDS`, `ALERTS` | End-to-End Ingestion Test |
| **FR-14** | UC-12 | Image Cache Manager | `DEFECT_IMAGES` | Cache Eviction Test |
| **FR-15** | UC-13 | Relay Actuation Driver | N/A (GPIO Relay) | Relay Oscilloscope Test |
| **FR-16** | UC-14 | Push Hub (WebSocket) | `ALERTS` | Latency Benchmark (<50ms) |
| **FR-17** | UC-15 | Web Canvas Renderer | `DEFECT_RECORDS` | Canvas Visual Test |
| **FR-18** | UC-16 | Defect Records API | `DEFECT_RECORDS` | CRUD Audit Trail Test |
| **FR-19** | UC-17 | Management Service | `UNINSPECTED_SECTIONS` | Role Authorization Test |
| **FR-20** | UC-18 | PDF Export Engine | `GRADING_REPORTS` | Document Output Test |
| **FR-21** | UC-19 | Auth & RBAC Service | `USERS` | JWT Security Scan |
| **FR-22** | N/A | Inventory Records Service| `INVENTORY_RECORDS` | Database Integration Test |
| **FR-23** | N/A | Analytics Engine | `DEFECT_RECORDS`, `ROLLS` | SQL Aggregation Test |
| **FR-24** | UC-20 | System Watchdog | N/A (System Telemetry) | Process Heartbeat Test |
| **FR-25** | N/A | Calibration Service | `SYSTEM_CONFIG` | Metric Grid Calibration |

---

### Academic Certification Sign-off

```
We hereby certify that this Software Requirements and Design Specification (SRDS) represents 
our original engineering work conducted under the supervision of the Department of Computer Science, 
COMSATS University Islamabad, Wah Campus. All architectural designs, structural models, and 
requirements specifications have been prepared in compliance with academic and professional standards.

_____________________________                      _____________________________
Muhammad Afnan Khan                                Muhammad Bilal Butt
FA23-BAI-028                                       FA23-BAI-042
Student, BS Artificial Intelligence                Student, BS Artificial Intelligence
COMSATS University Islamabad, Wah Campus           COMSATS University Islamabad, Wah Campus
```


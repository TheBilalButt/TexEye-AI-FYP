# TexEye AI — UML Component & Deployment Architecture

## 1. UML Component Architecture

The Component Diagram shows our software building blocks, their exposed interfaces, and the connections between edge, backend, and user applications.

```mermaid
flowchart TB
    subgraph EDGE_COMP ["texeye-edge-core Subsystem"]
        COMP_CAM["[Component] CameraIngestion"]
        COMP_ENC["[Component] EncoderTelemetry"]
        COMP_REL["[Component] ReliabilityMonitor"]
        COMP_AI["[Component] DefectDetector"]
        COMP_TRACK["[Component] MultiFrameTracker"]
        COMP_MAP["[Component] CoordinateMapper"]
        COMP_STORE["[Component] LocalPersistenceManager"]
        COMP_SYNC["[Component] EdgeSyncClient"]
    end

    subgraph BACKEND_COMP ["texeye-backend-api Subsystem"]
        COMP_SYNC_RCV["[Component] SyncReceiverService"]
        COMP_AUTH["[Component] Auth & RBAC Service"]
        COMP_ROLL["[Component] RollManagerService"]
        COMP_DEFECT["[Component] DefectManagerService"]
        COMP_GRADE["[Component] GradingEngine (4-Point)"]
        COMP_REPORT["[Component] ReportGenerator"]
        COMP_NOTIF["[Component] NotificationHub (WSS)"]
    end

    subgraph CLIENT_COMP ["user-applications Subsystem"]
        COMP_MOB["[Component] TexEyeMobileClient"]
        COMP_WEB["[Component] TexEyeWebDashboard"]
    end

    COMP_CAM --> COMP_REL
    COMP_ENC --> COMP_REL
    COMP_REL -->|ICameraStream| COMP_AI
    COMP_AI --> COMP_TRACK --> COMP_MAP
    COMP_ENC -->|IEncoderPosition| COMP_MAP
    COMP_MAP --> COMP_STORE
    COMP_REL -->|IUninspectedEvent| COMP_STORE
    COMP_STORE --> COMP_SYNC

    COMP_SYNC == "ISyncIngest (HTTPS REST)" ==> COMP_SYNC_RCV
    COMP_SYNC_RCV --> COMP_ROLL
    COMP_SYNC_RCV --> COMP_DEFECT
    COMP_DEFECT --> COMP_GRADE --> COMP_REPORT

    COMP_MOB == "IAuthService / IDefectService" ==> COMP_AUTH
    COMP_WEB == "IReportService / IRollService" ==> COMP_ROLL
    COMP_NOTIF -.->|IPushAlerts (WSS)| COMP_MOB
    COMP_NOTIF -.->|ITelemetry (WSS)| COMP_WEB
```

### 1.1 Interface Contracts
- `ICameraStream`: Feeds raw video frames along with incrementing frame IDs and millisecond timestamps.
- `IEncoderPosition`: Delivers total pulse count, current line speed (m/min), and incremental distance $\Delta L$.
- `IReliabilityStatus`: Provides a real-time boolean health status; triggers an event whenever camera feed, lighting lux, or frame rates fail.
- `IDefectInference`: Takes preprocessed image tensors; returns bounding boxes, defect labels, and confidence metrics.
- `ISyncDispatch`: Bundles pending queue entries into idempotent multipart REST batches sent to the cloud.

---

## 2. UML Deployment Architecture (Physical Execution Topology)

The Deployment Diagram details physical devices, runtime environments, Docker containers, and network connections.

```mermaid
flowchart TB
    subgraph NODE_STAND ["<<device>> Fabric Inspection Stand"]
        DEV_CAM["Industrial Camera<br/>(Area-Scan / Line-Scan Sensor)"]
        DEV_ENC["Incremental Rotary Encoder<br/>(Coupled to Measurement Roller)"]
        DEV_LIGHT["High-CRI LED Lighting Rig<br/>(Constant-Current Driver)"]
        DEV_ALERT["Alert Tower Light / Relay Buzzer<br/>(Proposed Hardware)"]
    end

    subgraph NODE_EDGE ["<<device>> Industrial Edge Computer (Ubuntu Linux 22.04 LTS)"]
        subgraph EDGE_PROC ["Processes & Runtimes"]
            P_CAP["texeye-capture-daemon<br/>(V4L2 / GenICam / GPIO Listener)"]
            P_AI["texeye-ai-inference<br/>(CUDA / TensorRT / YOLOv8 Runtime)"]
            P_SYNC["texeye-sync-agent<br/>(Background Python HTTP Worker)"]
            DB_LOCAL[("SQLite 3 Engine<br/>texeye_local.db (WAL Mode)")]
            FS_CACHE["NVMe Flash Cache<br/>/var/texeye/img_cache"]
        end
    end

    subgraph NODE_CLOUD ["<<device>> Central Enterprise Cloud / On-Prem Server"]
        subgraph DOCKER_BOX ["Docker Virtualization Host"]
            P_NGINX["Nginx 1.24 (Reverse Proxy & TLS 1.3 Termination)"]
            P_API["FastAPI Backend Container (Uvicorn ASGI)"]
            DB_CENTRAL[("PostgreSQL 16 Database Cluster")]
            OBJ_CENTRAL[("MinIO / AWS S3 Object Store")]
            P_WS["WebSocket Push Notification Hub"]
        end
    end

    subgraph NODE_MOB ["<<device>> Shop Floor Mobile Device"]
        MOB_CLIENT["TexEye AI Mobile App (Flutter / React Native)<br/>Camera QR Scanner &bull; Android / iOS"]
    end

    subgraph NODE_PC ["<<device>> QA & Management Workstation"]
        WEB_CLIENT["TexEye Web Dashboard (React + TypeScript)<br/>Chrome / Edge Browser &bull; Windows / macOS / Linux"]
    end

    DEV_CAM == "Proposed: USB 3.0 Vision / GigE Vision" ==> P_CAP
    DEV_ENC == "Proposed: Shielded GPIO Counter / TTL" ==> P_CAP
    P_CAP -.->|Strobe Sync Control| DEV_LIGHT
    P_CAP == "Opto Relay Trigger" ==> DEV_ALERT

    P_CAP --> P_AI
    P_AI --> DB_LOCAL
    P_AI --> FS_CACHE
    DB_LOCAL --> P_SYNC
    FS_CACHE --> P_SYNC

    P_SYNC == "TLS 1.3 / HTTPS (Industrial Ethernet Cat6 / Wi-Fi)" ==> P_NGINX
    P_NGINX --> P_API
    P_API <--> DB_CENTRAL
    P_API <--> OBJ_CENTRAL
    P_API --> P_WS

    MOB_CLIENT == "Wi-Fi 802.11 / 4G (HTTPS REST & WSS)" ==> P_NGINX
    WEB_CLIENT == "Corporate LAN (HTTPS REST & WSS)" ==> P_NGINX
```

### 2.1 Deployment Node Specifications
1. **Fabric Inspection Stand:** Physical frame holding the fabric roll, contact roller, overhead camera, lighting bar, and alert beacon.
2. **Edge Computer Node:** Industrial embedded GPU unit (NVIDIA Jetson Orin Nano/NX or Industrial Mini-PC with dedicated GPU) running Ubuntu Linux 22.04 LTS. Runs video capture, YOLO inference, local SQLite, and sync workers.
3. **Central Server Node:** On-prem server or cloud VM running Docker. Houses Nginx reverse proxy, FastAPI backend containers, PostgreSQL 16 database, and MinIO/S3 storage.
4. **Mobile Device Node:** Android or iOS devices used by floor operators to scan roll QR codes, review alerts, and inspect defect thumbnails.
5. **Quality Workstation Node:** Desktop PCs running standard web browsers connected over local network to display the 2D defect map and certify roll grades.

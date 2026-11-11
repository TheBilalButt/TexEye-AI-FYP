# TexEye AI — UML Sequence Diagrams

## 1. Sequence Diagram 1: Real-Time Fabric Inspection & Reliability Gating

This diagram walks through what happens during real-time fabric movement, highlighting the two paths: normal AI defect detection vs. isolating uninspected fabric when a sensor issue arises.

```mermaid
sequenceDiagram
    autonumber
    actor OP as Floor Operator
    participant STAND as Fabric Roller
    participant ENC as Rotary Encoder
    participant CAM as Industrial Camera
    participant MON as Edge Reliability Gate
    participant AI as AI Vision & Tracking Engine
    participant DB as Local SQLite Storage
    participant CLOUD as Central Backend API
    actor QI as Quality Inspector (Web)

    OP->>DB: Initiate Inspection Session (Scan Roll QR)
    DB-->>OP: Session Confirmed (Roll ID, Fabric Spec)
    
    STAND->>ENC: Fabric Moves (Linear Motion)
    ENC->>MON: Stream Channel A/B Pulses (Distance Increment ΔL)
    STAND->>CAM: Fabric Reflects Uniform Light
    CAM->>MON: Deliver High-Speed Frame Stream (Timestamped)

    Note over MON: Reliability Validation (Cam, Light, Blur, Drop-frame)

    alt Condition A: Reliability Check Passed (Optimal Conditions)
        MON->>AI: Forward Clean Frame + Rotary Pulse Count
        AI->>AI: Image Preprocessing (CLAHE Contrast + ROI)
        AI->>AI: Deep Learning Defect Detection (YOLO Inference)
        AI->>AI: Multi-Frame Tracking (Kalman Filter + IoU Association)
        AI->>AI: Spatial-Temporal Deduplication (Consolidate repeat detections)
        AI->>AI: Metric Coordinate Calculation (X_cm from calib, Y_m from encoder)
        AI->>DB: INSERT defect_records (Track_ID, Class, X, Y, ImgBlob)
        DB-->>AI: Transaction Committed (Local Zero-Latency)
        
        opt Defect Severity Exceeds Alert Threshold
            AI->>OP: Push Instant Vibration & Audio Alert to Mobile
            AI->>CLOUD: Stream Live Coordinate via WebSocket (If Online)
            CLOUD->>QI: Render Color-Coded Defect Pin on Live Map Canvas
        end

    else Condition B: Reliability Check Failed (e.g. Frame Drop / Cam Disconnect / Light Failure)
        MON->>MON: Calculate Degraded Interval [L_start = Y, L_end = Y + ΔL]
        MON->>DB: INSERT uninspected_sections (Session, Roll, Start, End, Reason)
        Note over DB: CRITICAL INVARIANT:<br/>Marked as UNINSPECTED &bull; NEVER defect-free!
        MON->>OP: Trip Physical Tower Light Relay & Fire Mobile Warning Alarm
        MON->>CLOUD: Broadcast UNINSPECTED_SECTION_WARNING Event
        CLOUD->>QI: Draw Yellow / Amber Hashed Warning Band on Defect Map
    end

    opt Post-Inspection Defect Audit & Verification
        QI->>CLOUD: Open Defect Crop & Verify Label
        QI->>CLOUD: Submit Correction (e.g., Change Predicted 'Stain' to 'Oil Spot')
        CLOUD->>DB: Update verified_class & Re-calculate 4-Point Grade
    end
```

---

## 2. Sequence Diagram 2: Offline Data Synchronization Flow

This diagram tracks how edge data accumulates locally during a network drop and how the background sync worker uploads it safely once the network is restored.

```mermaid
sequenceDiagram
    autonumber
    participant ENGINE as Inspection Engine
    participant SQLITE as Local SQLite DB
    participant CACHE as Local Image NVMe Disk
    participant SYNC as Edge Sync Daemon
    participant API as Central Backend API
    participant PG as Central PostgreSQL DB
    participant S3 as Central MinIO/S3 Storage

    Note over ENGINE,CACHE: Normal Local Shop Floor Operation
    ENGINE->>SQLITE: INSERT defect_records (sync_status = 'PENDING')
    ENGINE->>SQLITE: INSERT offline_sync_queue (UUIDv4, entity, JSON payload)
    ENGINE->>CACHE: Save Defect Crop Image (local_filepath)
    SQLITE-->>ENGINE: Commit Acknowledged (Zero Milliseconds Latency)

    loop Heartbeat Watchdog Loop (Every 5 seconds)
        SYNC->>API: HTTPS GET /api/v1/health (Health Ping)
        alt Network Outage / Factory Wi-Fi Severed
            API--xSYNC: Timeout / Network Unreachable
            Note over SYNC: Internet Offline: Accumulate in queue.<br/>Inspection runs at 100% full capacity.
        else Network Link Restored / Healthy
            API-->>SYNC: 200 OK (Backend Healthy)
            SYNC->>SQLITE: SELECT * FROM offline_sync_queue WHERE sync_status = 'PENDING' LIMIT 50
            SQLITE-->>SYNC: Return Batch of Transactions
            SYNC->>CACHE: Read Associated JPEG Image Blobs
            CACHE-->>SYNC: Return Image Streams
            
            SYNC->>API: HTTPS POST /api/v1/sync/batch (Chunked Gzip JSON + Multipart Crops)
            
            rect rgb(240, 255, 240)
                Note over API,S3: Atomic Central Cloud Ingestion
                API->>PG: Upsert Records Using UUIDv4 (Idempotent De-duplication)
                API->>S3: PutObject (Store Defect Bounding Box Crops)
                S3-->>API: Cloud Image URLs Generated
                API->>PG: Commit Transaction & Update Cloud Roll Defect Map
                PG-->>API: Transaction Committed
            end

            API-->>SYNC: 200 OK (Batch Acknowledged: {synced_ids: [1, 2, ...]})
            SYNC->>SQLITE: UPDATE offline_sync_queue SET sync_status = 'SYNCED' WHERE id IN (...)
            SQLITE-->>SYNC: Rows Updated
            SYNC->>CACHE: Evict Uploaded Images (Apply FIFO Storage Ceiling Quota)
            Note over SYNC: Batch sync complete. Ready for next pending slice.
        end
    end
```

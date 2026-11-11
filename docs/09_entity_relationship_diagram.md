# TexEye AI — Entity Relationship Diagram (ERD) & Data Dictionary

## 1. Entity Relationship Model

The TexEye AI data model is built for full relational consistency on central PostgreSQL while remaining directly usable inside lightweight SQLite on the edge computer.

```mermaid
erDiagram
    USERS ||--o{ INSPECTION_SESSIONS : "operates / inspects"
    USERS ||--o{ DEFECT_RECORDS : "verifies / corrects"
    USERS ||--o{ ROLL_GRADING : "certifies"
    USERS ||--o{ INVENTORY_RECORDS : "updates"
    USERS ||--o{ ALERTS : "acknowledges"

    FABRIC_ROLLS ||--o{ INSPECTION_SESSIONS : "undergoes"
    FABRIC_ROLLS ||--o{ DEFECT_RECORDS : "contains"
    FABRIC_ROLLS ||--o{ UNINSPECTED_SECTIONS : "exhibits"
    FABRIC_ROLLS ||--|| ROLL_GRADING : "receives"
    FABRIC_ROLLS ||--|| INVENTORY_RECORDS : "tracked_in"
    FABRIC_ROLLS ||--o{ ALERTS : "triggers"

    INSPECTION_SESSIONS ||--o{ DEFECT_RECORDS : "logs"
    INSPECTION_SESSIONS ||--o{ UNINSPECTED_SECTIONS : "records"
    INSPECTION_SESSIONS ||--o{ ALERTS : "generates"

    USERS {
        uuid id PK
        varchar username UK
        varchar password_hash
        varchar full_name
        varchar email UK
        varchar role "OPERATOR, INSPECTOR, PROD_MGR, INV_MGR, ADMIN"
        boolean is_active
        timestamp created_at
    }

    FABRIC_ROLLS {
        uuid id PK
        varchar roll_code_qr UK
        varchar batch_number
        varchar fabric_type "Cotton, Denim, Twill, Polyester, Blend"
        decimal total_length_m
        decimal width_cm
        varchar inspection_status "PENDING, IN_PROGRESS, COMPLETED, INTERRUPTED"
        varchar final_grade "GRADE_A, GRADE_B, GRADE_C, REJECT_SCRAP"
        timestamp created_at
    }

    INSPECTION_SESSIONS {
        uuid id PK
        uuid roll_id FK
        uuid operator_id FK
        uuid inspector_id FK
        varchar edge_device_id
        timestamp start_time
        timestamp end_time
        decimal total_inspected_length_m
        decimal total_uninspected_length_m
        varchar status "ACTIVE, COMPLETED, ABORTED"
    }

    DEFECT_RECORDS {
        uuid id PK
        uuid session_id FK
        uuid roll_id FK
        varchar defect_class "HOLE, STAIN, WARP_DEFECT, WEFT_DEFECT, FLOAT, OIL_SPOT"
        decimal confidence_score
        decimal position_x_cm "Lateral distance from left selvedge"
        decimal position_y_m "Longitudinal distance via encoder"
        json bounding_box "[ymin, xmin, ymax, xmax]"
        varchar image_path_local
        varchar image_url_cloud
        boolean is_verified
        varchar corrected_class
        uuid corrected_by FK
        integer penalty_points "1, 2, 3, or 4 points (ASTM D5430)"
        timestamp created_at
    }

    UNINSPECTED_SECTIONS {
        uuid id PK
        uuid session_id FK
        uuid roll_id FK
        decimal start_position_m "Start meter of degraded span"
        decimal end_position_m "End meter of degraded span"
        varchar failure_reason "CAMERA_DISCONNECTED, POOR_IMAGE_QUALITY, LIGHTING_ANOMALY, DROPPED_FRAMES"
        varchar severity_warning "WARNING, CRITICAL"
        timestamp logged_at
    }

    ROLL_GRADING {
        uuid id PK
        uuid roll_id FK
        uuid session_id FK
        varchar grading_standard "FOUR_POINT_SYSTEM"
        integer total_defect_points
        decimal points_per_100_sqm
        varchar final_grade "A, B, C, REJECT_SCRAP"
        uuid graded_by FK
        timestamp graded_at
    }

    INVENTORY_RECORDS {
        uuid id PK
        uuid roll_id FK
        varchar warehouse_zone "Zone A, Zone B, Quarantine Bay"
        varchar shelf_location "Rack/Shelf coordinate"
        varchar stock_status "IN_INSPECTION, IN_STOCK, DISPATCHED, SCRAP_ISOLATED"
        boolean is_scrap
        text scrap_reason
        uuid updated_by FK
        timestamp last_updated
    }

    ALERTS {
        uuid id PK
        uuid session_id FK
        uuid roll_id FK
        varchar alert_type "UNINSPECTED_SECTION, SEVERE_DEFECT, SENSOR_FAULT"
        varchar severity "LOW, MEDIUM, HIGH, CRITICAL"
        text message
        timestamp timestamp
        uuid acknowledged_by FK
        timestamp acknowledged_at
    }

    OFFLINE_SYNC_QUEUE {
        uuid id PK
        varchar entity_type "DEFECT, UNINSPECTED, ROLL, GRADING"
        uuid entity_id
        varchar operation "INSERT, UPDATE"
        json payload_json
        varchar sync_status "PENDING, SYNCED, FAILED"
        integer retry_count
        timestamp last_attempt
        timestamp created_at
    }
```

---

## 2. Relational Data Dictionary

### 2.1 Table: `fabric_rolls`
Stores master roll information, physical dimensions, and inspection state.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY, NOT NULL | Unique roll ID. |
| `roll_code_qr` | VARCHAR(64) | UNIQUE, NOT NULL | Unique string encoded in the roll's QR code. |
| `batch_number` | VARCHAR(50) | NOT NULL | Mill manufacturing batch identifier. |
| `fabric_type` | VARCHAR(50) | NOT NULL | Weave category (e.g., "100% Cotton Plain Weave", "Denim 12oz"). |
| `total_length_m` | DECIMAL(10,2)| NOT NULL | Total roll length in meters. |
| `width_cm` | DECIMAL(10,2)| NOT NULL | Usable fabric width in centimeters. |
| `inspection_status` | VARCHAR(30) | NOT NULL, DEFAULT 'PENDING' | Status: `PENDING`, `IN_PROGRESS`, `COMPLETED`, `INTERRUPTED`. |
| `final_grade` | VARCHAR(20) | NULL | Final grade: `GRADE_A`, `GRADE_B`, `GRADE_C`, `REJECT_SCRAP`. |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Record creation date and time. |

---

### 2.2 Table: `uninspected_sections`
Enforces our core rule: explicitly tracking every fabric interval where inspection was interrupted or compromised.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY, NOT NULL | Unique section ID. |
| `session_id` | UUID | FOREIGN KEY &rarr; `inspection_sessions.id` | Associated inspection session. |
| `roll_id` | UUID | FOREIGN KEY &rarr; `fabric_rolls.id` | Target fabric roll. |
| `start_position_m` | DECIMAL(10,2)| NOT NULL | Meter where sensor issue began. |
| `end_position_m` | DECIMAL(10,2)| NOT NULL | Meter where sensors recovered. |
| `failure_reason` | VARCHAR(50) | NOT NULL | Reason: `CAMERA_DISCONNECTED`, `POOR_IMAGE_QUALITY`, `LIGHTING_ANOMALY`, `DROPPED_FRAMES`. |
| `severity_warning` | VARCHAR(20) | NOT NULL | `WARNING` (&lt; 1 meter) or `CRITICAL` (&ge; 1 meter). |
| `logged_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Timestamp when incident was logged. |

---

### 2.3 Table: `defect_records`
Stores unique detected defects, calculated physical positions, and human audit verification.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY, NOT NULL | Unique defect ID. |
| `session_id` | UUID | FOREIGN KEY &rarr; `inspection_sessions.id` | Associated inspection session. |
| `roll_id` | UUID | FOREIGN KEY &rarr; `fabric_rolls.id` | Fabric roll containing defect. |
| `defect_class` | VARCHAR(40) | NOT NULL | Predicted class: `HOLE`, `STAIN`, `WARP_DEFECT`, `WEFT_DEFECT`, `FLOAT`, `OIL_SPOT`. |
| `confidence_score`| DECIMAL(5,4) | NOT NULL | Model confidence score between 0.0000 and 1.0000. |
| `position_x_cm` | DECIMAL(8,2) | NOT NULL | Distance from left edge in centimeters. |
| `position_y_m` | DECIMAL(10,2)| NOT NULL | Distance from start of roll in meters (via encoder). |
| `bounding_box` | JSON | NOT NULL | Normalized bounding box coordinates `[ymin, xmin, ymax, xmax]`. |
| `image_path_local`| VARCHAR(255)| NULL | File path on local edge NVMe drive. |
| `image_url_cloud` | VARCHAR(255)| NULL | S3 object URL after cloud sync. |
| `is_verified` | BOOLEAN | NOT NULL, DEFAULT FALSE | Whether a Quality Inspector has audited this defect. |
| `corrected_class` | VARCHAR(40) | NULL | Verified class label if inspector updated it. |
| `corrected_by` | UUID | FOREIGN KEY &rarr; `users.id`, NULL | Inspector who confirmed or changed the defect. |
| `penalty_points` | INTEGER | NOT NULL | ASTM 4-point penalty value: 1, 2, 3, or 4 points. |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Detection timestamp. |

---

### 2.4 Table: `offline_sync_queue`
Guarantees reliable transactional synchronization from edge to cloud.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY, NOT NULL | Unique queue transaction key. |
| `entity_type` | VARCHAR(30) | NOT NULL | Entity: `DEFECT`, `UNINSPECTED`, `ROLL`, `GRADING`. |
| `entity_id` | UUID | NOT NULL | Target entity primary key. |
| `operation` | VARCHAR(10) | NOT NULL | Action: `INSERT` or `UPDATE`. |
| `payload_json` | JSON | NOT NULL | JSON payload sent to backend API. |
| `sync_status` | VARCHAR(20) | NOT NULL, DEFAULT 'PENDING' | Status: `PENDING`, `SYNCED`, `FAILED`. |
| `retry_count` | INTEGER | NOT NULL, DEFAULT 0 | Number of upload retries attempted. |
| `last_attempt` | TIMESTAMP | NULL | Timestamp of most recent attempt. |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | When record was added to queue. |

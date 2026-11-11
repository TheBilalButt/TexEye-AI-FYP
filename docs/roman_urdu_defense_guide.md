# TexEye AI &mdash; Supervisor Defense &amp; Viva Guide (Roman Urdu)

## Final Year Project Presentation &amp; Supervisor Viva Guide
**Team Members:**
1. **Muhammad Afnan Khan** &mdash; FA23-BAI-028 (*Mobile App, Web Dashboard, Defect Mapping, Grading &amp; Sync*)
2. **Muhammad Bilal Butt** &mdash; FA23-BAI-042 (*AI Vision, Model Training, Hardware Integration &amp; Edge Reliability*)

---

## 1. Project Ka Real-World Problem aur Hamara Solution

### Problem:
Textile mills mein fabric inspection traditional tareeqay se insan (manual inspectors) visual inspection table par karte hain. Jab fabric tez speed (20 se 60 meters per minute) se guzarta hai, to insani ankh thakawat ki wajah se 30% se 40% tak chotay defects (surakh, daagh, warp/weft cut, oil spots) miss kar deti hai. Is se defective fabric aagay export shipments mein chala jata hai aur mills ko karoron ka jurmana ya fabric reject hota hai. Manual inspection mein na to defect ki exact metric position save hoti hai aur na hi koi digital record hota hai.

Doosra sab se bara masla yeh hai ke agar camera disconnect ho jaye, roshni kharab ho jaye, dhundla-pan (blur) aa jaye, ya frames drop ho jayein, to aam systems us hissay ko ghalti se "Clean / Defect-Free" declare kar dete hain, halanke wo hissa check hi nahi hua hota!

### TexEye AI Ka Solution:
TexEye AI aik **AI-based Edge-Accelerated Fabric Defect Detection aur Quality Management System** hai.
- Yeh industrial camera aur lighting se live video capture karta hai.
- Idler roller par laga **Rotary Encoder** fabric ki physical movement ko millimeter accuracy ke sath count karta hai.
- Hamara **Inspection Reliability Gate** har frame par camera signal, roshni, optical sharpness, aur dropped frames check karta hai.
- **Sab Se Bara Feature (Architectural Invariant):** Agar inspection reliable na ho, to system us span ko foran warning ke sath **`UNINSPECTED`** mark karta hai &mdash; **kisi bhi soorat mein usay clean nahi maanta!**
- Deep learning model (YOLO) defects detect karta hai, **Multi-Frame Tracker** consecutive frames mein ek hi defect ko track karke **Duplicate Detections** ko khatam karta hai.
- Internet chala jaye to inspection nahi rukti &mdash; local SQLite DB mein data save hota hai aur internet aane par auto-sync ho jata hai.
- **Mobile App** par floor operator ko instant alert milta hai aur wo QR code scan karke defect verify karta hai.
- **Web Dashboard** par management ko 2D **Digital Fabric Defect Map**, 4-Point ASTM grading, inventory bay status, aur automated PDF quality report milti hai.

---

## 2. Diagram-by-Diagram Supervisor Defense Script

---

### Diagram 1: Main System Workflow (`01_system_workflow`)
**Supervisor ko kaise samjhana hai:**
> *"Sir, yeh hamare pure system ka end-to-end workflow hai. Jab fabric roll inspection frame par enter hota hai, operator mobile app se roll ka QR code scan karta hai jis se session initialize ho jata hai.*
>
> *Jaise hi fabric aage barhta hai, continuous sensing shuru hoti hai: Camera video frames capture kar raha hota hai, uniform lighting fabric ko illuminate karti hai, aur rotary encoder roller ke sath ghoom kar movement pulses emit karta hai.*
>
> *Yahan hamara **Reliability Decision Gate** aata hai. Yeh char cheezein monitor karta hai: Camera disconnect to nahi hua? Roshni kam to nahi hui? Image blur ya lint to nahi aa gaya? Aur frames drop to nahi huye?*
>
> *Agar in charon mein se koi masla aaye (NO branch), to system foran physical tower light alarm aur mobile alert trigger karta hai, aur us particular length $[L_{start}, L_{end}]$ ko database mein **`UNINSPECTED`** mark kar deta hai. Hamara system strict rule follow karta hai ke uninspected fabric ko kabhi defect-free nahi samjha jayega.*
>
> *Agar sab theek ho (YES branch), to frames AI defect detection model ko jate hain. Model defect detect karta hai, tracker consecutive frames mein usay associate karta hai taake duplicate count na ho, aur encoder ki madad se exact physical coordinates $(X_{cm}, Y_m)$ nikaale jate hain.*
>
> *Yeh record foran local edge SQLite DB mein save hota hai. Agar factory ka internet live hai to data central backend ko stream hota hai; agar internet down ho to local sync queue mein buffer ho jata hai aur link aane par khud ba khud sync hota hai.*
>
> *Aakhir mein data Mobile App aur Web Dashboard par distribute hota hai jahan 4-Point ASTM fabric grading aur digital inspection report generate hoti hai."*

---

### Diagram 2: AI Inspection Pipeline (`02_ai_inspection_workflow`)
**Supervisor ko Bilal Butt explain karega:**
> *"Sir, yeh AI processing layer ka detailed technical pipeline hai jise main lead kar raha hoon. Iske char main stages hain:*
>
> *1. **Stage 1 (Pre-Inference Gate):** Frame AI model ko bhejne se pehle hum sequence intactness (dropped frames), histogram luminance (lighting uniformity), aur Laplacian variance (image sharpness/focus) compute karte hain. Agar frame degraded ho to inference bypass ho jati hai aur section uninspected mark ho jata hai.*
>
> *2. **Stage 2 (Conditioning & Detection):** Qualified frames par hum fabric boundary crop (ROI) karte hain aur CLAHE (Contrast-Limited Adaptive Histogram Equalization) apply karte hain taake warp aur weft threads ka contrast ubhar aaye. Phir hamara optimized YOLO deep learning object detection model run hota hai jo bounding boxes, class (Hole, Stain, Warp Defect, Weft Defect, Float, Oil Spot), aur confidence score nikalta hai.*
>
> *3. **Stage 3 (Multi-Frame Tracking & Deduplication):** Chunke fabric chal raha hota hai, aik hi defect 4 se 8 consecutive frames mein nazar aata hai. Agar hum har frame par count karein to defect 8 baar count ho jayega aur penalty points ghalat ho jayenge! Isliye hum **Kalman Filter aur Hungarian IoU Tracker** use karte hain jo defect ki trajectory maintain karta hai aur deduplication gate un sab ko **aik single unique defect** mein merge kar deta hai.*
>
> *4. **Stage 4 (Physical Coordinate Mapping):** Sir yahan optical resolution aur physical movement ko link kiya jata hai. Lateral position ($X_{cm}$) camera calibration ground sampling distance (cm/pixel) se calculate hoti hai, jabke longitudinal position ($Y_m$) rotary encoder ke cumulative pulses ko roller circumference se multiply karke calculate hoti hai. Is se hamare paas millimetric physical coordinate $[X, Y]$ aa jata hai."*

---

### Diagram 3: Offline / Online Synchronization (`03_offline_sync_workflow`)
**Supervisor ko Afnan Khan explain karega:**
> *"Sir, textile mills ke environment mein Wi-Fi dead zones aur internet outages aam baat hain. Agar hamara system cloud-dependent hota to internet jane par pure mill ki production line ruk jati!*
>
> *Hamara architecture **Offline-First** hai. Jab bhi defect detect hota hai ya uninspected section record hota hai, hamara edge daemon foran usay local edge SQLite database aur local NVMe flash cache mein commit karta hai. Is local transaction ki latency 5 milliseconds se bhi kam hai, isliye physical line 100% full speed par chalti rehti hai.*
>
> *Aik background sync daemon har 5 second baad central cloud API par HTTPS heartbeat ping karta hai. Agar internet down ho to transaction local `offline_sync_queue` outbox table mein `PENDING` status ke sath jama hoti rehti hain.*
>
> *Jaise hi internet wapis aata hai, sync daemon lock acquire karta hai aur 50, 50 records ke batches bana kar central API ko `POST /api/v1/sync/batch` bhejta hai. Central PostgreSQL database har record ke UUIDv4 key ki madad se **Idempotent Upsert** karta hai taake agar duplicate request aaye to data corrupt na ho. Jab backend 200 OK deta hai, to edge local outbox status ko `SYNCED` mark kar deta hai aur uploaded image crops ko clear kar deta hai."*

---

### Diagram 4: Hardware Architecture (`04_hardware_architecture`)
**Supervisor ko dono members explain karenge:**
> *"Sir, hardware architecture mein humne project proposal ke confirmed components aur proposed engineering alternatives ko bilkul wazeh rakha hai:*
>
> *1. **Fabric Stand Subsystem [Confirmed]:** Moving fabric web, idler friction roller, aur illuminated inspection area.*
> *2. **Sensing & Illumination [Confirmed]:** Industrial camera, high-CRI uniform LED bar, aur incremental optical quadrature rotary encoder.*
> *3. **Edge Processing Unit [Confirmed]:** Industrial Edge Computer jisme GPU accelerator (jaise NVIDIA Jetson ya Industrial Mini-PC with dedicated GPU) aur NVMe storage mojud hai.*
>
> *Important baat yeh hai sir ke humne exact hardware models aur interfaces ko **Proposed Alternatives** ke tor par mark kiya hai:*
> *- Camera connection ke liye humne USB 3.0 Vision, GigE Vision, aur MIPI-CSI2 ke options propose kiye hain.*
> *- Rotary encoder ke liye direct GPIO pulse counter, optocoupler isolation DAQ, ya dedicated microcontroller proposed hai.*
> *- Lighting ke liye 24V constant-current driver proposed hai.*
> *- Floor alert ke liye optocoupler relay driven stack tower light beacon proposed hai.*
>
> *Aur sir humne proposal ki boundaries ka sakhti se ehtram kiya hai: Hamare project mein koi automatic cutting actuator, machine stopping interlock, ya automatic marking stamper shamil nahi hai."*

---

### Diagram 5: Layered Software Architecture (`05_software_architecture`)
**Supervisor ko Afnan Khan explain karega:**
> *"Sir, hamara software architecture 5 decoupled logical layers par mushtamil hai:*
>
> *1. **Layer A (Hardware / Edge Layer):** Camera Capture Service, Rotary Encoder Service, Reliability Health Gate, aur Edge Sync Daemon.*
> *2. **Layer B (AI Vision & Metrology Layer):** OpenCV Preprocessing, YOLO Inference Runtime, Kalman Multi-Frame Tracker, Deduplication Engine, aur Metric Coordinate Mapper.*
> *3. **Layer C (Backend / Application Layer):** FastAPI par mushtamil asynchronous core jisme JWT Auth/RBAC, Roll & Batch Service, Defect Review Service, ASTM 4-Point Grading Engine, PDF Report Generator, aur WebSocket Notification Hub hai.*
> *4. **Layer D (Data Layer):** Local Edge SQLite DB + NVMe cache aur Central PostgreSQL Relational DB + MinIO/S3 Object Store.*
> *5. **Layer E (User Interface Layer):** Floor operator ke liye Flutter/React Native Mobile App aur Quality/Production Management ke liye React + TypeScript Web Dashboard.*
>
> *Mobile app aur Web app backend se HTTPS REST API aur live WebSocket channels ke zariye communicate karte hain."*

---

### Diagram 6: UML Use Case Diagram (`06_use_case_overall`)
**Supervisor ko Afnan Khan explain karega:**
> *"Sir, use case diagram mein humne system boundary ke andar software features rakhe hain aur bahar actors hain:*
>
> *- **Floor Operator:** Login karta hai, roll QR code scan karta hai, roll info dekhta hai, mobile par instant alerts receive karta hai, aur defect thumbnails review karta hai.*
> *- **Quality Inspector:** Web dashboard par digital defect map open karta hai, defect crops ko review karke **Correct Defect Record** karta hai (yeh `Review Defects` use case ka `<<extend>>` hai), 4-point grading confirm karta hai, aur inspection report generate karta.*
> *- **Production Manager:** Executive dashboard dekhta hai, Pareto defect distribution charts aur quality historical records monitor karta hai.*
> *- **Inventory Manager:** Warehousing bay locations update karta hai aur rejected/scrap rolls ko quarantine bay mein manage karta hai.*
> *- **System Administrator:** Users manage karta hai, RBAC roles assign karta hai, aur calibration parameters set karta hai.*
>
> *Iske sath humne **Internal Automated Subsystem** ke use cases bhi show kiye hain (Capture Frames, Read Pulses, Reliability Gate, Mark Uninspected, Run Inference, Track Defects, Store Local, aur Auto-Sync)."*

---

### Diagrams 7, 8, 9: Context Diagram aur Data Flow Diagrams (DFD L0 &amp; L1)
**Supervisor ko explain karein:**
> *"Sir, DFDs data ke flow aur transformation ko model karte hain:*
> *- **Context Diagram:** Core TexEye AI system aur 7 external entities (Camera, Encoder, Lighting, Operator, Inspector, Manager, Enterprise Cloud) ke darmian input/output streams dikhata hai.*
> *- **DFD Level 0:** 5 major processes dikhata hai: 1.0 Signal Ingestion, 2.0 AI Detection & Metrology, 3.0 Edge Persistence & Sync, 4.0 Central Quality & Grading, aur 5.0 User Apps & Alerts. Aur 4 data stores: D1 SQLite, D2 Sync Queue, D3 PostgreSQL, D4 MinIO/S3.*
> *- **DFD Level 1:** Sub-processes ko detail mein kholta hai jaise 1.3 Reliability Gate kis tarah anomaly detect hone par 1.4 Uninspected Span Calculator ko data deta hai aur qualified clean frames ko 2.1 Contrast Conditioning aur 2.2 YOLO Inference ko bhejta hai."*

---

### Diagrams 10 &amp; 11: Component &amp; Deployment Architecture
**Supervisor ko explain karein:**
> *- **Component Diagram:** Software modules ke interfaces dikhata hai jaise `ICameraStream`, `IEncoderPosition`, `IReliabilityStatus`, aur `ISyncIngest`.*
> *- **Deployment Diagram:** Physical hardware nodes dikhata hai: Inspection Stand Node, Edge Linux Computer Node (Ubuntu with CUDA & SQLite), Central Enterprise Cloud Server Node (Dockerized Nginx, FastAPI, PostgreSQL, MinIO), aur Client Workstations/Tablets.*

---

### Diagram 14: Entity Relationship Diagram (ERD &amp; Schema)
**Supervisor ko explain karein:**
> *"Sir, hamari relational database 9 interconnected entities par mushtamil hai:*
> *1. `users` &bull; 2. `fabric_rolls` &bull; 3. `inspection_sessions` &bull; 4. `defect_records` &bull; 5. `uninspected_sections` &bull; 6. `roll_grading` &bull; 7. `inventory_records` &bull; 8. `alerts` &bull; 9. `offline_sync_queue`.*
>
> *Har table mein primary keys (UUID), foreign keys, aur strict integrity constraints hain. Khas tor par `uninspected_sections` table `start_position_m`, `end_position_m`, aur `failure_reason` capture karti hai taake certified roll report mein audit trail transparent ho."*

---

## 3. Tough Supervisor Questions &amp; Best Answers

### Q1: "Agar fabric tez chale aur camera aik frame drop kar de, to aap ka system kya karega?"
**Answer:**
> *"Sir, yahi hamare system ka sab se bara feature hai. Hamara Dropped-Frame Analyzer rotary encoder ki physical movement speed aur camera ke incoming timestamps ko match karta hai. Agar frame drop ho, to system us missing interval ke encoder meters calculate karke foran `uninspected_sections` table mein row insert karta hai aur alarm bajata hai. System us missing section ko kabhi bhi clean ya defect-free treat nahi karega."*

### Q2: "Camera failure aur internet outage mein aap ke architecture mein kya farq hai?"
**Answer:**
> *"Sir dono completely mukhtalif failure modes hain:*
> *- **Camera Failure:** Hardware sensing ka fault hai. Fabric chal raha hai lekin hum usay dekh nahi pa rahe. Is mein AI inference bypass ho jati hai, fabric uninspected mark hota hai, aur floor par physical alarm bajta hai.*
> *- **Internet Outage:** Network communication ka fault hai. Edge computer aur camera bilkul theek chal rahe hain. Is soorat mein inspection 100% full speed par chalti rehti hai, defects detect hote hain, aur local SQLite outbox queue mein save hote hain. Jab internet aayega to background worker baghair kisi data loss ke cloud se sync kar lega."*

### Q3: "Aik hi defect agar 5 frames mein nazar aaye to grading kharab nahi hogi?"
**Answer:**
> *"Sir bilkul, agar naive system ho to wo 5 alag defects count kar lega. Is maslay ko hal karne ke liye Bilal Butt ne **Multi-Frame Defect Tracker aur Spatial-Temporal Deduplication Gate** implement kiya hai. Yeh Kalman Filter aur IoU matching se defect ko track karta hai aur jab defect frame se nikal jata hai to un tamam frame detections ko **aik single unique defect record** mein consolidate kar deta hai."*

### Q4: "Aap fabric defect ki physical metric position $(X, Y)$ kaise nikalte hain?"
**Answer:**
> *"Sir, longitudinal position ($Y$ meters) rotary encoder ke cumulative pulses ko roller circumference ($\pi \times D / \text{PPR}$) se multiply karke aati hai. Aur lateral position ($X$ centimeters) camera pixel coordinates ko calibrated ground resolution (cm/pixel) se multiply karke aati hai, jise humne optical checkerboard calibration se calibrate kiya hai."*

### Q5: "Aap ne automatic fabric cutting ya loom ko stop karne ka feature kiyun nahi dala?"
**Answer:**
> *"Sir, university-approved FYP scope aur industrial safety rules ke mutabiq, AI vision system ko directly high-voltage loom inverters ya mechanical cutting knives ke sath wire karna risky aur unapproved scope creep hai. Hamara system high-precision **Digital Fabric Defect Map** banata hai aur floor operator ko visual/audible alarms deta hai, taake mill management certified decision le sake."*


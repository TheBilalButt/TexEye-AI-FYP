# TexEye AI: AI-Based Fabric Defect Detection & Quality Management System

## Final Year Project (FYP) — System Analysis & Design Specification

---

### Project Information

- **Project Title:** TexEye AI: AI-Based Fabric Defect Detection and Quality Management System
- **Degree:** Bachelor of Science in Artificial Intelligence (BS-AI)
- **Project Members:**
  1. **Muhammad Afnan Khan** — FA23-BAI-028 (*Mobile App, Web Dashboard, Defect Mapping, Grading & Sync Lead*)
  2. **Muhammad Bilal Butt** — FA23-BAI-042 (*AI Vision, Model Training, Hardware Integration & Edge Reliability Lead*)

---

## 1. Executive Summary

In textile mills today, fabric inspection is still mostly done by hand. Human workers stand in front of rolling inspection tables, watching fabric fly past at 20 to 60+ meters per minute. It's an exhausting job, and after even an hour or two of staring at moving cloth, human eyes get tired. Studies and industry data show that manual inspectors regularly miss 30% to 40% of small defects — things like broken threads, tiny holes, or oil drops from machine bearings.

When these defects slip through, bad fabric gets shipped out to garment makers, leading to rejected batches, heavy financial penalties, and a lot of wasted material. On top of that, manual inspection relies on handwritten paper logs that don't record where defects actually are on the roll. There's no reliable way to track quality digitally.

**TexEye AI** is designed to solve this problem. We are building an edge-based, automated inspection system that combines computer vision, hardware sensors, a mobile application, and a central web dashboard. The system brings together:

1. An overhead industrial camera that captures continuous video under uniform LED lighting.
2. An incremental rotary encoder attached to a roller that measures fabric movement down to the millimeter.
3. An edge-based deep learning pipeline that detects fabric defects, tracks them across consecutive video frames, and removes duplicate counts.
4. A built-in **Inspection Reliability Gate** that constantly checks camera connection, lighting levels, image sharpness, and dropped frames.
5. An **Offline-First Sync Engine** so the inspection line keeps running at full speed even if the factory loses its internet connection.
6. A **Mobile App** for floor operators to get instant alerts, scan roll QR codes, and review defects.
7. A **Web Dashboard** for quality managers to view an interactive 2D defect map of the fabric roll, calculate standardized 4-point grades, manage inventory, and generate PDF inspection reports.

---

## 2. Real-World Problem Statement

### 2.1 The Inspection Bottleneck
1. **High Speeds vs. Human Limits:** Modern textile machines move fabric at 20 to 60+ meters per minute. A human inspector simply cannot catch tiny defects across a 1.5 to 2.5 meter wide sheet moving that fast for hours at a time.
2. **No Coordinate Tracking:** When an inspector does spot a flaw, they usually stick a piece of colored tape or chalk on the fabric edge. These stickers fall off, and they don't give you exact coordinates — you can't tell where the defect is across the width or along the length of the roll.
3. **Paper Records Disconnected from Inventory:** Inspection results are written down on paper forms. These forms often get lost or filed away, completely disconnected from warehouse and ERP systems.

### 2.2 System Reliability Failure Modes
Automated camera systems in textile mills face real-world hardware challenges:
- **Camera Disconnection:** Industrial machines vibrate heavily. Cables can loosen or disconnect, causing sudden video feed loss.
- **Lighting Changes:** Ambient light changes from day to night, dust settles on LED diffusers, or power supplies fluctuate.
- **Blur and Dust:** Cotton lint floats everywhere in textile mills. It settles on the camera lens, causing blurry images.
- **Dropped Frames:** High-speed video over USB or Ethernet can drop frames if the computer gets bogged down or bandwidth gets choked.

### 2.3 The Non-Negotiable "Uninspected Section" Rule
A common and dangerous mistake in automated vision systems is assuming that if the camera didn't record a defect, the fabric must be clean. If the camera disconnected or the image was blurry, you simply don't know what was on that fabric.

In TexEye AI, we have a strict rule built into the architecture:

> **Core System Invariant:** If the camera disconnects, lighting drops below our threshold, the image gets too blurry, or frames are dropped, the system records that exact stretch of fabric $[L_{start}, L_{end}]$ as **`UNINSPECTED`**. Under no circumstances is an uninspected section treated as defect-free. It is flagged, the operator is alerted, and the roll cannot receive an automatic passing grade until a human checks that section.

---

## 3. High-Level System Scope & Boundaries

### 3.1 Confirmed Project Features
- [x] Continuous video capture using an overhead industrial camera.
- [x] Fabric movement measurement using an incremental rotary encoder.
- [x] Automatic reliability monitoring (checking camera connection, lighting, blur, and frame rate).
- [x] Tracking and flagging of uninspected sections with immediate operator warnings.
- [x] AI-based detection of standard fabric defects (Holes, Stains, Warp defects, Weft defects, Floats, Oil spots).
- [x] Multi-frame tracking so the same defect isn't counted multiple times as it passes under the camera.
- [x] Physical defect coordinate calculation $(X_{cm}, Y_m)$ using camera calibration and encoder pulses.
- [x] Local edge database (SQLite) for zero-delay saves on the shop floor.
- [x] Offline sync queue that automatically uploads saved data once internet/network connectivity is restored.
- [x] Mobile app for floor operators (QR scanning, live alerts, defect review and correction).
- [x] Web dashboard for quality managers (2D digital defect map, 4-point grading system, inventory tracking, PDF reports).
- [x] Role-Based Access Control (RBAC) with user login/authentication.

### 3.2 Explicit Exclusions (Out of Scope)
To keep the project realistic and focused on our approved FYP proposal:
- **No automatic fabric cutting:** The system does not control motorized knives or cutters.
- **No machine emergency stopping:** We do not wire into loom emergency stops or motor inverters. We issue alerts to human operators instead.
- **No physical ink-marking systems:** We map defects digitally on a 2D map rather than spraying physical ink or stamping chalk on the fabric.
- **No worker shift scheduling or payroll:** Management features are strictly limited to quality, defect stats, and inventory records.

---

## 4. Key Distinction: Camera Failure vs. Internet Outage

It's critical to understand how TexEye AI handles different types of failures. A camera failure is a physical inspection problem, while an internet outage is just a network problem:

| Situation | Camera / Lighting / Sensor Failure | Network / Internet Outage |
| :--- | :--- | :--- |
| **What Happened** | Camera disconnected, LED power failed, lens is blurry/blocked, or frames were dropped. | Factory Wi-Fi dropped, Ethernet cable unplugged, or central server is unreachable. |
| **Impact on Inspection** | Fabric is moving, but the camera cannot see it clearly or at all. | The edge computer cannot reach the cloud backend, but all local sensors and AI work fine. |
| **System Action** | **Pause AI inference on the bad frames.** Calculate the length $[L_1, L_2]$ using encoder pulses. Mark the section as **`UNINSPECTED`**. Fire local alarm light/buzzer and alert the operator. | **Keep inspecting at 100% full speed!** The AI keeps detecting defects, tracking coordinates, and saving everything locally. |
| **Data Handling** | Saves an `uninspected_sections` record in local SQLite. Shows up as a yellow warning band on the defect map. | Saves all records normally to local SQLite, plus queues them in `offline_sync_queue` with status `PENDING`. |
| **When Resolved** | Operator fixes the issue, resets the sensor, and the uninspected section is flagged for manual review. | Background sync worker detects the network is back and automatically uploads all queued records to the cloud. |

---

## 5. Architectural Quality Attributes

1. **Reliability:** Built-in health checks make sure bad sensor data never gets recorded as "good fabric."
2. **Edge Independence:** The inspection line works 100% locally. Zero internet connection is needed for real-time defect detection and data saving.
3. **Accurate Coordinates:** Every defect gets real physical coordinates (centimeters across width, meters along length) by combining calibrated pixels with encoder pulses.
4. **Data Safety:** Uses an offline-first transactional queue so zero inspection data is lost, even during extended network outages.
5. **Role-Based Security:** JWT authentication ensures operators, inspectors, and managers only have access to their own features.

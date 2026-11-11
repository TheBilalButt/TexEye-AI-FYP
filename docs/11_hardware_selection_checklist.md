# TexEye AI — Hardware Selection Checklist & Evaluation Guide

## 1. Overview

While the main hardware subsystem types (Camera, Rotary Encoder, Uniform Lighting, Edge Computer) are established in our project charter, the specific physical models, lenses, and electrical interfaces remain **proposed engineering alternatives** that will be finalized through bench tests and supervisor sign-off.

This checklist outlines the evaluation criteria and decisions needed prior to procurement.

---

## 2. Hardware Decision Matrix

### Decision 1: Camera Sensor & Resolution
- [ ] **Target Ground Sampling Distance (GSD):**
  - Minimum defect size to catch: $\approx 0.5$ mm to $1.0$ mm (e.g., small holes or broken warp yarns).
  - Target optical resolution: $\le 0.35$ mm per pixel across the fabric width.
- [ ] **Area-Scan vs. Line-Scan Evaluation:**
  - *Area-Scan Camera (Recommended for prototype):* 2MP to 5MP ($2448 \times 2048$). More affordable, straightforward calibration, uses standard C-mount lenses.
  - *Line-Scan Camera (Alternative for wide industrial looms):* 2K or 4K single-line sensor. Eliminates perspective distortion on very wide fabrics ($> 2$ meters), but requires specialized line lights and continuous encoder sync triggering.
- [ ] **Status:** Final choice depends on physical inspection stand width.

### Decision 2: Camera Connection Interface
- [ ] **USB 3.0 Vision:**
  - Good for: Laboratory prototype where cable run is under 3 meters.
  - Caution: Standard USB ports can loosen under vibration. Needs industrial screw-locking cables.
- [ ] **GigE Vision (PoE):**
  - Good for: Factory deployment where camera stand is $> 5$ meters from edge PC.
  - Advantage: One Cat6 Ethernet cable delivers both power and 1 Gbps video data with secure locking connectors.
- [ ] **Status:** USB 3.0 chosen for initial lab bench testing; GigE Vision planned for factory deployment.

### Decision 3: Camera Lens & Focal Length
- [ ] **Working Distance (WD):** Vertical mounting height of camera above fabric (typically 600–1000 mm).
- [ ] **Focal Length ($f$):**
  $$f = \frac{\text{Sensor Width (mm)} \times \text{Working Distance (mm)}}{\text{Field of View (mm)}}$$
  - Candidate lenses: 8mm, 12mm, or 16mm low-distortion fixed industrial lenses.
- [ ] **Aperture & Depth of Field (DoF):** Set lens aperture to $f/4.0–f/5.6$ to keep fabric in sharp focus even with $\pm 5$ mm vertical flutter.

### Decision 4: Rotary Encoder Resolution & Mechanical Coupling
- [ ] **Measurement Roller Diameter ($D_{\text{roller}}$):**
  - Roller diameter: 50 mm to 100 mm.
  - Circumference: $C = \pi \times D \approx 157–314$ mm.
- [ ] **Encoder Pulses Per Revolution (PPR):**
  - Resolution goal: at least 1 mm fabric movement per pulse.
  - Example: If $D = 63.66$ mm ($C = 200$ mm) and $\text{PPR} = 1000$ (with $4\times$ quadrature $= 4000$ ticks/rev):
    $$\text{Resolution} = \frac{200 \text{ mm}}{4000 \text{ counts}} = 0.05 \text{ mm/count}$$
  - Gives plenty of precision for millimeter-level defect tracking.
- [ ] **Mechanical Mounting:** Flexible bellows shaft coupling or rubber-coated friction wheel riding on fabric edge.

### Decision 5: Lighting Setup & Controller
- [ ] **Illumination Angle:**
  - *Direct Overhead Light ($90^\circ$):* Best for spotting stains, oil spots, and color defects.
  - *Low-Angle Side Light ($15^\circ–30^\circ$):* Best for showing weave relief, missed picks, slubs, and surface texture flaws.
  - *Backlight (Through fabric):* Best for holes, thin spots, and foreign fibers.
- [ ] **LED Driver Mode:**
  - Constant-current 24V DC driver vs. camera-strobe triggered PWM driver (extends LED lifespan and keeps heat down).

### Decision 6: Edge Processing Unit Form Factor
- [ ] **Embedded Platform (Option A):** NVIDIA Jetson Orin Nano (40 TOPS) / Orin NX (70–100 TOPS) running Linux ARM64. Low power consumption (15–25W), compact enclosure right on the stand.
- [ ] **Industrial Mini-PC (Option B):** Intel Core i7 / AMD Ryzen + NVIDIA GeForce RTX GPU running Linux x86_64. More raw compute power for testing multiple model backbones.

---

## 3. Procurement Verification Sign-Off

| Component | Proposed Model / Spec | Supervisor Review | Status |
| :--- | :--- | :--- | :--- |
| Industrial Camera | 5MP USB3 / GigE Global Shutter CMOS | [ ] Approved [ ] Revision Req. | Proposed |
| C-Mount Lens | 12mm Fixed Focal Length, Low Distortion | [ ] Approved [ ] Revision Req. | Proposed |
| Rotary Encoder | 1000 PPR Optical Quadrature (A/B) | [ ] Approved [ ] Revision Req. | Proposed |
| Lighting Rig | High-CRI 24V Linear LED Bar + Diffuser | [ ] Approved [ ] Revision Req. | Proposed |
| Edge Unit | NVIDIA Jetson Orin / Industrial Mini-PC with GPU | [ ] Approved [ ] Revision Req. | Proposed |

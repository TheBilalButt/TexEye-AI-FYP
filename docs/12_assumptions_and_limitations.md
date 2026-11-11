# TexEye AI — Assumptions, Limitations & Scope Boundaries

## 1. System Assumptions

1. **Forward Fabric Movement:** The fabric advances continuously forward during an active inspection session without significant backwards rewinding.
2. **Roller Grip:** The friction roller maintains firm, non-slip contact with the fabric web (rubber or polyurethane roller coating is assumed).
3. **Camera Field of View:** The camera mounting height and lens focal length are calibrated so the full usable width of the fabric is visible within the image frame.
4. **Vibration Damping:** The inspection stand is rigid enough to keep machine vibration from causing continuous optical blur.
5. **Fabric Tension:** Feed rollers keep the moving fabric reasonably flat ($\pm 5$ mm vertical flutter) in the inspection area.
6. **Defect Types:** The AI model is trained on standard woven/knitted fabric flaws (Hole, Stain, Warp Defect, Weft Defect, Float, Oil Spot); complex patterned fabrics (like jacquards) would need dedicated training data.
7. **Local Storage & Power:** The edge computer has non-volatile NVMe SSD storage and is connected to a small UPS to prevent data corruption during sudden factory power outages.

---

## 2. Technical & Operational Limitations

1. **Total Lens Blockage:** If heavy cotton lint or an object completely blocks the lens, the camera cannot detect defects optically. However, the **reliability gate catches the focus/blur failure immediately** and marks that entire stretch as `UNINSPECTED`.
2. **Speed vs. Inference Time:** Maximum line speed is limited by model inference time. For example, if YOLO inference runs at 25 ms (40 FPS), and the camera covers a 20 cm longitudinal strip, the theoretical speed limit is:
   $$v_{\text{max}} = 0.20\text{ m} \times 40\text{ s}^{-1} = 8.0\text{ m/s} = 480\text{ m/min}$$
   Since textile inspection tables typically run at 20–60 m/min, the system has plenty of headroom.
3. **Porous / Mesh Fabrics:** Very open mesh fabrics might trigger false hole alerts with standard lighting and may require calibrated backlight adjustments.
4. **Local Disk Space:** While SQLite text records can be stored for months without filling the drive, defect crop images are capped at an 80% disk threshold with FIFO eviction for already-synced images.

---

## 3. Explicit Scope Boundaries (Out of Scope)

To keep our FYP realistic and strictly adhere to our approved project proposal, the following items are **explicitly excluded**:

- **No automated fabric cutting:** TexEye AI does not control motorized blades or pneumatic shears to cut out bad fabric.
- **No direct machine stopping:** We do not wire into loom emergency stops or motor inverters. We notify human operators through audio/visual alerts instead.
- **No motor speed control:** The system does not adjust machine feed rates or motor frequencies.
- **No physical ink-marking systems:** We plot defect locations digitally on a 2D map rather than spraying physical ink or stamping chalk on the fabric.
- **No factory shift scheduling or payroll:** Management features focus strictly on fabric quality, defect statistics, and warehouse roll tracking.

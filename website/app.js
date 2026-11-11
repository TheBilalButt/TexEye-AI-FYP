// TexEye AI Portal & Live Simulator Engine
document.addEventListener('DOMContentLoaded', () => {
  // Tab Navigation
  const tabs = document.querySelectorAll('.tab-btn');
  const panes = document.querySelectorAll('.tab-pane');

  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      tabs.forEach(t => t.classList.remove('active'));
      panes.forEach(p => p.classList.remove('active'));

      tab.classList.add('active');
      const targetId = tab.getAttribute('data-tab');
      const targetPane = document.getElementById(targetId);
      if (targetPane) {
        targetPane.classList.add('active');
        if (targetId === 'tab-simulator') {
          initSimulator();
        }
      }
    });
  });

  // ==========================================
  // LIVE INSPECTION SIMULATOR ENGINE
  // ==========================================
  let simRunning = false;
  let animId = null;
  let fabricY = 0; // meters
  let encoderTicks = 0;
  const fabricWidthCm = 150; // cm
  const rollerCircumferenceM = 0.20; // 200 mm
  const encoderPpr = 1000;
  let lineSpeedMPerMin = 30; // 30 m/min
  let lastTimestamp = 0;

  // Failure modes
  let cameraFailed = false;
  let opticalBlur = false;
  let uninspectedStartM = null;

  // Defect & Uninspected storage
  const defects = [];
  const uninspectedSpans = [];

  // Canvas elements
  const camCanvas = document.getElementById('cameraCanvas');
  const mapCanvas = document.getElementById('mapCanvas');
  const camCtx = camCanvas ? camCanvas.getContext('2d') : null;
  const mapCtx = mapCanvas ? mapCanvas.getContext('2d') : null;

  // Telemetry elements
  const telemPos = document.getElementById('telem-pos');
  const telemSpeed = document.getElementById('telem-speed');
  const telemPulses = document.getElementById('telem-pulses');
  const telemCam = document.getElementById('telem-cam');
  const telemGate = document.getElementById('telem-gate');
  const telemGrade = document.getElementById('telem-grade');
  const camBadge = document.getElementById('cam-badge');
  const defectBadge = document.getElementById('defect-badge');
  const overlayUninspected = document.getElementById('overlay-uninspected');
  const auditList = document.getElementById('audit-list');

  // Control Buttons
  const btnToggleRun = document.getElementById('btn-toggle-run');
  const btnReset = document.getElementById('btn-reset');
  const btnAddHole = document.getElementById('btn-add-hole');
  const btnAddStain = document.getElementById('btn-add-stain');
  const btnAddOil = document.getElementById('btn-add-oil');
  const btnToggleCamFail = document.getElementById('btn-toggle-cam-fail');
  const btnToggleBlur = document.getElementById('btn-toggle-blur');

  // Moving elements on camera
  let fabricWeaveOffset = 0;
  let activeFlaws = [];

  function logAudit(msg, type = 'info') {
    if (!auditList) return;
    const entry = document.createElement('div');
    const timeStr = `[${(fabricY).toFixed(2)}m]`;
    let color = '#94a3b8';
    if (type === 'warn') color = '#fbbf24';
    if (type === 'danger') color = '#f87171';
    if (type === 'success') color = '#4ade80';

    entry.style.color = color;
    entry.textContent = `${timeStr} ${msg}`;
    auditList.prepend(entry);
  }

  function calculateGrade() {
    let totalPoints = 0;
    defects.forEach(d => {
      totalPoints += d.points;
    });

    const rollLengthM = Math.max(fabricY, 1);
    const fabricWidthM = fabricWidthCm / 100;
    const area100Sqm = (rollLengthM * fabricWidthM) / 100;
    const pointsPer100Sqm = area100Sqm > 0 ? (totalPoints / area100Sqm) : 0;

    let grade = 'GRADE A';
    let gradeColor = '#4ade80';

    if (uninspectedSpans.length > 0 || cameraFailed) {
      grade = 'HOLD (UNINSPECTED SPAN)';
      gradeColor = '#f59e0b';
    } else if (pointsPer100Sqm > 40) {
      grade = 'REJECT / SCRAP';
      gradeColor = '#ef4444';
    } else if (pointsPer100Sqm > 25) {
      grade = 'GRADE C';
      gradeColor = '#f97316';
    } else if (pointsPer100Sqm > 15) {
      grade = 'GRADE B';
      gradeColor = '#38bdf8';
    }

    if (telemGrade) {
      telemGrade.textContent = `${grade} (${totalPoints} pts, ${pointsPer100Sqm.toFixed(1)}/100m²)`;
      telemGrade.style.color = gradeColor;
    }
  }

  function drawCameraView() {
    if (!camCtx) return;
    const w = camCanvas.width;
    const h = camCanvas.height;

    if (cameraFailed) {
      camCtx.fillStyle = '#020617';
      camCtx.fillRect(0, 0, w, h);
      camCtx.fillStyle = '#ef4444';
      camCtx.font = 'bold 16px monospace';
      camCtx.textAlign = 'center';
      camCtx.fillText('NO CAMERA SIGNAL (USB/GigE DISCONNECT)', w / 2, h / 2);
      return;
    }

    // Fabric background
    camCtx.fillStyle = '#1e293b';
    camCtx.fillRect(0, 0, w, h);

    // Fabric weave texture simulation
    camCtx.strokeStyle = 'rgba(255, 255, 255, 0.05)';
    camCtx.lineWidth = 1;
    const spacing = 8;
    for (let x = 0; x < w; x += spacing) {
      camCtx.beginPath();
      camCtx.moveTo(x, 0);
      camCtx.lineTo(x, h);
      camCtx.stroke();
    }
    const offset = fabricWeaveOffset % spacing;
    for (let y = offset; y < h; y += spacing) {
      camCtx.beginPath();
      camCtx.moveTo(0, y);
      camCtx.lineTo(w, y);
      camCtx.stroke();
    }

    // Selvedge borders
    camCtx.fillStyle = 'rgba(56, 189, 248, 0.2)';
    camCtx.fillRect(0, 0, 20, h);
    camCtx.fillRect(w - 20, 0, 20, h);

    if (opticalBlur) {
      camCtx.fillStyle = 'rgba(255, 255, 255, 0.4)';
      camCtx.fillRect(0, 0, w, h);
      camCtx.fillStyle = '#d97706';
      camCtx.font = 'bold 15px sans-serif';
      camCtx.textAlign = 'center';
      camCtx.fillText('OPTICAL BLUR DETECTED (LAPLACIAN VARIANCE FAIL)', w / 2, 30);
    }

    // Draw active passing flaws
    activeFlaws.forEach(flaw => {
      camCtx.save();
      if (flaw.type === 'HOLE') {
        camCtx.fillStyle = '#000000';
        camCtx.beginPath();
        camCtx.ellipse(flaw.x, flaw.y, 14, 10, 0, 0, Math.PI * 2);
        camCtx.fill();
        camCtx.strokeStyle = '#ef4444';
        camCtx.lineWidth = 2;
        camCtx.stroke();
      } else if (flaw.type === 'STAIN') {
        camCtx.fillStyle = 'rgba(180, 83, 9, 0.7)';
        camCtx.beginPath();
        camCtx.ellipse(flaw.x, flaw.y, 18, 12, 0.3, 0, Math.PI * 2);
        camCtx.fill();
      } else if (flaw.type === 'OIL_SPOT') {
        camCtx.fillStyle = 'rgba(88, 28, 135, 0.8)';
        camCtx.beginPath();
        camCtx.arc(flaw.x, flaw.y, 12, 0, Math.PI * 2);
        camCtx.fill();
      }

      // YOLO Bounding Box & Label
      if (!cameraFailed && !opticalBlur) {
        camCtx.strokeStyle = flaw.color;
        camCtx.lineWidth = 2;
        camCtx.strokeRect(flaw.x - 25, flaw.y - 20, 50, 40);

        camCtx.fillStyle = flaw.color;
        camCtx.fillRect(flaw.x - 25, flaw.y - 38, 90, 18);

        camCtx.fillStyle = '#000000';
        camCtx.font = 'bold 10px monospace';
        camCtx.textAlign = 'left';
        camCtx.fillText(`${flaw.type} ${(flaw.confidence).toFixed(2)}`, flaw.x - 22, flaw.y - 25);
      }
      camCtx.restore();
    });

    // Overhead HUD
    camCtx.fillStyle = '#38bdf8';
    camCtx.font = '10px monospace';
    camCtx.textAlign = 'left';
    camCtx.fillText(`OVERHEAD CAMERA (ROI) • FABRIC WIDTH: 150cm`, 25, 20);
    camCtx.fillText(`GROUND SAMPLING: 0.32 mm/px`, 25, 34);
  }

  function drawDefectMap() {
    if (!mapCtx) return;
    const w = mapCanvas.width;
    const h = mapCanvas.height;

    // Clear
    mapCtx.fillStyle = '#090d16';
    mapCtx.fillRect(0, 0, w, h);

    // Roll representation (horizontal length from 0 to max(fabricY + 5, 20) meters)
    const maxM = Math.max(fabricY + 5, 20);
    const paddingX = 40;
    const paddingY = 30;
    const mapW = w - paddingX * 2;
    const mapH = h - paddingY * 2;

    // Draw roll boundary box
    mapCtx.strokeStyle = '#334155';
    mapCtx.lineWidth = 1.5;
    mapCtx.strokeRect(paddingX, paddingY, mapW, mapH);

    // Grid lines for meters
    mapCtx.fillStyle = '#64748b';
    mapCtx.font = '9px monospace';
    mapCtx.textAlign = 'center';
    const meterStep = maxM > 50 ? 10 : 5;
    for (let m = 0; m <= maxM; m += meterStep) {
      const xPos = paddingX + (m / maxM) * mapW;
      mapCtx.strokeStyle = 'rgba(51, 65, 85, 0.4)';
      mapCtx.beginPath();
      mapCtx.moveTo(xPos, paddingY);
      mapCtx.lineTo(xPos, paddingY + mapH);
      mapCtx.stroke();
      mapCtx.fillText(`${m}m`, xPos, paddingY + mapH + 15);
    }

    // Inspected fabric fill
    const inspectedX = paddingX + (fabricY / maxM) * mapW;
    mapCtx.fillStyle = 'rgba(56, 189, 248, 0.12)';
    mapCtx.fillRect(paddingX, paddingY, inspectedX - paddingX, mapH);

    // Current inspection head line
    mapCtx.strokeStyle = '#38bdf8';
    mapCtx.lineWidth = 2;
    mapCtx.beginPath();
    mapCtx.moveTo(inspectedX, paddingY);
    mapCtx.lineTo(inspectedX, paddingY + mapH);
    mapCtx.stroke();

    // Draw uninspected spans (Amber/Red hashed bands)
    uninspectedSpans.forEach(span => {
      const sX = paddingX + (span.start / maxM) * mapW;
      const endM = span.end !== null ? span.end : fabricY;
      const eX = paddingX + (endM / maxM) * mapW;
      const spanW = Math.max(eX - sX, 2);

      mapCtx.fillStyle = 'rgba(239, 68, 68, 0.45)';
      mapCtx.fillRect(sX, paddingY, spanW, mapH);

      mapCtx.strokeStyle = '#ef4444';
      mapCtx.lineWidth = 1;
      mapCtx.strokeRect(sX, paddingY, spanW, mapH);

      mapCtx.fillStyle = '#fca5a5';
      mapCtx.font = 'bold 9px monospace';
      mapCtx.textAlign = 'center';
      mapCtx.fillText(`UNINSPECTED`, sX + spanW / 2, paddingY + mapH / 2);
    });

    // Draw plotted defect pins
    defects.forEach(d => {
      const dX = paddingX + (d.y_m / maxM) * mapW;
      const dY = paddingY + (d.x_cm / fabricWidthCm) * mapH;

      mapCtx.save();
      mapCtx.fillStyle = d.color;
      mapCtx.beginPath();
      mapCtx.arc(dX, dY, 5, 0, Math.PI * 2);
      mapCtx.fill();
      mapCtx.strokeStyle = '#ffffff';
      mapCtx.lineWidth = 1.5;
      mapCtx.stroke();
      mapCtx.restore();
    });

    // Legend
    mapCtx.fillStyle = '#38bdf8';
    mapCtx.font = '10px monospace';
    mapCtx.textAlign = 'left';
    mapCtx.fillText(`ROLL 2D DEFECT MAP (Length: 0 to ${maxM.toFixed(0)}m, Width: 150cm)`, paddingX, 18);
  }

  function simLoop(timestamp) {
    if (!lastTimestamp) lastTimestamp = timestamp;
    const deltaSec = (timestamp - lastTimestamp) / 1000;
    lastTimestamp = timestamp;

    if (simRunning) {
      // Distance moved in this frame
      const speedMPerSec = lineSpeedMPerMin / 60;
      const dY = speedMPerSec * deltaSec;
      fabricY += dY;

      // Rotary encoder pulse ticks
      const pulsesPerMeter = encoderPpr / rollerCircumferenceM;
      encoderTicks = Math.floor(fabricY * pulsesPerMeter);

      fabricWeaveOffset += dY * 150;

      // Update telemetry
      if (telemPos) telemPos.textContent = `${fabricY.toFixed(2)} m`;
      if (telemPulses) telemPulses.textContent = `${encoderTicks.toLocaleString()} ticks`;

      // Update active flaw positions
      for (let i = activeFlaws.length - 1; i >= 0; i--) {
        const flaw = activeFlaws[i];
        flaw.y += speedMPerSec * deltaSec * 140;

        // When defect leaves camera FOV, commit deduplicated record
        if (flaw.y > (camCanvas ? camCanvas.height : 260) + 30) {
          if (!cameraFailed && !opticalBlur) {
            const defectRecord = {
              id: defects.length + 1,
              type: flaw.type,
              confidence: flaw.confidence,
              points: flaw.points,
              x_cm: flaw.x_cm,
              y_m: flaw.y_m,
              color: flaw.color
            };
            defects.push(defectRecord);
            if (defectBadge) defectBadge.textContent = `${defects.length} Defects`;
            logAudit(`Defect finalized & deduplicated: [${flaw.type}] at X=${flaw.x_cm.toFixed(1)}cm, Y=${flaw.y_m.toFixed(2)}m (Penalty: ${flaw.points} pts)`, 'warn');
          }
          activeFlaws.splice(i, 1);
        }
      }

      // Handle ongoing uninspected section
      if (cameraFailed || opticalBlur) {
        if (uninspectedSpans.length > 0 && uninspectedSpans[uninspectedSpans.length - 1].end === null) {
          // Span is stretching
        }
      }

      calculateGrade();
    }

    drawCameraView();
    drawDefectMap();

    animId = requestAnimationFrame(simLoop);
  }

  function initSimulator() {
    if (!animId) {
      lastTimestamp = 0;
      animId = requestAnimationFrame(simLoop);
    }
  }

  // Button Listeners
  if (btnToggleRun) {
    btnToggleRun.addEventListener('click', () => {
      simRunning = !simRunning;
      if (simRunning) {
        btnToggleRun.textContent = '⏸ Pause Inspection';
        btnToggleRun.classList.remove('btn-primary');
        btnToggleRun.classList.add('btn-outline');
        logAudit(`Inspection started at ${lineSpeedMPerMin} m/min. Rotary encoder streaming.`, 'success');
      } else {
        btnToggleRun.textContent = '▶ Start Inspection';
        btnToggleRun.classList.remove('btn-outline');
        btnToggleRun.classList.add('btn-primary');
        logAudit(`Inspection paused at ${fabricY.toFixed(2)}m.`, 'info');
      }
    });
  }

  if (btnReset) {
    btnReset.addEventListener('click', () => {
      simRunning = false;
      fabricY = 0;
      encoderTicks = 0;
      defects.length = 0;
      activeFlaws.length = 0;
      uninspectedSpans.length = 0;
      cameraFailed = false;
      opticalBlur = false;
      uninspectedStartM = null;

      if (btnToggleRun) {
        btnToggleRun.textContent = '▶ Start Inspection';
        btnToggleRun.classList.remove('btn-outline');
        btnToggleRun.classList.add('btn-primary');
      }
      if (telemPos) telemPos.textContent = '0.00 m';
      if (telemPulses) telemPulses.textContent = '0 pulses';
      if (telemCam) {
        telemCam.textContent = 'ONLINE (60 FPS)';
        telemCam.style.color = '#4ade80';
      }
      if (telemGate) {
        telemGate.textContent = 'NOMINAL';
        telemGate.style.color = '#4ade80';
      }
      if (camBadge) {
        camBadge.textContent = 'OK';
        camBadge.className = 'badge badge-success';
      }
      if (defectBadge) defectBadge.textContent = '0 Defects';
      if (overlayUninspected) overlayUninspected.style.display = 'none';

      calculateGrade();
      logAudit('Roll reset. Ready for next batch session.', 'info');
    });
  }

  function injectFlaw(type, points, color) {
    if (!simRunning) {
      alert('Click "Start Inspection" first to run fabric movement!');
      return;
    }
    const canvasW = camCanvas ? camCanvas.width : 500;
    const xPixel = 40 + Math.random() * (canvasW - 80);
    const xCm = (xPixel / canvasW) * fabricWidthCm;

    activeFlaws.push({
      type: type,
      points: points,
      color: color,
      x: xPixel,
      y: 0,
      x_cm: xCm,
      y_m: fabricY,
      confidence: 0.85 + Math.random() * 0.12
    });

    logAudit(`AI Detected candidate: [${type}] at Y=${fabricY.toFixed(2)}m, X=${xCm.toFixed(1)}cm (Tracking...)`, 'info');
  }

  if (btnAddHole) {
    btnAddHole.addEventListener('click', () => injectFlaw('HOLE', 4, '#ef4444'));
  }
  if (btnAddStain) {
    btnAddStain.addEventListener('click', () => injectFlaw('STAIN', 2, '#f59e0b'));
  }
  if (btnAddOil) {
    btnAddOil.addEventListener('click', () => injectFlaw('OIL_SPOT', 3, '#a855f7'));
  }

  if (btnToggleCamFail) {
    btnToggleCamFail.addEventListener('click', () => {
      cameraFailed = !cameraFailed;
      if (cameraFailed) {
        btnToggleCamFail.textContent = '🔌 Reconnect Camera';
        btnToggleCamFail.style.background = '#15803d';
        btnToggleCamFail.style.color = '#bbf7d0';
        uninspectedStartM = fabricY;
        uninspectedSpans.push({ start: fabricY, end: null, reason: 'CAMERA_DISCONNECT' });

        if (telemCam) {
          telemCam.textContent = 'DISCONNECTED (0 FPS)';
          telemCam.style.color = '#ef4444';
        }
        if (telemGate) {
          telemGate.textContent = 'FAULT (UNINSPECTED)';
          telemGate.style.color = '#ef4444';
        }
        if (camBadge) {
          camBadge.textContent = 'DISCONNECTED';
          camBadge.className = 'badge badge-danger';
        }
        if (overlayUninspected) overlayUninspected.style.display = 'flex';

        logAudit(`🚨 CRITICAL INVARIANT: Camera disconnected at ${fabricY.toFixed(2)}m. Section logged as UNINSPECTED (NEVER defect-free)!`, 'danger');
      } else {
        btnToggleCamFail.textContent = '⚠️ Disconnect Camera';
        btnToggleCamFail.style.background = '#7f1d1d';
        btnToggleCamFail.style.color = '#fca5a5';

        if (uninspectedSpans.length > 0 && uninspectedSpans[uninspectedSpans.length - 1].end === null) {
          uninspectedSpans[uninspectedSpans.length - 1].end = fabricY;
          const spanLen = (fabricY - uninspectedSpans[uninspectedSpans.length - 1].start).toFixed(2);
          logAudit(`Camera restored at ${fabricY.toFixed(2)}m. Uninspected segment sealed: ${spanLen}m logged to SQLite outbox.`, 'warn');
        }

        if (telemCam) {
          telemCam.textContent = 'ONLINE (60 FPS)';
          telemCam.style.color = '#4ade80';
        }
        if (telemGate) {
          telemGate.textContent = 'NOMINAL';
          telemGate.style.color = '#4ade80';
        }
        if (camBadge) {
          camBadge.textContent = 'OK';
          camBadge.className = 'badge badge-success';
        }
        if (overlayUninspected) overlayUninspected.style.display = 'none';
      }
      calculateGrade();
    });
  }

  if (btnToggleBlur) {
    btnToggleBlur.addEventListener('click', () => {
      opticalBlur = !opticalBlur;
      if (opticalBlur) {
        btnToggleBlur.textContent = '🧼 Clean Lens';
        btnToggleBlur.style.background = '#15803d';
        btnToggleBlur.style.color = '#bbf7d0';
        uninspectedStartM = fabricY;
        uninspectedSpans.push({ start: fabricY, end: null, reason: 'OPTICAL_BLUR' });

        if (telemGate) {
          telemGate.textContent = 'BLUR_FAULT';
          telemGate.style.color = '#f59e0b';
        }
        logAudit(`⚠️ Reliability Alert: Laplacian focus variance below threshold at ${fabricY.toFixed(2)}m. Flagged as UNINSPECTED!`, 'warn');
      } else {
        btnToggleBlur.textContent = '🌫️ Optical Blur';
        btnToggleBlur.style.background = '#78350f';
        btnToggleBlur.style.color = '#fde68a';

        if (uninspectedSpans.length > 0 && uninspectedSpans[uninspectedSpans.length - 1].end === null) {
          uninspectedSpans[uninspectedSpans.length - 1].end = fabricY;
          logAudit(`Lens blur cleared at ${fabricY.toFixed(2)}m. Inspection nominal.`, 'success');
        }
        if (telemGate) {
          telemGate.textContent = 'NOMINAL';
          telemGate.style.color = '#4ade80';
        }
      }
      calculateGrade();
    });
  }

  // Auto-init on page load if simulator tab is already visible
  const activeTab = document.querySelector('.tab-btn.active');
  if (activeTab && activeTab.getAttribute('data-tab') === 'tab-simulator') {
    initSimulator();
  }
});

"""
Update docs/srds_pdf_template.html with clean, professional black-and-white Visio & UML diagrams,
then render the final publication-grade TexEye_AI_SRDS_COMSATS.pdf via Microsoft Edge headless,
and also build a matching TexEye_AI_SRDS_COMSATS.docx in Microsoft Word format.
"""

import os, re, subprocess, shutil

HTML_PATH = os.path.abspath(r"docs\srds_pdf_template.html")
PDF_PATH = os.path.abspath(r"docs\TexEye_AI_SRDS_COMSATS.pdf")
EDGE_EXE = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
ONEDRIVE_DIR = r"C:\Users\User\OneDrive\TexEye_AI_Visio_Diagrams"

def update_html():
    with open(HTML_PATH, 'r', encoding='utf-8') as f:
        html = f.read()

    pages = html.split('<div class="page"')
    print(f"Total pages before update: {len(pages) - 1}")

    # Page 6: Figure 2.1 System block diagram
    # Replace ../diagrams/svg/01_system_workflow.svg with ../diagrams/visio/png/01_overall_system_workflow.png
    p6 = pages[6]
    p6_new = re.sub(
        r'<img class="diagram-img" src="[^"]+" alt="System block diagram of TexEye AI"[^>]*>',
        r'<img class="diagram-img" src="../diagrams/visio/png/01_overall_system_workflow.png" alt="System block diagram of TexEye AI" style="max-height: 140mm; max-width: 100%; object-fit: contain;" />',
        p6
    )
    pages[6] = p6_new

    # Page 11: Figure 3.1 Use case diagram
    # Replace ../diagrams/svg/06_use_case_overall.svg with clean Visio ../diagrams/visio/png/07_module_wise_use_cases.png
    p11 = pages[11]
    p11_new = re.sub(
        r'<img class="diagram-img" src="[^"]+" alt="Use case diagram of TexEye AI"[^>]*>',
        r'<img class="diagram-img" src="../diagrams/visio/png/07_module_wise_use_cases.png" alt="Use case diagram of TexEye AI" style="max-height: 140mm; max-width: 100%; object-fit: contain;" />',
        p11
    )
    pages[11] = p11_new

    # Page 19: Figure 4.1 Hardware Architecture Diagram
    p19 = pages[19]
    p19_new = re.sub(
        r'<img class="diagram-img" src="[^"]+" alt="Hardware Architecture Diagram"[^>]*>',
        r'<img class="diagram-img" src="../diagrams/png/04_hardware_architecture.png" alt="Hardware Architecture Diagram" style="max-height: 140mm; max-width: 100%; object-fit: contain;" />',
        p19
    )
    pages[19] = p19_new

    # Page 22: Figure 5.1 & 5.2 (Composite Viewpoint: Package & Deployment)
    p22 = pages[22]
    comp_block = '''<div style="display: flex; gap: 4mm; margin-bottom: 2.5mm;">
            <!-- Subsystem Decomposition -->
            <div style="flex: 1; border: 1px solid #000; padding: 2mm; background: #ffffff; text-align: center;">
              <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1.5mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
                Figure 5.1: Subsystem Package Decomposition
              </div>
              <img src="../diagrams/png/10_component_diagram.png" alt="Package and Component Diagram" style="width: 100%; max-height: 135px; object-fit: contain;" />
            </div>

            <!-- Deployment Diagram -->
            <div style="flex: 1; border: 1px solid #000; padding: 2mm; background: #ffffff; text-align: center;">
              <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1.5mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
                Figure 5.2: Physical Deployment Nodes
              </div>
              <img src="../diagrams/png/11_deployment_diagram.png" alt="Physical Deployment Diagram" style="width: 100%; max-height: 135px; object-fit: contain;" />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  '''
    p22_new = re.sub(
        r'<div style="display: flex; gap: 4mm; margin-bottom: 2\.5mm;">.*',
        comp_block,
        p22,
        flags=re.DOTALL
    )
    pages[22] = p22_new

    # Page 23: Figure 5.3 Domain Class Model Diagram
    p23 = pages[23]
    class_block = '''<div style="border: 1px solid #000; padding: 2.5mm; margin-bottom: 3mm; background: #ffffff; text-align: center;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 2mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.3: Domain Class Model Diagram
            </div>
            <img src="../diagrams/modules/png/06_texeye_ai_class_diagram.png" alt="Domain Class Model Diagram" style="width: 100%; max-height: 205px; object-fit: contain;" />
          </div>'''
    p23_new = re.sub(
        r'<div style="border: 1px solid #000; padding: 2\.5mm; margin-bottom: 3mm; background: #ffffff;">\s*<div[^>]*>\s*Figure 5\.3: Domain Class Model Diagram\s*</div>\s*<svg.*?</svg>\s*</div>',
        class_block,
        p23,
        flags=re.DOTALL
    )
    pages[23] = p23_new

    # Page 24: Figure 5.4 Relational ERD
    p24 = pages[24]
    erd_block = '''<div style="border: 1px solid #000; padding: 2.5mm; margin-bottom: 3mm; background: #ffffff; text-align: center;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 2mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.4: Relational Entity-Relationship Diagram (ERD)
            </div>
            <img src="../diagrams/png/14_entity_relationship_diagram.png" alt="Relational ERD" style="width: 100%; max-height: 205px; object-fit: contain;" />
          </div>'''
    p24_new = re.sub(
        r'<div style="border: 1px solid #000; padding: 2\.5mm; margin-bottom: 3mm; background: #ffffff;">\s*<div[^>]*>\s*Figure 5\.4: Relational Entity-Relationship Diagram \(ERD\)\s*</div>\s*<svg.*?</svg>\s*</div>',
        erd_block,
        p24,
        flags=re.DOTALL
    )
    pages[24] = p24_new

    # Page 25: Figure 5.5 & 5.6 (Sequence Diagrams: Real-Time Detection & Invariant Gating)
    p25 = pages[25]
    seq_25_block = '''<div style="border: 1px solid #000; padding: 1.5mm; margin-bottom: 2mm; background: #ffffff; text-align: center;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1mm; border-bottom: 1px solid #ccc; padding-bottom: 0.5mm;">
              Figure 5.5: Sequence Diagram: Real-Time Inspection &amp; Defect Detection
            </div>
            <img src="../diagrams/visio/png/01_module_1_ai_detection_sequence.png" alt="Real-Time Detection Sequence" style="width: 100%; max-height: 135px; object-fit: contain;" />
          </div>

          <div style="border: 1px solid #000; padding: 1.5mm; margin-bottom: 2mm; background: #ffffff; text-align: center;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1mm; border-bottom: 1px solid #ccc; padding-bottom: 0.5mm;">
              Figure 5.6: Sequence Diagram: Inspection Reliability &amp; Hardware Invariant Gating
            </div>
            <img src="../diagrams/visio/png/02_module_2_hardware_monitoring_sequence.png" alt="Reliability Gating Sequence" style="width: 100%; max-height: 132px; object-fit: contain;" />
          </div>'''
    
    p25_new = re.sub(
        r'<div style="border: 1px solid #000; padding: 2mm; margin-bottom: 3mm; background: #ffffff;">\s*<div[^>]*>\s*Figure 5\.5:.*?</div>\s*<svg.*?</svg>\s*</div>\s*<div style="border: 1px solid #000; padding: 2mm; margin-bottom: 3mm; background: #ffffff;">\s*<div[^>]*>\s*Figure 5\.6:.*?</div>\s*<svg.*?</svg>\s*</div>',
        seq_25_block,
        p25,
        flags=re.DOTALL
    )
    pages[25] = p25_new

    # Page 26: Figure 5.7 & 5.8 (Sequence Diagrams: Offline Buffering & Central Review)
    p26 = pages[26]
    seq_26_block = '''<div style="border: 1px solid #000; padding: 1.5mm; margin-bottom: 2mm; background: #ffffff; text-align: center;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1mm; border-bottom: 1px solid #ccc; padding-bottom: 0.5mm;">
              Figure 5.7: Sequence Diagram: Offline Buffering &amp; Outbox Synchronization
            </div>
            <img src="../diagrams/visio/png/03_module_3_mobile_app_sequence.png" alt="Offline Buffering Sequence" style="width: 100%; max-height: 135px; object-fit: contain;" />
          </div>

          <div style="border: 1px solid #000; padding: 1.5mm; margin-bottom: 2mm; background: #ffffff; text-align: center;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1mm; border-bottom: 1px solid #ccc; padding-bottom: 0.5mm;">
              Figure 5.8: Sequence Diagram: Central Review &amp; ASTM 4-Point Grading Finalization
            </div>
            <img src="../diagrams/visio/png/04_module_4_web_quality_map_sequence.png" alt="Central Review Sequence" style="width: 100%; max-height: 130px; object-fit: contain;" />
          </div>'''
    p26_new = re.sub(
        r'<div style="border: 1px solid #000; padding: 2mm; margin-bottom: 3mm; background: #ffffff;">\s*<div[^>]*>\s*Figure 5\.7:.*?</div>\s*<svg.*?</svg>\s*</div>\s*<div style="border: 1px solid #000; padding: 2mm; margin-bottom: 3mm; background: #ffffff;">\s*<div[^>]*>\s*Figure 5\.8:.*?</div>\s*<svg.*?</svg>\s*</div>',
        seq_26_block,
        p26,
        flags=re.DOTALL
    )
    pages[26] = p26_new

    # Page 27: Figure 5.9 (Sequence Diagram: PDF Quality Export)
    p27 = pages[27]
    seq_27_block = '''<div style="border: 1px solid #000; padding: 1.5mm; margin-bottom: 2.5mm; background: #ffffff; text-align: center;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1mm; border-bottom: 1px solid #ccc; padding-bottom: 0.5mm;">
              Figure 5.9: Sequence Diagram: Production Inspection PDF Export
            </div>
            <img src="../diagrams/visio/png/05_module_5_smart_operations_astm_sequence.png" alt="PDF Export Sequence" style="width: 100%; max-height: 125px; object-fit: contain;" />
          </div>'''
    p27_new = re.sub(
        r'<div style="border: 1px solid #000; padding: 2mm; margin-bottom: 3mm; background: #ffffff;">\s*<div[^>]*>\s*Figure 5\.9:.*?</div>\s*<svg.*?</svg>\s*</div>',
        seq_27_block,
        p27,
        flags=re.DOTALL
    )
    pages[27] = p27_new

    # Page 28: Figure 5.10 & 5.11 (State Machine Diagrams)
    p28 = pages[28]
    fsm_block = '''<div style="border: 1px solid #000; padding: 2mm; margin-bottom: 3mm; background: #ffffff; text-align: center;">
            <div style="font-weight: bold; font-size: 8.5pt; text-align: center; margin-bottom: 1.5mm; border-bottom: 1px solid #ccc; padding-bottom: 1mm;">
              Figure 5.10: State Machine Diagram: Roll Inspection Run FSM &amp; Offline Sync Outbox FSM
            </div>
            <img src="../diagrams/modules/png/08_roll_inspection_fsm.png" alt="Roll Inspection FSM" style="width: 100%; max-height: 220px; object-fit: contain;" />
          </div>'''
    p28_new = re.sub(
        r'<div style="border: 1px solid #000; padding: 2\.5mm; margin-bottom: 3mm; background: #ffffff;">\s*<div[^>]*>\s*Figure 5\.10:.*?</div>\s*<svg.*?</svg>\s*</div>\s*<div style="border: 1px solid #000; padding: 2mm; margin-bottom: 3mm; background: #ffffff;">\s*<div[^>]*>\s*Figure 5\.11:.*?</div>\s*<svg.*?</svg>\s*</div>',
        fsm_block,
        p28,
        flags=re.DOTALL
    )
    pages[28] = p28_new

    # Reassemble HTML
    new_html = '<div class="page"'.join(pages)
    with open(HTML_PATH, 'w', encoding='utf-8') as f:
        f.write(new_html)
    print("Successfully updated docs/srds_pdf_template.html with clean diagrams and perfect div balance!")

def render_pdf():
    print(f"Rendering {PDF_PATH} via Microsoft Edge headless...")
    cmd = [
        EDGE_EXE,
        '--headless',
        '--disable-gpu',
        '--run-all-compositor-stages-before-draw',
        f'--print-to-pdf={PDF_PATH}',
        '--no-pdf-header-footer',
        HTML_PATH
    ]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode == 0 and os.path.exists(PDF_PATH):
        print(f"SUCCESS: Rendered {PDF_PATH} ({os.path.getsize(PDF_PATH):,} bytes)")
        if os.path.exists(ONEDRIVE_DIR):
            try:
                shutil.copy2(PDF_PATH, os.path.join(ONEDRIVE_DIR, "TexEye_AI_SRDS_COMSATS.pdf"))
                print(f"Mirrored to OneDrive: {ONEDRIVE_DIR}\\TexEye_AI_SRDS_COMSATS.pdf")
            except Exception as e:
                print(f"OneDrive mirror error: {e}")
    else:
        print(f"ERROR: Edge rendering failed. Stderr: {res.stderr}")

if __name__ == "__main__":
    update_html()
    render_pdf()

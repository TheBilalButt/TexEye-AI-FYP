import os, shutil, subprocess
from PIL import Image

BASE_DIR = os.path.abspath(r"C:\Users\User\Desktop\FYP")
DOCS_DIR = os.path.join(BASE_DIR, "docs")
VISIO_PNG_DIR = os.path.join(BASE_DIR, "diagrams", "visio", "png")
BW_DIR = os.path.join(BASE_DIR, "diagrams", "srds_bw")
ONEDRIVE_DIR = r"C:\Users\User\OneDrive\TexEye_AI_Visio_Diagrams"

src_png = os.path.join(DOCS_DIR, "TexEye_AI_System_Workflow.png")
src_pdf = os.path.join(DOCS_DIR, "TexEye_AI_Workflow_Diagram_Landscape.pdf")

print("1. Syncing exact 4-tier workflow diagram image across all targets...")

# Color PNG copies
shutil.copy2(src_png, os.path.join(DOCS_DIR, "supervisor_paper_workflow.png"))
shutil.copy2(src_png, os.path.join(VISIO_PNG_DIR, "00_rough_workflow_paper.png"))
shutil.copy2(src_png, os.path.join(VISIO_PNG_DIR, "01_overall_system_workflow.png"))
shutil.copy2(src_png, os.path.join(VISIO_PNG_DIR, "01_system_workflow.png"))

# PDF copy
if os.path.exists(src_pdf):
    shutil.copy2(src_pdf, os.path.join(DOCS_DIR, "TexEye_AI_Supervisor_Paper_Workflow.pdf"))

# Pure High-Contrast Monochrome copies for SRDS
im = Image.open(src_png).convert("L")
im.save(os.path.join(BW_DIR, "00_rough_workflow_paper.png"))
im.save(os.path.join(BW_DIR, "01_overall_system_workflow.png"))
im.save(os.path.join(BW_DIR, "01_system_workflow.png"))

print("2. Monochrome B&W workflow images saved to diagrams/srds_bw/.")

# OneDrive mirror
if os.path.exists(ONEDRIVE_DIR):
    shutil.copy2(src_png, os.path.join(ONEDRIVE_DIR, "supervisor_paper_workflow.png"))
    shutil.copy2(src_png, os.path.join(ONEDRIVE_DIR, "00_rough_workflow_paper.png"))
    shutil.copy2(src_png, os.path.join(ONEDRIVE_DIR, "01_overall_system_workflow.png"))
    if os.path.exists(src_pdf):
        shutil.copy2(src_pdf, os.path.join(ONEDRIVE_DIR, "TexEye_AI_Supervisor_Paper_Workflow.pdf"))
    print("3. Mirrored to OneDrive.")

print("Done syncing workflow diagram!")

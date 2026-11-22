import os, subprocess
from PIL import Image

edge_exe = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
svg_path = os.path.abspath(r"docs\TexEye_AI_System_Workflow.svg")
html_path = os.path.abspath(r"docs\render_workflow_temp.html")
png_out = os.path.abspath(r"docs\supervisor_paper_workflow.png")
pdf_out = os.path.abspath(r"docs\TexEye_AI_Supervisor_Paper_Workflow.pdf")

html_content = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  @page {{ size: 1320px 860px; margin: 0; }}
  body {{ margin: 0; padding: 0; background: #ffffff; overflow: hidden; }}
  img {{ width: 1320px; height: 860px; display: block; }}
</style>
</head>
<body>
<img src="{svg_path.replace(os.sep, '/')}" />
</body>
</html>
"""

with open(html_path, "w", encoding="utf-8") as f:
    f.write(html_content)

# Render PNG via Edge headless screenshot
cmd_png = [
    edge_exe,
    "--headless",
    "--disable-gpu",
    "--run-all-compositor-stages-before-draw",
    "--window-size=1320,860",
    f"--screenshot={png_out}",
    f"file:///{html_path.replace(os.sep, '/')}"
]
subprocess.run(cmd_png, check=True)

# Render PDF via Edge headless print
cmd_pdf = [
    edge_exe,
    "--headless",
    "--disable-gpu",
    "--run-all-compositor-stages-before-draw",
    "--no-pdf-header-footer",
    f"--print-to-pdf={pdf_out}",
    f"file:///{html_path.replace(os.sep, '/')}"
]
subprocess.run(cmd_pdf, check=True)

if os.path.exists(html_path):
    os.remove(html_path)

print(f"Rendered PNG: {png_out} ({os.path.getsize(png_out):,} bytes)")
print(f"Rendered PDF: {pdf_out} ({os.path.getsize(pdf_out):,} bytes)")

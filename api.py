from fastapi import FastAPI, UploadFile, File
import subprocess
import uuid
import os

app = FastAPI()

BASE_DIR = "/data"
INPUT_DIR = f"{BASE_DIR}/input"
OUTPUT_DIR = f"{BASE_DIR}/output"

AUDIVERIS_BIN = "/audiveris/app/build/install/app/bin/app"

os.makedirs(INPUT_DIR, exist_ok=True)
os.makedirs(OUTPUT_DIR, exist_ok=True)


@app.post("/omr")
async def run_omr(file: UploadFile = File(...)):
    job_id = str(uuid.uuid4())
    input_pdf = f"{INPUT_DIR}/{job_id}.pdf"
    output_dir = f"{OUTPUT_DIR}/{job_id}"

    os.makedirs(output_dir, exist_ok=True)

    with open(input_pdf, "wb") as f:
        f.write(await file.read())

cmd = [
    AUDIVERIS_BIN,
    "-batch",
    "-export",
    "-output", output_dir,
    input_pdf
]

    subprocess.run(cmd, check=True)

    # procurar MusicXML gerado
    for root, _, files in os.walk(output_dir):
        for file in files:
            if file.endswith(".musicxml") or file.endswith(".xml"):
                with open(os.path.join(root, file), "r", encoding="utf-8", errors="ignore") as f:
                    return {
                        "job_id": job_id,
                        "musicxml": f.read()
                    }

    return {"error": "MusicXML not found"}

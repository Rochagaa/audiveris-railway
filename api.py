from fastapi import FastAPI, UploadFile, File, HTTPException
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
    if not file.filename.lower().endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Envie um arquivo PDF")

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

    try:
        result = subprocess.run(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=True
        )
    except subprocess.CalledProcessError as e:
        return {
            "error": "Audiveris failed",
            "stdout": e.stdout,
            "stderr": e.stderr
        }

    for root, _, files in os.walk(output_dir):
        for filename in files:
            if filename.endswith(".musicxml") or filename.endswith(".xml"):
                with open(os.path.join(root, filename), "r", encoding="utf-8", errors="ignore") as f:
                    return {
                        "job_id": job_id,
                        "musicxml": f.read()
                    }

    return {
        "error": "MusicXML not generated",
        "stdout": result.stdout,
        "stderr": result.stderr
    }

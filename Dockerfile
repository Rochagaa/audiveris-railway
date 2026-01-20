FROM eclipse-temurin:25-jdk

# -----------------------------
# 1. Dependências do sistema
# -----------------------------
RUN apt-get update && apt-get install -y \
    git \
    ghostscript \
    imagemagick \
    tesseract-ocr \
    python3 \
    python3-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# 2. Instalar Audiveris
# -----------------------------
WORKDIR /audiveris

RUN git clone https://github.com/Audiveris/audiveris.git .

RUN ./gradlew installDist --no-daemon

# -----------------------------
# 3. Criar ambiente virtual Python
# -----------------------------
WORKDIR /app

RUN python3 -m venv /app/venv

ENV PATH="/app/venv/bin:$PATH"

# -----------------------------
# 4. Instalar API (FastAPI)
# -----------------------------
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY api.py .

# -----------------------------
# 5. Diretório de dados
# -----------------------------
WORKDIR /data

# -----------------------------
# 6. Expor porta da API
# -----------------------------
EXPOSE 8000

# -----------------------------
# 7. Subir a API automaticamente
# -----------------------------
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]

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
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# 2. Instalar Audiveris
# -----------------------------
WORKDIR /audiveris

RUN git clone https://github.com/Audiveris/audiveris.git .

RUN ./gradlew installDist --no-daemon

# -----------------------------
# 3. Instalar API (FastAPI)
# -----------------------------
WORKDIR /app

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

COPY api.py .

# -----------------------------
# 4. Diretório de dados
# -----------------------------
WORKDIR /data

# -----------------------------
# 5. Expor porta da API
# -----------------------------
EXPOSE 8000

# -----------------------------
# 6. Subir a API automaticamente
# -----------------------------
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]

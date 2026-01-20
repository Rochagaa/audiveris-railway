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

# IMPORTANTE: garantir build do módulo app
RUN ./gradlew :app:installDist --no-daemon

# -----------------------------
# 3. Criar launcher fixo
# -----------------------------
RUN chmod +x /audiveris/app/build/install/app/bin/app && \
    ln -s /audiveris/app/build/install/app/bin/app /usr/local/bin/audiveris

# -----------------------------
# 4. Criar ambiente Python
# -----------------------------
WORKDIR /app

RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY api.py .

# -----------------------------
# 5. Diretório de dados
# -----------------------------
WORKDIR /data

EXPOSE 8000

# -----------------------------
# 6. Subir API
# -----------------------------
WORKDIR /app
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]

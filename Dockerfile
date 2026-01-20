FROM eclipse-temurin:17-jdk

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    ghostscript \
    imagemagick \
    tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*

# Diretório de trabalho
WORKDIR /audiveris

# Clonar Audiveris
RUN git clone https://github.com/Audiveris/audiveris.git .

# Build do Audiveris Console
RUN ./gradlew installDist --no-daemon

# Diretório de dados
WORKDIR /data

# Mantém o container ativo
CMD ["tail", "-f", "/dev/null"]

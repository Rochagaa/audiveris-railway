FROM eclipse-temurin:17-jdk

# Dependências do sistema para OMR
RUN apt-get update && apt-get install -y \
    wget \
    ghostscript \
    imagemagick \
    tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*

# Diretório de trabalho
WORKDIR /audiveris

# Baixar Audiveris oficial via Maven Central (ESTÁVEL)
RUN wget https://repo1.maven.org/maven2/org/audiveris/audiveris-console/5.3.1/audiveris-console-5.3.1.jar

# Script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

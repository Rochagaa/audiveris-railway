FROM eclipse-temurin:17-jdk

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ghostscript \
    imagemagick \
    tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*

# Criar diretório do Audiveris
WORKDIR /audiveris

# Baixar Audiveris
RUN wget https://github.com/Audiveris/audiveris/releases/download/5.4.3/Audiveris-5.4.3-bin.zip \
    && unzip Audiveris-5.4.3-bin.zip \
    && rm Audiveris-5.4.3-bin.zip

# Copiar script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]

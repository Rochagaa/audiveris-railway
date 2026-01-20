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
RUN apt-get update && apt-get install -y curl \
    && curl -L https://github.com/Audiveris/audiveris/releases/latest/download/Audiveris-bin.zip -o audiveris.zip \
    && unzip audiveris.zip \
    && rm audiveris.zip

# Copiar script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]

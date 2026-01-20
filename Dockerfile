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

# Baixar e extrair Audiveris (formato tar.gz)
RUN apt-get update && apt-get install -y curl tar \
    && curl -L https://github.com/Audiveris/audiveris/releases/latest/download/Audiveris.tar.gz -o audiveris.tar.gz \
    && tar -xzf audiveris.tar.gz \
    && rm audiveris.tar.gz

# Copiar script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]

FROM python:3.11-slim

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    wget gnupg ca-certificates curl unzip fonts-liberation libnss3 libxss1 libasound2 libxshmfence1 \
    libgtk-3-0 libgbm1 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 libxext6 libxfixes3 libxrender1 libxtst6 libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

# Instala Playwright
RUN pip install --no-cache-dir playwright
RUN playwright install chromium

# Copia el código
WORKDIR /app
COPY . .

# Instala las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 10000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]

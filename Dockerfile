# Base image
FROM mcr.microsoft.com/playwright/python:v1.43.1-jammy

# Set working directory
WORKDIR /app

# Copia los archivos del repo al contenedor
COPY . .

# Instala las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Expone el puerto que usará FastAPI
EXPOSE 10000

# Ejecuta el servidor
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]

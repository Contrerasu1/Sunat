# Imagen base oficial de Playwright con navegador ya instalado
FROM mcr.microsoft.com/playwright/python:v1.43.1-jammy

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Validar instalación de browsers
RUN playwright install --with-deps && \
    ls /ms-playwright && \
    ls /ms-playwright/chromium-*

# Exponer puerto para FastAPI
EXPOSE 10000

# Comando para ejecutar la app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]

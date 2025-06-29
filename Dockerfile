FROM mcr.microsoft.com/playwright/python:v1.43.1-jammy

WORKDIR /app

COPY . .

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

RUN pip install --no-cache-dir -r requirements.txt

# Si quieres garantizar instalación manual (opcional)
RUN playwright install chromium

EXPOSE 10000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]

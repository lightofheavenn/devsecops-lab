FROM python:3.11-slim

WORKDIR /app

RUN useradd -m appuser

COPY app/ /app/
RUN pip install --no-cache-dir -r requirements.txt

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD curl -f http://localhost:8080/ || exit 1

USER appuser

EXPOSE 8080
CMD ["python", "app.py"]

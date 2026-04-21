# -------------------------------------------
# BUILD STAGE
# -------------------------------------------
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirments.txt .
RUN pip install --no-cache-dir -r requirements.txt

# -------------------------------------------
# PRODUCTION STAGE
# -------------------------------------------
FROM python:3.11-slim

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin/gunicorn /usr/local/bin/gunicorn

# Copy app code
COPY . .

# Expose port
EXPOSE 8000

# Run with gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "app:create_app()"]
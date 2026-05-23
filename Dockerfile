# Minimal secure base image
FROM python:3.12-slim

# Prevent Python from writing pyc files
ENV PYTHONDONTWRITEBYTECODE=1

# Prevent Python buffering
ENV PYTHONUNBUFFERED=1

# Create app user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Set working directory
WORKDIR /app

# Install dependencies first (better layer caching)
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Change ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 5000

# Start app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
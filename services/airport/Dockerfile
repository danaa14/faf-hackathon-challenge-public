FROM python:3.12-slim

WORKDIR /app

# Install system dependencies needed for pip packages
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

EXPOSE 3001

# Run with gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:3001", "--workers", "1", "--threads", "8", "app:app"]

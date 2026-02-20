# STAGE 1: The Builder (The "Workshop")
FROM python:3.12-slim AS builder

WORKDIR /app

# Install build tools needed ONLY for compiling mysqlclient
RUN apt-get update && apt-get install -y \
    python3-dev \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Install dependencies to a specific folder (/install)
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# STAGE 2: The Final Image (The "Shipping Box")
FROM python:3.12-slim

WORKDIR /app

# 1. Copy the compiled libraries from the builder stage
COPY --from=builder /install /usr/local

# 2. Copy the MySQL runtime library (needed for the app to run)
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Copy your application code
COPY . .

EXPOSE 5000

CMD ["python", "app.py"]

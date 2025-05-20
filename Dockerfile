# Stage 1: Build wheels
FROM python:3.11-slim AS builder

WORKDIR /wheels

RUN apt-get update && apt-get install -y build-essential && \
    pip install --upgrade pip && \
    apt-get clean

COPY requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir --no-index --find-links=/wheels -r /wheels/requirements.txt

COPY . .

CMD ["python", "tex_orchestrator.py"]
# === base ===
FROM python:3.13-slim AS base

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
        ffmpeg \
        libavdevice-dev \
        libavfilter-dev \
        libopus-dev \
        libvpx-dev \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN pip install uv
COPY pyproject.toml .

# === dev ===
FROM base AS dev

# installs prod + dev (pytest, debugpy, ruff, playwright)
RUN uv sync

# dependencies for playwright
RUN apt-get update && apt-get install -y \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcups2 \
        libdrm2 \
        libxkbcommon0 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxrandr2 \
        libgbm1 \
        libasound2 \
    && rm -rf /var/lib/apt/lists/*

# installs playwright
RUN uv run playwright install chromium

COPY . .

# === prod ===
FROM base AS prod

RUN uv sync --no-dev
COPY . .
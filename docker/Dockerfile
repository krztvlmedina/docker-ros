# syntax=docker/dockerfile:1.7-labs

# -----------------------------
# Stage 1: System deps + spconv clone (cached)
# -----------------------------
FROM python:3.8-slim-bookworm as spconv-source
COPY --from=ghcr.io/astral-sh/uv:0.8.4 /uv /uvx /bin/

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git build-essential cmake

# Clone spconv with persistent cache
RUN --mount=type=cache,target=/tmp/spconv-cache \
    if [ ! -d /tmp/spconv-cache/.git ]; then \
        echo "Cloning spconv repository..." && \
        git clone --recursive https://github.com/traveller59/spconv.git /tmp/spconv-cache && \
        cd /tmp/spconv-cache && \
        git checkout fad3000249d27ca918f2655ff73c41f39b0f3127 && \
        git submodule update --recursive; \
    else \
        echo "Using cached spconv repository."; \
    fi

# Copy to /spconv for build stage
RUN cp -a /tmp/spconv-cache /spconv


# -----------------------------
# Stage 2: Build spconv + install Python deps
# -----------------------------
FROM python:3.8-slim-bookworm as spconvbuilder
COPY --from=ghcr.io/astral-sh/uv:0.8.4 /uv /uvx /bin/

WORKDIR /src

# Install same system deps as clone stage for build
RUN apt-get update && \
    apt-get install -y build-essential cmake

# Python version
RUN uv python install 3.8.6

# Copy your project requirements early for caching
COPY src/requirements.txt .
COPY src/pyproject.toml .
RUN touch README.md
RUN uv venv

# Build spconv wheel
COPY --from=spconv-source /spconv /spconv
WORKDIR /spconv
RUN --mount=type=cache,target=/root/.cache/uv \
    uv --verbose sync --no-editable --no-install-project
RUN --mount=type=cache,target=/root/.cache/uv \
    uv run check_torch.py
RUN --mount=type=cache,target=/root/.cache/uv \
    uv run setup.py bdist_wheel


# -----------------------------
# Stage 3: Final app image
# -----------------------------
FROM python:3.8-slim-bookworm
COPY --from=ghcr.io/astral-sh/uv:0.8.4 /uv /uvx /bin/
RUN uv python install 3.8.6
RUN uv lock

# Install spconv wheel
COPY --from=spconvbuilder /spconv/dist/ /dist
WORKDIR /dist
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install -e .

# Install app dependencies
WORKDIR /app
COPY src/requirements.txt .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install -r requirements.txt

COPY src/pyproject.toml .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install -r pyproject.toml

# Copy source code last to maximize cache
COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install -e .

# Set PYTHONPATH for second.pytorch
ENV PYTHONPATH="${PYTHONPATH}:/app/second/second"

# Final sync to ensure lock matches
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked


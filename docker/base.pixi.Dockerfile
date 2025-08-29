# syntax=docker/dockerfile:1.7-labs
FROM ghcr.io/prefix-dev/pixi:0.53.0 AS build-spconv
COPY src/conda-environment.yml .
# COPY pixi.toml .
# COPY src/pyproject.toml .
# COPY src/check_torch.py .
COPY external/spconv /spconv
COPY spconv.pixi.toml /spconv/pixi.toml



RUN curl -fsSL https://pixi.sh/install.sh | sh
WORKDIR /spconv
RUN pixi install -vv

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
RUN pixi run check_cuda
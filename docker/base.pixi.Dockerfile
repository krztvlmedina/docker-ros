# syntax=docker/dockerfile:1.7-labs
FROM nvidia/cuda:11.0.3-base-ubuntu20.04 AS build-spconv
COPY src/conda-environment.yml .
# COPY pixi.toml .
# COPY src/pyproject.toml .
# COPY src/check_torch.py .
COPY external/spconv_121 /spconv
COPY .pixi/spconv.pixi.toml /spconv/pixi.toml
RUN apt-get update -y && apt-get install curl -y
RUN apt-get install linux-headers-$(uname -r) -y 
WORKDIR /spconv
RUN bash -c "set -euo pipefail; curl -fsSL https://pixi.sh/install.sh -o install.sh; bash install.sh"
ENV PATH="/root/.pixi/bin:${PATH}"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
RUN pixi install -vv && pixi run check_cuda
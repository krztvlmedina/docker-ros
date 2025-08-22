# syntax=docker/dockerfile:1.7-labs
FROM ghcr.io/prefix-dev/pixi:0.53.0 AS build-spconv
COPY src/conda-environment.yml .
COPY pixi.toml .
COPY src/pyproject.toml .
COPY src/check_torch.py .
COPY external/spconv /spconv

ENV NVIDIA_VISIBLE_DEVICES: all
ENV NVIDIA_DRIVER_CAPABILITIES: all

RUN curl -fsSL https://pixi.sh/install.sh | sh
RUN pixi init spconv-builder && pixi install -vv 
RUN apt-get update -y && apt-get dist-upgrade -y \
	&& apt-get install libboost-all-dev -y \
	&& apt-get install -y git build-essential libxml2
WORKDIR /spconv
RUN pixi run check_cuda

# Build spconv wheel
ENV CONDA_OVERRIDE_CUDA=11.8

# Set CUDA environment variables to help cmake find CUDA
ENV CUDA_HOME=/.pixi/envs/spconv
ENV CUDA_ROOT=/.pixi/envs/spconv
ENV CUDA_TOOLKIT_ROOT_DIR=/.pixi/envs/spconv
ENV CUDACXX=/.pixi/envs/spconv/bin/nvcc
ENV CUDA_NVCC_EXECUTABLE=/.pixi/envs/spconv/bin/nvcc

# Add CUDA include path to help nvcc find headers
ENV CPATH=/.pixi/envs/spconv/include:$CPATH
ENV C_INCLUDE_PATH=/.pixi/envs/spconv/include:$C_INCLUDE_PATH
ENV CPLUS_INCLUDE_PATH=/.pixi/envs/spconv/include:$CPLUS_INCLUDE_PATH

# Ensure cmake can find CUDA
RUN pixi run --environment spconv cmake \
  -DCUDA_TOOLKIT_ROOT_DIR=/.pixi/envs/spconv \
  -DCMAKE_PREFIX_PATH="/.pixi/envs/spconv;/.pixi/envs/spconv/lib/python3.8/site-packages/torch" \
  -DCUDA_NVCC_EXECUTABLE=/.pixi/envs/spconv/bin/nvcc \
  -DCUDA_INCLUDE_DIRS=/.pixi/envs/spconv/include \
  -DCUDA_CUDART_LIBRARY=/.pixi/envs/spconv/lib/libcudart.so \
  -DPYBIND11_PYTHON_VERSION=3.8 \
  -DSPCONV_BuildTests=OFF \
  -DPYTORCH_VERSION=11301 \
  -DCMAKE_BUILD_TYPE=Release \
  /spconv

RUN export PATH=/usr/bin/cmake:$PATH && pixi run --environment spconv python setup.py bdist_wheel && pixi install -e pifenet
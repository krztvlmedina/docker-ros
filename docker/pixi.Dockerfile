# syntax=docker/dockerfile:1.7-labs
FROM spconv:latest as built-spconv
# RUN apt-get update -y && apt-get dist-upgrade -y \
# 	&& apt-get install libboost-all-dev -y \
# 	&& apt-get install -y git build-essential libxml2

# # Build spconv wheel
# ENV CONDA_OVERRIDE_CUDA=11.8

# # Set CUDA environment variables to help cmake find CUDA
# ENV CUDA_HOME=/.pixi/envs/default
# ENV CUDA_ROOT=/.pixi/envs/default
# ENV CUDA_TOOLKIT_ROOT_DIR=/.pixi/envs/default
# ENV CUDACXX=/.pixi/envs/default/bin/nvcc
# ENV CUDA_NVCC_EXECUTABLE=/.pixi/envs/default/bin/nvcc

# # Add CUDA include path to help nvcc find headers
# ENV CPATH=/.pixi/envs/default/include:$CPATH
# ENV C_INCLUDE_PATH=/.pixi/envs/default/include:$C_INCLUDE_PATH
# ENV CPLUS_INCLUDE_PATH=/.pixi/envs/default/include:$CPLUS_INCLUDE_PATH

# # Ensure cmake can find CUDA
# RUN pixi run --environment spconv cmake \
# -DCUDA_TOOLKIT_ROOT_DIR=/.pixi/envs/spconv \
# -DCMAKE_PREFIX_PATH="/.pixi/envs/spconv;/.pixi/envs/spconv/lib/python3.8/site-packages/torch" \
# -DCUDA_NVCC_EXECUTABLE=/.pixi/envs/spconv/bin/nvcc \
# -DCUDA_INCLUDE_DIRS=/.pixi/envs/spconv/include \
# -DCUDA_CUDART_LIBRARY=/.pixi/envs/spconv/lib/libcudart.so \
# -DPYBIND11_PYTHON_VERSION=3.8 \
# -DSPCONV_BuildTests=OFF \
# -DPYTORCH_VERSION=11301 \
# -DCMAKE_BUILD_TYPE=Release \
# /spconv
RUN ls

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

WORKDIR /spconv
RUN pixi run setup_cuda_env && pixi run check_cuda && pixi run start
# RUN pixi run setup_cuda_env && pixi run check_cuda && export PATH=/usr/bin/cmake:$PATH && pixi run start

FROM built-spconv
COPY pifenet.pixi.toml .
# COPY spconv .
RUN ls -a
WORKDIR /pifenet
RUN pixi install -e pifenet
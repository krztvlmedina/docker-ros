# syntax=docker/dockerfile:1.7-labs

FROM continuumio/miniconda3:latest as pifenet-base
COPY --from=ghcr.io/astral-sh/uv:0.8.4 /uv /uvx /bin/
COPY src/conda-environment.yml .
COPY src/pyproject.toml .
COPY src/check_torch.py .

# Install system deps
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y git build-essential cmake libxml2

# Create conda env
RUN conda create --name pifenet python=3.8.6 \
    pytorch=1.7.1 \
    cudatoolkit=11.0.221 cudatoolkit-dev cmake=3.18.2 \
    cuda-nvcc cudnn boost \
    -c pytorch \
    -c conda-forge -c nvidia

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "pifenet", "/bin/bash", "-c"]

RUN conda init
# RUN echo "source activate pifenet" > ~/.bashrc
# RUN conda activate pifenet \
#     && conda install conda-forge::mamba \
#     && mamba install libboost numba open3d yaml -c pytorch -c conda-forge -c nvidia -c numba -c open3d-admin \
#     && pip install uv \
#     && uv add addict einops fire jupyterlab jupyter-packaging \
#     tensorboard tensorboardx matplotlib numpy scikit-image \
#     psutil scikit-learn pandas pillow protobuf scipy seaborn tqdm opencv-python

RUN conda install conda-forge::mamba 

RUN pip install uv \
    && uv add addict einops fire jupyterlab jupyter-packaging \
    tensorboard tensorboardx matplotlib numpy scikit-image \
    psutil scikit-learn pandas pillow protobuf scipy seaborn tqdm opencv-python

RUN mamba install -v libboost numba open3d yaml -c pytorch -c conda-forge -c nvidia -c numba -c open3d-admin

# Prepare workdir
WORKDIR /src
RUN touch README.md

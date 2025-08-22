# syntax=docker/dockerfile:1.7-labs
FROM pifenet-base

# Copy pre-cloned repos
COPY ../external/spconv /spconv
ENV NVIDIA_VISIBLE_DEVICES: all
ENV NVIDIA_DRIVER_CAPABILITIES: all
WORKDIR /spconv

# Ensure correct Python environment is active
SHELL ["conda", "run", "-n", "pifenet", "/bin/bash", "-c"]
RUN uv pip list
RUN conda list
# Build spconv wheel
# RUN python setup.py bdist_wheel


# FROM pifenet-base as builder
# COPY --from=pifenet-base /opt/conda /opt/conda
# ENV PATH=/opt/conda/bin:$PATH

# # Copy source code
# WORKDIR /app
# COPY src/pyproject.toml .
# COPY src/check_torch.py .

# # Copy pre-cloned external repos
# COPY ../external/PiFeNet /pifenet
# COPY ../external/spconv /spconv

# # Build spconv wheel
# WORKDIR /spconv
# RUN echo "Contents of /spconv:" && ls -alh
# RUN python setup.py bdist_wheel

# # Copy wheel to a common dist folder
# RUN mkdir -p /dist && cp dist/*.whl /dist/

# # Install your application
# WORKDIR /app
# COPY . .
# RUN pip install -e .

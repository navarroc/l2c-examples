FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

ARG CUDA_VERSION="12.2"
ENV CUDA_VERSION=

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    /bin/bash miniconda.sh -b -p $CONDA_DIR && \
    rm miniconda.sh

WORKDIR /app

# Copy the source code to the work directory
COPY . /app

# When this generates, we will need to get the environment name from tne environment.yml file

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

RUN echo "Building with CUDA version $CUDA_VERSION"

# Create the environment based on the environment.yml file
RUN CONDA_OVERRIDE_CUDA=$CUDA_VERSION conda env create -f /app/environment.yml && \
    conda clean --all && \
    rm /app/environment.yml

# Use this for debugging images
#CMD ["tail", "-f", "/dev/null"]

# Set default command to run when the container starts
ENTRYPOINT ["./run_tool.sh"]

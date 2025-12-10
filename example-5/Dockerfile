FROM continuumio/miniconda3:latest

WORKDIR /app

# Copy the source code to the work directory
COPY . /app

# Specify the CUDA Version to use
ARG CUDA_VERSION="11.8"
ENV CONDA_OVERRIDE_CUDA=${CUDA_VERSION}

RUN echo "Building with CUDA version $CUDA_VERSION"

# Create the environment based on the environment.yml file
RUN CONDA_OVERRIDE_CUDA=${CUDA_VERSION} conda env create -f /app/environment.yml && \
    conda clean --all && \
    rm /app/environment.yml

# Use this for debugging images
#CMD ["tail", "-f", "/dev/null"]

# Set default command to run when the container starts
ENTRYPOINT ["./run_tool.sh"]

FROM continuumio/miniconda3:latest

WORKDIR /app

# Copy the source code to the work directory
COPY . /app

# Create the Conda environment - assumes this will be in work directory
RUN conda env create -f /app/environment.yml && \
    conda clean --all && \
    rm /app/environment.yml

# Set this for debugging images
#CMD ["tail", "-f", "/dev/null"]

# Set default command to run when the container starts
ENTRYPOINT ["./run_tool.sh"]

# Laptop to Container Examples

This project contains a set of example python codes that can be used with the laptop-to-container bash scripts for containerizing existing python projects.

## Overview

These examples can be containerized using the Laptop to Container bash scripts without having to write your own Dockerfile.

## Prerequisites

- laptop-to-container repository with bash scripts 

## Running the Scripts

### Building with Conda

```bash
./create_docker.sh -a example-1 -d l2c/example-1 -e environment.yml -p linux/arm64 -m example1.py
```

```bash
./create_docker.sh -a example-2 -d l2c/example-2 -e environment.yml -m example2.py
```

```bash
./create_docker.sh -a example-3 -d l2c/example-3 -e environment.yml -m example3.py
```

```bash
./create_docker.sh -a example-4 -d l2c/example-4 -e environment.yml -m example4.py
```

```bash
./create_docker.sh -a example-5 -d l2c/example-5 -e environment.yml -m neural_style/neural_style.py
```

| Parameter | Description                                                 | Default       |
|-----------|-------------------------------------------------------------|---------------|
| `-a`      | Path to the source code folder                              | `N/A`         |
| `-c`      | CUDA version to use                                         | `11.8`        |
| `-d`      | Tag for generated docker image                              | `latest`      |
| `-e`      | Name of the environment yaml file in the source code folder | `N/A`         |
| `-h`      | Print help                                                  | `N/A`         |
| `-m`      | Python file containing the main method                      | `N/A`         |
| `-p`      | Build platform                                              | `linux/amd64` |
| `-r`      | Registry to publish the container image                     | `None`        |

To run the image, do the following:

```
docker run -it l2c/example-1
```

### Building with Pip/CUDA

```bash
./create_docker_cuda.sh -a example-8 -d l2c/example-8 -e requirements.txt -m example8.py -p linux/arm64 -c 11.8
```
```bash
./create_docker_cuda.sh -a example-9 -d l2c/example-9 -e requirements.txt -m neural_style/neural_style.p -c 11.8
```

| Parameter | Description                                                                        | Default       |
|-----------|------------------------------------------------------------------------------------|---------------|
| `-a`      | Path to the source code folder                                                     | `N/A`         |
| `-c`      | CUDA version to use                                                                | `11.8`        |
| `-d`      | Tag for generated docker image                                                     | `latest`      |
| `-e`      | Name of the pip environment file in the source code folder (e.g. requirements.txt) | `N/A`         |
| `-h`      | Print help                                                                         | `N/A`         |
| `-m`      | Python file containing the main method                                             | `N/A`         |
| `-p`      | Build platform                                                                     | `linux/amd64` |
| `-r`      | Registry to publish the container image                                            | `None`        |

To run the image, do the following:

```
docker run -it l2c/example-8
```

### Building with Pip

This is a ML example using LinearRegression that doesn't need CUDA.

```bash
./create_docker_pip.sh -a example-6 -d l2c/example-6 -e requirements.txt -p linux/arm64 -m example6.py
```
```bash
./create_docker_pip.sh -a example-7 -d l2c/example-7 -e requirements.txt -m example7.py
```

| Parameter | Description                                                                        | Default       |
|-----------|------------------------------------------------------------------------------------|---------------|
| `-a`      | Path to the source code folder                                                     | `N/A`         |
| `-d`      | Tag for generated docker image                                                     | `latest`      |
| `-e`      | Name of the pip environment file in the source code folder (e.g. requirements.txt) | `N/A`         |
| `-h`      | Print help                                                                         | `N/A`         |
| `-m`      | Python file containing the main method                                             | `N/A`         |
| `-p`      | Build platform                                                                     | `linux/amd64` |
| `-r`      | Registry to publish the container image                                            | `None`        |

To run the image, do the following:

```
docker run -it l2c/example-6
```


### Running on Campus Cluster, Delta or DeltaAI

If you are pulling from an external registry, then you will need to login to the container registry first.
This will create a local token.

```bash
apptainer registry login --username <username> docker://ghcr.io
```

```bash
./run_apptainer.sh -a <account> -p cpu -w /app -i l2c-example-1 -r ghcr.io/navarroc
```

```bash
./run_apptainer.sh -a <account> -p cpu -w /app -i l2c-example-2 -r ghcr.io/navarroc
```

```bash
./run_apptainer.sh -a <account> -p cpu -w /app -b "--bind /path/to/output:/app/outputs" -i l2c-example-5 -r ghcr.io/navarroc eval --content-image images/content-images/amber.jpg --model saved_models/mosaic.pth --output-image /app/outputs/output-normal2.jpg
```

In the above example, /path/to should be replaced with the path on your account where outputs should be written so
the are available outside the container.

For DeltaAI, you will need to specify 1 or more GPUs or the job will not run.

| Parameter | Description                                         | Default  |
|-----------|-----------------------------------------------------|----------|
| `-a`      | Account to submit job under                         | `N/A`    |
| `-b`      | Bindings to mount when running the image            | `N/A`    |
| `-d`      | Tag of  container to run                            | `latest` |
| `-g`      | Number of GPUs to request                           | `0` |
| `-h`      | Print help                                          | `N/A`    |
| `-i`      | Name of image to run                                | `N/A`    |
| `-p`      | Partition to run image                              | `N/A`    |
| `-r`      | Registry to pull the container image                | `None`   |
| `-w`      | Container Work directory where application is       | `None`   |



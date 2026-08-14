# Example-7

This is the pip version of example 2. Included is an example Dockerfile that works for testing. 
However, to build the container from a script and template, run the following:

./create_docker_pip.sh -a example-7/ -d l2c/example-7 -e requirements.txt -m example7.py -r your-registry

To run:

docker run -it l2c/example-7

## Snakemake

To see how you can run this with Snakemake, see the example Snakefiles. These are
intended only as examples and could be configured more than they are. They provide
a bare minimum setup to run with Slurm or locally.

See [Snakefile.local](Snakefile.local) for local execution or [Snakefile.slurm](Snakefile.slurm)
for an example with SLURM. There is also a [Snakefile.docker](Snakefile.docker) example
for how you can reference a Docker container, which will get converted to SIF by apptainer.

If you are using this with the Docker containers built using the laptop-to-hpc scripts, you will need to
add some bindings when you run Snakemake. Here is an example for running with SLURM:

```
snakemake --executor slurm --use-singularity --singularity-args "--cwd /app --bind $(pwd)/output:/app/output" --jobs 1
```

If you are running locally, you can use the following:

```
snakemake --use-singularity --singularity-args "--cwd /app --bind $(pwd)/output:/app/output" -j1

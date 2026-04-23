# Example-1

This is a python example that can be containerized with the laptop-to-hpc scripts.

## Snakemake

To see how you can run this with Snakemake, see the example Snakefiles. These are
intended only as examples and could be configured more than they are. They provide
a bare minimum setup to run with Slurm or Locally.

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

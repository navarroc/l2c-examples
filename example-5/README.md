# Example-5

This example is taken from the pytorch examples repository. 

docker run -v outputs:/app/outputs -it l2c/example-5 eval --content-image images/content-images/amber.jpg --model saved_models/mosaic.pth --output-image /app/outputs/amber-example.jpg

## Snakemake

To see how you can run this with Snakemake, see the example Snakefiles. These are
intended only as examples and could be configured more than they are. They provide
a bare minimum setup to run with Slurm or Locally.

See [Snakefile.local](Snakefile.local) for local execution or [Snakefile.slurm](Snakefile.slurm)
for an example with SLURM.

If you are using this with the Docker containers built using the laptop-to-hpc scripts, you will need to 
add some bindings when you run Snakemake. Here is an example for running with SLURM:

```
snakemake --executor slurm --use-singularity --singularity-args "--cwd /app --bind $(pwd)/output:/app/output" --jobs 1
```

If you are running locally, you can use the following:

```
snakemake --use-singularity --singularity-args "--cwd /app --bind $(pwd)/output:/app/output" -j1
```

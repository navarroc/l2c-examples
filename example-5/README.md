# Example-5

This example is taken from the pytorch examples repository. 

docker run -v outputs:/app/outputs -it l2c/example-5 eval --content-image images/content-images/amber.jpg --model saved_models/mosaic.pth --output-image /app/outputs/amber-example.jpg

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

If you want to pass in parameters, use the following:

```
snakemake --executor slurm --latency-wait 60 --use-singularity --singularity-args "--cwd /app --bind $(pwd)/output:/app/output" --jobs 1 --config model_mode="eval" content_image="--content-image images/content-images/amber.jpg" model="--model saved_models/mosaic.pth" output_image="--output-image /app/output/output-normal2.jpg"
```

You can use the config parameter to change inputs/outputs when executing the workflow.

If you are running locally, you can use the following:

```
snakemake --use-singularity --singularity-args "--cwd /app --bind $(pwd)/output:/app/output" -j1
```

## Nextflow

To see how you can run this with Nextflow, see the example main.nf and nextflow.config. These
are only intended as examples and could be configured in different ways. The provide a bare
minimum setup to run with SLURM.

You can run this with SLURM using the 'slurm' profile. Otherwise, it defaults to local execution.

To run this locally, do the following:

```
nextflow run main.nf
```

To run this with a SLURM scheduler, do the following:

```
nextflow run main.nf -profile slurm
```

For a more complex example, see main.nf.example-1 and main.nf.example-2. example-1 shows how can you pass in an input
file so that it gets staged into the container for execution. The main drawback is you must always specify a file. 
example-2 shows how you can optionally specify a file that gets staged in or you can use the default image that is in
the container. For example, assuming you use main.nf.example-2 as your main.nf, you can specify an input file and the
name of the output file by doing the following:

```
nextflow run main.nf -profile slurm --input 'amber.jpg' --output_name 'output-normal1.jpg'
```

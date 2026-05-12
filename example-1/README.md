# Example-1

This is a python example that can be containerized with the laptop-to-hpc scripts.

## Snakemake

To see how you can run this with Snakemake, see the example Snakefiles. These are
intended only as examples and could be configured more than they are. They provide
a bare minimum setup to run with SLURM or locally.

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
```

For a slightly more complex example, here is an Snakefile for a 2-step workflow that uses example-1 and 
example-5. See [Snakefile.2step](Snakefile.2step)

Finally, here is an example for running Snakemake on a compute node:

```
#!/bin/bash
#SBATCH --partition=some-partition
#SBATCH --account=some-account
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:05:00  # Adjust based on expected workflow duration

# Load your environment (conda, modules, etc.)
# module load snakemake  # Example
module load python/3.11.11
source /path/to/snakemake/myenv/bin/activate

snakemake --executor slurm --latency-wait 60 --use-singularity --singularity-args "--cwd /app --bind $(pwd)/output:/app/output" --jobs 1
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

nextflow run main.nf -profile slurm

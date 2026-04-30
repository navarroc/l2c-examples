# pyincore Example 

This example is uses the pyincore library to run an example analysis. 

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
snakemake --executor slurm --latency-wait 60 --use-singularity --singularity-args "--cwd /app --bind $(pwd)/outputs:/app/outputs --bind $(pwd)/incore_token:/app/incore_token" --jobs 1 
```

If you want to pass in parameters, use the following:

```
snakemake --executor slurm --latency-wait 60 --use-singularity --singularity-args "--cwd /app --bind $(pwd)/outputs:/app/outputs --bind $(pwd)/incore_token:/app/incore_token" --jobs 1 --config tool_args="--analysis pyincore.analyses.buildingstructuraldamage.buildingstructuraldamage:BuildingStructuralDamage --token /app/incore_token --result_name outputs/slc_dmg --buildings 62fea288f5438e1f8c515ef8 --hazard_type earthquake --hazard_id 64108b5f86a52d419dd69a3f --dfr3_mapping_set 6309005ad76c6d0e1f6be081 --num_cpu 8"
```

You can use the config parameter to change inputs/outputs when executing the workflow.

If you are running locally, you can use the following:

```
snakemake --use-singularity --singularity-args "--cwd /app --bind $(pwd)/output:/app/output --bind $(pwd)/incore_token:/app/incore_toke" -j1
```

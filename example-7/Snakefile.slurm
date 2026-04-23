# Snakefile
rule run_container:
    output:
        "output/stdout.txt"
    singularity:
        "l2c-example-7_latest.sif"
    resources:
        slurm_partition="",
        runtime=5,
        mem_mb=4000,
        cpus_per_task=1,
        slurm_account="",
        nodes=1
    shell:
        """
        ./run_tool.sh > {output}
        """

rule run_container:
    output:
        "output/stdout.txt"
    singularity:
        "l2c-example-5_latest.sif"
    resources:
        slurm_partition="",
        runtime=5,
        mem_mb=4000,
        cpus_per_task=1,
        slurm_account="",
        nodes=1
    shell:
        """
        ./run_tool.sh eval --content-image images/content-images/amber.jpg --model saved_models/mosaic.pth --output-image /app/output/output-normal2.jpg > {output}

rule run_container:
    output:
        "output/stdout.txt"
    singularity:
        "l2c-example-5_latest.sif"
    params:
        model_mode=config.get("model_mode", "eval"),
        content_image=config.get("content_image", "--content-image images/content-images/amber.jpg"),
        model=config.get("tool_model", "--model saved_models/mosaic.pth"),
        output_image=config.get("output_image", "--output-image /app/output/output-normal2.jpg")
    resources:
        slurm_partition="",
        runtime=5,
        mem_mb=4000,
        cpus_per_task=1,
        slurm_account="",
        nodes=1
    shell:
        """
        ./run_tool.sh {params.model_mode} {params.content_image} {params.model} {params.output_image} > {output}
        """

rule all:
    input:
        "outputs/stdout.txt"
rule run_model:
    output:
        "outputs/stdout.txt"
    singularity:
        "dw-pyincore_amd64.sif"
    params:
        tool_args=config.get("tool_args", "--analysis pyincore.analyses.buildingstructuraldamage.buildingstructuraldamage:BuildingStructuralDamage --token /app/incore_token --result_name outputs/slc_dmg --buildings 62fea288f5438e1f8c515ef8 --hazard_type earthquake --hazard_id 64108b5f86a52d419dd69a3f --dfr3_mapping_set 6309005ad76c6d0e1f6be081 --num_cpu 8")
    resources:
        slurm_partition="",
        runtime=5,
        mem_mb=40000,
        cpus_per_task=8,
        slurm_account="",
        nodes=1
    shell:
        """
        ./run_tool.sh {params.tool_args} > {output}
        """

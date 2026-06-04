# Running Workflows

These instructions are intended to help users who want to use Snakemake or Nextflow on
a cluster where these tools are not available. The scripts handle installing the workflow, loading
any required modules and generating a sbatch script so the workflow system runs on a compute node. Using the 
run scripts with examples in this repository can help show how you might configure running the workflow. However, 
you may still need to make adjustments depending on your use case. The assumption is you already have created a 
workflow that you run on your local machine that you now want to scale. These scripts have been configured for
a few systems. You can add more conditionals to configure other systems by matching the hostname and the 
required modules and profile you want to set. 

## Snakemake

The script [run_snakemake.sh](snakemake/run_snakemake.sh) is designed to help run Snakemake
workflows on different systems. You can find basic profiles for several systems in the folder
snakemake/profiles. 

By default, the script assumes you are running in the Campus Cluster in the IllinoisComputes
partition with the ncsa-ic account. This is configurable using the following:

To run your workflow, do the following:

| Parameter | Description                                                       | Default  |
|-----------|-------------------------------------------------------------------|----------|
| `-a`      | Account to submit job under.                                      | `N/A`    |
| `-c`      | Cleanup temporary files.                                          | `N/A`    |
| `-h`      | Print help.                                                       | `N/A`    |
| `-p`      | Partition to run the job in.                                      | `N/A`    |
| `-s`      | Run Snakemake on a compute node (default runs on the login node). | `N/A`    |

```
./run_snakemake.sh -a some-account -p some-partition 
```

The script is designed to install Snakemake if it's needed. It will also load the right
python module depending on what system you are running on. 

## Nextflow

The script [run_nextflow.sh](nextflow/run_nextflow.sh) is designed to help run Nextflow 
workflows on different systems. You can find basic profiles for several systems in the file
nextflow/nextflow.config. This can be extended to other systems as well by adding more profiles.

By default, the script assumes you are running in the Campus Cluster in the IllinoisComputes
partition with the ncsa-ic account. This is configurable using the following:

To run your workflow, do the following:

| Parameter | Description                                                      | Default  |
|-----------|------------------------------------------------------------------|----------|
| `-a`      | Account to submit job under.                                     | `N/A`    |
| `-c`      | Cleanup temporary files.                                         | `N/A`    |
| `-h`      | Print help.                                                      | `N/A`    |
| `-p`      | Partition to run the job in.                                     | `N/A`    |
| `-s`      | Run Nextflow on a compute node (default runs on the login node). | `N/A`    |

```
./run_nextflow.sh -a some-account -p some-partition 
```

The script is designed to install Nextflow if it's needed. If needed, you can also adapt the script to
load a particular Java module. For the systems already configured, the Java version is recent enough for
the latest Nextflow. 


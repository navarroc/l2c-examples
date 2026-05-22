# Running Workflows

## Snakemake

The script [run_snakemake.sh](snakemake/run_snakemake.sh) is designed to help run Snakemake
workflows on different systems. You can find basic profiles for several systems in the folder
snakemake/profiles. 

By default, the script assumes you are running in the Campus Cluster in the IllinoisComputes
partition with the ncsa-ic account. This is configurable using the following:

To run the your workflow, do the following:

| Parameter | Description                                                       | Default  |
|-----------|-------------------------------------------------------------------|----------|
| `-a`      | Account to submit job under.                                      | `N/A`    |
| `-h`      | Print help.                                                       | `N/A`    |
| `-p`      | Partition to run the job in.                                      | `N/A`    |
| `-s`      | Run Snakemake on a compute node (default runs on the login node). | `N/A`    |

```
./run_snakemake.sh -a some-account -p some-partition 
```

The script is designed to install Snakemake if it's needed. It will also load the right
python module depending on what system you are running on. 

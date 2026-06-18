#!/bin/bash

sbatch_template() {
cat <<'EOF'
#!/bin/bash

# Users should set --time as appropriate for their jobs(e.g. --time=1-00:00:00) for one day.
# Snakemake needs very little resources since it's only handling orchestration so most of this
# Should be reasonable except the wall time

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:05:00  # Adjust based on expected workflow duration
#SBATCH --partition={{ PARTITION }}
#SBATCH --account={{ ACCOUNT }}

module load {{ PYTHON }}
PROFILE={{ SLURM_PROFILE }}

echo "Activate Snakemake"
source ~/snakemake/myenv/bin/activate

# TODO the singularity args could be made configurable
snakemake --profile "$PROFILE" --jobs 1 {{ IMAGE_CLI }}

EOF
}

config_template() {
cat <<'EOF'
executor: slurm
use-singularity: true
latency-wait: 60

default-resources:
  slurm_partition: "{{ PARTITION }}"
  runtime: 5
  mem_mb: 4000
  cpus_per_task: 1
  slurm_account: "{{ ACCOUNT }}"
  nodes: 1
  {{ GPU_OPTION }}
EOF
}

JOB_ACCOUNT=""
JOB_PARTITION=""
WORKFLOW_ACCOUNT=""
WORKFLOW_PARTITION=""

HELP="NO"
USE_SLURM="NO"
# By default, don't remove the temporary files - users might want to see this to write their own
CLEANUP="NO"
NUM_GPUS=0

while getopts "a:cg:hi:p:sw:" opt; do
    case $opt in
        a)
            JOB_ACCOUNT="$OPTARG"
        ;;
        c)
            CLEANUP="YES"
        ;;
        g)
            NUM_GPUS="$OPTARG"
        ;;
        h)
            HELP="YES"
        ;;
        i)
            WORKFLOW_PARTITION="$OPTARG"
        ;;
        p)
            JOB_PARTITION="$OPTARG"
        ;;
        s)
            USE_SLURM="YES"
        ;;
        w)
            WORKFLOW_ACCOUNT="$OPTARG"
        ;;
    esac
done

# For now, we assume all other arguments are for the container
shift $((OPTIND - 1))
IMAGE_CLI="$@"

# If we read it into an array - this fixes the local run, but breaks
# the sbatch run when inserting into the template - leaving this for later
# Without this, we need to use eval to run on the login node, which is not ideal
# IMAGE_CLI=("$@")

echo "These are the arguments we'll pass to the workflow steps"
echo $IMAGE_CLI

if [ "$HELP" == "YES" ]; then
    echo "Usage : $0 <-a Account Name > <-p Partition> [-h]"
    echo ""
    echo "-a account    : Account name to run job under "
    echo "-c            : Clean up temporary files (e.g sbatch script)"
    echo "-h            : this help text"
    echo "-p partition  : partition requested for the job"
    exit 0
fi

if [[ -z "$WORKFLOW_ACCOUNT" ]]; then
  WORKFLOW_ACCOUNT=$JOB_ACCOUNT
fi

if [[ -z "$WORKFLOW_PARTITION" ]]; then
  WORKFLOW_PARTITION=$JOB_PARTITION
fi

echo "Job will run with account $JOB_ACCOUNT and in partition $JOB_PARTITION"

# TODO add local profile execution option for running on a users laptop

# Find where the job is running and load the correct modules
hostname="${HOSTNAME%%.*}"

if [[ "$hostname" == dt-login* ]]; then
    echo "Running on Delta"
    PYTHON="cray-python/3.11.7"
#    PROFILE="profiles/delta"
elif [[ "$hostname" == gh-login* ]]; then
    echo "Running on Delta AI"
    PYTHON="python/3.11.9"
#    PROFILE="profiles/delta-ai"
elif [[ "$hostname" == cc-login* ]]; then
    echo "Running on campus cluster"
    PYTHON="python/3.11.11"
#    PROFILE="profiles/ccluster"
else
    echo "Unknown host - it needs to be added to use this script: $hostname"
    exit 1
fi

# Load python before checking if Snakemake is installed
module load $PYTHON

# Check for Snakemake and install it before launching the job
if [[ -d ~/snakemake ]]; then
    echo "Snakemake is installed, activate environment"
    source ~/snakemake/myenv/bin/activate
else
    echo "Snakemake is not installed, installing it in $HOME/snakemake"
    python3 -m venv ~/snakemake/myenv
    source ~/snakemake/myenv/bin/activate
    pip install snakemake snakemake-executor-plugin-slurm
fi


echo "Creating Snakemake config"
# Check if using GPUS
GPU_OPTION=""
if [[ $NUM_GPUS -gt 0 ]]; then
  GPU_OPTION="slurm_extra: \"--gres=gpu:${NUM_GPUS}\""
fi

PROFILE=config.yaml
config_template > config.yaml
sed  -i -e "s|{{ PARTITION }}|$JOB_PARTITION|g" \
     -i -e "s|{{ ACCOUNT }}|$JOB_ACCOUNT|g" \
     -i -e "s|{{ GPU_OPTION }}|$GPU_OPTION|g" config.yaml

if [ "$USE_SLURM" == "YES" ]; then
    sbatch_template > run_job.sh
    sed -i -e "s|{{ PARTITION }}|$WORKFLOW_PARTITION|g" \
        -i -e "s|{{ ACCOUNT }}|$WORKFLOW_ACCOUNT|g" \
        -i -e "s|{{ SLURM_PROFILE }}|$PROFILE|g" \
        -i -e "s|{{ PYTHON }}|$PYTHON|g" \
        -i -e "s|{{ IMAGE_CLI }}|$IMAGE_CLI|g" run_job.sh

    chmod +x run_job.sh
    echo "Run Snakemake on a compute node"
    sbatch run_job.sh
    # TODO we should add a flag to not clean up the sbatch script in case it's needed for debugging
else
    echo "Run Snakemake on the login node"
    # This line might need to be tailored to your container depending how you built it
    # Right now it will only launch 1 job in parallel at a time
    # TODO it would be better to replace eval here - the below works, but if we use an array
    # for the CLI arguments, I couldn't get the run_job.sh updated correctly - leaving this
    # to investigate later
    # snakemake --profile "$PROFILE" --jobs 1 "${IMAGE_CLI[@]}"
    eval snakemake --profile "$PROFILE" --jobs 1 $IMAGE_CLI
fi

if [ "$CLEANUP" == "YES" ]; then
  echo "Cleaning up temporary files"
  rm run_job.sh
fi
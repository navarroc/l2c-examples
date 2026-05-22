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

snakemake --profile "$PROFILE" --singularity-args "--cwd /app --bind $(pwd)/output:/app/output" --jobs 1

EOF
}

ACCOUNT_NAME="ncsa-ic"
PARTITION="IllinoisComputes"
HELP="NO"
USE_SLURM="NO"

while getopts "a:hp:s" opt; do
    case $opt in
        a)
            ACCOUNT_NAME="$OPTARG"
        ;;
        h)
            HELP="YES"
        ;;
        p)
            PARTITION="$OPTARG"
        ;;
        s)
            USE_SLURM="YES"
        ;;
    esac
done

if [ "$HELP" == "YES" ]; then
    echo "Usage : $0 <-a Account Name > <-p Partition> [-h]"
    echo ""
    echo "-a account    : Account name to run job under "
    echo "-h            : this help text"
    echo "-p partition  : partition requested for the job"
    exit 0
fi

echo "Job will run with account $ACCOUNT_NAME and in partition $PARTITION"

# TODO add local profile execution option for running on a users laptop

# Find where the job is running and load the correct modules
hostname="${HOSTNAME%%.*}"

if [[ "$hostname" == dt-login* ]]; then
    echo "Running on Delta"
    PYTHON="cray-python/3.11.7"
    PROFILE="profiles/delta"
elif [[ "$hostname" == gh-login* ]]; then
    echo "Running on Delta AI"
    PYTHON="python/3.11.9"
    PROFILE="profiles/delta-ai"
elif [[ "$hostname" == cc-login* ]]; then
    echo "Running on campus cluster"
    PYTHON="python/3.11.11"
    PROFILE="profiles/ccluster"
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

if [ "$USE_SLURM" == "YES" ]; then
    sbatch_template > run_job.sh
    sed -i -e "s|{{ PARTITION }}|$PARTITION|g" \
        -i -e "s|{{ ACCOUNT }}|$ACCOUNT_NAME|g" \
        -i -e "s|{{ SLURM_PROFILE }}|$PROFILE|g" \
        -i -e "s|{{ PYTHON }}|$PYTHON|g" run_job.sh
    chmod +x run_job.sh
    echo "Run Snakemake on a compute node"
    sbatch run_job.sh
    # TODO we should add a flag to not clean up the sbatch script in case it's needed for debugging
    echo "Removing run_job.sh"
    rm run_job.sh
else
    echo "Run Snakemake on the login node"
    # This line might need to be tailored to your container depending how you built it
    # Right now it will only launch 1 job in parallel at a time
    snakemake --profile "$PROFILE" --singularity-args "--cwd /app --bind $(pwd)/output:/app/output" --jobs 1
fi


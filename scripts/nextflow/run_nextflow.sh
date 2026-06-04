#!/bin/bash

sbatch_template() {
cat <<'EOF'
#!/bin/bash

# Users should set --time as appropriate for their jobs(e.g. --time=1-00:00:00) for one day.
# Snakemake needs very little resources since it's only handling orchestration so most of this
# Should be reasonable except the wall time

#SBATCH --partition={{ PARTITION }}
#SBATCH --account={{ ACCOUNT }}
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:05:00  # Adjust based on expected workflow duration

PROFILE={{ SLURM_PROFILE }}

~/nextflow/nextflow run main.nf -resume -profile "$PROFILE"
EOF
}

config_template() {
cat <<'EOF'
docker {
    enabled = false
}

singularity {
    enabled = false
    autoMounts = true
}

profiles {
    // The default profile used when no -profile is specified
    standard {
        docker.enabled = true
        singularity.enabled = false
        process {
            container = 'hub.ncsa.illinois.edu/farmdoc/l2c-example-1:amd64'
            executor = 'local'
        }
    }

    // SLURM profile
    slurm_ccluster {
        docker.enabled = false
        singularity.enabled = true
        process {
            executor = 'slurm'
            container = 'docker://hub.ncsa.illinois.edu/farmdoc/l2c-example-1:amd64'
            clusterOptions = '--account=ncsa-ic --partition=IllinoisComputes --nodes=1'
        }
    }
    // todo - update account when system is online
    slurm_delta {
        docker.enabled = false
        singularity.enabled = true
        process {
            executor = 'slurm'
            container = 'docker://hub.ncsa.illinois.edu/farmdoc/l2c-example-1:amd64'
            clusterOptions = '--account=bccu-delta-cpu --partition=cpu --nodes=1'
        }
    }
    // todo - update account when system is online
    slurm_delta_ai {
        docker.enabled = false
        singularity.enabled = true
        process {
            executor = 'slurm'
            container = 'docker://hub.ncsa.illinois.edu/farmdoc/l2c-example-1:arm64'
            clusterOptions = '--account= --partition= --nodes=1'
        }
    }
}
EOF
}

# Potential future implementation - generate main.nf - this is highly configurable so not clear if it's worthwhile

ACCOUNT_NAME="ncsa-ic"
PARTITION="IllinoisComputes"
HELP="NO"
# By default, don't remove the temporary files - users might want to see this to write their own
CLEANUP="NO"
USE_SLURM="NO"

while getopts "a:chp:s" opt; do
    case $opt in
        a)
            ACCOUNT_NAME="$OPTARG"
        ;;
        c)
            CLEANUP="YES"
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
    echo "-c            : Clean up temporary files (e.g sbatch script)"
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
#    JAVA_MODULE=""
    PROFILE="slurm_delta"
elif [[ "$hostname" == gh-login* ]]; then
    echo "Running on Delta AI"
#    JAVA_MODULE=""
    PROFILE="slurm_delta-ai"
elif [[ "$hostname" == cc-login* ]]; then
    echo "Running on campus cluster"
    #JAVA_MODULE="java/23"
    PROFILE="slurm_ccluster"
else
    echo "Unknown host - it needs to be added to use this script: $hostname"
    exit 1
fi

# Check if Nextflow is already installed
if [[ -d ~/nextflow ]]; then
    echo "Nextflow is installed - nothing to do"
else
    echo "Nextflow is not installed, installing it in $HOME/nextflow"
    mkdir ~/nextflow
    wget -qO- https://get.nextflow.io | bash
    chmod +x nextflow
    mv nextflow ~/nextflow
fi
# TODO - create basic nextflow.config file that can be used for different campus
# systems, but container info must either be added to it or the main.nf should have it
echo "Generate template sbatch file - nextflow_sbatch.sh"
sbatch_template > nextflow_sbatch.sh
 sed -i -e "s|{{ PARTITION }}|$PARTITION|g" \
     -i -e "s|{{ ACCOUNT }}|$ACCOUNT_NAME|g" \
     -i -e "s|{{ SLURM_PROFILE }}|$PROFILE|g" nextflow_sbatch.sh

chmod +x nextflow_sbatch.sh
sbatch nextflow_sbatch.sh

# Remove run script if user specifies to clean it up - default is to not remove it
if [ "$CLEANUP" == "YES" ]; then
  echo "Cleaning up temporary files"
  rm nextflow_sbatch.sh
fi

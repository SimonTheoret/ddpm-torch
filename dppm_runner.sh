#!/bin/bash
#SBATCH --job-name=25gaussians                              # Job name
#SBATCH --cpus-per-task=1                                   # Ask for 6 CPUs
#SBATCH --gres=gpu:1                                        # Ask for 1 GPUs
#SBATCH --mem=32000M                                        # Ask for 32 GB of RAM
#SBATCH --time=0-03:00:00                                   # Duration: max 3 hour
#SBATCH --output=/scratch/logs/slurm-%j-%x.out   # log file
#SBATCH --error=/scratch/logs/slurm-%j-%x.error  # log file

# Arguments
# $1: Path to code directory. Directory must be already present on the remote machine.
# Copy code dir to the compute node and cd there
cd
rsync -av --relative "$0" $SLURM_TMPDIR --exclude ".git" # copies the directory to the slurm tmpdir
cd $SLURM_TMPDIR/"$0"
module purge
module load StdEnv/2020
module load python
virtualenv --no-download $SLURM_TMPDIR/venv
source $SLURM_TMPDIR/venv/bin/activate
pip install numpy pandas scikit-learn --no-index
pip install torch torchvision--no-index

echo "Currently using:"
echo $(which python)
echo "in:"
echo $(pwd)

python train_toy.py --dataset gaussian25 --device cpu --epochs 100



#!/bin/bash --login
#SBATCH --time 9:00:00
#SBATCH --cpus-per-task=4  
#SBATCH --mem=16G 
#SBATCH --partition=batch 
#SBATCH --job-name=launch-jupyter-server
#SBATCH --mail-type=ALL
#SBATCH --output=results/%x-%j-slurm.out
#SBATCH --error=results/%x-%j-slurm.err

# setup the environment
module purge
conda activate ./env 

# setup ssh tunneling 
export XDG_RUNTIME_DIR=/tmp IBEX_NODE=$(hostname -s) 
KAUST_USER=$(whoami)  
JUPYTER_PORT=8888

echo "
To connect to the compute node ${IBEX_NODE} on Ibex running your Jupyter server, 
you need to create an ssh tunnel from your local machine to login node on Ibex 
using the following command.

ssh -L ${JUPYTER_PORT}:${IBEX_NODE}:${JUPYTER_PORT} ${KAUST_USER}@ilogin.ibex.kaust.edu.sa 

Next, you need to copy the second url provided below and paste it into the browser 
on your local machine.
" >&2

# launch jupyter server
jupyter ${1:-lab} --no-browser --port=${JUPYTER_PORT} --ip=${IBEX_NODE}

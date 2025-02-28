#!/bin/bash
#SBATCH --job-name=EL_LCC08CSF0.5 # specifies a user-defined job name
#SBATCH --nodes=2 # number of compute nodes to be used
#SBATCH --ntasks-per-node=3 # number of MPI processes per node
#SBATCH --partition=small # partition (small_shared, small, medium, small_fat, small_gpu)
# special partitions: large (for selected users only!)
# job configuration testing partition: dev
#SBATCH --cpus-per-task=24 # number of cores per process
#SBATCH --time=12:00:00 # maximum wall clock limit for job execution
#SBATCH --output=logOutput_%j.log # log file which will contain all output
#SBATCH --array=0-4

### some additional information (you can delete those lines)
echo "#==================================================#"
echo " num nodes: " $SLURM_JOB_NUM_NODES
echo " num tasks: " $SLURM_NTASKS
echo " cpus per task: " $SLURM_CPUS_PER_TASK
echo " nodes used: " $SLURM_JOB_NODELIST
echo " job cpus used: " $SLURM_JOB_CPUS_PER_NODE
echo "#==================================================#"
# commands to be executed
# modify the following line to load a specific MPI implementation

module load intel-oneapi-mpi


mkdir run_${SLURM_ARRAY_TASK_ID}
cd run_${SLURM_ARRAY_TASK_ID}
cp ../* .


export OMP_NUM_THREADS=24
export OMP_PLACES=cores
export OMP_PROC_BIND=true

unset I_MPI_PMI_LIBRARY
export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0

mpirun -np 6 $HOME/AutoPas/build-MPI2/examples/md-flexible/md-flexible --yaml-filename explodingLiquid.yaml

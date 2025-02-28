#!/bin/bash
#SBATCH --job-name=Uni_B_Job_Array # specifies a user-defined job name
#SBATCH --nodes=1 # number of compute nodes to be used
#SBATCH --ntasks-per-node=1 # number of MPI processes per node
#SBATCH --partition=small # partition (small_shared, small, medium, small_fat, small_gpu)
# special partitions: large (for selected users only!)
# job configuration testing partition: dev
#SBATCH --cpus-per-task=36 # number of cores per process
#SBATCH --time=05:00:00 # maximum wall clock limit for job execution
#SBATCH --output=logOutput_%j.log # log file which will contain all output
#SBATCH --array=0-749

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

# Generate arrays of parameters indexed by job ID
declare -a noParticles
declare -a thread_count
declare -a rebuild_frequency
declare -a verlet_skin_per_timestep
declare -a run
index=0
for noParticlesIter in 012800 025600 051200 102400 204800
do
    for thread_count_iter in 06 12 18 24 30 36
    do
	for rebuild_frequency_iter in 10
	do
	    for verlet_skin_per_timestep_iter in 0.01 0.02 0.03 0.04 0.05
	    do
		for run_iter in `seq 0 4`
		do
		    
		    noParticles[$index]="$noParticlesIter"
		    thread_count[$index]="$thread_count_iter"
		    rebuild_frequency[$index]="$rebuild_frequency_iter"
		    verlet_skin_per_timestep[$index]="$verlet_skin_per_timestep_iter"
		    run[$index]="$run_iter"
		    index=$((index + 1))
		done
	    done
	done
    done
done

#    echo "Arrays created"
    
# Go to folder of experiment for this job ID
cd noParticles_${noParticles[${SLURM_ARRAY_TASK_ID}]}/${thread_count[${SLURM_ARRAY_TASK_ID}]}_threads/SpT_${verlet_skin_per_timestep[${SLURM_ARRAY_TASK_ID}]}/run_${run[${SLURM_ARRAY_TASK_ID}]}

# Set up enviroment variables

export OMP_NUM_THREADS=${thread_count[${SLURM_ARRAY_TASK_ID}]}
export OMP_PLACES=cores
export OMP_PROC_BIND=true

unset I_MPI_PMI_LIBRARY
export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0


#sequentially loop over each run

#for run in `seq 0 4`
#do
 #   cd run_${run}
    #echo "In noParticles_${noParticles[${SLURM_ARRAY_TASK_ID}]}/${thread_count[${SLURM_ARRAY_TASK_ID}]}_threads/RF_${rebuild_frequency[${SLURM_ARRAY_TASK_ID}]}/SpT_${verlet_skin_per_timestep[${SLURM_ARRAY_TASK_ID}]}/run_${run}" > logOutput_$SLURM_JOB_ID.log
mpirun -np 1 $HOME/AutoPas/build-MPI/examples/md-flexible/md-flexible --yaml-filename input.yaml > logOutput_${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}.out
#    cd ..
#done

#mpirun -np 1 $HOME/AutoPas/build-MPI/examples/md-flexible/md-flexible --yaml-filename input.yaml

#echo "After MPI call"

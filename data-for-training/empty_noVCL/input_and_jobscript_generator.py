from string import Template
import numpy as np
import os

inputTemplateFile = open("template_input.yaml", "r")

inputTemplate = Template(inputTemplateFile.read())

#jobscriptTemplateFile = open("template_jobscript.sh", "r")

#jobscriptTemplate = Template(jobscriptTemplateFile.read())

verlet_skin_per_timesteps = np.array([0.01, 0.02, 0.03, 0.04, 0.05])
#rebuild_frequencies = np.array([10, 20, 30, 40, 50])
thread_counts = np.array([6, 12, 18, 24, 30, 36])
#num_particles = np.array([100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200, 102400, 204800])
#num_particles = np.array([204800])
#slice_sizes = np.array([5, 10, 15, 20])

    
for thread_count in thread_counts:
    os.mkdir(f"./{thread_count:0>2}_threads")
    os.chdir(f'./{thread_count:0>2}_threads')
    for verlet_skin_per_timestep in verlet_skin_per_timesteps:
        os.mkdir(f"./SpT_{verlet_skin_per_timestep}")
        os.chdir(f'./SpT_{verlet_skin_per_timestep}')
        
        for run in range(5):
            os.mkdir(f"./run_{run:0>1}")
            os.chdir(f"./run_{run:0>1}")
                
            dictionary = {
                'skinpertimestep' : verlet_skin_per_timestep,
            }

                
                        
            f = open("./input.yaml", "w")
                    
            f.write(inputTemplate.substitute(dictionary))
                    
            f.close()
                    
            #f = open("./jobscript.sh", "w")
                    
                
            
            os.chdir('..')
        os.chdir("..")
    os.chdir("..")
    
    

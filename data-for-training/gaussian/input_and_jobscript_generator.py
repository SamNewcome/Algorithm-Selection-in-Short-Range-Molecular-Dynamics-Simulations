from string import Template
import numpy as np
import os

inputTemplateFile = open("template_input.yaml", "r")

inputTemplate = Template(inputTemplateFile.read())

#jobscriptTemplateFile = open("template_jobscript.sh", "r")

#jobscriptTemplate = Template(jobscriptTemplateFile.read())

number_of_clusters = np.array([10, 20, 40, 80, 160])
verlet_skin_per_timesteps = np.array([0.01, 0.02, 0.03, 0.04, 0.05])
thread_counts = np.array([6, 12, 18, 24, 30, 36])

for num_cluster in number_of_clusters:
    os.mkdir(f"./noClusters_{num_cluster:0>3}")
    os.chdir(f'./noClusters_{num_cluster:0>3}')
    
    for thread_count in thread_counts:
        os.mkdir(f"./{thread_count:0>2}_threads")
        os.chdir(f'./{thread_count:0>2}_threads')
        for verlet_skin_per_timestep in verlet_skin_per_timesteps:
            os.mkdir(f"./SpT_{verlet_skin_per_timestep}")
            os.chdir(f'./SpT_{verlet_skin_per_timestep}')
            
            for run in range(5):
                os.mkdir(f"./run_{run:0>1}")
                os.chdir(f"./run_{run:0>1}")


                # Generate Object String
                objectStr = ''
                # For each cluster, add a gaussian object
                for cluster in range(num_cluster):
                    # randomly generate a centre not too close to any wall
                    centre = np.random.uniform(2, 18, 3)

                    objectStr += f'''    {cluster}:
      distribution-mean              :  [{centre[0]}, {centre[1]}, {centre[2]}]
      distribution-stddeviation      :  [2, 2, 2]
      numberOfParticles              :  100
      box-length                     :  [20, 20, 20]
      bottomLeftCorner               :  [0, 0, 0]
      velocity                       :  [0, 0, 0]
      particle-type-id               :  0
'''
                
                dictionary = {
                    'skinpertimestep' : verlet_skin_per_timestep,
                    'objects' : objectStr
                }

                
                        
                f = open("./input.yaml", "w")
                    
                f.write(inputTemplate.substitute(dictionary))
                    
                f.close()
                    
                #f = open("./jobscript.sh", "w")
                    
                #jobDict = {
                #    'jobname' : f"Uni_n{num_particle:0>6}_rf{rebuild_frequency}_spt{verlet_skin_per_timestep}_r{run:0>1}",
                #'jobname' : f"Uni_n{num_particle:0>6}_rf{rebuild_frequency}_spt{verlet_skin_per_timestep}",
                #    'nthreads' : thread_count
                #}
                #f.write(jobscriptTemplate.safe_substitute(jobDict))
                
                #f.close()
                    
                #os.system('sbatch ./jobscript.sh')

                

                os.chdir('..')
            os.chdir('..')
        os.chdir("..")
    os.chdir("..")
    
    

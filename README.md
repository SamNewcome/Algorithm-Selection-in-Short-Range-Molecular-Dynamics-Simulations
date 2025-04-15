This repository contains data related to the paper "Algorithm Selection in Short-Range Molecular Dynamics Simulations" by Samuel James Newcome, Fabio Alexander Gratl, Manuel Lerchner, Abdulkadir Pazar, Manish Kumar Mishra, and Hans-Joachim Bungartz of the Chair of Scientific Computing in Computer Science, Department of Computer Science, Technical University of Munich.

The paper is accepted but not yet published. 

This data includes:
- In `data-for-training`: all template input files, python scripts that turn these templates into the input files used in training, and SLURM job arrays. With the first two, you can generate the same dataset used in the paper. To also run the input files, the job arrays probably need to be modified for your machine but may be of use.
- In `experiments`: All the data relating to the experiments including input files, jobscripts (again probably needing modification if you want to run them), rule files, models. In addition, the md-flexible outputs used for the results are also kept in this directory.
- In Software_Versions.md: The AutoPas git commit used, compiler versions, and python (and it's modules) versions.
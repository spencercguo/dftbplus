import numpy as np
import os 
import sys

# load locations
scratch = os.environ['SCRATCH']
data_dir = os.path.join(scratch, 'dftb-dft-dipoles/data/data-0')

geom_file = os.path.join(scratch, 'dftb-dft-dipoles/split/dft_traj-0.xyz')
charges_file = os.path.join(data_dir, 'detailed.out')

xyz = np.zeros((384, 3), dtype=np.float64)
with open(geom_file, mode='r') as f:
    for i, line in enumerate(f):
        if 2 <= i <= 385:
            print(line)
            x, y, z = line.split()[1:]
            xyz[i - 2] = x, y, z

charges = np.zeros(384, dtype=np.float64)
with open(charges_file, mode='r') as f:
    for i, line in enumerate(f):
        if 14 <= i <= 397:
            charges[i - 14] = float(line.split()[1])

dipole_x = np.dot(xyz[:,0], charges)
dipole_y = np.dot(xyz[:,1], charges)
dipole_z = np.dot(xyz[:,2], charges)

print(dipole_x, dipole_y, dipole_z)

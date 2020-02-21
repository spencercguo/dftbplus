import numpy as np
import sys
import os
import ir

def load_charges(data_dir, charge_filename):
    charges = np.zeros((2, nframes), dtype=np.float64)
    # get charges for two H atoms
    natoms = 384
    for i in range(nframes):
        charge_dir = 'data-{0}'.format(i)
        charge_file = os.path.join(data_dir, charge_dir, charge_filename)
        if not os.path.exists(charge_file):
            print('{0} does not exist!'.format(traj_file))
        
        with open(charge_file, mode='r') as f:
            
            start_index = 14 + index * i
            charges[0, i] = float(

def calc_oh_vectors():
    # shape 2 x 3 x 100000
    # 2 vectors, each xyz, for each frame
    oh_vectors = np.zeros((2, 3, nframes), dtype=np.float64)
    for i in range(nframes):
        # calculate position vector for O-H bonds
        #
        # 384
        #  i = step, time = ...
        #  O    12....
        #  H    2.33...
        #  H    12.65...
        o_index = 386 * i + 3 + index * 3
        o_line = lines[o_index]
        h1_line = lines[o_index + 1]
        h2_line = lines[o_index + 2]

        o_xyz = float(o_line.split()[1:])
        h1_xyz = float(h1_line.split()[1:])
        h2_xyz = float(h2_line.split()[1:])
        oh_vector_1 = o_xyz - h1_xyz
        oh_vector_2 = o_xyz - h2_xyz

def calc_dipoles():
    dipoles = np.zeros((3, nframes), dtype=np.float64)
    with open(traj_file, mode='r') as f:
        lines = f.readlines()

        
def main():
    nframes = 100000

    # location of charge files (calculated from DFTB+)
    scratch = os.environ['SCRATCH']
    data_dir = os.path.join(scratch, 'data/')
    charge_filename = 'detailed.out'

# input trajectory
traj_file = sys.argv[0]
if not os.path.exists(traj_file):
    print('{0} does not exist!'.format(traj_file))

# which water molecule (0 indexed)
index = sys.argv[1]

 

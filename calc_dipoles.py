import os
import sys
import numpy as np
import mdtraj as md
import pickle

def load_trajectory():
    xyz_file = sys.argv[1]
    pdb_file = sys.argv[2]
    print('Loading trajectory from {0}.....'.format(xyz_file))
    traj = md.load_xyz(xyz_file, pdb_file)
    # traj = md.load_xyz(xyz_file, pdb_file, frame=0)
    print("Number of frames {0}".format(traj.n_frames))
    print('Number of atoms {0}'.format(traj.n_atoms))

    return traj


def load_charges():
    nframes = 10000
    natoms = 384
    charges = np.zeros((natoms, nframes), dtype=np.float64)
    file_header = sys.argv[3]
    file_name = '/detailed.out'

    for i in range(nframes):
        full_name = file_header + str(i) + file_name
        # check for file path
        if not os.path.exists(input_path):
            print("%s doesn't exist!" %input_path)
            sys.exit(1)
        if i % 1000 == 0:
            print('Loaded charges from frame {0}'.format(i))

        # load data file with charges
        with open(full_name, mode='r') as f:
            for j, line in enumerate(f):
                if 14 <= j <= 397:
                    # line has format "Atom Charge"
                    charges[j - 14, i] = float(line.split()[1])
        
    return charges


def main():
    traj = load_trajectory()
    charges = load_charges()
    print('Calculating dipole moments....')
    dipoles = md.dipole_moments(traj, charges)
    print(dipoles.shape)
    # print(dipoles[0])
    # pickle.dump(dipoles, 'dipoles.dat')
    np.save('dipoles', dipoles)

if __name__ == '__main__':
    main()

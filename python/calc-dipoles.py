import os 
import sys
import numpy as np
import mdtraj as md
import pickle

def load_trajectory(xyz_file, pdb_file):
    print('Loading trajectory from {0}.....'.format(xyz_file))
    traj = md.load_xyz(xyz_file, pdb_file)
    print("Number of frames {0}".format(traj.n_frames))
    print('Number of atoms {0}'.format(traj.n_atoms))

    return traj


def load_charges(start, nframes, file_header): 
    natoms = 384
    charges = np.zeros((natoms, nframes), dtype=np.float64)
    file_name = '/detailed.out'
    
    for i, j in enumerate(range(start, start + nframes)):
        full_name = file_header + str(j) + file_name
        if j == 0:
            print("file path:" + full_name)
        # check for file path
        if not os.path.exists(full_name):
            print("%s doesn't exist!" %full_name) 
            sys.exit(1)
        # if j % 1000 == 0:
        #     print('loaded charges from frame {0}'.format(i))

        # load data file with charges
        with open(full_name, mode='r') as f:
            for k, line in enumerate(f):
                if 14 <= k <= 397:
                    # line has format "atom charge"
                    charges[k - 14, i] = float(line.split()[1])
        
    return charges


def main():
    # number of frames at a time for which to calculate dipoles
    nframes = 1000
    
    # load trajectory
    print('Starting calculation....')
    xyz_file = sys.argv[1]
    pdb_file = sys.argv[2]
    #SBATCH --mail-user=scguo@stanford.edu
    #SBATCH --mail-user=scguo@stanford.edu
    print('XYZ file:' + xyz_file)
    print('PDB file:' + pdb_file)
    if not os.path.exists(xyz_file):
        print('{0} does not exist'.format(xyz_file))
    if not os.path.exists(pdb_file):
        print('{0} does not exist'.format(pdb_file))
     
    traj = load_trajectory(xyz_file, pdb_file)
    
    # load charges
    file_header = sys.argv[3]
    start = int(sys.argv[4])
    charges = load_charges(start, nframes, file_header)

    print('Calculating dipole moments....')
    dipoles = np.zeros((nframes, 3), dtype=np.float64)
    # dipoles = md.dipole_moments(traj[:nframes], charges)
    for i in range(nframes):
        # calculate box dipole moment for each frame in the trajectory
        # using the extracted charges for each frame
        box_dipole = md.dipole_moments(traj[i], charges[:,i])
        dipoles[i,:] = box_dipole
    
    # write dipoles to file
    out_header = sys.argv[5]
    out_file = '{0}-{1}.out'.format(out_header, start)
    with open(out_file, mode='w') as f:
        np.savetxt(f, dipoles, fmt='%01f')

    # print(dipoles.shape)
    # print(dipoles[0])
    # print(dipoles[1])
    # pickle.dump(dipoles, 'dipoles.dat')
    # np.save('dipoles', dipoles)

if __name__ == '__main__':
    main()

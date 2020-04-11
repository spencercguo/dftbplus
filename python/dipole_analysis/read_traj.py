import numpy as np
import mdtraj as md
import pickle


def load_trajectory():
    xyz_file = 'dft_traj.xyz'
    pdb_file = '../300K_water128_1.pdb'
    print(f'Loading trajectory from {xyz_file}.....')
    traj = md.load_xyz(xyz_file, pdb_file)
    print(f"Number of frames {traj.n_frames}")
    print(f'Number of atoms {traj.n_atoms}')

    return traj


def load_charges():
    nframes = 100000
    natoms = 384
    charges = np.zeros((natoms, nframes), dtype=np.float64)
    file_header = '/scratch/users/scguo/dftb-dft-dipoles/data/data-'
    file_name = '/detailed.out'

    for i in range(nframes):
        full_name = "{file_header}{i}{file_name}"
        with open(full_name, mode='r') as f:
            for j, line in enumerate(f):
                if 15 <= j <= 398:
                    # line has format "Atom Charge"
                    charges[j - 15, i] = float(line.split()[1])
        
    return charges


def main():
    traj = load_trajectory()
    charges = load_charges()
    dipoles = md.dipole_moments(traj, charges)
    pickle.dump(dipoles, 'dipoles.pickle')



if __name__ == "__main__":
    main()

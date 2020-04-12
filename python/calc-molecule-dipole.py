import numpy as np
import sys
import os
# import ir

def load_charges(data_dir, charge_filename, nframes):
    # load charges only for Hs
    nmols = 128

    # 128 x 2 x 10000
    # 128 molecules, 2 charge, 10000 frames
    charges = np.zeros((nmols, 2, nframes), dtype=np.float32)

    for i in range(nframes):
        charge_dir = 'data-{0}'.format(i)
        charge_file = os.path.join(data_dir, charge_dir, charge_filename)
        if not os.path.exists(charge_file):
            print('{0} does not exist!'.format(traj_file))

        with open(charge_file, mode='r') as f:
            for atom, line in enumerate(f):
                if 14 <= atom <= 397:
                    mol_index = (atom - 14) // 3
                    # first H atom
                    if atom % 3 == 0:
                        charges[mol_index, 0, i] = float(line.split()[1])
                    # second H atom
                    elif atom % 3 == 1:
                        charges[mol_index, 1, i] = float(line.split()[1])

    return charges

def calc_oh_vectors(traj_file, nframes):
    """
    Get O-H vectors for each frame
    """
    # num atoms x xyz
    xyz = np.zeros((384, nframes, 3), dtype=np.float32)

    # shape 128 x 2 x 3 x 100000
    # 2 vectors, each xyz, for each frame and for each water molecule
    oh_vectors = np.zeros((128, 2, 3, nframes), dtype=np.float32)

    with open(traj_file, mode='r') as f:
        lines = f.readlines()
        for i in range(nframes):
            for index in range(128):
                # determine O-H vectors for each molecule
                o_index = 386 * i + 2 + index * 3
                o_line = lines[o_index]
                h1_line = lines[o_index + 1]
                h2_line = lines[o_index + 2]

                o_xyz = list(map(float, o_line.split()[1:]))
                h1_xyz = list(map(float, h1_line.split()[1:]))
                h2_xyz = list(map(float, h2_line.split()[1:]))
                 
                oh_vector_1 = [(o - h) for o,h in zip(o_xyz, h1_xyz)]
                oh_vector_2 = [(o - h) for o,h in zip(o_xyz, h2_xyz)]

                oh_vectors[index, :, :, i] = oh_vector_1, oh_vector_2
    return oh_vectors

def calc_dipoles(charges, vectors, nframes):
    # charges: 128 x 2 x 10000
    # vectors: 128 x 2 x 3 x 10000
    # dipoles: 128 x 3 x 10000
    charges = np.tile(charges, 3)
    charges = np.reshape(charges, (128, 2, 3, nframes))
    dipoles = charges[:, 0, :, :] * vectors[:, 0, :, :] + charges[:, 1, :, :] * vectors[:, 1, :, :]

    return dipoles


def main():
    nframes = int(sys.argv[3])

    # location of charge files (calculated from DFTB+)
    # scratch = os.environ['SCRATCH']
    # data_dir = os.path.join(scratch, 'data/')
    charge_filename = 'detailed.out'
    data_dir = sys.argv[2]

    # input trajectory
    traj_file = sys.argv[1]
    if not os.path.exists(traj_file):
        print('{0} does not exist!'.format(traj_file))

    print(f'Data directory: {data_dir}')
    print(f'Number of frames: {nframes}')
    print(f'Trajectory file: {traj_file}')

    # which water molecule (0 indexed)
    # index = sys.argv[1]
    
    print('Extracting charges...') 
    # Calculate molecular dipoles for each of 
    # extract charges
    charges = load_charges(data_dir, charge_filename, nframes)
    print('Charges:', charges[:2,:,0])
    
    print('Calculating O-H displacement vectors...')
    # num atoms x xyz x nframes
    vectors = calc_oh_vectors(traj_file, nframes)
    # print(vectors[0, :, :, 0])

    # calculate dipoles
    print('Calculating molecular dipoles...')
    dipoles = calc_dipoles(charges, vectors, nframes)
    # print('Dipoles:', dipoles[0, :, 0])
    print('Dipoles:', dipoles.shape)
    
    print('Saving dipoles...')
    np.save('molecular_dipoles', dipoles)
    
    print('Finished.')

if __name__ == "__main__":
    main()

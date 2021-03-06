# This script splits our xyz files into multiple files of equal size 

import os
import sys

def mkdir_p(dir):
    if not os.path.exists(dir):
        os.mkdir(dir)

def main():
    print(sys.argv)
    input_file = sys.argv[1]
    # number of frames per split to produce
    num_frames = int(sys.argv[2])
    
    # total number of frames
    total_frames = int(sys.argv[3])

    # each frame has 384 atoms, plus 2 lines for identification
    num_lines = 386
    
    scratch = os.environ['SCRATCH']

    split_dir = sys.argv[4]
    data_dir = os.path.join(scratch, split_dir)
    mkdir_p(data_dir)

    file_header = sys.argv[5]

    # input_file = os.path.join(scratch, 'dftb-dft-dipoles/dft_traj.xyz')
    with open(input_file, mode='r') as f:
        for i in range(total_frames // num_frames):
            frame = [next(f) for j in range(num_lines * num_frames)]
            with open('{0}/{1}-{2}.xyz'.format(data_dir, file_header, i), mode='w+') as new_f:
                new_f.writelines(frame)

if __name__ == "__main__":
    main()

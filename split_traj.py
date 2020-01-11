# This script splits our xyz files into multiple files, one
# for each frame of the reference trajectory

import sys

def main():
    file_header = "dft_traj"
    # total number of frames/files to split
    num_frames = int(sys.argv[1])
    # each frame has 384 atoms, plus 2 lines for identification
    num_lines = 386

    with open('{0}.xyz'.format(file_header), mode='r') as f:
        for i in range(num_frames):
            frame = [next(f) for j in range(num_lines)]
            with open('input_files/{0}-{1}.xyz'.format(file_header, i), mode='w+') as new_f:
                new_f.writelines(frame)


if __name__ == "__main__":
    main()

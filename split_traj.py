import numpy

def main():
    file_header = "300K_water128_1"
    num_frames = 1
    num_lines = 386

    with open(f'{file_header}.xyz', mode='r') as f:
        for i in range(num_frames):
            frame = [next(f) for i in range(num_lines)]
            with open(f'{file_header}-{i}.xyz', mode='w+') as new_f:
                new_f.writelines(frame)


if __name__ == "__main__":
    main()

import numpy as np
import matplotlib.pyplot as plt

spec = np.loadtxt('../scripts/ipi-traj/spectrum_ir_H2O.csv', delimiter=';')
plt.plot(spec[:,0], spec[:,1])
plt.xlabel('Wavenumbers (cm-1)')
plt.ylabel('Intensity')
plt.xlim([0, 5000])
plt.ylim([0, 2.0])
plt.title('DFTB spectrum of bulk water, 128 molecules')
plt.savefig('spectrum-H2O', dpi=300)

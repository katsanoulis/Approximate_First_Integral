# [1] S. Katsanoulis, F. Kogelbauer, S. Roshan, J. Ault & G. Haller. 
# Approximate streamsurfaces for flow visualization. To appear in JFM.

# Libraries
import numpy as np
import scipy as sp
import pyvista as pv

## Read computed first integral data
mode = 13
with np.load('N'+str(mode)+'.npz') as data:
    H = data['H']
    xspan = data['xspan']
    yspan = data['yspan']
    zspan = data['zspan']
    D = data['D']

print(D)
X, Y, Z = np.meshgrid(xspan,yspan,zspan,indexing='ij')
Hr = np.absolute(H)
Hr = sp.ndimage.uniform_filter(Hr, 3)

mesh = pv.StructuredGrid(X, Y, Z)
mesh.point_data['Hr'] = Hr.ravel(order='F')

iso1 = np.linspace(0.27,0.37,10)
iso2 = np.linspace(0.2,np.amax(Hr),50)
isoValues = np.concatenate((iso1, iso2))

surfaces = [mesh.contour([v]) for v in isoValues]

colors = ['red', 'yellow', 'green', 'blue', 'cyan']

pl = pv.Plotter()
for ind in range(np.size(isoValues)):
    pl.add_mesh(surfaces[ind], color = colors[ind % 5])

pl.show(screenshot='tori.png')

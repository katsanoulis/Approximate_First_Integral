# [1] S. Katsanoulis, F. Kogelbauer, S. Roshan, J. Ault & G. Haller. 
# Approximate streamsurfaces for flow visualization. To appear in JFM.

# Libraries
import time
import numpy as np
from numpy import linalg as LA
from modes import modaltrunc
from numba import jit

## Grid Definition
start_time = time.time()
k = 60; l = 60; m = 60;

xspan = np.linspace(0,2*np.pi,k)
yspan = np.linspace(0,2*np.pi,l)
zspan = np.linspace(0,2*np.pi,m)

X, Y, Z = np.meshgrid(xspan,yspan,zspan,indexing='ij')

## Order of modal truncation for the Fourier series
N = 13
kmatrix = modaltrunc(N)
#kmatrix = np.float32(kmatrix)

## Flow field definition
A = np.sqrt(3); B = np.sqrt(2); C = 1;

u1 = A*np.sin(Z) + C*np.cos(Y)
u2 = B*np.sin(X) + A*np.cos(Z)
u3 = C*np.sin(Y) + B*np.cos(X)

## Solution of the eigenvalue problem for the coefficient matrix C as described in [1]
nPoints = np.size(X)
nModes = int(np.shape(kmatrix)[0])
Alpha = np.zeros( (nPoints,nModes), dtype = np.complex128 )

X = X.flatten('F'); Y = Y.flatten('F'); Z = Z.flatten('F');
u1 = u1.flatten('F'); u2 = u2.flatten('F'); u3 = u3.flatten('F');

@jit(nopython=True)
def filler_fast(Alpha,nPoints,nModes,kmatrix,X,Y,Z,u1,u2,u3):
    for indP in range(nPoints):
        for indM in range(nModes):
            innerPos = kmatrix[indM,0]*X[indP] + kmatrix[indM,1]*Y[indP] + kmatrix[indM,2]*Z[indP]
            innerVel = kmatrix[indM,0]*u1[indP] + kmatrix[indM,1]*u2[indP] + kmatrix[indM,2]*u3[indP]
            Alpha[indP,indM] = np.exp(1j*innerPos)*innerVel

    return Alpha

filler_fast(Alpha,nPoints,nModes,kmatrix,X,Y,Z,u1,u2,u3)

Alpha = np.matmul( Alpha.conj().T,Alpha )

Alpha = (Alpha + Alpha.conj().T) / 2

D, linear = LA.eigh(Alpha)
eive = linear[:,0]
linear = linear[:,:9]
D = D[:9]

H = np.zeros( nPoints, dtype = np.complex128 )

@jit(nopython=True)
def fIntegral_Fast(H,nPoints,nModes,kmatrix,X,Y,Z,eive):
    for indP in range(nPoints):
        for indM in range(nModes):
            innerPos = kmatrix[indM,0]*X[indP] + kmatrix[indM,1]*Y[indP] + kmatrix[indM,2]*Z[indP]
            coe = eive[indM]*np.exp(1j*innerPos)
            H[indP]  = H[indP]+coe
    return H

fIntegral_Fast(H,nPoints,nModes,kmatrix,X,Y,Z,eive)

H = np.reshape( H, (k, l, m), 'F')

print("--- %.2f seconds ---" % (time.time() - start_time) )

np.savez('N'+str(N)+'.npz', linear = linear, D = D, H = H, xspan = xspan, yspan = yspan, zspan = zspan)

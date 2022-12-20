# Outputs the modes that have norm less or equal than N

import numpy as np

def modaltrunc(N):
    x = np.linspace(-N,N,2*N+1)
    r = np.zeros( 3 )
    kmatrix = np.zeros( ((2*N+1)**3,3) )
    ind = 0
    for i in range( np.max(np.size(x)) ):
        r[0] = x[i]
        for j in range( np.max(np.size(x)) ):
            r[1] = x[j]
            for k in range( np.max(np.size(x)) ):
                r[2] = x[k]
                kmatrix[ind,:] = r
                ind += 1

    B = np.sqrt(kmatrix[:,0]**2 + kmatrix[:,1]**2 + kmatrix[:,2]**2)
    kmatrix = kmatrix[B<=N,:]
    #kmatrix = kmatrix[Bk[0],:]
    #print(round(np.shape(kmatrix)[0]/2))
    ind = round(np.shape(kmatrix)[0]/2)
    if (N % 2) == 0:
        kmatrix[ind+1:,:] = np.flip(kmatrix[ind+1:,:], axis=0)
        kmatrix = np.delete(kmatrix, ind, axis = 0)
    else:
        kmatrix[ind:,:] = np.flip(kmatrix[ind:,:], axis=0)
        kmatrix = np.delete(kmatrix, ind-1, axis = 0)

    return kmatrix


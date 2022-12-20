# Approximate First Integral in the non-integrable ABC flow

## Running instructions

For the ABC flow we provide two different implementations in MATLAB and Python.

Within MATLAB we offer two sample scripts. The first one is to be used on a typical workstation as it requires approximately 10GB of memory. It can be found under the "Low Memory Requirement" directory and possesses a number of necessary simplifications to reduce its memory footprint (use of single precision arithmetic as well as lower number of Fourier modes and grid points). Despite that, all the KAM surfaces of the non-integrable ABC flow are reconstructed with sufficient accuracy.

The second script can be found under the "High Memory Requirement" directory and is to be used in clusters. Here we make no simplifications resulting in higher memory requirements (140GB) but also a more faithful surface reconstruction.

In both cases the file "main.m" computes the approximate first integral and the file "plotStructures.m" plots and outputs the extracted structures. The MATLAB scripts were tested on MATLAB R2019a.

Within Python you may run the script "job.sh" to compute the approximate first integral and then run the script "jobPlot.sh" to plot the extracted structures. The Python scripts are only marginally optimized using the just-in-time compiler Numba. This invariably results in both a larger execution time and larger memory requirement when compared to the MATLAB scripts. The current version requires approximately 60GB for the "job.sh" script.

The Python scripts were tested on Python 3.8.5. and use the libraries NumPy, scipy, Numba and PyVista.

## References
[1] S. Katsanoulis, F. Kogelbauer, S. Roshan, J. Ault & G. Haller. Approximate streamsurfaces for flow visualization. To appear in JFM.

Citation:

Please cite [1], if you use the code in your work.

## License

This software is made public for research use only. It may be modified and redistributed under the terms of the GNU General Public License.

Maintained by Stergios Katsanoulis,

skatsanoulis at gmail dot com

December 20, 2022.

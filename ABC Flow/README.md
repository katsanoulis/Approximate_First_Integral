# Approximate First Integral in the non-integrable ABC flow

## Running instructions

For the ABC flow we provide two different sample scripts. The first one is to be used on a typical workstation as it requires approximately 10GB of memory. It can be found under the "Low Memory Requirement" directory and possesses a number of necessary simplifications to reduce its memory footprint (use of single precision arithmetic as well as lower number of Fourier modes and grid points). Despite that, all the KAM surfaces of the non-integrable ABC flow are reconstructed with sufficient accuracy.

The second script can be found under the "High Memory Requirement" directory and is to be used in clusters. Here we make no simplifications resulting in higher memory requirements (140GB) but also a more faithful surface reconstruction.

In both cases the file "main.m" computes the approximate first integral and the file "plotStructures.m" plots and outputs the extracted structures.

## References
[1] S. Katsanoulis, F. Kogelbauer, S. Roshan, J. Ault & G. Haller. Approximate streamsurfaces for flow visualization. To appear in JFM.

Citation:

Please cite [1], if you use the code in your work.

## License

This software is made public for research use only. It may be modified and redistributed under the terms of the GNU General Public License.

Tested on Matlab R2019a. 

Maintained by Stergios Katsanoulis,

katsanos at ethz dot ch

January 24, 2022.

%% Reference:
%[1] S. Katsanoulis, F. Kogelbauer, S. Roshan, J. Ault & G. Haller. 
% Approximate streamsurfaces for flow visualization. To appear in JFM.

%% Grid definition
k = 100; l = 100; m = 100;

xspan = linspace(0,2*pi,k);
yspan = linspace(0,2*pi,l);
zspan = linspace(0,2*pi,m);

[x0,y0,z0] = ndgrid(xspan,yspan,zspan);

%% Order of modal truncation for the Fourier series
N = 13;
kmatrix = modaltrunc(N);
kmatrix(round(size(kmatrix,1)/2),:) = [];

%% Flow field definition
A = sqrt(3); B = sqrt(2); C = 1;
    
u1 = A*sin(z0) + C*cos(y0);
u2 = B*sin(x0) + A*cos(z0);
u3 = C*sin(y0) + B*cos(x0);

%% Solution of the eigenvalue problem for the coefficient matrix C as described in [1]
nPoints = length(x0(:));
nModes = size(kmatrix,1);
Alpha = zeros(nPoints,nModes);

tic
for indP = 1:nPoints
    for indM = 1:nModes
        innerPos = kmatrix(indM,1)*x0(indP) + kmatrix(indM,2)*y0(indP) + kmatrix(indM,3)*z0(indP);
        innerVel = kmatrix(indM,1)*u1(indP) + kmatrix(indM,2)*u2(indP) + kmatrix(indM,3)*u3(indP);
        Alpha(indP,indM) = exp(1j*innerPos)*innerVel;
    end
end
toc

tic
Alpha = Alpha'*Alpha;
%[linear,D] = eig(Alpha);
[linear,D] = eigs(Alpha,1,'SM');
toc

%% First integral computation
%%
tic
H = 0*x0;
for indP = 1:nPoints
    for indM = 1:nModes
        innerPos = kmatrix(indM,1)*x0(indP) + kmatrix(indM,2)*y0(indP) + kmatrix(indM,3)*z0(indP);
        H(indP) = H(indP)+linear(indM)*exp(1j*innerPos);
    end
end
toc
%% Output
filename = strcat('/N',num2str(N),'.mat');
save(filename,'H','xspan','yspan','zspan','-v7.3')


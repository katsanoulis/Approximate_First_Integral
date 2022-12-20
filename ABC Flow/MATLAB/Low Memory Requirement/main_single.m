%% Reference:
%[1] S. Katsanoulis, F. Kogelbauer, S. Roshan, J. Ault & G. Haller. 
% Approximate streamsurfaces for flow visualization. Submitted.

%% Grid definition
k = 60; l = 60; m = 60;

xspan = single(linspace(0,2*pi,k));
yspan = single(linspace(0,2*pi,l));
zspan = single(linspace(0,2*pi,m));

[X,Y,Z] = ndgrid(xspan,yspan,zspan);

%% Order of modal truncation for the Fourier series
N = 11;
kmatrix = single(modaltrunc(N));
kmatrix(round(size(kmatrix,1)/2),:) = [];

%% Flow field definition
A = sqrt(3); B = sqrt(2); C = 1;

u1 = A*sin(Z) + C*cos(Y);
u2 = B*sin(X) + A*cos(Z);
u3 = C*sin(Y) + B*cos(X);

%% Solution of the eigenvalue problem for the coefficient matrix C as described in [1]
nPoints = length(X(:));
nModes = size(kmatrix,1);
Alpha = single(zeros(nPoints,nModes));

tic
for indP = 1:nPoints
    for indM = 1:nModes
        innerPos = kmatrix(indM,1)*X(indP) + kmatrix(indM,2)*Y(indP) + kmatrix(indM,3)*Z(indP);
        innerVel = kmatrix(indM,1)*u1(indP) + kmatrix(indM,2)*u2(indP) + kmatrix(indM,3)*u3(indP);
        Alpha(indP,indM) = exp(1j*innerPos)*innerVel;
    end
end
toc

tic
Alpha = Alpha'*Alpha;
toc

[linear,D] = eig(Alpha);

eive = linear(:,1);
linear = linear(:,1:10);
D = D(1:10,1:10);

%% First integral computation
tic
H = 0*X;
for indP = 1:nPoints
    for indM = 1:nModes
        innerPos = kmatrix(indM,1)*X(indP) + kmatrix(indM,2)*Y(indP) + kmatrix(indM,3)*Z(indP);
        coe = eive(indM)*exp(1j*innerPos);
        H(indP)  = H(indP)+coe;
    end
end
toc

%% Output
filename = strcat('/N',num2str(N),'_single.mat');
save(filename,'linear','D','H','xspan','yspan','zspan','-v7.3')

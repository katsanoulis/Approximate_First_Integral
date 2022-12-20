%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%              ____________________   ___           %%%%%%%%%%%%%
%%%%%%%%%%%             /  ________   ___   /__/  /           %%%%%%%%%%%%%
%%%%%%%%%%%            /  _____/  /  /  /  ___   /            %%%%%%%%%%%%%
%%%%%%%%%%%           /_______/  /__/  /__/  /__/             %%%%%%%%%%%%%
%%%%%%%%%%%    Swiss Federal Institute of Technology Zurich   %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  Author: Stergios Katsanoulis  %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  Email:  katsanos@ethz.ch      %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  Date:   24.01.2022            %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Order of modal truncation for the Fourier series
mode = 11;
%% Read computed first integral data
filename = strcat('N',num2str(mode),'_single.mat');
load(filename)

k = size(H,1); l = size(H,2); m = size(H,3);
[x0,y0,z0] = ndgrid(xspan,yspan,zspan);

%% Plot KAM surfaces

Hr = abs(H);
Hr = smooth3(Hr,'box',3);
isoValues = linspace(0.2,max(Hr(:)),50);

colors = {'r','y','g','b','c'};
figure()
hold on

verticesAll = [];
facesAll = [];

facesCounter = 0;
for ind = 1:length(isoValues)
    pInd = isosurface(x0,y0,z0,Hr,isoValues(ind));
    pIcell = struct2cell(pInd);
    verts = pIcell{1,1}; fcs = pIcell{2,1};
    verticesAll = vertcat(verticesAll,verts);
    facesAll = vertcat(facesAll,fcs+facesCounter);
    
    if ~isempty(pInd.faces)
        facesCounter = facesCounter + max(pInd.faces(:));
    end
    p = patch(pInd);
    p.FaceColor = colors{mod(ind,5)+1};
    p.EdgeColor = 'none';
    p.FaceVertexAlphaData = .5;    % Set constant transparency
    p.FaceAlpha = 'flat' ;
    hold on
end

set(gcf,'color','w');
xlabel('$$x$$','Interpreter','latex','FontWeight','bold','FontSize',28);
ylabel('$$y$$','Interpreter','latex','FontWeight','bold','FontSize',28);
zlabel('$$z$$','Interpreter','latex','FontWeight','bold','FontSize',28);
set(gcf, 'Position', [500, 500, 800, 800])
set(gca,'TickLabelInterpreter', 'latex');
set(gca,'FontSize',28,'fontWeight','normal');
view(-35,18)

FV.vertices = verticesAll;
FV.faces = facesAll;
    
%% Write STL file with structures for visualization on Paraview or rendering,
%% i.e., on Houdini or Blender
stlwrite('structures.stl',FV) % Save to binary .stl

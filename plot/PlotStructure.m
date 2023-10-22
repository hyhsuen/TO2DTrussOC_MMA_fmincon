function scale = PlotStructure(mesh,rho,D,stress)
% This subroutine plots the undeformed and deformed structure
% Plotting Un-Deformed and Deformed Structure
% Created ddmmyyyy 21/02/2023 by Ho Yuen Henry Suen  
% INPUTS:
% mesh:         structure
% rho：         design varible for truss = Area, vector
% D:            KD=P, the deformed structure, vector
% stress:       axial stress of the truss elements, vector  
% OUTPUT:
% scale         LineWidth, scalar
clf
hold on
box on

scale=3/max(rho);                                               % LineWidth

for e = 1:mesh.ne
    xx = mesh.X(mesh.IX(e,1:2),1);
    yy = mesh.X(mesh.IX(e,1:2),2);

    h1=plot(xx,yy,'k:','LineWidth',1.);

    edof = [2*mesh.IX(e,1)-1 2*mesh.IX(e,1) 2*mesh.IX(e,2)-1 2*mesh.IX(e,2)];
    xx = xx + D(edof(1:2:4));
    yy = yy + D(edof(2:2:4));

    linewidth=max(rho(e)*scale,0.01);

    if stress(e)>max(stress)*10e-5&&stress(e)>0
        h2=plot(xx,yy,'b','LineWidth',linewidth);
    elseif stress(e)<-max(stress)*10e-5
        h3=plot(xx,yy,'r','LineWidth',linewidth);
    else
        h4=plot(xx,yy,'g','LineWidth',linewidth);
    end
    % Plot nodes
    plot(xx,yy,'ko','MarkerSize',5,'LineWidth',3)
end

plotsupports
plotloads

if exist('h1','var') &&  exist('h2','var') && exist('h3','var') && exist('h4','var')
    legend([h1 h2 h3 h4],{'Undeformed state',...
        'Tension state','Compression state','Undeformed state'})
elseif exist('h2','var')
    legend([h1 h2],{'Undeformed state','Tension state'})
elseif exist('h2','var') && exist('h3','var')
    legend([h1 h2 h3],{'Undeformed state',...
        'Tension state','Compression state'})
elseif exist('h4','var')
    legend([h1 h4],{'Undeformed state','Undeformed state'})
else
    legend([h1 h3],{'Undeformed state','Compression state'})
end

axis equal
hold off
% drawnow
set(gca,'FontSize',14)
set(gcf,'Position',[100 100 800 800])
end

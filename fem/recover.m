function [strain,stress]=recover(mesh,rho,D,p)
% This subroutine recovers the element stress, element strain, 
% and nodal reaction forces
strain=zeros(mesh.ne,1);                     % Element strain vector
stress=zeros(mesh.ne,1);                     % Element stress vector
% Emin=1e-9; % Young modulus of truss with 0 cross section A area  
for e=1:mesh.ne
    Ee=mesh.mprop(mesh.IX(e,end),1);
    delta_x=mesh.X(mesh.IX(e,2),1)-mesh.X(mesh.IX(e,1),1);
    delta_y=mesh.X(mesh.IX(e,2),2)-mesh.X(mesh.IX(e,1),2);
    L0e=sqrt(delta_x^2+delta_y^2);
    B0=1/L0e^2*[-delta_x -delta_y delta_x delta_y];
    edof=[mesh.IX(e,1)*2-1 mesh.IX(e,1)*2 mesh.IX(e,2)*2-1 mesh.IX(e,2)*2];
    de=D(edof);
    strain(e)=B0*de;
    stress(e)=Ee*rho(e)^p*strain(e);
%     stress(e)=(Emin+rho(e)^p*(Ee-Emin))*strain(e);
end
end
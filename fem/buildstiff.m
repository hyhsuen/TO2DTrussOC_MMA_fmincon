function [K]=buildstiff(mesh,rho,p)
% This subroutine builds the global stiffness matrix from
% the local element stiffness matrices
Emin=1e-9; % Young modulus of truss with 0 cross section A area
K=sparse(mesh.neqn,mesh.neqn);                % Stiffness matrix
for e=1:mesh.ne
    Ee=mesh.mprop(mesh.IX(e,end),1);
    Ek_iterpo=Emin+rho(e)^p*(Ee-Emin);
    Ae=mesh.mprop(mesh.IX(e,end),2);
    delta_x=mesh.X(mesh.IX(e,2),1)-mesh.X(mesh.IX(e,1),1);
    delta_y=mesh.X(mesh.IX(e,2),2)-mesh.X(mesh.IX(e,1),2);
    L0e=sqrt(delta_x^2+delta_y^2);
    B0=1/L0e^2*[-delta_x -delta_y delta_x delta_y]';
    k=Ek_iterpo*Ae*L0e*B0*B0';
    edof=[mesh.IX(e,1)*2-1 mesh.IX(e,1)*2 mesh.IX(e,2)*2-1 mesh.IX(e,2)*2 ];
    K(edof,edof)=K(edof,edof)+k;    
end
% full(K)
end
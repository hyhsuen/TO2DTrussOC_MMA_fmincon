function [fval,dfval]=Truss2D_comp_obj_area(x0,mesh,fmincon_opt,p,P)
Emin=1e-9; % Young modulus of truss with 0 cross section A area
rho=x0;
dfval=zeros(mesh.ne,1);
fval=0;
% solve FEM
[Kmatr]=buildstiff(mesh,rho,p);             % Build global stiffness matrix
[Kmatr,P]=enforce(mesh,Kmatr,P);            % Enforce boundary conditions
D=Kmatr\P;
% iterate on all elements
for e=1:mesh.ne
    Ee=mesh.mprop(mesh.IX(e,end),1);
    Ae=mesh.mprop(mesh.IX(e,end),2);
    delta_x=mesh.X(mesh.IX(e,2),1)-mesh.X(mesh.IX(e,1),1);
    delta_y=mesh.X(mesh.IX(e,2),2)-mesh.X(mesh.IX(e,1),2);
    L0e=sqrt(delta_x^2+delta_y^2);
    B0=1/L0e^2*[-delta_x -delta_y delta_x delta_y]';
    edof=[mesh.IX(e,1)*2-1 mesh.IX(e,1)*2 mesh.IX(e,2)*2-1 mesh.IX(e,2)*2];
    de=D(edof);
    ke=Ae*L0e*B0*B0';
    fval=fval+(Emin+rho(e)^p*(Ee-Emin))*de'*ke*de; % objective value, compliance
    dfval(e)=-p*(Ee-Emin)*rho(e)^(p-1)*de'*ke*de;  % gradient df/d_rho
end

if strcmp(fmincon_opt.plotSwitch,'on')
    [~,stress]=recover(mesh,rho,D,p);              
    figure(1)
    scale=PlotStructure(mesh,rho,D,stress);
end

end
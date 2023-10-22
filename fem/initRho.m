function rho = initRho(mesh,Vmax)
% This subroutine initialize density vector to satisfied Vmax
v_in=0;
rho=zeros(mesh.ne,1);
for ii=1:mesh.ne
    Ae=mesh.mprop(mesh.IX(ii,end),2);
    delta_x=mesh.X(mesh.IX(ii,2),1)-mesh.X(mesh.IX(ii,1),1);
    delta_y=mesh.X(mesh.IX(ii,2),2)-mesh.X(mesh.IX(ii,1),2);
    L0e=sqrt(delta_x^2+delta_y^2);
    v_in=v_in+L0e*Ae;
end
rho(:,1)=Vmax/v_in;
if max(rho)>1
    warning(['### WARNING!! You can reduce given Vmax']);
end
end
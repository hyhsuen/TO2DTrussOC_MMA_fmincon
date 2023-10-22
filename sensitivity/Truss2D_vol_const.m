function [c,ceq,dc,dceq]=Truss2D_vol_const(x0,mesh,Vmax)
% works for both truss and beam
ceq=[];dceq=[];
rho=x0;
v=zeros(mesh.ne,1);
for e=1:mesh.ne
    Ae=mesh.mprop(mesh.IX(e,end),2);
    delta_x=mesh.X(mesh.IX(e,2),1)-mesh.X(mesh.IX(e,1),1);
    delta_y=mesh.X(mesh.IX(e,2),2)-mesh.X(mesh.IX(e,1),2);
    L0e=sqrt(delta_x^2+delta_y^2);
    v(e)=Ae*L0e;
end
c=v(:)'*rho(:)/Vmax-1;
dc=v/Vmax;
end
function [c,ceq,dc,dceq]=Truss2D_comp_const(x0,Cmax,fun)
% works for both truss and beam elements
ceq=[];dceq=[];
[fval,dfval]=fun(x0); % fun call: Truss2D_comp_obj_area(x0,mesh,fmincon_opt,p,P);
c=fval/Cmax-1;
dc=dfval/Cmax;
end
function [fval,dfval]=Truss2D_vol_obj_area(x0,Vmax,fun)

[c,~,dc,~]=fun(x0); % fun call: Truss2D_vol_const(x0,mesh,Vmax); 
fval = (c+1)*Vmax;
dfval = dc*Vmax;

end
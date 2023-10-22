%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Basis truss program                              %
%                   TO OC on cross section area A                         %
% Created ddmmyyyy 21/02/2023 by Ho Yuen Henry Suen                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;clc;

%--- Input file ----------------------------------------------------------%
addpath('mesh')
addpath('mesh/input_files')
addpath('plot')
addpath('fem')
addpath('solver')                    % containts mma and fmincon
addpath('sensitivity')               % Obj Constraint and their derivatives
%--- Input mesh ----------------------------------------------------------%
inputMesh='cantileverBeam';
[mesh] = StructMeshGenerator(inputMesh);
disp(['Number of DOF ' sprintf('%d',mesh.neqn) ...
    ' Number of elements ' sprintf('%d',mesh.ne)]);
%--- TO initialize -------------------------------------------------------%
f_obj=zeros(mesh.ne,1);
Vmax=30;                          % Max volume of total material use V=A*L
max_iopt=100;                     % max iteration allowed
p=2;                              % Penalizing factor
stop=10e-6;                       % Stopping criteria
fmincon_opt.plotSwitch='off';     % plot every iteration 
rho = initRho(mesh,Vmax);         % Initialize density satified volume constraint
[P]=buildload(mesh);              % Build global load vector
%--- TO loop -------------------------------------------------------------%
tic % Start timing
for i=1:max_iopt
    rho_old=rho;
    % Obj. and Cont. with sen respect to design varible rho
    [f,df_dr]=Truss2D_comp_obj_area(rho,mesh,fmincon_opt,p,P);
    [c,ceq,dg_dr,dceq]=Truss2D_vol_const(rho,mesh,Vmax);

    f_obj(i)=f;                   % Stored value for plotting
    % Update design varible based on sensitivity
    rho=bisect(rho_old,Vmax,df_dr,dg_dr*Vmax,mesh.ne);

    if norm(rho_old-rho)<stop*norm(rho) % Stopping condition
        break
    end
end
toc % End timing
%--- Post processing -----------------------------------------------------%
% Calculating stress on each element, based on deformaion D
[Kmatr]=buildstiff(mesh,rho,p);             % Build global stiffness matrix
[Kmatr,P]=enforce(mesh,Kmatr,P);            % Enforce boundary conditions
D=Kmatr\P;                                  % Solve system of equations
[strain,stress]=recover(mesh,rho,D,p);      % Calculate element SS

figure(1) % Plot structure
PlotStructure(mesh,rho,D,stress);
figure(2) % Plot objective history
plot(1:size(f_obj,1),f_obj,'-o','LineWidth',1.5)
xlabel('Iter.');
ylabel('Obj.');

%%% bi section method %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rho]=bisect(rho_old,Vmax,df_dr,dg_dr,ne)
stop=10e-6;
lambda1=10e-10;
lambda2=10e10;
rho_min=10e-6;
damping_coeff=0.5;
rho=zeros(ne,1);

while (lambda2-lambda1)/(lambda1+lambda2)>stop
    lambda_mid=(lambda1+lambda2)/2;

    Be= -df_dr./(lambda_mid.*dg_dr);
    rho=rho_old.*Be.^damping_coeff;
    rho(rho<=rho_min)=rho_min;
    rho(rho>=1)=1;

    if rho'*dg_dr-Vmax>0
        lambda1= lambda_mid;
    else
        lambda2= lambda_mid;
    end

end
end



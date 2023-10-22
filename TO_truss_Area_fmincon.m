%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Basis truss program                              %
%                 TO fmincon on cross section area A                      %
% Created ddmmyyyy 21/02/2023 by Ho Yuen Henry Suen                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;clc;

%--- Input file ----------------------------------------------------------%
addpath('mesh')
addpath('mesh/input_files')
addpath('plot')
addpath('fem')
addpath('solver')          % containts mma and fmincon
addpath('sensitivity')     % containts obj constraint and their derivatives
%--- Input mesh ----------------------------------------------------------%
inputMesh='cantileverBeam';
[mesh] = StructMeshGenerator(inputMesh);
disp(['### Number of DOF ' sprintf('%d',mesh.neqn) ...
    ' Number of elements ' sprintf('%d',mesh.ne)]);
%--- fmincon initialize --------------------------------------------------%
fmincon_opt.algorithm='interior-point'; % sqp, active-set, interior-point
fmincon_opt.max_iopt=100;               % max iteration allowed
fmincon_opt.stop_tol=10e-6;             % Stopping criteria
fmincon_opt.gradSwitch='on';            % user provide sensitivity 'on'; 
fmincon_opt.plotSwitch='on';            % plot every iteration 
fmincon_opt.CheckGradSwitch='off';      % fmincon build in FD check, turn it off if value is small
fmincon_opt.fast='off';                 % do not print out in command window iter etc..
%--- TO initialize -------------------------------------------------------%
optDef=1;                               % 1 obj:compliance, 2 obj:volume
p=2;                                    % penalizing factor
Vmax=30;                                % max volumn of total material use V=A*L;
Cmax=3.18;                              % max compliance, run comp_obj first to get
rho = initRho(mesh,Vmax);               % Initialize density satified volume constraint
[P]=buildload(mesh);                    % Build global load vector
% base on element, objective and constraint type
if optDef==1
disp(['### Obj: min Comp, s.t.: Vol<=Vmax'])
fun=@(x0)Truss2D_comp_obj_area(x0,mesh,fmincon_opt,p,P);                   % Obj. with sen
nonlcon=@(x0)Truss2D_vol_const(x0,mesh,Vmax);                              % Const. with sen
else
disp(['### Obj: min Vol, s.t.: Comp<=Cmax'])
fun1=@(x0)Truss2D_comp_obj_area(x0,mesh,fmincon_opt,p,P);           
nonlcon1=@(x0)Truss2D_vol_const(x0,mesh,Vmax);  
fun=@(x0)Truss2D_vol_obj_area(x0,Vmax,nonlcon1);                           % Obj. with sen
nonlcon=@(x0)Truss2D_comp_const(x0,Cmax,fun1);                             % Const. with sen
end
%--- run TO with fmincon -------------------------------------------------%
lb=ones(mesh.ne,1)*1e-6;                % lower bounds for design varible, vector
ub=ones(mesh.ne,1);                     % upper bounds for design varible, vector
tic % Start timing
[ history ]= fminconMain(fun,nonlcon,rho,lb,ub,fmincon_opt);
toc % End timing
%--- Post processing -----------------------------------------------------%
rho=history.xe(:,end);
[Kmatr]=buildstiff(mesh,rho,p);         % Build global stiffness matrix
[Kmatr,P]=enforce(mesh,Kmatr,P);        % Enforce boundary conditions
D=Kmatr\P;                              % Solve system of equations
[strain,stress]=recover(mesh,rho,D,p);  % Calculate element

figure(1) % Plot structure
PlotStructure(mesh,rho,D,stress,1) 
figure(2)
plot(history.it,history.fval,'-o','LineWidth',1.5)
xlabel('Iter.');
ylabel('Obj.');










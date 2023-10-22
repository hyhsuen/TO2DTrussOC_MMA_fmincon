%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Basis truss program                              %
%                   TO MMA on cross section area A                        %
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
disp(['Number of DOF ' sprintf('%d',mesh.neqn) ...
    ' Number of elements ' sprintf('%d',mesh.ne)]);
%--- TO initialize -------------------------------------------------------%
optDef=1;                               % 1 obj:compliance, 2 obj:volume
p=2;                                    % penalizing factor
Vmax=30;                                % max volumn of total material use V=A*L;
Cmax=0.0027;                            % max compliance, run comp_obj first to get
stop=10e-6;                             % Stopping criteria
max_iopt=100;                           % max iteration allowed
loop=0;change=1;
fmincon_opt.plotSwitch='on';
rho = initRho(mesh,Vmax);               % Initialize density satified volume constraint
[P]=buildload(mesh);                    % Build global load vector

% INITIALIZE MMA OPTIMIZER DESIGN UPDATE BY THE MMA METHOD
m     = 1;                % The number of general constraints. Volumn constrain
n     = mesh.ne;          % The number of design variables x_j.
xmin  = ones(n,1)*1e-6;   % Column vector with the lower bounds for the variables x_j.
xmax  = ones(n,1);        % Column vector with the upper bounds for the variables x_j.
xold1 = rho(:);           % xval, one iteration ago (provided that iter>1).
xold2 = rho(:);           % xval, two iterations ago (provided that iter>2).
low   = [  ];             % Column vector with the lower asymptotes from the previous iteration (provided that iter>1).
upp   = [  ];             % Column vector with the upper asymptotes from the previous iteration (provided that iter>1).
a0    = 1;                % The constants a_0 in the term a_0*z.
a     = zeros(m,1);       % Column vector with the constants a_i in the terms a_i*z.
c_MMA = 1000*ones(m,1);   % Column vector with the constants c_i in the terms c_i*y_i.
d     = zeros(m,1);       % Column vector with the constants d_i in the terms 0.5*d_i*(y_i)^2.
move  = 0.1;              % Move limit for each variables x_j.

if optDef==1
    disp(['### Obj: min Comp, s.t.: Vol<=Vmax'])
    fun=@(x0)Truss2D_comp_obj_area(x0,mesh,fmincon_opt,p,P);               % Obj. with sen
    nonlcon=@(x0)Truss2D_vol_const(x0,mesh,Vmax);                          % Const. with sen
else
    disp(['### Obj: min Vol, s.t.: Comp<=Cmax'])
    fun1=@(x0)Truss2D_comp_obj_area(x0,mesh,fmincon_opt,p,P);
    nonlcon1=@(x0)Truss2D_vol_const(x0,mesh,Vmax);
    fun=@(x0)Truss2D_vol_obj_area(x0,Vmax,nonlcon1);                       % Obj. with sen
    nonlcon=@(x0)Truss2D_comp_const(x0,Cmax,fun1);                         % Const. with sen
end

%TO loop
tic
while loop<=max_iopt && change>stop
    loop=loop+1;
    [f,dfval]=fun(rho);
    [c,~,dc,~]=nonlcon(rho);
    f_obj(loop)=f;

    % METHOD OF MOVING ASYMPTOTES
    xmin = max( rho(:) - move, 0 );
    xmax = min( rho(:) + move, 1 );
    f0val = f;                                 % scalar
    df0dx = dfval;                             % column
    fval  = c;                                 % scalar volumn constrain
    dfdx  = dc';                               % row
    [ xmma, ~, ~, ~, ~, ~, ~, ~, ~, low, upp ] = ...
        mmasub( m, n, loop, rho(:), xmin, xmax, xold1, xold2, f0val,df0dx,fval,dfdx,low,upp,a0,a,c_MMA,d);
    % Update MMA Variables
    xold2    = xold1(:);
    xold1    = rho(:);
    rho      = xmma;
    change = abs(sum(rho(:))-sum(xold1(:)));
    % PRINT RESULTS
    fprintf(' It.:%5i Obj.:%11.4f Vol.:%7.3f ch.:%7.3f\n',loop,f, ...
        dfdx*rho(:)*Vmax,change);

end
toc
[Kmatr]=buildstiff(mesh,rho,p);                % Build global stiffness matrix
[Kmatr,P]=enforce(mesh,Kmatr,P);               % Enforce boundary conditions
D=Kmatr\P;                                     % Solve system of equations
[strain,stress]=recover(mesh,rho,D,p);         % Calculate element

figure(1)
PlotStructure(mesh,rho,D,stress)
figure(2)
plot(1:length(f_obj),f_obj,'-o','LineWidth',1.5)
xlabel('Iter.');
ylabel('Obj.');

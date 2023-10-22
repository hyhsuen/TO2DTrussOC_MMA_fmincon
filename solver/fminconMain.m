function [ history ]= fminconMain(fun,nonlcon,x0,lb,ub,fmincon_opt)
% fmincon function calling with history output
% Created ddmmyyyy 21/02/2023 by Ho Yuen Henry Suen   
%
% INPUTS:
% fun:           autonomous function for objective and its derivative
% nonlcon:       autonomous function for constraints and its derivative
% x0:            initial value for design varibles, vector
% lb:            lower bounds for design varible, vector
% ub:            upper bounds for design varible, vector
% fmincon_opt:   options for selecting following
% fmincon_opt.gradSwitch='on','off'; on: use provided sensitivity 
% off: automatic compute sensitivity use Finite Difference (FD) Methods                   
% fmincon_opt.plotSwitch='on','off'; Plot every iteration   
% fmincon_opt.CheckGradSwitch='on','off'; FD check on 1st iteration    
% fmincon_opt.fast='on','off'; Output message in Command Window
%
% OUTPUT:
% "history" structure with fields:
% fval:         Objective function value
% it:           Iteration
% xe:           Design varibles
%
% reference: Structural optimization Week2 Lecture notes 
% Fengwen Wang, Ole Sigmund DTU

%--- Function start ------------------------------------------------------%
% A =[A]; b = [Vmax]; 
A=[];b=[];
Aeq = []; beq = [];
history.it = []; history.fval = []; history.xe = [];

if strcmp(fmincon_opt.gradSwitch,'on')
    disp('### fmincon with gradient');
    fmincon_opt.gradSwitch=true;
else
    disp('### fmincon without gradient');
    fmincon_opt.gradSwitch=false;
end

if strcmp(fmincon_opt.CheckGradSwitch,'on')
    fmincon_opt.CheckGradSwitch=true;
else
    fmincon_opt.CheckGradSwitch=false;
end

if strcmp(fmincon_opt.fast,'on')
    options = optimoptions ('fmincon','OutputFcn',@outfun,'Algorithm',...
    fmincon_opt.algorithm, 'MaxIterations' ,fmincon_opt.max_iopt , ...
    'MaxFunctionEvaluations', 2e4 , 'StepTolerance' ,fmincon_opt.stop_tol, ...
    'FunctionTolerance' ,fmincon_opt.stop_tol, 'SpecifyObjectiveGradient',fmincon_opt.gradSwitch, ...
    'SpecifyConstraintGradient',fmincon_opt.gradSwitch,'CheckGradients',fmincon_opt.CheckGradSwitch);

else
    options = optimoptions ('fmincon','OutputFcn',@outfun,'Display','iter','Algorithm',...
    fmincon_opt.algorithm, 'MaxIterations' ,fmincon_opt.max_iopt , ...
    'MaxFunctionEvaluations', 2e4 , 'StepTolerance' ,fmincon_opt.stop_tol, ...
    'FunctionTolerance' ,fmincon_opt.stop_tol, 'SpecifyObjectiveGradient',fmincon_opt.gradSwitch, ...
    'SpecifyConstraintGradient',fmincon_opt.gradSwitch,'CheckGradients',fmincon_opt.CheckGradSwitch);

end

[~,~] = fmincon (fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);  % CALL fmincon
    
% x and output is include in the history, x is history.xe(end,:), output
% is history.fval(end)
    function stop = outfun (xe,optimValues,state)
            stop = false;
        switch state
            case 'iter'
                history.fval = [ history.fval ; optimValues.fval ];
                history.it = [ history.it; optimValues.iteration ];
                history.xe = [ history.xe,xe ];
            otherwise
        end
    end
end

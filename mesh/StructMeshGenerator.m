function [mesh] = StructMeshGenerator(inputMesh)
% Simple, structured mesh generator
% Created ddmmyyyy 21/02/2023 by Ho Yuen Henry Suen                       
%
% INPUTS:
% inputMesh:    mesh file name
%
% OUTPUT:
% "mesh" structure with fields:
% type:         truss or beam
% X:            nodal coordinates
% IX:           topology table
% mprop:        truss: [E A], beam [E]
% bound:        list of BCs
% loads:        list of loads
% free:         free Dofs for the system

%--- Function start ------------------------------------------------------%
% Load mesh data
run(inputMesh);

% Derived data
mesh.neqn = size(X,1)*size(X,2);         % Number of equations
mesh.ne = size(IX,1);                    % Number of elements
mesh.nn = size(X,1);                     % Number of nodes

% Transfer mesh data
mesh.X = X;
mesh.IX = IX;
mesh.mprop = mprop;
mesh.bound = bound;
mesh.loads = loads;
mesh.inputMesh = inputMesh;

% record the freeDofs
if size(mesh.X,2)==2 % check for truss ele
    disp(['### -',inputMesh,'- is a Truss structure']);
    mesh.type = 'truss';
    for i = 1 : size( mesh.bound, 1 )
        fixDof(i) = ( mesh.bound( i, 1 ) - 1 ) * 2 + mesh.bound( i, 2 ); % all the fixed dofs
    end
    mesh.free = setdiff(1:mesh.neqn,fixDof); % free dofs
elseif size(mesh.X,2)==3 % check for beam ele
    disp(['### -',inputMesh,'- is a Beam structure']);
    mesh.type = 'beam';
    for i = 1 : size( mesh.bound, 1 )
        fixDof(i) = ( mesh.bound( i, 1 ) - 1 ) * 3 + mesh.bound( i, 2 ); % all the fixed dofs
    end
    mesh.free = setdiff(1:mesh.neqn,fixDof); % free dofs
else
    warning('### Use Truss or Beam please')
end

end
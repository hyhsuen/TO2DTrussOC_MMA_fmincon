function [P]=buildload(mesh)
% This subroutine builds the global load vector
P=zeros(mesh.neqn,1);
for i=1:size(mesh.loads,1)
    P((mesh.loads(i,1)-1)*2+mesh.loads(i,2),1)=mesh.loads(i,3);
end
end
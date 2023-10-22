function [K,P]=enforce(mesh,K,P)
% This subroutine enforces the support boundary conditions
for i=1:size(mesh.bound,1)
    K((mesh.bound(i,1)-1)*2+mesh.bound(i,2),:)=0;
    K(:,(mesh.bound(i,1)-1)*2+mesh.bound(i,2))=0;
    K((mesh.bound(i,1)-1)*2+mesh.bound(i,2),(mesh.bound(i,1)-1)*2+mesh.bound(i,2))=1;
    P((mesh.bound(i,1)-1)*2+mesh.bound(i,2),:)=mesh.bound(i,3);
end
% full(K)
end
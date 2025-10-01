function [sinogram, theta] = forward_projection(obj, numAngles)
if nargin<2, numAngles = 180; end
[M,N] = size(obj);
theta = linspace(0,179,numAngles);
projLen = max(M,N);
sinogram = zeros(projLen, numAngles);
pad = max(M,N);
padObj = zeros(pad,pad);
startR = floor((pad-M)/2)+1; startC = floor((pad-N)/2)+1;
padObj(startR:startR+M-1, startC:startC+N-1) = obj;
for i = 1:numAngles
    ang = theta(i);
    R = imrotate(padObj, -ang, 'bilinear', 'crop');
    sinogram(:,i) = sum(R,2);
end
sinogram = sinogram(1:pad, :);
end
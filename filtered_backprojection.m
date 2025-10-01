function recon = filtered_backprojection(sinogram, theta, outSize)
[projLen, numAngles] = size(sinogram);
if nargin<3, outSize = projLen; end
n = (0:projLen-1) - floor(projLen/2);
omega = 2*pi*n/projLen;
H = abs(omega);
H = fftshift(H);
filtSin = zeros(size(sinogram));
for i=1:numAngles
    P = fft(sinogram(:,i));
    P = P .* H(:);
    pf = real(ifft(P));
    filtSin(:,i) = pf;
end
recon = zeros(outSize,outSize);
for i = 1:numAngles
    ang = theta(i);
    projRep = repmat(filtSin(:,i), 1, projLen);
    back = imrotate(projRep, ang, 'bilinear', 'crop');
    recon = recon + back(1:outSize,1:outSize);
end
recon = recon * (pi/(2*numAngles));
end
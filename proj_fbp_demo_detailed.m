function [sinogram, theta, recon_fbp, obj, stats] = proj_fbp_demo_detailed()
N = 256;
obj = false(N,N);
[x,y] = meshgrid(1:N,1:N);
cx = (N+1)/2; cy = (N+1)/2; r = 60;
obj(((x-cx).^2+(y-cy).^2) <= r^2) = true;
numAngles = 180;
[sinogram, theta] = forward_projection(double(obj), numAngles);
recon_fbp = filtered_backprojection(sinogram, theta, N);
obj_f = mat2gray(obj);
recon_f = mat2gray(recon_fbp);
mse_val = mean((obj_f(:) - recon_f(:)).^2);
try, psnr_val = psnr(recon_f, obj_f); catch, psnr_val = NaN; end
try, ssim_val = ssim(recon_f, obj_f); catch, ssim_val = NaN; end
stats.mse = mse_val; stats.psnr = psnr_val; stats.ssim = ssim_val;
stats.summary = sprintf('FBP recon: MSE=%.6f, PSNR=%.2f dB, SSIM=%.4f', mse_val, psnr_val, ssim_val);
figure('Name','Part4.2 - Object, Sinogram, Reconstruction','NumberTitle','off');
subplot(1,3,1); imshow(obj_f); title('Original Object (disc)');
subplot(1,3,2); imshow(mat2gray(sinogram)); title('Sinogram (180 angles)');
subplot(1,3,3); imshow(recon_f, []); title('FBP Reconstruction');
end
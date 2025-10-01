function [sharp_rgb_uint8, sharp_hsv_uint8, diff_img, stats] = laplace_sharpen_detailed(I_color)
I = im2double(I_color);
lap = [0 -1 0; -1 4 -1; 0 -1 0];
sharp_rgb = zeros(size(I));
for c=1:3
    L = imfilter(I(:,:,c), lap, 'replicate');
    tmp = I(:,:,c)+L;
    sharp_rgb(:,:,c)=min(max(tmp,0),1);
end
sharp_rgb_uint8 = im2uint8(sharp_rgb);
HSV = rgb2hsv(I);
V = HSV(:,:,3);
L = imfilter(V,lap,'replicate');
V_sharp = min(max(V+L,0),1);
HSV(:,:,3)=V_sharp;
sharp_hsv = hsv2rgb(HSV);
sharp_hsv_uint8 = im2uint8(sharp_hsv);
diff_img = abs(double(sharp_rgb_uint8)/255 - double(sharp_hsv_uint8)/255);
diff_img = mean(diff_img,3);
orig=mat2gray(I);
mse_rgb=mean((orig(:)-sharp_rgb(:)).^2);
mse_hsv=mean((orig(:)-sharp_hsv(:)).^2);
try, psnr_rgb=psnr(sharp_rgb,orig); psnr_hsv=psnr(sharp_hsv,orig); catch, psnr_rgb=NaN; psnr_hsv=NaN; end
try, ssim_rgb=ssim(sharp_rgb,orig); ssim_hsv=ssim(sharp_hsv,orig); catch, ssim_rgb=NaN; ssim_hsv=NaN; end
stats.mse_rgb=mse_rgb; stats.mse_hsv=mse_hsv;
stats.psnr_rgb=psnr_rgb; stats.psnr_hsv=psnr_hsv;
stats.ssim_rgb=ssim_rgb; stats.ssim_hsv=ssim_hsv;
stats.summary=sprintf('Sharpen: MSE(RGB)=%.6f MSE(HSV)=%.6f | PSNR(RGB)=%.2f PSNR(HSV)=%.2f | SSIM(RGB)=%.4f SSIM(HSV)=%.4f',...
    mse_rgb,mse_hsv,psnr_rgb,psnr_hsv,ssim_rgb,ssim_hsv);
figure('Name','Part4.3 - Original / Sharp RGB / Sharp HSV / Diff','NumberTitle','off');
subplot(1,4,1); imshow(orig); title('Original');
subplot(1,4,2); imshow(sharp_rgb); title('Sharpen RGB (clipped)');
subplot(1,4,3); imshow(sharp_hsv); title('Sharpen HSV (clipped)');
subplot(1,4,4); imshow(diff_img); title('Abs difference');
end
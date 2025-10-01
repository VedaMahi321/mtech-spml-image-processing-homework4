function [restored_rgb, degraded_rgb, psf, stats] = wiener_restoration_detailed(I_color, k, noise_var)
if nargin < 2 || isempty(k), k = 2.5e-4; end
if nargin < 3 || isempty(noise_var), noise_var = 0.001; end

I_color = im2double(I_color);
[M,N,~] = size(I_color);

[u,v] = meshgrid((-floor(N/2)):(ceil(N/2)-1), (-floor(M/2)):(ceil(M/2)-1));
D2 = u.^2 + v.^2;
H = exp(-k * (D2).^(5/6));
H = ifftshift(H);

psf = abs(ifft2(H));
psf = psf / sum(psf(:));

degraded_rgb = zeros(size(I_color));
restored_rgb = zeros(size(I_color));

psnr_ch = zeros(1,3); ssim_ch = zeros(1,3); mse_ch = zeros(1,3);

for c=1:3
    orig = I_color(:,:,c);
    F = fft2(orig);
    G = H .* F;
    g = real(ifft2(G));
    g_noisy = g + sqrt(noise_var)*randn(size(g));
    degraded_rgb(:,:,c) = min(max(g_noisy,0),1);

    Sxx = abs(F).^2;
    Snn = noise_var * ones(size(Sxx));
    W = conj(H) ./ (abs(H).^2 + (Snn ./ (Sxx + eps)));
    F_hat = W .* fft2(g_noisy);
    f_hat = real(ifft2(F_hat));
    f_hat_clipped = min(max(f_hat,0),1);
    restored_rgb(:,:,c) = f_hat_clipped;

    orig_norm = mat2gray(orig);
    restored_norm = f_hat_clipped;
    mse_ch(c) = mean((orig_norm(:)-restored_norm(:)).^2);
    try, psnr_ch(c)=psnr(restored_norm,orig_norm); catch, psnr_ch(c)=10*log10(1/(mse_ch(c)+eps)); end
    try, ssim_ch(c)=ssim(restored_norm,orig_norm); catch, ssim_ch(c)=NaN; end
end

orig_rgb = mat2gray(I_color);
mse_overall = mean((orig_rgb(:)-restored_rgb(:)).^2);
try, psnr_overall = psnr(restored_rgb,orig_rgb); catch, psnr_overall=10*log10(1/(mse_overall+eps)); end
try, ssim_overall = ssim(restored_rgb,orig_rgb); catch, ssim_overall=NaN; end

stats.psnr_channel=psnr_ch; stats.ssim_channel=ssim_ch; stats.mse_channel=mse_ch;
stats.psnr_overall=psnr_overall; stats.ssim_overall=ssim_overall; stats.mse_overall=mse_overall;
stats.summary = sprintf('Wiener restore: PSNR ch [%.2f %.2f %.2f], overall=%.2f dB, SSIM=%.4f, MSE=%.6f',...
    psnr_ch(1),psnr_ch(2),psnr_ch(3),psnr_overall,ssim_overall,mse_overall);

try
    figure('Name','Part4.1 - Original / Degraded / Restored','NumberTitle','off');
    subplot(1,3,1); imshow(orig_rgb); title('Original (input)');
    subplot(1,3,2); imshow(degraded_rgb); title('Degraded (blur+noise)');
    subplot(1,3,3); imshow(restored_rgb); title('Restored (Wiener)');
end
end
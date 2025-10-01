% run_all_hw4_detailed.m
% Driver that runs Parts 4.1, 4.2 and 4.3 and prints/saves detailed outputs.
clear; close all; clc;
addpath(pwd);

logfile = 'hw4_detailed_log.txt';
if exist(logfile,'file'), delete(logfile); end
logf = fopen(logfile,'a');
fprintf(logf, 'HW4 Detailed Run Log\nDate: %s\n\n', datestr(now));
fprintf('HW4 Detailed Run\nDate: %s\n\n', datestr(now));

%% Input image (color)
imgName = 'sample_color.png'; % change if needed
if ~exist(imgName,'file')
    error('Input image sample_color.jpg not found in current folder.');
end
I_color = im2double(imread(imgName));
if size(I_color,3)==1
    I_color = repmat(I_color,[1 1 3]);
end

%% PART 4.1: Wiener restoration (detailed)
fprintf('\n---- Part 4.1: Wiener restoration ----\n');
fprintf(logf, '---- Part 4.1: Wiener restoration ----\n');
k = 2.5e-4; % updated turbulence parameter default
noise_var = 0.001; % updated noise variance default
[restored_rgb, degraded_rgb, psf, stats4_1] = wiener_restoration_detailed(I_color, k, noise_var);

% save outputs
imwrite(degraded_rgb, 'part4_1_degraded.png');
imwrite(restored_rgb, 'part4_1_restored_wiener.png');
imwrite(mat2gray(psf), 'part4_1_psf.png');

% log metrics
fprintf('Part4.1 metrics (per-channel and overall):\n');
fprintf(logf,'Part4.1 metrics (per-channel and overall):\n');
disp(stats4_1);
fprintf(logf, '%s\n\n', stats4_1.summary);

%% PART 4.2: Projection & Filtered Backprojection (detailed)
fprintf('\n---- Part 4.2: Projection & FBP ----\n');
fprintf(logf, '---- Part 4.2: Projection & FBP ----\n');

[sinogram, theta, recon_fbp, obj, stats4_2] = proj_fbp_demo_detailed();

% save outputs
imwrite(mat2gray(obj), 'part4_2_object.png');
imwrite(mat2gray(sinogram), 'part4_2_sinogram.png');
imwrite(mat2gray(recon_fbp), 'part4_2_recon_fbp.png');

% log metrics
fprintf('Part4.2 metrics:\n');
fprintf(logf,'Part4.2 metrics:\n');
disp(stats4_2);
fprintf(logf, '%s\n\n', stats4_2.summary);

%% PART 4.3: Laplacian sharpening (detailed)
fprintf('\n---- Part 4.3: Laplacian sharpening ----\n');
fprintf(logf, '---- Part 4.3: Laplacian sharpening ----\n');

[sharp_rgb, sharp_hsv, diff_img, stats4_3] = laplace_sharpen_detailed(I_color);

% save outputs
imwrite(sharp_rgb, 'part4_3_sharp_rgb.png');
imwrite(sharp_hsv, 'part4_3_sharp_hsv.png');
imwrite(mat2gray(diff_img), 'part4_3_difference.png');

% log metrics
fprintf('Part4.3 metrics:\n');
fprintf(logf,'Part4.3 metrics:\n');
disp(stats4_3);
fprintf(logf, '%s\n\n', stats4_3.summary);

fclose(logf);
fprintf('\nRun complete. See generated PNGs and hw4_detailed_log.txt\n');

clc; clear; close all;

%% Step 1: Load Damaged Image and Mask
img = imread('test_img.jpg'); % Color damaged image
manual_mask = imread('mask7.jpg'); % Binary mask (white = damaged)

% Convert manual mask to binary
manual_mask = imbinarize(rgb2gray(manual_mask));

% Auto-generate mask using edge detection (optional)
gray_img = rgb2gray(img);
edges = edge(gray_img, 'Canny');
se = strel('disk', 2);
auto_mask = imdilate(edges, se); % automatic mask

%% Step 2: PDE-based Inpainting (regionfill)
pde_img = img;
for c = 1:3
    channel = im2double(img(:,:,c));
    filled = regionfill(channel, manual_mask);
    pde_img(:,:,c) = im2uint8(filled);
end

%% Step 3: Exemplar-based Inpainting (inpaintCoherent)
% This function works best on grayscale; we'll apply to color channels
exemplar_img = img;
for c = 1:3
    exemplar_img(:,:,c) = inpaintCoherent(img(:,:,c), manual_mask);
end

%% Step 4: Color Enhancement
enhanced_img = im2double(pde_img);
enhanced_img = imadjust(enhanced_img, stretchlim(enhanced_img), []);

%% Step 5: Denoising using Non-Local Means
denoised_img = imnlmfilt(pde_img);

%% Step 6: PSNR and SSIM (optional if ground truth available)
% If you have the original (undamaged) image for comparison:
% original_img = imread('original.jpg');
% psnr_val = psnr(pde_img, original_img);
% ssim_val = ssim(pde_img, original_img);

%% Step 7: Show All Results
figure('Name', 'Restoration Comparison', 'Position', [100 100 1200 700]);

subplot(2,3,1);
imshow(img);
title('Original Damaged Image');

subplot(2,3,2);
imshow(manual_mask);
title('Manual Mask');

subplot(2,3,3);
imshow(auto_mask);
title('Auto-detected Mask');

subplot(2,3,4);
imshow(pde_img);
title('PDE-Based Inpainting');

subplot(2,3,5);
imshow(exemplar_img);
title('Exemplar-Based Inpainting');

subplot(2,3,6);
imshow(denoised_img);
title('Denoised Result');

figure;
imshow(enhanced_img);
title('Color Enhanced PDE Result');


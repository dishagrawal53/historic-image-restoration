
clc; 
clear; 
close all;

% Load image
img = imread('test_img.jpg');
gray = rgb2gray(img);
img_double = im2double(img);

% Resize if large
if max(size(gray)) > 800
    img = imresize(img, 0.5);
    gray = rgb2gray(img);
    img_double = im2double(img);
end

%% Step 1: Create Better Mask for Damaged Regions

% 1. Morphological top-hat to extract small bright spots (like cracks)
tophat = imtophat(gray, strel('disk', 10));
tophat_mask = imbinarize(tophat, 0.15);  % Detect bright irregularities

% 2. Suppress edges from figures using gradient magnitude
[~, Gmag] = imgradient(gray);
edge_suppress = Gmag < 30;  % remove strong gradients (likely actual content)

% 3. Combine with light saliency (difference from median)
saliency = imabsdiff(gray, medfilt2(gray, [21 21]));
saliency_mask = imbinarize(saliency, 0.1);

% Final rough mask
rough_mask = (tophat_mask & edge_suppress) | saliency_mask;

% Clean it up
se = strel('disk', 2);
clean_mask = imclose(rough_mask, se);
clean_mask = imfill(clean_mask, 'holes');
clean_mask = bwareaopen(clean_mask, 150);  % remove very small bits
clean_mask=~clean_mask
%% Step 2: PDE-Based Inpainting
pde_result = img;
for c = 1:3
    chan = im2double(img(:,:,c));
    filled = regionfill(chan, clean_mask);
    pde_result(:,:,c) = im2uint8(filled);
end

%% Step 3: Enhancement (Optional)
enhanced_result = imadjust(im2double(pde_result), stretchlim(im2double(pde_result)), []);
denoised_result = imnlmfilt(pde_result);

%% Display All Results
figure('Name','Historical Restoration','Position',[100 100 1200 700]);

subplot(2,3,1); imshow(img); title('Original Image');
subplot(2,3,2); imshow(clean_mask); title('Smart Auto-Mask');
subplot(2,3,3); imshow(pde_result); title('PDE Inpainted');
subplot(2,3,4); imshow(denoised_result); title('Denoised Inpainted');
subplot(2,3,5); imshow(enhanced_result); title('Enhanced Result');



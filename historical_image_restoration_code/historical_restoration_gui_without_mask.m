function historical_restoration_gui_without_mask()
    % Create a figure window for the GUI
    fig = uifigure('Name', 'Historical Restoration GUI', 'Position', [100, 100, 1000, 600]);

    % Add a button for loading the damaged image
    uibutton(fig, 'Text', 'Load Image', 'Position', [50, 550, 150, 30], ...
        'ButtonPushedFcn', @(btn, event) load_image(fig));

    % Add a button for applying PDE Inpainting
    uibutton(fig, 'Text', 'Apply Inpainting', 'Position', [250, 550, 150, 30], ...
        'ButtonPushedFcn', @(btn, event) apply_inpainting(fig));

    % Add a button for displaying results
    uibutton(fig, 'Text', 'Show Results', 'Position', [450, 550, 150, 30], ...
        'ButtonPushedFcn', @(btn, event) show_results(fig));

    % Create axes for displaying images
    ax1 = axes(fig, 'Position', [0.05, 0.1, 0.28, 0.4]); % Original Image
    ax2 = axes(fig, 'Position', [0.35, 0.1, 0.28, 0.4]); % Smart Auto-Mask
    ax3 = axes(fig, 'Position', [0.65, 0.1, 0.28, 0.4]); % PDE Inpainted Image
    ax4 = axes(fig, 'Position', [0.05, 0.55, 0.28, 0.4]); % Denoised Image
    ax5 = axes(fig, 'Position', [0.35, 0.55, 0.28, 0.4]); % Enhanced Image

    % Initialize variables for storing images
    img = [];
    clean_mask = [];
    pde_result = [];
    denoised_result = [];
    enhanced_result = [];

    % Load the image
    function load_image(fig)
        [filename, pathname] = uigetfile({'*.jpg;*.png', 'Image Files (*.jpg, *.png)'}, 'Select Image');
        if isequal(filename, 0)
            return;
        end
        img = imread(fullfile(pathname, filename));
        gray = rgb2gray(img);
        img_double = im2double(img);

        % Resize if large
        if max(size(gray)) > 800
            img = imresize(img, 0.5);
            gray = rgb2gray(img);
            img_double = im2double(img);
        end

        imshow(img, 'Parent', ax1);
        title(ax1, 'Original Image');
    end

    % Apply PDE Inpainting
    function apply_inpainting(fig)
        if isempty(img)
            uialert(fig, 'Please load an image first.', 'Error');
            return;
        end

        gray = rgb2gray(img);
        img_double = im2double(img);

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
        clean_mask = ~clean_mask;

        imshow(clean_mask, 'Parent', ax2);
        title(ax2, 'Smart Auto-Mask');

        %% Step 2: PDE-Based Inpainting
        pde_result = img;
        for c = 1:3
            chan = im2double(img(:,:,c));
            filled = regionfill(chan, clean_mask);
            pde_result(:,:,c) = im2uint8(filled);
        end
        imshow(pde_result, 'Parent', ax3);
        title(ax3, 'PDE Inpainted');
    end

    % Show Results
    function show_results(fig)
        if isempty(pde_result)
            uialert(fig, 'Please apply inpainting first.', 'Error');
            return;
        end

        %% Step 3: Enhancement (Optional)
        enhanced_result = imadjust(im2double(pde_result), stretchlim(im2double(pde_result)), []);
        denoised_result = imnlmfilt(pde_result);

        imshow(denoised_result, 'Parent', ax4);
        title(ax4, 'Denoised Image');

        imshow(enhanced_result, 'Parent', ax5);
        title(ax5, 'Enhanced Image');
    end
end


function restoration_gui
    % GUI window
    fig = figure('Name','Historical Image Restoration', ...
        'Position',[100 100 1350 800], 'Resize','off', 'Color', [0.94 0.94 0.94]);

    % UI Controls - Moved Down Slightly
    uicontrol('Style','text','Position',[30 720 150 20],'String','Input Controls','FontWeight','bold');

    uicontrol('Style','pushbutton', 'String','📂 Load Image', ...
        'FontSize',10, 'Position',[30 680 120 30], 'Callback',@loadImage);

    uicontrol('Style','pushbutton', 'String','🖌️ Load Mask', ...
        'FontSize',10, 'Position',[30 640 120 30], 'Callback',@loadMask);
    
    uicontrol('Style','pushbutton', 'String','⚙️ Run Restoration', ...
        'FontSize',10, 'Position',[30 600 120 30], 'Callback',@runRestoration);

    % Create 7 axes (with labels below each image)
    ax = gobjects(1, 7);
    titles = ["Damaged Image", "Manual Mask", "Auto Mask", ...
              "PDE Inpainting", "Exemplar Inpainting", "Denoised Result", "Enhanced PDE Result"];

    x_offsets = [180, 520, 860];  % Columns
    y_offsets = [500, 240, -20];  % Rows

    idx = 1;
    for r = 1:3
        for c = 1:3
            if idx > 7, break; end
            % Axes
            ax(idx) = axes('Units','pixels','Position',[x_offsets(c), y_offsets(r)+60, 320, 200]);

            % Label below each image
            uicontrol('Style','text', 'Position',[x_offsets(c), y_offsets(r)+35, 320, 20], ...
                      'String', titles(idx), 'FontSize', 9, 'FontWeight','bold', ...
                      'BackgroundColor', [0.94 0.94 0.94]);

            idx = idx + 1;
        end
    end

    % Shared data
    data = struct('img',[], 'mask',[]);
    setappdata(fig, 'data', data);
    setappdata(fig, 'axes', ax);

    %% Load Image Callback
    function loadImage(~,~)
        [file,path] = uigetfile({'*.jpg;*.png'},'Select Damaged Image');
        if isequal(file,0), return; end
        img = imread(fullfile(path,file));
        data = getappdata(fig, 'data');
        data.img = img;
        setappdata(fig, 'data', data);
        axes(ax(1)); imshow(img);
    end

    %% Load Mask Callback
    function loadMask(~,~)
        [file,path] = uigetfile({'*.jpg;*.png'},'Select Binary Mask');
        if isequal(file,0), return; end
        mask_img = imread(fullfile(path,file));
        if size(mask_img,3) == 3
            mask_img = rgb2gray(mask_img);
        end
        mask_img = imbinarize(mask_img);
        data = getappdata(fig, 'data');
        data.mask = mask_img;
        setappdata(fig, 'data', data);
        axes(ax(2)); imshow(mask_img);
    end

    %% Run Restoration Callback
    function runRestoration(~,~)
        data = getappdata(fig, 'data');
        if isempty(data.img)
            errordlg('Please load a damaged image.');
            return;
        end

        img = data.img;
        gray = rgb2gray(img);

        % Use manual or auto-generated mask
        if isempty(data.mask)
            edges = edge(gray, 'Canny');
            mask = imdilate(edges, strel('disk', 2));
            axes(ax(3)); imshow(mask);
        else
            mask = data.mask;
            axes(ax(3)); imshow(mask);
        end

        %% PDE Inpainting
        pde_img = img;
        for c = 1:3
            ch = im2double(img(:,:,c));
            pde_img(:,:,c) = im2uint8(regionfill(ch, mask));
        end
        axes(ax(4)); imshow(pde_img);

        %% Exemplar-Based Inpainting
        exemplar_img = img;
        for c = 1:3
            exemplar_img(:,:,c) = inpaintCoherent(img(:,:,c), mask);
        end
        axes(ax(5)); imshow(exemplar_img);

        %% Denoising
        denoised_img = imnlmfilt(pde_img);
        axes(ax(6)); imshow(denoised_img);

        %% Color Enhancement
        enhanced = imadjust(im2double(pde_img), stretchlim(im2double(pde_img)), []);
        axes(ax(7)); imshow(enhanced);
    end
end



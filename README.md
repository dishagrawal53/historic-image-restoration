# TITLE- HISTORICAL IMAGE RESTORATION
# INTRODUCTION
This project focuses on the restoration of damaged images through a combination of advanced inpainting techniques, including Partial Differential Equation (PDE)-based and exemplar-based methodsThe aim is to reconstruct missing or deteriorated regions in historical, personal, or forensic images while preserving the overall structure and visual fidelity. The process begins with preprocessing and damage detection using both smart auto-masking and manual masking techniques. The auto-mask is generated using image saliency and morphological operations to accurately identify the damaged regions. PDE-based inpainting is then employed to smoothly interpolate missing pixel values, while exemplar-based inpainting fills complex textures by sampling similar patches from the undamaged parts of the image. Additional enhancement steps such as contrast adjustment and non-local means denoising are applied to improve the visual quality of the final image. The project also incorporates a user interface to allow easy comparison of results and fine-tuning of parameters. By combining traditional methods with manual input and modern enhancements, the system achieves visually compelling and accurate image restoration. This work has practical implications in fields like archival restoration, heritage conservation, and digital forensics, and it sets a foundation for future integration with deep learning-based approaches.

# PROBLEM STATEMENT
Historical photographs and artworks often deteriorate over time due to aging, environmental exposure, and improper handling, resulting in physical damage such as cracks, stains, and missing regions. These degradations not only compromise the aesthetic and historical value of the images but also pose significant challenges in archiving and cultural preservation. Manual restoration is time-consuming, labor-intensive, and requires expert knowledge, making it impractical for large collections. There is a pressing need for an efficient, semi-automated digital restoration system that can accurately identify and repair damaged areas while preserving the original texture and quality of the images. The solution must support both automated detection and manual correction of damage regions, provide effective inpainting techniques for restoration, and offer an intuitive user interface for ease of use by non-experts.
This project aims to address these challenges by developing a MATLAB-based image restoration system that combines automatic and manual mask generation, advanced inpainting algorithms, noise reduction, and image enhancement, integrated into a graphical user interface for interactive and efficient historical image restoration

# METHODOLOGY
The proposed image restoration system follows a modular architecture that integrates key components for damage detection, image inpainting, noise reduction, enhancement, and user interaction. Each module in the architecture is designed to handle specific tasks, ensuring flexibility, scalability, and ease of maintenance. The architecture supports both automated and semi-automated workflows for historical image restoration.

<b>1. Image Loading & Preprocessing</b>
The system starts by loading an RGB image, resizing it for efficiency, and converting it to grayscale for easier mask generation. Users can optionally load a custom binary mask to define damaged areas not detected automatically.
<br>
<b>2. Masking Support (Manual & Automatic)</b>
Users can provide a hand-drawn mask or let the system generate one. Manual masking is useful for subtle damage, while automatic masking uses morphological operations and saliency detection to isolate issues like cracks and faded regions.
<br>
<b>3. Automatic Mask Generation</b>
Automatic masks are created through a pipeline involving top-hat filtering, gradient suppression, and saliency analysis. These masks are refined using morphological operations to focus only on damaged areas.
<br>
<b>4. PDE-Based Inpainting</b>
Using MATLAB’s regionfill, this method performs isotropic diffusion to restore narrow or smooth damaged regions. Each RGB channel is processed separately to ensure natural gradient transitions.
<br>
<b>5. Exemplar-Based Inpainting</b>
MATLAB’s inpaintCoherent is used for textured or complex areas. It fills damaged regions with similar patches from the image, preserving continuity in elements like fabric or walls.
<br>
<b>6.Post-Inpainting Enhancement</b>
To improve visual quality, contrast stretching (imadjust, stretchlim) is applied, enhancing dynamic range and blending restored regions more naturally with the original image.
<br>
<b>7. Denoising</b>
Non-Local Means (NLM) denoising (imnlmfilt) reduces residual noise without blurring edges, cleaning up artifacts from earlier steps and improving image clarity.
<br>
<b>8. Result Visualization</b>
All stages—original, mask, inpainted, and final—are displayed side-by-side using subplots, enabling easy comparison and evaluation of restoration quality.
<br>
<b>9. Interactive MATLAB GUI</b>
A user-friendly GUI facilitates the full pipeline with options for image selection, masking type, inpainting method, enhancements, and side-by-side previews. It supports both novice users and experts needing fine control.
 # Flowchart
 ![image](https://github.com/user-attachments/assets/bb489f25-a7fa-47f8-8884-7626d92e2c4f)
 
 # RESULTS
![image](https://github.com/user-attachments/assets/07fe28b7-c582-4143-9369-b9d73a11bbcb)
Fig : Enhanced image with a provided mask
![image](https://github.com/user-attachments/assets/0393ba9e-ab80-4016-959f-c7bdefba6051)
 Enhanced image without a provided mask
 




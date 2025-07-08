# 🖼️ HISTORICAL IMAGE RESTORATION

##  INTRODUCTION

This project focuses on restoring damaged historical images using a combination of advanced inpainting techniques, including **Partial Differential Equation (PDE)-based** and **exemplar-based** methods. It aims to reconstruct missing or deteriorated regions while preserving structural integrity and visual authenticity.

The system begins with preprocessing and damage detection using both **automatic smart masking** (via image saliency and morphological operations) and **manual masking** options. PDE-based inpainting smoothly interpolates missing pixel values, while exemplar-based methods reconstruct textured areas using similar patches from the original image.

Post-restoration enhancement—such as contrast stretching and **Non-Local Means (NLM) denoising**—further improves visual clarity. An interactive MATLAB GUI supports easy comparison of results and fine-tuning, making this tool effective for both technical and non-technical users.

This hybrid approach is applicable in <b>archival restoration, heritage conservation, digital forensics</b>, and more, laying a foundation for future integration with deep learning methods.



##  PROBLEM STATEMENT

Historical photographs often degrade over time due to environmental exposure, aging, or improper handling. Common forms of damage include cracks, stains, and missing regions—posing challenges to cultural preservation.

Manual restoration is time-consuming, requires expertise, and is not scalable. Thus, there's a need for a <b>semi-automated digital system</b> that:

- Accurately detects and restores damaged regions  
- Preserves original texture and quality  
- Supports both manual and automatic mask inputs  
- Provides an easy-to-use interface for all users

This MATLAB-based system integrates smart masking, advanced inpainting, enhancement modules, and a user-friendly GUI to address these needs effectively.

---

## METHODOLOGY

The architecture consists of multiple modules, each handling a specific part of the image restoration workflow.

<br>

<b>1. Image Loading & Preprocessing</b><br>
- Load and resize RGB image  
- Convert to grayscale  
- Option to load user-defined binary masks  

<br>

<b>2. Masking Support (Manual & Automatic)</b><br>
- Manual masks allow precision input  
- Automatic masks generated using saliency + morphological operations  

<br>

<b>3. Automatic Mask Generation</b><br>
- Top-hat filtering for small bright regions  
- Gradient suppression to remove edges  
- Saliency analysis for significant pixel deviations  
- Morphological refinement  

<br>

<b>4. PDE-Based Inpainting</b><br>
- Uses MATLAB’s `regionfill` for smooth diffusion  
- Separate inpainting on each RGB channel  

<br>

<b>5. Exemplar-Based Inpainting</b><br>
- Uses `inpaintCoherent` to copy similar texture patches  
- Ideal for walls, fabrics, and detailed textures  

<br>

<b>6. Post-Inpainting Enhancement</b><br>
- Uses `imadjust` and `stretchlim` for contrast stretching  
- Restores image vibrance and visual continuity  

<br>

<b>7. Denoising</b><br>
- Applies Non-Local Means filtering (`imnlmfilt`)  
- Reduces noise, preserves edges  

<br>

<b>8. Result Visualization</b><br>
- Side-by-side comparison of original, mask, inpainted, and enhanced images  

<br>

<b>9. Interactive MATLAB GUI</b><br>
- Options for loading images, selecting masking & inpainting methods  
- Supports real-time visualization and parameter tuning  


##  FLOWCHART

<img src="https://github.com/user-attachments/assets/bb489f25-a7fa-47f8-8884-7626d92e2c4f" alt="Flowchart" width="600"/>


##  RESULTS

<b> Enhanced Image with Provided Mask</b><br>
<img src="https://github.com/user-attachments/assets/07fe28b7-c582-4143-9369-b9d73a11bbcb" width="600"/><br>

<b>Enhanced Image without Provided Mask</b><br>
<img src="https://github.com/user-attachments/assets/0393ba9e-ab80-4016-959f-c7bdefba6051" width="600"/>




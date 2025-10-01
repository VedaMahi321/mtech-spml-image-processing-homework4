# Homework 4 — Image Restoration, Tomographic Reconstruction & Sharpening  

📌 **Course:** M.Tech SPML — Image Processing  
👤 **Author:** Veda Prakash Mohanarangan  
📂 **Repository:** [mtech-spml-image-processing-homework4](https://github.com/VedaMahi321/mtech-spml-image-processing-homework4)  

---

## 📖 Overview  
This repository contains MATLAB implementations and report for **Homework 4** in the Image Processing course.  
The assignment covers three main tasks:  

1. **Wiener Filter for Image Restoration**  
   - Degrade an image using turbulence model and noise.  
   - Restore using Wiener filtering.  

2. **Parallel Projection & Filtered Backprojection (FBP)**  
   - Generate sinograms for simple objects.  
   - Reconstruct using FBP.  

3. **Laplacian-based Image Sharpening**  
   - Apply sharpening in RGB and HSV models.  
   - Compare results.  

---

## 🗂 Repository Structure  

mtech-spml-image-processing-homework4/
│
├── code/ # MATLAB source files
│ ├── run_all_hw4_detailed.m
│ ├── wiener_restoration_detailed.m
│ ├── forward_projection.m
│ ├── filtered_backprojection.m
│ ├── proj_fbp_demo_detailed.m
│ └── laplace_sharpen_detailed.m
│
├── results/ # Generated outputs (PNGs)
│ ├── sample_color.png
│ ├── part4_1_degraded.png
│ ├── part4_1_restored_wiener.png
│ ├── part4_1_psf.png
│ ├── part4_2_object.png
│ ├── part4_2_sinogram.png
│ ├── part4_2_recon_fbp.png
│ ├── part4_3_sharp_rgb.png
│ ├── part4_3_sharp_hsv.png
│ └── part4_3_difference.png
│
├── logs/
│ └── hw4_detailed_log.txt
│
├── hw4_report_final.tex # LaTeX report
├── hw4_report_final.pdf # Compiled PDF report
└── README.md # This file

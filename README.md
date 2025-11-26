# EE635_Project
ODAV (Audio Signal Reconstruction using Fourier Series Projection)

This MATLAB script demonstrates how to reconstruct an audio signal by projecting it onto a basis of sinusoidal (sine and cosine) functions, effectively performing a truncated **Fourier Series Expansion**.

It reads an audio file, identifies the most relevant frequencies , and then uses these frequencies to build a reconstructed signal by taking inner product. This gives the best approximation of the original for any given dimension of basis vectors.

## Prerequisites

1.  **MATLAB:** You must have a working installation of MATLAB.
2.  **Audio File:** You need to put the MP3 audio file in the same directory as the script.

## How to Use the Script

1.  **Save the Code:** Save the provided MATLAB code as a `orthogonalDecomposition.m` file.
2.  **Place Audio File:** Ensure the file is in the same directory.
3.  **Run in MATLAB:** Open MATLAB, navigate to the directory, and run the script by typing the filename in the Command Window:
    ```matlab
    orthogonalDecomposition
    ```

Key Parameters

You can adjust the signal processing behavior by modifying the parameters at the start of the script:

| Parameter | Description | Recommended Range |
| :--- | :--- | :--- |
| `basisDimension` | The **number of prominent frequencies** (and thus basis vectors: 1 DC, `N` cos, `N` sin) used for reconstruction. **This is the main parameter for quality vs. processing time.** | 100 to 1000 |
| `filename` | The name of the audio file to process. | `'river_flows_in_you.mp3'` (or your file) |
| `duration` | The duration (in seconds) of the segment to process. Keep this small for fast results. | 2 to 10 |
| `offset` | The starting time (in seconds) of the segment to process. | 0 to (Total Duration - `duration`) |

## 🧠 Core Concepts: Fourier Series and Projection

The script operates on the principle of **signal approximation** using a basis, which is fundamental to Fourier Analysis.

### 1. The Basis

The script uses a set of basis vectors derived from the prominent frequencies:
* **DC Component:** A constant vector of ones.
* **AC Components:** Pairs of **sine** and **cosine** waves ($\cos(2 \pi f_k t)$ and $\sin(2 \pi f_k t)$ for each prominent frequency $f_k$).

### 2. Identifying Prominent Frequencies (`blackBox` Function)

The `blackBox` function uses the **Fast Fourier Transform (FFT)** to convert the audio signal from the **time domain** to the **frequency domain**. 

[Image of Time Domain vs Frequency Domain]


* The FFT output provides the magnitude (amplitude) of every frequency component present in the signal.
* It then identifies the `basisDimension` frequencies with the largest magnitudes. These are the **prominent frequencies** that contain the most energy and are most important for reconstructing the sound.

### 3. Projection and Reconstruction

For each basis vector (DC, $\cos(2 \pi f_k t)$, $\sin(2 \pi f_k t)$), the script calculates the **projection coefficient (amplitude)** using the formula for vector projection:

$$
\text{Coefficient} = \frac{\mathbf{y} \cdot \mathbf{b}}{\mathbf{b} \cdot \mathbf{b}}
$$

* $\mathbf{y}$ is the clipped audio signal vector.
* $\mathbf{b}$ is the current basis vector (e.g., $\mathbf{cos}$).
* The coefficient is the **amplitude** of that basis function in the audio signal.

The final **reconstructed signal** $\mathbf{y}_{\text{reconstructed}}$ is the sum of each basis vector multiplied by its calculated coefficient:

$$
\mathbf{y}_{\text{reconstructed}} = DC component + \sum_{k=1}^{\text{basisDimension}} \left( a_k \cos(2 \pi f_k t) + b_k \sin(2 \pi f_k t) \right)
$$

### 4. Visualization and Error

The script dynamically plots the:
* **Original vs. Reconstructed Signal:** Showing how well the limited basis vectors approximate the original wave.
* **Error Signal:** The difference between the original and reconstructed signals ($y_{\text{clipped}} - y_{\text{reconstructed}}$) .
* **RMSE Error:** The Root Mean Square Error (RMSE) is calculated and displayed, quantifying the quality of the reconstruction.

As `k` (the number of basis vectors) increases, you will observe the reconstructed signal getting closer to the original, and the RMS error decreasing.





https://github.com/user-attachments/assets/702250d6-fbcc-4eee-9b4c-6076da977e20


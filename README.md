# Spectral Estimation and Digital Filtering of an Audio Signal  
### Course Project – CIE 237  
### Title: Performance of Correlation Receivers for M-PAM over AWGN Channels  


---

## 📌 Introduction

This project investigates the performance of correlation receivers (matched filters) for **M-level Pulse Amplitude Modulation (M-PAM)** over **Additive White Gaussian Noise (AWGN)** channels. We study the **Bit Error Rate (BER)** and **Symbol Error Rate (SER)** for 2-, 4-, and 8-PAM systems using MATLAB and Simulink.

---

## 📖 Theoretical Background

### 🔹 Correlation Receiver
- Compares received signal with expected waveform.
- Selects the transmitted symbol based on the maximum correlation output.
- Maximizes SNR by using a matched filter.

### 🔹 M-PAM Modulation
- Maps log₂(M) bits to one of M amplitude levels.
- Higher M values lead to reduced spacing between symbols → higher BER and SER.
- BER and SER degrade as M increases, especially at low SNR.

---

## ⚙️ Simulation Methodology

### Parameters:
- **Symbols:** 100,000
- **Modulation Levels:** M = 2, 4, 8
- **SNR Range:** 0 to 20 dB (step = 2 dB)
- **Channel:** AWGN

### Steps:
1. Generate random bits.
2. Modulate using M-PAM (using `pammod`).
3. Pass through AWGN channel.
4. Add Gaussian noise based on SNR.
5. Use correlation receiver (matched filter) for demodulation.
6. Compute:
   - Simulated BER
   - Theoretical BER (using Q-function)
   - SER
7. Plot BER vs. SNR for different M values.

---

## 📊 Results

- **2-PAM:** Best performance, lowest BER.
- **4-PAM, 8-PAM:** Higher errors due to closer spacing.
- Simulated BER closely matches theoretical BER.
- SER decreases with SNR but increases with M.
- MATLAB proves effective for modeling digital comms systems.

---

## 🔁 Simulink Comparison

Simulink was used to model 8-PAM using:
- Random Integer Source  
- 8-PAM Modulator & Demodulator  
- FIR Pulse Shaping Filter  
- AWGN Channel  
- Error Rate Calculator  

Results were consistent with MATLAB simulation.


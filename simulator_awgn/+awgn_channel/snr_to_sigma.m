function sigma = snr_to_sigma(snr_db)
% Convert SNR (dB) to sigma for complex Gaussian noise (CN)
N0 = 1 / (10^(snr_db / 10));
sigma = sqrt(N0 / 2);
end
function p_fit = fit_error_rate(snr_range, fer, snr_fit, max_degree)
log_fer = 10 * log10(fer);
% Perform SNR normalization
snr_span = max(snr_range) - min(snr_range);
snr_normalized = (snr_range - min(snr_range)) / snr_span;
% Run polyfit / polyval
P = polyfit(snr_normalized, log_fer, min(max_degree, length(log_fer) - 1));
snr_normalized_fit = (snr_fit - min(snr_range)) / snr_span;
p_fit = 10 .^ (polyval(P, snr_normalized_fit) / 10);

% Handle edge conditions
p_fit(snr_normalized_fit < 0) = max(fer);
p_fit(snr_normalized_fit > 1) = min(fer);
p_fit(p_fit < 0) = 0;
end
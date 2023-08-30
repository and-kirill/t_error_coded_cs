function [llr, symb_tx, symb_rx] = awgn_qam_channel(cwd, bps, sigma)
% Generate LLR vector after AWGN channel with given sigma and modulation
% order (M = 2^bps, M = 4 for QPSK), bps -- bits per symbol

% Use default Gray coding for modulation
M = 2^bps;
assert(round(length(cwd) / bps) * bps == length(cwd));
cwd_stacked = reshape(cwd, bps, []);

tx = qammod(cwd_stacked, M, 'InputType', 'bit');

% Add Gaussian noise
n_points = length(tx);
sigma_normalized = sigma * sqrt(mean(abs(qammod(0:(M - 1), M).^2)));
rx = tx + sigma_normalized * (randn(1, n_points) + 1j * randn(1, n_points));

% Perform demodulation
llr_per_symbol = qamdemod(rx, M, 'OutputType', 'llr', 'NoiseVariance', 2 * sigma_normalized^2);

% Define the transmitted symbol sequence and the received symbol sequence
symb_tx = qamdemod(tx, M, 'OutputType', 'Integer', 'NoiseVariance', 0);
symb_rx = qamdemod(rx, M, 'OutputType', 'Integer', 'NoiseVariance', 2 * sigma_normalized^2);
llr = llr_per_symbol(:)';
end

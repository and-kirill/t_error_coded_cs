function [cwd_hat, h_hat] = omp(A, y, K0, sigma_noise, iteration_stride, use_fading)
% A -- codebook of size (M, n), M -- codebook size, n -- codeword length
% y -- received signal of size (n, N_rx), where N_rx is the receive antenna
% count
% K0 -- the number of OMP iterations
% sigma_noise -- the noise variance, used for MMSE OMP version
% iteration_stride -- how many successive cancellation steps are performed
% at once
if nargin == 3
    sigma_noise = 0;
end
y_residual = y;

[n1, N_rx] = size(y);
R = zeros_gpu([n1, K0]); % Matrix of resolved codewords (zeros at unknown rows)

cwd_hat = zeros(1, K0);
h_hat = zeros_gpu([K0, N_rx]);

iter = 0;

while iter < K0
    corr_energy = sum(abs(A' * y_residual).^2, 2);
    % Maximum correlation criterion (top-k)
    dk = min(iteration_stride, K0 - iter);
    [~, id] = maxk(corr_energy, dk);
    
    update_idx = (iter + 1):(iter + dk);
    cwd_hat(update_idx) = id;
    
    % Update resolved codewords list and remove them from the rest codebook
    R(:, (iter + 1):(iter + dk)) = A(:, id);
    A(:, id) = 0;

    iter = iter + dk;
    % Successive interference cancellation. Note that all channel gains
    % corresponding to previously detected codewords are updated.
    C = R(:, 1:iter);
    if use_fading
        R_pinv = pinv_mmse(C, sigma_noise);
        h = R_pinv * y;
    else
        h = ones(iter, 1);
    end
    h_hat(1:iter, :) = h;
    y_residual = y - R(:, 1:iter) * h;
    
end
assert (iter == K0);
end


function H_inv = pinv_mmse(H, sigma_noise)
n_rows = size(H, 2);
denominator = H' * H + sigma_noise^2 * eye(n_rows);
H_inv = denominator \ H';
end


function x = zeros_gpu(shape)
try
    % Generate Gaussian samples using GPU (R2020b and later required)
    x = gpuArray(zeros(shape));
catch
    warning('GPU is not available');
    x = zeros(shape);
end
end

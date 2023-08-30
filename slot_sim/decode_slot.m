function cwd_hat = decode_slot(sigma_noise, sys_params, cwd, K0, V)

Q = 2^sys_params.ks;
% Generate codebook
slot_length = round(sys_params.n / V);
A = generate_codebook(slot_length, Q);

y = generate_channel_output(cwd, A, sys_params, sigma_noise);
iteration_stride = 15;
[cwd_hat, ~] = omp(A, y, K0, sigma_noise, iteration_stride, sys_params.fading);
end
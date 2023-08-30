function chs = rsno_single_run(sigma_noise, sys_params, Ka, V, kx, log2q_rs)
rs_params = generate_rsno_params(sys_params, V, kx, log2q_rs);
[~, cwd_bin, cwd_rs, prefix] = rsno_encode(sys_params, rs_params, Ka);

% Decode the inner code for each outer code symbol
K0_max = Ka * sys_params.K0_scale;

cwd_hat_qary = zeros(V, K0_max);
cwd_qary = bin2qary(cwd_bin, sys_params.ks);
slot_length = round(sys_params.n / V);
A = generate_codebook(slot_length, 2^sys_params.ks);
iteration_stride = 15;

for i = 1:V
    y = generate_channel_output(cwd_qary(i, :), A, sys_params, sigma_noise);
    [cwd_hat_qary(i, :), ~] = omp(A, y, K0_max, sigma_noise, iteration_stride, sys_params.fading);
end

% Evaluate the outer code performance for each possible K0 value
chs = rs_stats.empty(sys_params, Ka, V);
assert(length(chs.PUPE) == K0_max);
chs.PUPE = ones(K0_max, 1);
for K0 = floor(Ka / 2):K0_max
    [success_K, n_CRC] = evaluate_rsno_performance(rs_params, cwd_hat_qary(:, 1:K0), cwd_rs.x, prefix);
    chs.PUPE(K0) = (Ka - success_K) / Ka;
    chs.n_CRC(K0) = n_CRC;
end

chs.n_exp = 1;
end


function chs = slot_single_run(sigma_noise, Ka, V, sys_params)
cwd = randi([1, 2^sys_params.ks], 1, Ka);

chs = mac_stats.empty(sys_params, Ka, V);
K0_max = max(chs.K0);
cwd_hat_total = decode_slot(sigma_noise, sys_params, cwd, K0_max, V);

% Postprocess OMP decoding
p_m_series = zeros(1, K0_max);
p_f_series = zeros(1, K0_max);
Q = 2^sys_params.ks;

for iter = 1:K0_max
    cwd_hat = cwd_hat_total(1:iter);
    p_m_series(iter) = length(setdiff(cwd, cwd_hat)) / Ka;
    p_f_series(iter) = length(setdiff(cwd_hat, cwd)) / (Q - length(unique(cwd)));
end
% Finalize channel statistics
chs.K0    = 1:K0_max;
chs.p_m   = p_m_series';
chs.p_f   = p_f_series';
chs.n_exp = 1;
end

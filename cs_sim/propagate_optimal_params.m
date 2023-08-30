function propagate_optimal_params(sys_params, Ka, DK)
if strcmp(sys_params.bound, 'capacity') || strcmp(sys_params.bound, 'converse')
    sys_params.t_max = 0;
end

for t = 0:sys_params.t_max
    fprintf('Propagate optimal point: K: %d --> %d, t = %d\n', Ka, Ka + DK, t);
    [V, ebno_db] = get_optimal_point(sys_params, Ka, t);
    if V == 0
        continue;
    end
    snr_db = ebno_db + 10 * log10(sys_params.k / sys_params.n);
    snr_delta = 4.0;
    snr_range = [-1, 1] * snr_delta + snr_db;
    simulate_slot(sys_params, Ka + DK, V, t, snr_range);
end
end

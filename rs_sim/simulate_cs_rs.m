close all;
clc;
clear;

sys_params = sys_params_default(15, 1);
Ka_series = get_rs_ka();

% Simulation:
for i = 1:length(Ka_series)
    Ka = Ka_series(i);
    kx_range = get_kx_range(sys_params, Ka);
    for kx = kx_range
        % Find an optimal point for each prefix size separately
        fprintf('Simulating Ka = %d and prefix size %d\n', Ka, kx);
        simulate_rs_Ka(sys_params, Ka, kx);
        % Propagate optimal point further
        if i == length(Ka_series)
            continue;
        end
        [V, ebno_db] = get_optimal_rs_point(sys_params, Ka, kx);
        fprintf('Propagate optimal point Ka = %d -> %d. Prefix size %d\n', Ka, Ka_series(i + 1), kx);
        snr_db = ebno_db + 10 * log10(sys_params.k / sys_params.n);
        simulate_rs(sys_params, Ka_series(i + 1), V, kx, snr_db + 3 * [-1, 1]);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%% Simulator implementation %%%%%%%%%%%%%%%%%%%%%%%%
% Simulation automation routines
function simulate_rs_Ka(sys_params, Ka, kx)
max_attempts = 20;
for i = 1:max_attempts
    [V, ebno_db] = get_optimal_rs_point(sys_params, Ka, kx);
    if V == 0
        return;
    end
    snr_db = ebno_db + 10 * log10(sys_params.k / sys_params.n);
    simulate_rs(sys_params, Ka, (V - 2):(V + 2), kx, snr_db + 3 * [-1, 1]);
end
end


function simulate_rs(sys_params, Ka, V_range, kx, snr_range)
for V = V_range
    do_simulate_rs(sys_params, Ka, V, kx, snr_range);
end
end


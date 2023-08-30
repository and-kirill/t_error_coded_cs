function simulate_Ka(sys_params, Ka, t)
% Ka -- the number of active users;
if nargin == 3
    simulate_Ka_t(sys_params, Ka, t);
    return;
end

if strcmp(sys_params.bound, 'capacity') || strcmp(sys_params.bound, 'converse')
    sys_params.t_max = 0;
end

for t = 0:sys_params.t_max
    simulate_Ka_t(sys_params, Ka, t);
end
end


function simulate_Ka_t(sys_params, Ka, t)
% Maximum number of optimization attempts
max_attempts = 20;
% Simulation near optimum point +/- snr_delta offset only
snr_delta = 4; % dB

for i = 1:max_attempts
    [V, ebno_db] = get_optimal_point(sys_params, Ka, t);
    if V == 0
        break;
    end
    slot_range = (V - 1):(V + 1);
    if strcmp(sys_params.bound, 'linear') && t > 0
        slot_range = (V - 2):(V + 2);
    end

    V_min = ceil(sys_params.k / sys_params.ks);
    slot_range(slot_range < V_min) = [];

    snr_db = ebno_db + 10 * log10(sys_params.k / sys_params.n);
    snr_range = [-1, 1] * snr_delta + snr_db;

    files_updated = simulate_slot(sys_params, Ka, slot_range, t, snr_range);
    if ~files_updated
        break;
    end
end
end

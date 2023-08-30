function chs = empty(sys_params, Ka, V)
K0 = sys_params.K0_scale * Ka;
chs = struct( ...
    'Ka', Ka,              ... The number of active users
    'V', V,                ... The number of slots
    'PUPE', zeros(K0, 1),  ... Per user probability of error
    'n_CRC', zeros(K0, 1), ... Required CRC size
    'n_exp', 0             ... Total number of conducted experiments
    );
end

function chs = empty(sys_params, Ka, V)
K0 = max(100, sys_params.K0_scale * Ka);
chs = struct( ...
    'Ka', Ka,            ... The number of active users
    'V', V, ...The number of slots
    'K0', 1:K0,  ... Array of the output list size
    'p_m', zeros(K0, 1), ... Missed detection probability corresponding to each output list size
    'p_f', zeros(K0, 1), ... False detection probability corresponding to each output list size
    'n_exp', 0           ... Total number of conducted experiments
    );
end

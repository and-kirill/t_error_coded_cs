function print_bit_allocation(ks, Ka, t, max_paths)
% ks - bits per slot, Q = 2^ks;
% Ka - the number of active users
% t  - the number of errors that can be corrected
% max_paths - the maximum average number of paths for linear code decoder

N_rx = 1; % The number of antennas at the base station

% Generate system parameters:
sp = sys_params_default(ks, N_rx);
sp.bound = 'linear';
sp.max_paths = max_paths;

% Evaluate the optimal point
% Slot count
L = get_optimal_point(sp, Ka, t);
% Eb/No [dB]
ebno_db = evaluate_cs_bound(sp, Ka, t);
if isinf(ebno_db)
    fprintf('The point is unreachable\n');
    return;
end

% Inner code output list size
K0 = get_optimal_K0(sp, Ka, L, t, ebno_db);
% Slot misdetection and false alarm probabilities
[p_m, p_f] = get_slot_performance(sp, Ka, K0, L, ebno_db);
Q = get_Q_matrix(sp, Ka, L, t, p_m, p_f);
[~, ~, inf_bits_pattern] = greedy_bits_allocation(sp, Ka, L, Q);
[P_m, P_f] = linear_bound(sp, Ka, L, t, p_m, p_f);

fprintf('PUPE: %1.3e, FAR: %1.3e\n', P_m, P_f);
fprintf('\\mathbf{b} = \\left[');
for i = 1:(length(inf_bits_pattern) - 1)

    fprintf(' %d\\ ', inf_bits_pattern(i));
end
fprintf('%d\\right]\n', inf_bits_pattern(end));
end

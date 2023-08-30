function [P_f, path_profile, inf_bits_pattern] = greedy_bits_allocation(sys_params, Ka, V, Q)
assert(isfield(sys_params, 'max_paths'));
inf_bits_pattern = zeros(1, V);
path_profile = zeros(1, V);

P_series = nan(1, V);

for si = 1:V
    if sum(inf_bits_pattern) < sys_params.k
        inf_bits_pattern(si) = allocate_next_bit(sys_params, Ka, inf_bits_pattern(1:si - 1), Q, P_series);
    end
    [path_profile(si), P_series] = evaluate_bit_allocation(inf_bits_pattern(1:si), Ka, Q, P_series);
end
P_f = path_profile(end);
end

function b = allocate_next_bit(sys_params, Ka, inf_bits_pattern, Q, P_series)
remaining_bits = sys_params.k - sum(inf_bits_pattern);
for b = min(sys_params.ks, remaining_bits):-1:0
    [P_f, ~] = evaluate_bit_allocation([inf_bits_pattern, b], Ka, Q, P_series);
    if P_f < sys_params.max_paths
        break;
    end
end
end


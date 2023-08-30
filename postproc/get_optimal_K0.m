function K0 = get_optimal_K0(sys_params, Ka, V, t, ebno_db)
file_list = get_file_list(sys_params, Ka, V);
assert (length(file_list) == 1);
results = file_list.results;

n_exp = [results.stats.n_exp];

% Filter zero experiments count
snr_range = results.snr_range(n_exp > 0);
stats = results.stats(n_exp > 0);

n_points = length(snr_range);
K0_list = zeros(1, n_points);
ebno_list = snr_range - 10 * log10(sys_params.k / sys_params.n);
for i = 1:n_points
    [~, K0_list(i)] = get_min_pupe(sys_params, stats(i), t);
end
if isempty(K0_list)
    K0 = 0;
elseif length(K0_list) == 1
    K0 = K0_list;
else
    K0 = round(interp1(ebno_list, K0_list, ebno_db));
end
end

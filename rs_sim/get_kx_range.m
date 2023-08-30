function kx_range = get_kx_range(sys_params, Ka, do_sim_full)
kx_range_full = 7:(sys_params.ks - 4);
if nargin == 2
    do_sim_full = false;
end
if do_sim_full
    kx_range = kx_range_full;
    return;
end

[ebno_db, ~, kx] = evaluate_rs_ebno_db(sys_params, Ka);
if ~isinf(ebno_db)
    kx_range = kx:(kx + 1);
else
    p_e_series = ones(size(kx_range_full));
    for i = 1:length(kx_range_full)
        kx = kx_range_full(i);
        [p_e_series(i), ~, ~, ~] = get_min_rs_pupe(sys_params, Ka, kx);
    end
    [~, id] = min(p_e_series);
    idx = id:(id + 1);
    idx = idx(idx > 0);
    kx_range = kx_range_full(idx);
end
kx_range(kx_range > 9) = [];

% Check that all requested points have at least one simulated slot value
for kx = kx_range
    file_list = get_rs_files(sys_params, Ka, kx);
    [p_e, ~, ~, ~] = get_min_rs_pupe(sys_params, Ka, kx);
    if isempty(file_list)
        warning('There are no simultions for Ka = %d, kx = %d', Ka, kx);
    elseif p_e == 1
        warning('p_e = 1 for Ka = %d, kx = %d', Ka, kx);
    end
end


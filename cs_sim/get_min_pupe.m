function [P_e, K0] = get_min_pupe(sys_params, chs, t)
% Get minimum PUPE over all output list sizes of the inner code
if chs.n_exp == 0
    P_e = 1; K0 = 0;
    return;
end
p_m = chs.p_m / chs.n_exp;
p_f = chs.p_f / chs.n_exp;

[P_e, K0] = do_get_min_pupe(sys_params, chs.Ka, chs.V, t, p_m, p_f);
end


function [min_pupe , K0_opt] = do_get_min_pupe(sys_params, Ka, V, t, p_m_series, p_f_series)
n_points = length(p_m_series);
assert(length(p_f_series) == n_points);

P_m = zeros(1, n_points);
P_f = zeros(1, n_points);

if strcmp(sys_params.bound, 'linear')
    % Use parallel evaluation for convolutional bound
    parfor i = 1:n_points
        [P_m(i), P_f(i)] = do_get_bound(sys_params, Ka, V, t, p_m_series(i), p_f_series(i));
    end
else
    % Parfor causes an extreme overhead in this case
    for i = 1:n_points
        [P_m(i), P_f(i)] = do_get_bound(sys_params, Ka, V, t, p_m_series(i), p_f_series(i));
    end
end
% Check false alaram rate condition and return the minimum value
P_m(P_f > sys_params.far_rate *  sys_params.p_e) = 1;
[min_pupe, K0_opt] = min(P_m);
end


function [P_m, P_f] = do_get_bound(sys_params, Ka, V, t, p_m, p_f)
if strcmp(sys_params.bound, 'rcb')
    [P_m, P_f] = random_coding_bound(sys_params, Ka, V, t, p_m, p_f);
elseif strcmp(sys_params.bound, 'linear')
    [P_m, P_f] = linear_bound(sys_params, Ka, V, t, p_m, p_f);
elseif strcmp(sys_params.bound, 'capacity')
    [P_m, P_f] = capacity_bound(sys_params, Ka, V, t, p_m, p_f);
elseif strcmp(sys_params.bound, 'converse')
    [P_m, P_f] = ccs_converse_bound(sys_params, Ka, V, t, p_m, p_f);
else
    error('Unknown bound type');
end
end

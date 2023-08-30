function s = print(chs, sys_params, t)

n_experiments = chs.n_exp;

s = sprintf('#%1.3e, ', n_experiments);
if n_experiments == 0
    return;
end
s = [s, 'PUPE: '];
if ~strcmp(sys_params.bound, 'capacity') && ~strcmp(sys_params.bound, 'converse')
    s = [s, sprintf('t = %d: ', t)];
end
[p_e , K0] = get_min_pupe(sys_params, chs, t);
s = [s, sprintf('%1.3e @ K0 = %d ', p_e, K0)];
end

function n_errors = error_count(chs, sys_params, t)
n_errors = round(get_min_pupe(sys_params, chs, t) * chs.n_exp);
end
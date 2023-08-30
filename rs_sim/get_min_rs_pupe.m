
function [p_e, ebno_db, V, kx] = get_min_rs_pupe(sys_params, Ka, kx)
V = 0;
p_e = 1.0;
ebno_db = inf;

file_list = get_rs_files(sys_params, Ka, kx);
for i = 1:length(file_list)
    if min(file_list(i).pupe) < p_e
        [p_e, id] = min(file_list(i).pupe);
        ebno_db = file_list(i).snr_range(id) - 10 * log10(sys_params.k / sys_params.n);
        V = file_list(i).V;
        kx = file_list(i).kx;
    end
end
end
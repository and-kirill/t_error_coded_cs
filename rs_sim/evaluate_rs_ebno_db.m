function [ebno_db, V, kx, K0] = evaluate_rs_ebno_db(sys_params, Ka, kx)
if nargin == 2
    kx = nan;
end


file_list = get_rs_files(sys_params, Ka, kx);

n_files = length(file_list);
ebno_db_series = inf(1, n_files);

for i = 1:length(file_list)
    if min(file_list(i).pupe) > sys_params.p_e || file_list(i).kx > 9
        continue;
    end
    ebno_db_series(i) = find_ebno_db(...
        sys_params, ...
        file_list(i).snr_range, ...
        file_list(i).pupe, ...
        file_list(i).n_errors ...
        );
end

[ebno_db, id] = min(ebno_db_series);

if n_files == 0 || isinf(ebno_db)
    ebno_db = inf; kx = 0; V = 0; K0 = 0;
else
    ebno_db_offset = 10 * log10((sys_params.k + file_list(id).kx) / sys_params.k);
    ebno_db = ebno_db + ebno_db_offset;
    kx = file_list(id).kx;
    V  = file_list(id).V;
    K0 = get_K0(sys_params, file_list(id));
end
end


function K0 = get_K0(sys_params, file_data)
id = find(file_data.pupe < sys_params.p_e, 1);
K0 = file_data.K0(id);
end

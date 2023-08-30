function [V, ebno_db] = get_optimal_point(sys_params, Ka, t)
fprintf('================================================================================\n');
[ebno_db, V] = evaluate_cs_bound(sys_params, Ka, t);
if ~isinf(ebno_db)
    fprintf('TEST EBNO: Ka = %d, t = %d, e_b = %1.3e (@V = %d)\n', Ka, t, ebno_db, V);
else
    [min_pupe, ebno_db, V] = min_pupe_global(sys_params, Ka, t);
    fprintf('TEST PUPE: Ka = %d, t = %d, p_e = %1.3e (@V = %d, Eb/N0 = %1.3f)\n', Ka, t, min_pupe, V, ebno_db);
    if min_pupe > 0.5
        V = 0;
    end
end
fprintf('================================================================================\n');
end


function [min_pupe, ebno_db, V] = min_pupe_global(sys_params, Ka, t)
file_list = get_file_list(sys_params, Ka);

if isempty(file_list)
    min_pupe = 1; ebno_db = sys_params.ebno_db_max; V = 0;
    return;
end
n_files = length(file_list);
p_e = zeros(1, n_files);
ebno = zeros(1, n_files);
% Search for the minimum PUPE among all files and all simulated SNR values
for i = 1:n_files
    [p_e(i), ebno(i)] = get_min_pupe_from_file(sys_params, file_list(i).results, t);
end
[min_pupe, i] = min(p_e);
ebno_db = ebno(i); V = file_list(i).V;
end


function [min_pupe, ebno_db] = get_min_pupe_from_file(sys_params, results, t)
[P_e, ~] = file2pupe(sys_params, results, t);
ebno = results.snr_range - 10 * log10(sys_params.k / sys_params.n);
[min_pupe, i] = min(P_e);
ebno_db = ebno(i);
end

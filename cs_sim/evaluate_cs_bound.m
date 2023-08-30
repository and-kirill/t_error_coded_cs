function [ebno_db, V] = evaluate_cs_bound(sys_params, Ka, t)
file_list = get_file_list(sys_params, Ka);

if isempty(file_list)
    ebno_db = inf; V = 0;
    return;
end

% Find minimum Eb/N0 among all files (= all slot counts)
ebno_db_list = zeros(1, length(file_list));
for i = 1:length(file_list)
    ebno_db_list(i) = get_min_ebno(sys_params, file_list(i).results, t);
end

[ebno_db, i] = min(ebno_db_list);
if isinf(ebno_db)
    V = 0;
else
    V = file_list(i).V;
end
end


function ebno_db = get_min_ebno(sys_params, results, t)
[pupe_range, ~] = file2pupe(sys_params, results, t);

% Filter by the number of experiments first
n_experiments = [results.stats.n_exp];
snr_range = results.snr_range(n_experiments > 0);
pupe_range = pupe_range(n_experiments > 0);
n_errors = pupe_range .* n_experiments(n_experiments > 0);

ebno_db = find_ebno_db(sys_params, snr_range, pupe_range, n_errors);
end

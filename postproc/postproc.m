function postproc(sys_params)
Ka_series = get_Ka_series(sys_params);

if strcmp(sys_params.bound, 'capacity') || strcmp(sys_params.bound, 'converse')
    sys_params.t_max = 0;
end

bound_type = sys_params.bound;
if strcmp(sys_params.bound, 'linear')
    bound_type = sprintf('%s_%d', sys_params.bound, sys_params.max_paths);
end

if sys_params.fading
    ebno_filename = fopen(sprintf('data/ebno_ka_ks%d_%s_N%d.txt', sys_params.ks, bound_type, sys_params.N_rx), 'w');
    slot_filename = fopen(sprintf('data/slot_count_ks%d_%s_N%d.txt', sys_params.ks, bound_type, sys_params.N_rx), 'w');
else
    ebno_filename = fopen(sprintf('data/ebno_ka_ks%d_%s_AWGN.txt', sys_params.ks, bound_type), 'w');
    slot_filename = fopen(sprintf('data/slot_count_ks%d_%s_AWGN.txt', sys_params.ks, bound_type), 'w');
end

header_string = 'Ka  ';
for t = 0:sys_params.t_max
    header_string = [header_string, sprintf('         t%d', t)];
end

fprintf(ebno_filename, '%s\n', header_string);
fprintf(slot_filename, '%s\n', header_string);

for K = Ka_series
    fprintf(ebno_filename, '%04d', K);
    fprintf(slot_filename, '%04d', K);
    fprintf('Processing K = %d\n', K);
    for t = 0:sys_params.t_max
        [ebno_db, V] = evaluate_cs_bound(sys_params, K, t);
        if isinf(ebno_db)
            ebno_db = sys_params.ebno_db_max;
        end
        if V > 0
            K0 = get_optimal_K0(sys_params, K, V, t, ebno_db);
            if K0 == 2 * K
                fprintf('Hit maximum K0 at K = %d, t = %d\n', K, t);
            end
        end
        fprintf(ebno_filename, ' %+1.3e', ebno_db);
        fprintf(slot_filename, ' %02d', V);
    end
    fprintf(ebno_filename, '\n');
    fprintf(slot_filename, '\n');
end

fclose(ebno_filename);
fclose(slot_filename);
end

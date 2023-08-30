function file_list = get_rs_files(sys_params, Ka, kx)
src_dir = get_directory(sys_params, 'RS');
if isnan(kx)
    all_files = sprintf('%s/rs_Ka_%d_*.mat', src_dir, Ka);
else
    all_files = sprintf('%s/rs_Ka_%d_V*_kx%d.mat', src_dir, Ka, kx);
end

dir_content = dir(all_files);
n_files = length(dir_content);

file_list = repmat(struct('V', 0, 'filename', ''), 1, n_files);

for i = 1:n_files
    filename = [src_dir, '/', dir_content(i).name];
    file_list(i).filename = filename;
    load(filename, 'results');
    assert(min(results.snr_range) == sys_params.snr_db_min);
    assert(max(results.snr_range) >= sys_params.snr_db_max);

    n_exp = [results.stats.n_exp];
    stats = results.stats(n_exp > 0);

    file_list(i).snr_range = results.snr_range(n_exp > 0);
    p_e = [stats.PUPE] ./ n_exp(n_exp > 0);
    [file_list(i).pupe, file_list(i).K0] = min(p_e, [], 1);
    file_list(i).n_errors = file_list(i).pupe .* n_exp(n_exp > 0);

    split = regexp(filename,'\d*','match');
    offset = (sys_params.N_rx ~= 1) + 2;

    Ka  = str2double(split{offset});
    V   = str2double(split{offset + 1});
    kx  = str2double(split{offset + 2});

    file_list(i).V = V;
    file_list(i).Ka = Ka;
    file_list(i).kx = kx;
end
end

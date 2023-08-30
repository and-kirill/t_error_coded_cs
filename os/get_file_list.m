function file_list = get_file_list(sys_params, Ka, V)
src_dir = get_directory(sys_params);
if nargin == 2
    all_files = sprintf('%s/slot_Ka_%d_*.mat', src_dir, Ka);
elseif nargin == 3
    all_files = sprintf('%s/slot_Ka_%d_V%d.mat', src_dir, Ka, V);
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
    file_list(i).results = results;
    [~, V] = filename_split(filename, sys_params);
    file_list(i).V = V;
end
end

function [Ka, V] = filename_split(filename, sys_params)

split = regexp(filename,'\d*','match');
if sys_params.N_rx == 1
    Ka  = str2double(split{2});
    V   = str2double(split{3});
else
    Ka  = str2double(split{3});
    V   = str2double(split{4});
end
end

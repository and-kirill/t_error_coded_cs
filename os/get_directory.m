function dir_path = get_directory(sys_params, subdir)
root_dir = 'data';
if nargin == 2
    root_dir = [root_dir, '/', subdir];
end
if sys_params.N_rx == 1
    dir_path = sprintf('%s/ks_%d', root_dir, sys_params.ks);
else
    assert(sys_params.fading, 'Multiple antennas are not applicable for AWGN');
    dir_path = sprintf('%s/ks_%d_N_%d', root_dir, sys_params.ks, sys_params.N_rx);
end
if ~sys_params.fading
    dir_path = [dir_path, '_awgn'];
end
if ~isfolder(dir_path)
    mkdir(dir_path);
end
end
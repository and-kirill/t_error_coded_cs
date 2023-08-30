function filename = get_output_file(sys_params, Ka, V)
dst_dir = get_directory(sys_params);
filename = sprintf('%s/slot_Ka_%d_V%d.mat', dst_dir, Ka, V);
end

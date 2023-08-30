function frame_output_raw = decode_inner_code(code_params, sys_params, cwd, p_m, p_f)
% Get slot decoding results for each slot in the frame
% Return One-hot mapping for each slot
Q = 2^sys_params.ks;

cwd_qary = bin2qary(cwd, sys_params.ks);
frame_output_raw = zeros(code_params.V, Q);

for i = 1:code_params.V
    cwd = unique(cwd_qary(i, :));
    n_cwd_tx = length(cwd);

    cwd(rand(1, n_cwd_tx) < p_m) = [];
    false_idx = find(rand(1, Q) < p_f);
    cwd = unique([cwd, false_idx]);
    
    frame_output_raw(i, cwd) = 1;
end
end




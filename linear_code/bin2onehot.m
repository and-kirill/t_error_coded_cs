function cwd_onehot = bin2onehot(sys_params, cwd)
cwd_qary = bin2qary(cwd, sys_params.ks);
V = size(cwd_qary, 1);
Q = 2^sys_params.ks;

cwd_onehot = zeros(V, Q);

for slot_id = 1:V
    cwd_onehot(slot_id, cwd_qary(slot_id, :)) = 1;
end
end

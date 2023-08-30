function cwd_bin = qary2bin(cwd_qary, log2Q)
[L, Ka] = size(cwd_qary);
cwd_bin = zeros(Ka, L * log2Q);
for i = 1:L
    idx_dst = (1:log2Q) + (i - 1) * log2Q;
    cwd_bin(:, idx_dst) = de2bi(cwd_qary(i, :) - 1, log2Q);
end
end
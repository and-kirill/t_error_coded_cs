function [iwd, cwd_bin, cwd_rs, prefix_idx] = rs_encode(sys_params, rs_params, Ka)

% Random preambles selected by each user
prefix_idx = randi([1, rs_params.Q_prefix], 1, Ka);
% Generate the information word, encode CRC
iwd = randi([0, 1], Ka, rs_params.k);
prefix_idx
assert(rs_params.b == 0, 'CRC is not implemented yet!');

iwd_qary = gf(bin2qary(iwd, log2(rs_params.Q_RS)) - 1, log2(rs_params.Q_RS));
% RS encodinfg (informartion part)
cwd_rs = rs_params.G_RS' * iwd_qary;
% Add prefix to each slot
Q = 2^sys_params.ks;
cwd_qary = mod(double(cwd_rs.x) + rs_params.prefix(prefix_idx, :)', Q);
cwd_bin = qary2bin(cwd_qary, sys_params.ks);
end
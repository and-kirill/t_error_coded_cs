function [iwd, cwd_bin, cwd_rs, prefix] = rs_encode(sys_params, rs_params, Ka)

% Random preambles selected by each user
prefix = randi([0, rs_params.Q_prefix - 1], 1, Ka);
% Generate the information word, encode CRC
iwd = randi([0, 1], Ka, rs_params.k);

assert(rs_params.b == 0, 'CRC is not implemented yet!');

iwd_qary = gf(bin2qary(iwd, log2(rs_params.Q_RS)) - 1, log2(rs_params.Q_RS));
% RS encodinfg (informartion part)
cwd_rs = rs_params.G_RS' * iwd_qary;
% Add prefix to each slot
cwd_qary = double(cwd_rs.x) + prefix * rs_params.Q_RS + 1;
cwd_bin = qary2bin(cwd_qary, sys_params.ks);
end
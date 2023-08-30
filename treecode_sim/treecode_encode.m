function [iwd, cwd] = treecode_encode(Ka, code_params, sys_params)
iwd = randi([0, 1], Ka, sys_params.k);
cwd = mod(iwd * code_params.G, 2);
end
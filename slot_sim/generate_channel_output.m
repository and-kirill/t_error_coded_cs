function y = generate_channel_output(cwd, codebook, sys_params, sigma_noise)
Ka = size(cwd, 2);
[slot_length, Q] = size(codebook);
S = zeros(Q, Ka);

for i = 1:Ka
    S(cwd(i), i) = 1;
end
if sys_params.fading
    h = S * generate_cn([Ka, sys_params.N_rx]) / sqrt(2);
else
    h = S * ones([Ka, sys_params.N_rx]);
end
% Received signal
y = codebook * h + generate_cn([slot_length, sys_params.N_rx]) * sigma_noise;
end
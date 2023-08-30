function rs_params = generate_rs_params(sys_params, V, kx)
rs_params.log2Q_RS = sys_params.ks - kx;
rs_params.Q_prefix = 2^kx;
rs_params.Q_RS = 2^rs_params.log2Q_RS;

rs_params.k = ceil(sys_params.k / rs_params.log2Q_RS) * rs_params.log2Q_RS;
rs_params.b = 0; % The CRC size
rs_params.k_rs = (rs_params.k + rs_params.b) / rs_params.log2Q_RS;
rs_params.R_RS = rs_params.k_rs / V;
rs_params.G_RS = reed_solomon_G(rs_params.k_rs, V, rs_params.log2Q_RS);
end


function G = reed_solomon_G(k, n, log2Q)
% Create the Reed-Solomon code generator matrix
% k     -- the number of information bits
% n     -- the code length (the number of slots in our setup)
% log2Q -- field size
deg_matrix = (0:(n - 1)) .* (0:(k - 1))';
alpha = gf(2, log2Q);
G = alpha .^ deg_matrix;
end

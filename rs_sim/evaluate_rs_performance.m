function [success_K, n_CRC] = evaluate_rs_performance(rs_params, cwd_hat_qary, cwd_rs, prefix)
m = 10; % Maximum multiplicity coefficient

cwd_hat_rs_matrix = mod(cwd_hat_qary - 1, rs_params.Q_RS);
prefix_id_matrix = floor((cwd_hat_qary - 1) ./ rs_params.Q_RS);
success_K = 0;
V = size(cwd_hat_qary, 1);
n_CRC = zeros(1, rs_params.Q_prefix);

for prefix_val = 0:(rs_params.Q_prefix - 1)
    tx_idx = find(prefix == prefix_val);
    T = length(tx_idx);
    if T == 0
        continue;
    end

    prefix_id_cur = prefix_id_matrix == prefix_val;
    coverage_matrix = zeros(T, V);
    cwd_tx = cwd_rs(:, prefix == prefix_val);
    for i = 1:V
        symb_list = cwd_hat_rs_matrix(i, prefix_id_cur(i, :));
        for j = 1:T
            coverage_matrix(j, i) = sum(cwd_tx(i, j) == symb_list) > 0;
        end
    end

    metric = sum(coverage_matrix, 2)';
    CM = sum(prefix_id_cur(:) ~= 0);
    success_K = success_K + sum(metric >= sqrt((m + 1) / m .* CM * (rs_params.k_rs - 1)));
    complexity = min(1, sqrt(m * (m + 1) * CM / 2 / rs_params.k_rs));

    n_CRC(prefix_val + 1) = ceil(log2(complexity)) + log2(rs_params.Q_prefix);
end
n_CRC = max(n_CRC);
end

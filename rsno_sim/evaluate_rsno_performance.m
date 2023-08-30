function [success_K, n_CRC] = evaluate_rs_performance(rs_params, cwd_hat_qary, cwd_rs, prefix)
success_K = zeros(1, rs_params.Q_prefix);
% V = size(cwd_hat_qary, 1);
n_CRC = zeros(1, rs_params.Q_prefix);

for prefix_val = unique(prefix)
    cwd_hat = mod(cwd_hat_qary - rs_params.prefix(prefix_val, :)', 2^15);
    cwd_hat(cwd_hat >= rs_params.Q_RS) = nan;

    coverage_matrix = get_coverage_matrix(cwd_rs(:, prefix == prefix_val), cwd_hat);
    [n_CRC(prefix_val + 1), success_K(prefix_val + 1)] = ervaluate_rs(rs_params, coverage_matrix, cwd_hat);
end

n_CRC = max(n_CRC);
success_K = sum(success_K);
end


function coverage_matrix = get_coverage_matrix(cwd_tx, cwd_hat)
[V, T] = size(cwd_tx);
coverage_matrix = zeros(T, V);
for i = 1:V
    symb_list = cwd_hat(i, :);
    for j = 1:T
        coverage_matrix(j, i) = sum(cwd_tx(i, j) == symb_list) > 0;
    end
end
end

function [n_CRC, K_success] = ervaluate_rs(rs_params, coverage_matrix, cwd_hat, m)
if nargin == 3
    m = 10; % Maximum multiplicity coefficient
end
CM = sum(~isnan(cwd_hat(:)) ~= 0);
if CM == 0
    n_CRC = 0; K_success = 0;
    return;
end

metric = sum(coverage_matrix, 2)';

K_success = sum(metric >= sqrt((m + 1) / m .* CM * (rs_params.k_rs - 1)));
complexity = min(1, sqrt(m * (m + 1) * CM / 2 / rs_params.k_rs));

n_CRC = ceil(log2(complexity)) + log2(rs_params.Q_prefix);
end

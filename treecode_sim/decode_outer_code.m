function cwd_list = decode_outer_code(sys_params, code_params, frame_output_raw, cwd)
check_codewords_coverage(sys_params, code_params, frame_output_raw, cwd);

for V = 1:code_params.V
    b = code_params.inf_bits(V);
    Q_slot = 2^b;
    slot_iwd = gen_iwd_book(b);
    % Construct all possible codeword candidates / metric lists
    if V == 1
        iwd_list = slot_iwd;
        metric_list = zeros(1, Q_slot);
    else
        n_iwd = size(iwd_list, 1);
        iwd_list = [repelem(iwd_list, Q_slot, 1), repmat(slot_iwd, n_iwd, 1)];
        metric_list = repelem(metric_list, 1, Q_slot);
    end
    G = get_G(code_params, V);
    cwd_list = mod(iwd_list * G, 2);

    inner_idx = bin2qary(cwd_list(:, ((V - 1)* sys_params.ks + 1):end), sys_params.ks);
    metric_list = metric_list + 1 - frame_output_raw(V, inner_idx);
    % Remove candidate codeword with too high metrics
    remove_idx = find(metric_list > code_params.t);
    iwd_list(remove_idx, :) = [];
    cwd_list(remove_idx, :) = [];
    metric_list(remove_idx) = [];
    covered_idx = get_correct_cwd_count(cwd_list, cwd);
    fprintf('Decoded slot %d (%d bits), list size %1.3e, covered codewords: %d\n', V, b, size(cwd_list, 1), sum(covered_idx));
end
end


function true_idx = get_correct_cwd_count(cwd_list, cwd)
[~, n_bits] = size(cwd_list);
Ka = size(cwd, 1);
cwd_parts = cwd(:, 1:n_bits);

true_idx = zeros(1, Ka);
for i = 1:Ka
    [val, ~] = min(sum(mod(cwd_list + cwd_parts(i, :), 2), 2));
    if val == 0
        true_idx(i) = 1;
    end
end
end


function G = get_G(code_params, slot_index)
k = sum(code_params.inf_bits(1:slot_index));
n = slot_index * code_params.ks;
G = code_params.G(1:k, 1:n);
end


function iwd_book = gen_iwd_book(k)
    if k == 0
        iwd_book = [];
        return;
    end
    iwd_book = logical(de2bi(0:(2^k - 1), k));
end

function check_codewords_coverage(sys_params, code_params, frame_output_raw, cwd)
Ka = size(cwd, 1);
size(frame_output_raw)
V = size(frame_output_raw, 1);
fprintf('Active users: %d, V = %d\n', Ka, V);

coverage_map = zeros(Ka, V);
cwd_qary = bin2qary(cwd, sys_params.ks);
for slot_id = 1:V
    idx = (1:sys_params.ks) + sys_params.ks * (slot_id - 1);
    if min(idx) > size(cwd, 2)
        break;
    end
    for user_id = 1:Ka
        coverage_map(user_id, slot_id) = frame_output_raw(slot_id, cwd_qary(slot_id, user_id));
    end
    fprintf('Slot: %d, t = 0:%d, Covered:', slot_id, code_params.t);
    for t = 0:code_params.t
        n_covered = sum(sum(coverage_map, 2) >= slot_id - t);
        fprintf(' %d', n_covered);
    end
    fprintf('\n');
end
end
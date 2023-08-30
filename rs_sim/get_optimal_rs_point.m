function [V, ebno_db] = get_optimal_rs_point(sys_params, Ka, kx)
[ebno_db, V, ~] = evaluate_rs_ebno_db(sys_params, Ka, kx);
p_e = 0;

fprintf('================================================================================\n');
if V ~= 0
    fprintf('TEST EBNO: Ka = %d, kx = %d, e_b = %1.3e (@V = %d)\n', Ka, kx, ebno_db, V);
else
    [p_e, ebno_db, V, kx] = get_min_rs_pupe(sys_params, Ka, kx);
    fprintf('TEST PUPE: Ka = %d, kx = %d, p_e = %1.3e (@V = %d, Eb/N0 = %1.3f)\n', Ka, kx, p_e, V, ebno_db);
end
fprintf('================================================================================\n');
if isinf(ebno_db) || p_e > 0.5
    V = 0; kx = 0;
end
end

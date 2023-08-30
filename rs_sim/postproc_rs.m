close all;
clc;
clear;

sp = sys_params_default(15, 1);
Ka_series = get_rs_ka();

kx_series = 6:10;

N_prefix = length(kx_series);
N_Ka = length(Ka_series);
Eb = zeros(N_Ka, N_prefix);

print_prefix_header(kx_series);
for i = 1:N_Ka
    Ka = Ka_series(i);
    for j = 1:N_prefix
        [ebno_db, ~, ~] = evaluate_rs_ebno_db(sp, Ka, kx_series(j));
        Eb(i, j) = ebno_db;
    end
    print_row(Ka, Eb(i, :));
end

% Print Eb/N0 Ka data
fprintf(' Ka      EBNO  V  K0 bp CRC     Ro\n');
for Ka = Ka_series
    [ebno_db, V, kx, K0] = evaluate_rs_ebno_db(sp, Ka);
    if isinf(ebno_db)
        continue;
    end
    crc_size = ceil(log2(1 / sp.far_rate / sp.p_e));
    k_total = sp.k + kx;
    ebno_db_shift = 10 * log10((k_total + crc_size) / k_total);
    rs_params = generate_rs_params(sp, V, kx);
    r_outer = rs_params.k_rs / V;
    fprintf('%03d %1.3e %02d %03d %02d  %02d %1.4f\n', ...
        Ka, ebno_db + ebno_db_shift, V, K0, kx, kx + crc_size, r_outer...
        );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function print_prefix_header(kx_series)
fprintf('Ka  ');
for i = 1:length(kx_series)
    fprintf('   %02d    ', kx_series(i));
end
fprintf('\n');
end


function print_row(Ka, x)
fprintf('%03d ', Ka);
for i = 1:length(x)
    print_double(x(i));
end
fprintf('\n');
end


function print_double(x)
if isinf(x)
    fprintf('   --    ');
else
    fprintf('%1.2e ', x);
end
end


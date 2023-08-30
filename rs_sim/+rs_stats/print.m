function s = print(chs)

n_experiments = chs.n_exp;

s = sprintf('#%1.3e, ', n_experiments);
if n_experiments == 0
    return;
end
s = [s, 'PUPE: '];

[p_e, K0] = min(chs.PUPE);
n_crc = chs.n_CRC(K0) / n_experiments;

s = [s, sprintf('%1.3e @ K0 = %d. CRC: %02d bits.', p_e / n_experiments, K0, round(n_crc))];
end

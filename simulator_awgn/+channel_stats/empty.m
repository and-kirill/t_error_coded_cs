function chs = empty()
% Generate empty statistics for simulations. Each field reflects the sum
% over conducted experiments
chs = struct( ...
    'in_ber',  0, ... Input bit error rate 
    'in_ser',  0, ... Input symbol error rate
    'out_ber', 0, ... Ouptut bit error rate
    'out_fer', 0, ... Output frame error rate
    'n_exp',   0  ... Total number of conducted experiments
    );
end
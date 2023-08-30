close all;
clc;
clear;

sys_params = sys_params_default(15, 1);
sys_params.bound = 'linear';

Ka = 200;

for i = [100, 48, 32, 24, 20, 16, 12, 10, 8]
    sys_params.max_paths = 2^i;
    fprintf('Processing list size 2^%d\n', i);
    simulate_Ka(sys_params, Ka);
end


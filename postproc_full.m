close all;
clc;
clear;

p = gcp('nocreate');
if isempty(p)
    parpool(40 - 12);
end
% system('rm data/*.txt');

% Postproc convolutional bound
sp = sys_params_default(15, 1);
sp.bound = 'capacity';
postproc(sp);

sp.bound = 'converse';
postproc(sp);

sp.bound = 'linear';
sp.max_paths = 2^10;
postproc(sp);

postproc(sys_params_default(15, 1));
postproc(sys_params_default(15, 8));

postproc(sys_params_default(10, 1));
postproc(sys_params_default(10, 8));

postproc(sys_params_default(15, 1, 1));
postproc(sys_params_default(10, 1, 1));

fprintf('Optimal bits allocation for linear code:\n');
for t = [0, 1]
    for Ka = 50:50:200
        print_bit_allocation(15, Ka, t, 2^10);
    end
end

fprintf('Postprocess list dependency:\n');
sys_params = sys_params_default(15, 1);
sys_params.bound = 'linear';
fprintf('Ka = 200, List dependency table\n');
Ka = 200;
fprintf('        ');
for t = 0:5
    fprintf('  t%d', t);
end
fprintf('\n');
for i = [100, 48, 32, 24, 20, 16, 12, 10, 8]
    sys_params.max_paths = 2^i;
    fprintf('v=2^%02d: ', i);
    for t = 0:5
        ebno_db = evaluate_cs_bound(sys_params, Ka, t);
        if isinf(ebno_db)
            fprintf(' --  ');
        else
            fprintf('%2.1f ', ebno_db);
        end
    end
    fprintf('\n');
end

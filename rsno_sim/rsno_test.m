addpath('rsno_sim/');

close all;
clc;

sys_params = sys_params_default(15, 1);

Ka  = 100;
V   =  40;
kx  =  12;
krs =   5;

snr_db = 0;
sigma_noise = awgn_channel.snr_to_sigma(snr_db);

profile off;
profile on;
chs = rsno_single_run(sigma_noise, sys_params, Ka, V, kx, krs);
profile viewer;

restoredefaultpath;
close all;
clc;
clear;

% Output files management routines
addpath('os');
% External module: simulator
addpath('simulator_awgn');

% Random coding bound for the outer code
addpath('rcb');
% Linear code bound
addpath('linear_bound');

% CCS-based bound simulation routines
addpath('cs_sim');
% Inner code simultation routines
addpath('slot_sim');
% Postprocessing routines
addpath('postproc');
% Common routines for the linear code simulations
addpath('linear_code');
% Reed-Solomon simulation routines
addpath('rs_sim');
% Simulate linear random outer code
addpath('treecode_sim');


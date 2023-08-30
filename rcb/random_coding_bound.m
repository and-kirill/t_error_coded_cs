function [P_m, P_f] = random_coding_bound(sys_params, Ka, V, t, p_m, p_f)
% This function calculates random coding bound for the coded compressed
% sensing cheme

% Inputs:
% sys_params: System parameters (see sys_params_default() function)
% Ka:         The number of active users in the frame
% V:          Slot count in the system
% t:          The number of errors that the outer code can correct
% p_m:        Inner code probability of missing a message
% p_f:        Inner code false detection probavility

% Outputs:
% P_m:        Outer code probability of missing a codeword
% P_f:        Outer code false alarm probability (uinon bound over the
%             whole codebook)

Q = 2^sys_params.ks;
M_total = 2^sys_params.k;

P_m = pupe_get(V, t, p_m);
P_f = far_get(Q, Ka, V, t, p_f, p_m) .* (M_total - Ka);
end
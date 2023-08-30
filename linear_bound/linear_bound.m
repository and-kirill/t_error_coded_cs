function [P_m, P_f] = linear_bound(sys_params, Ka, V, t, p_m, p_f)
% This function calculates convolutional bound for the coded compressed
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


Q = get_Q_matrix(sys_params, Ka, V, t, p_m, p_f);
[P_f, ~, inf_bits_pattern] = greedy_bits_allocation(sys_params, Ka, V, Q);

if sys_params.k > sum(inf_bits_pattern)
    P_m = 1;
else
    P_m = pupe_get(V, t, p_m);
end
end

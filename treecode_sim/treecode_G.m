function G = treecode_G(code_params, sys_params)
if nargin == 1
    sys_params = sys_params_default();
end
code_params.n1 = floor(sys_params.n / code_params.V);
code_params.n = code_params.n1 * code_params.V;

% Sanity checks
assert(sum(code_params.inf_bits) == sys_params.k);
assert(length(code_params.inf_bits) == code_params.V);
assert(code_params.n1 * code_params.V == code_params.n);
assert(round(code_params.n1) == code_params.n1);
assert(round(code_params.V) == code_params.V);
fprintf('treecode_GH: Sanity check passed\n');

G = [];
B = code_params.inf_bits;
for i = 1:code_params.V
    G = [G; zeros(B(i), (i-1)*sys_params.ks) randi([0 1], B(i), (code_params.V-i+1)*sys_params.ks)];
end

end
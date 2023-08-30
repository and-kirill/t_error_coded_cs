function A = generate_codebook(slot_length, M)
A = generate_cn([slot_length, M]);
% Normalize the power of each codeword
A_norm = sum(abs(A).^2, 1);
A = A .* (sqrt(slot_length) ./ sqrt(A_norm));
end
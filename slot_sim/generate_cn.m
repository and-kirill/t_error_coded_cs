function x = generate_cn(shape)
try
    % Generate Gaussian samples using GPU (R2020b and later required)
    x = randn(shape, "gpuArray") + 1j * randn(shape, "gpuArray");
catch
    warning('GPU is not available');
    x = randn(shape) + 1j * randn(shape);
end
end

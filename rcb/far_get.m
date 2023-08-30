function far = far_get(Q, Ka, n, t, p0to1, p1to0)

py = py_get(Q, Ka, p0to1, p1to0);

temp_val = (1-py)/py;

far = 1;

for ii = 1:t
    jj = 1:ii;
    far = far + prod(((n - ii + jj)./jj)*temp_val);
end

far = (py^n)*far;

end


function far_exp = far_exp_get(Q, Ka, tau, p0to1, p1to0)

py = py_get(Q, Ka, p0to1, p1to0);
far_exp = Dkl_get(1-tau, py);

end


function py = py_get(Q, Ka, p0to1, p1to0)

px = px_get(Q, Ka);
py = px*(1 - p1to0) + (1 - px)*p0to1;

end


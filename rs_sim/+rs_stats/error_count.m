function n_errors = error_count(chs)
if chs.n_exp == 0
    n_errors = 0;
else
    n_errors = round(min(chs.PUPE));
end

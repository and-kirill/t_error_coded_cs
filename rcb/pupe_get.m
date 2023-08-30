function pupe = pupe_get(n, t, p1to0)

temp_val = p1to0/(1 - p1to0);

pupe = 1;

for ii = 1:t
    jj = 1:ii;
    pupe = pupe + prod(((n - ii + jj)./jj)*temp_val);
end

pupe = 1 - ((1 - p1to0)^n)*pupe;

end


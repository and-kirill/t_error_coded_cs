function Dkl = Dkl_get(p1,p2)

Dkl = p1*log(p1/p2) + (1-p1)*log((1-p1)/(1-p2));

end


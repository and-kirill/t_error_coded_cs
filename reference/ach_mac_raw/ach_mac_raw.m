function [pe1] = ach_mac_raw(k,n, P, Ka, fixrho1, dump_stats, joint_error)
% compute upper bound on prob. of (per-codeword) error.
%
% Random coding with X \sim matn(0, P). This script only computes the raw sum:
% \sum t/K_a  \min_{\rho,\rho_1} (K_a choose t)^rho_1 M^{\rho \rho_1 t} / (t!)^(\rho\rho1) e^(-n E_0(\rho,\rho_1))
% 
% Representative run:
% [pe] = ach_mac_raw(100, 30000, 0.01098, 300)
%
% NOTE: WARNING!!! fixrho1 should be in *decreasing* order and should start with 1!!!
% 
% joint_error = 1 means to use the joint probability of error, not a per-user one.

if(nargin < 5) || (isempty(fixrho1))
	rho1s = linspace(1,0);
else
	rho1s = fixrho1;
end

if(nargin < 6) || (isempty(dump_stats))
	dump_stats = 0;
end


if(nargin < 7) || (isempty(joint_error))
	joint_error = 0;
end

Ts = 1:Ka;
Es = zeros(1, Ka);
best_rho1 = zeros(1, Ka);
best_rho = zeros(1, Ka);


R1 =  k * log(2) / n;

% Before running parfor don't forget to run the following on older MATLABs:
% > matlabpool('open', 4);

% use parfor!
% parfor t=Ts;
for t=Ts  
	R2 = (gammaln(Ka+1) - gammaln(t+1) - gammaln(Ka-t+1))/n;
	%rho1s = linspace(1,0);
	E0min = Inf; br1 = NaN; br = NaN;
	for rho1 = rho1s
		f = @(rho) rho1*rho*t*R1 + rho1*R2 - eval_E0(rho, rho1, P, t) - rho*rho1*gammaln(t+1)/n;
		[rho, E0test] = fminbnd( f, 0, 1);
		if(E0test < E0min)
			br1 = rho1;
			br = rho;
			E0min = E0test;
		else
			%disp(sprintf('ach_mac: t = %d, rho1 = %g, E0test = %g (at rho=%g), breaking here.', t, rho1, E0test, rho));
			break;
		end
		%disp(sprintf('ach_mac: t = %d, rho1 = %g, E0test = %g (at rho=%g)', t, rho1, E0test, rho));
	end
	best_rho(t) = br; best_rho1(t) = br1; Es(t) = E0min;
end

%
% Calculate first term separately
%
V1 = P/(1+P) * log2(exp(1))^2;
gm = k + log2(exp(1)*sqrt(V1*n*2*pi));

% Normal approximation method (non-rigorous)
% thre = (gm - n/2 * log2(1+P))/sqrt(V1*n);
% tt1 = normcdf(thre+norminv(1/2/Ka)) + 2^(k-gm+log2(Ka));

% average non-central chi-squares (rigorous)

prec = 1/100;
Zgrid = chi2inv(0:prec:(1-prec), n);
vals = 0*Zgrid;
% addpath ('C:/Users//Documents/MATLAB/spectre-master/awgn')
% addpath ~/c/spectre/awgn;
for jj=1:(length(Zgrid)-1)
	normz = (Zgrid(jj) + Zgrid(jj+1))/2;
	par = (1+P)/P * (2/log2(exp(1)) * (gm - n/2 * log2(1+P)) + normz);
	%disp(sprintf('Calling ncx2log(%g, %g, %g)', par, n, normz/P));
% 	nncf = log1p(-exp(ncx2log(par, n, normz/P)));
% 	vals(jj) = 1-exp(Ka*nncf)

	%ncx2cdf and ncx2log are too slow, use Berry-Esseen
	mu1 = n+normz/P; mu2 = 2*n + 4*(normz/P); mu3 = 8*n + 24 * normz/P;
	par2 = (mu1 - par)/sqrt(mu2);
	% compute lower bound on 1-ncx2cdf(par, n, normz/P)
	ncx2cocdf_lbnd = max(normcdf(par2) - mu3/(mu2)^(3/2)/2, 0);
	
	% diagnostics
% 	ncx2cocdf = 1-ncx2cdf(par, n, normz/P);
% 	if(ncx2cocdf > 0)
% 		disp(sprintf('comparing 1-ncx2cdf(%g,%g,%g): true = %g, BES=%g, rel.gap = %g', par, n, normz/P, ...
% 				ncx2cocdf, ncx2cocdf_lbnd, (ncx2cocdf-ncx2cocdf_lbnd)/ncx2cocdf));
% 	end
	vals(jj) = 1-ncx2cocdf_lbnd^Ka;
end
tt1 = sum(vals)*prec + 2^(k-gm+log2(Ka));
Es(1) = min(log(tt1)/n, Es(1));

pblock = sum(exp(n*Es));

if(joint_error)
	pe1 = pblock;
else
	pe1 = sum(Ts./Ka .* exp(n*Es));
end

% This prints out contribution of different terms and optimizing rho/rho1
if(dump_stats)
% 	[Ts; Ts./Ka.*exp(n*Es)/pe1; exp(n*Es)/pblock; best_rho; best_rho1]
    if(joint_error)
		fracs = exp(n*Es)/pe1;
	else
		fracs = Ts./Ka.*exp(n*Es)/pe1;
    end
	stats = [Ts; fracs; best_rho; best_rho1];
	stats(:,fracs > 1e-3)
end


% base-e expon!
function E0 = eval_E0(rho, rho1, P, t)
D = (P.*t - 1)^2 + 4.*P.*t * (1+rho1.*rho)./(1+rho);
% xst = ((P.*t - 1) + sqrt(D)) .* (1+rho) ./ (2+2*rho1.*rho);
lamst = ((P.*t - 1) + sqrt(D)) ./ (4*(1+rho1.*rho).*P.*t);
% lamst = xst ./ (2 * (1+rho).*P.*t);

must = rho.*lamst./(1+2*P.*t.*lamst);

a = rho/2 .* log(1+2*P.*t.*lamst) + 1/2 .* log(1+2*P.*t.*must);
b = rho.*lamst - must./(1+2*P.*t.*must);

% I checked this: 1-2*b*rho1 > 0 always
E0 = rho1.*a + 1/2 * log(1-2*b.*rho1);

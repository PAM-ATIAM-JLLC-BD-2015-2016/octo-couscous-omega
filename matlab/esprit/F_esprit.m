function [ delta, f ] = F_esprit( x, n, K )

% High resolution method for frequency extraction

W = F_sig_space( x, n, K );

% Estimation des frequences et des facteurs d'amortissement
Wdown = W(1:end-1,:);
Wup = W(2:end,:);

PHI = pinv(Wdown)*Wup;

[~,Z] = eig(PHI);
delta = diag(log(abs(Z)));
f = (1/(2*pi))*diag(angle(Z));

end


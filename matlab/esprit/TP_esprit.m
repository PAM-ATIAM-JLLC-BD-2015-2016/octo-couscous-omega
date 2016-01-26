function [ delta, f ] = TP_esprit( x, n, K )
% TP_ESPRIT 
% High resolution method

W = sigSpace( x, n, K );

% Estimation des frequences et des facteurs d'amortissement
Wdown = W(1:end-1,:);
Wup = W(2:end,:);

PHI = pinv(Wdown)*Wup;

[~,Z] = eig(PHI);
delta = diag(log(abs(Z)));
f = (1/(2*pi))*diag(angle(Z));

end


function [W,W_orth] = sigSpace( x, n, K )
% This function computes the correlation matrix R and then the space signal
% matrix W
N = length(x);
l = N-n+1;
X = hankel(x);
X = X(1:n,1:l);

Rxx = (1/l)*X*X';

[U1,Lambda,U2]=svd(Rxx);

W=U1(:,1:K);

W_orth = U1(:,K+1:end);

end


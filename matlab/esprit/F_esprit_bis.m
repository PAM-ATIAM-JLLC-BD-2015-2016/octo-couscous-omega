function [f, a, delta, phi] = F_esprit_bis(x, Fs, K, N, n, dis)
%% Computes the ESPRIT method on a signal
% INPUTS
%   x, a column array : signal
%   Fs : sampling rate
%   K : signal space dimension
%   N : size of the studied segment
%   n : n-k is the noise space dimension
%   dis : if 1 displays results and comparison to periodogram
%
% OUTPUTS
%   f : frequencies array
%   a : amplitude array
%   delta : damping array
%   phi : phase array

if nargin<6
    dis = 0;
end    

% Initialization
x = x(1:N);

% Esprit
[delta_esprit, f_esprit] = esprit_priv(x,n,K); 
delta_esprit_temp = delta_esprit(delta_esprit<0);
f_esprit = f_esprit(delta_esprit<0);
delta_esprit = delta_esprit_temp;
[a_esprit,phi_esprit] = least_squares_priv( x, delta_esprit, f_esprit );

% Outputs
data_esprit(:,1) = f_esprit( f_esprit > 0 );
data_esprit(:,2) = a_esprit( f_esprit > 0 );
data_esprit(:,3) = phi_esprit( f_esprit > 0 );
data_esprit(:,4) = delta_esprit( f_esprit > 0 );

data_esprit = sortrows(data_esprit);

f       = data_esprit(:,1);
a       = data_esprit(:,2);
phi     = data_esprit(:,3);
delta   = data_esprit(:,4);

%% Display
if dis == 1    
    % Periodogramme avec zero-padding
    Nfft = 2^nextpow2(N);
    Xd2 = fft(x,Nfft);
    freqx2 = [0:Nfft-1]/Nfft;
    P2 = (1/Nfft)*(abs(Xd2)).^2;
    
    figure('units','normalized','outerposition',[0 0.5 1 0.5])
    hold on
    % Affichage du periodogramme en fond
    plot(freqx2(1:floor(Nfft/2)),db(P2(1:floor(Nfft/2))),'b')
    y_lims_plot = ylim;
    ymin_plot = y_lims_plot(1);
%     baselvl = min(db(P2(1:floor(Nfft/2))));
    % Affichage des pics detects par la methode
    stem(f, db(a),'r','BaseValue',ymin_plot);
    % Noms
    title( ['Periodogramme, pics issus de la methode ESPRIT et comparaison avec les 15 facteurs donnes'])
    xlabel('Frequence normalisee')
    ylabel('Gain (dB)')
    legend('Periodogramme','Freq ESPRIT')
    xlim([0 0.5])
    hold off
end

end

function [ delta, f ] = esprit_priv( x, n, K )
% High resolution method
W = signal_space_priv( x, n, K );

% Estimation des frequences et des facteurs d'amortissement
Wdown = W(1:end-1,:);
Wup = W(2:end,:);

PHI = pinv(Wdown)*Wup;
[~,Z] = eig(PHI);
delta = diag(log(abs(Z)));
f = (1/(2*pi))*diag(angle(Z));

end

function [W,W_orth] = signal_space_priv( x, n, K )
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

function [ a, phi ] = least_squares_priv( x, delta, f )
    N = length(x);
    t = (0:N-1);
    y = delta+1i*2*pi*f;
    VN = exp(t'*y.');
    alpha = pinv(VN)*x;
    a = abs(alpha);
    phi = angle(alpha);
end

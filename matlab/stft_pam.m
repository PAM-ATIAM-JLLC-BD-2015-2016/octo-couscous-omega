function Xs = tfct_pam(x,Fe,Nfft,I)
% analyse d'un signal ? l'aide de la TFCT
% transform?e de Fourier ? Court Terme
%clear all; close all;

x=x(:);
N = length(x); % longueur du signal
%Nw = 512;
Nw = Nfft; % Maxime
w = hanning(Nw); % d?finition de la fenetre d'analyse
ws = w; % d?finition de la fen?tre de synth?se
%R = Nw/4; % incr?ment sur les temps d'analyse,
          % appel? hop size, t_a=uR
R = I; % longueur d'une trame
          
%M = 512; % ordre de la tfd 
M = Nfft; % ordre de la tfd
L = M/2+1;

affich = 1 ; % pour affichage du spectrogramme, 0 pour
             % pour faire analyse/modif/synth?se sans affichage
             % note: cf. spectrogram sous matlab


Nt = fix( (N-Nw)/R ); % calcul du nombre de tfd ? calculer
y = zeros(N,1); % signal de synth?se

if affich
    Xs = zeros(M,Nt);
end

for k=1:Nt;  % boucle sur les trame
   deb = (k-1)*R +1; % d?but de trame
   fin = deb + Nw -1; % fin de trame
   tx = x(deb:fin).*w; % calcul de la trame  
   X = fft(tx,M); % tfd ? l'instant b
   
   if affich, Xs(:,k)=X;end
   
   % op?rations de transformation (sur la partie \nu > 0)
   % ....
   Y = X;
   % fin des op?ration de transformation
   
   %
   ys = real(ifft(Y));
   ys = ys.*ws;
   % overlap add
   y(deb:fin)=y(deb:fin)+ys;
end

% soundsc(y,Fe) % ? d?commenter pour jouer le son

% if affich
%     
% freq = (0:M/2)/M*Fe; % ?chelle de fr?quence
% b = ([0:Nt-1]*R+Nw/2)/Fe; % tps d'analyse (centre de la fen?tre)
% imagesc(b,freq,db(abs(Xs(1:L,:))))
% axis xy
% 
% end
function stft_measure()
Fs = 25600;
Nfft = 2^12;
I = 1;

measure_name = 'measures/yamaha-c40_1/body-no_string_E2/mesure_z2.mat';

load( measure_name );

acceleration = data_Temporel_1(1:Fs,2);
figure, plot( acceleration );

Xs = stft_pam(acceleration,Fs,Nfft,I);
Xs = Xs(1:floor(Nfft/2),:);

freq = [0:floor(Nfft/2)-1]*Fs/Nfft;
ts = [1:size(Xs,2)]/(Fs/I);

res = abs(Xs);

figure
imagesc(ts,freq,res); axis xy
xlabel('time')
ylabel('frequency')
ylim([0 1000])
title('Short term fourier tran5form of acceleration of the guitar bridge');

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

Nt = fix( (N-Nw)/R ); % calcul du nombre de tfd ? calculer
y = zeros(N,1); % signal de synth?se

Xs = zeros(M,Nt);

for k=1:Nt;  % boucle sur les trame
   deb = (k-1)*R +1; % d?but de trame
   fin = deb + Nw -1; % fin de trame
   tx = x(deb:fin).*w; % calcul de la trame  
   X = fft(tx,M); % tfd ? l'instant b
   
   Xs(:,k)=X;
end



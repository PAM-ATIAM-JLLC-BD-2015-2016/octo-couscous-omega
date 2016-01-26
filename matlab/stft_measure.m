
clear all, close all, clc;

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
ylim([0 2000])
title('Short term fourier tran5form of acceleration of the guitar bridge');




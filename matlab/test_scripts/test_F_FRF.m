
%%
clear all, close all, clc;
nb_modes = 150;
Nfft = 2^19;
Fs = 25600;

sound_frf = F_FRF( 'measures/yamaha-c40_1/body-no_string_E2//mesure_z1.mat', 'E2', 1);
figure, plot(sound_frf);
soundsc(sound_frf,Fs);

figure, plot([0:Nfft-1]*Fs/Nfft,db(fft(sound_frf,Nfft)));
xlim([0 5000])

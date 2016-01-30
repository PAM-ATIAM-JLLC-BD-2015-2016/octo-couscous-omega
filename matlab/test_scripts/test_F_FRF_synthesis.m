

%function test_F_FRF_synthesis()
clear all, close all, clc;

Nfft = 2^19;
Fs = 25600;
note_str = 'E2';

measure_str = ['matlab/measures/yamaha-c40_1/body-no_string_' note_str '/mesure_z3.mat'];      

sound_frf = F_FRF_synthesis( measure_str, note_str, 'point', 0);

sound_frf = sound_frf/max(abs(sound_frf));

figure, plot([0:Nfft-1]*Fs/Nfft, db(fft( sound_frf, Nfft )));
title(['Synthesized Guitar Sound FFT : ' note_str]), xlabel('Frequency(Hz)'), ylabel('Gain(dB)')
xlim([0 Fs/2]);

soundsc( sound_frf, Fs );
%audiowrite( 'guitar_FRF_old_woodhouse_coeffs.wav', sound_frf, Fs);

%end
    
    
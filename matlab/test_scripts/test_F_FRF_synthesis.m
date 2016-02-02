

%function test_F_FRF_synthesis()
clear all, close all, clc;

Nfft = 2^19;
Fs = 25600;
note_str = 'E2';

measure_str = ['matlab/measures/yamaha-c40_1/body-no_string_' note_str '/mesure_z2.mat'];      

s = {};

s.string_modes_number       = 30;
s.note_str                  = 'E2';
s.path_measure_mat_str      = measure_str;
s.excitation_type            = 'point';
s.excitation_length         = 33;
s.excitation_bridge_dist    = 0.15; %m
s.listening_mode            = 'position'; % 'acceleration', 'speed' or 'position'


sound_frf = F_FRF_synthesis( s, 1 );

sound_frf = sound_frf/max(abs(sound_frf));

figure, plot([0:Nfft-1]*Fs/Nfft, db(fft( sound_frf, Nfft )));
title(['Synthesized Guitar Sound FFT : ' note_str]), xlabel('Frequency(Hz)'), ylabel('Gain(dB)')
xlim([0 Fs/2]);

soundsc( sound_frf, Fs );
%audiowrite( 'guitar_FRF_E4_100modes_integrated_point_xexc_17cm.wav', sound_frf, Fs);

%end
    
    
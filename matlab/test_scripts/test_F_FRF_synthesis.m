

%function test_F_FRF_synthesis()
clear all, close all, clc;

Nfft = 2^19;
Fs = 25600;
note_str = 'E2';

measure_str = 'matlab/measures/yamaha-c40_1/body-no_string_E2/mesure_z2.mat';      

sound_frf = F_FRF_synthesis( measure_str, note_str, 'point', 0);

sound_frf = sound_frf/max(abs(sound_frf));

soundsc( sound_frf, Fs );

audiowrite( 'FRF_synthesis_17mm_pointExc.wav', sound_frf, Fs);


%end
    
    
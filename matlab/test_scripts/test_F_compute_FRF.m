
function test_F_compute_FRF()

clear all, close all, clc;

Nfft = 2^19;
Fs = 25600;
f_hz_v = Fs*linspace(0,1,Nfft); f_hz_v = f_hz_v(1:Nfft/2+1);
omega_rad_v = 2*pi*f_hz_v+eps;

note_str = 'E2';
measure_str = ['matlab/measures/yamaha-c40_1/body-no_string_' note_str '/mesure_z3.mat'];  

[Y11_b,~] = F_compute_FRF(measure_str,Fs,Nfft);

%% Plotting
figure, plot( f_hz_v, real(Y11_b) )
title('TEST REAL F compute FRF (Y body)')
xlabel('\omega')
xlim([0 5000])
figure, plot( f_hz_v, db(Y11_b) )
title('TEST DB F compute FRF (Y body)')
xlabel('\omega')
xlim([0 5000])

%% Correcting the integration
f0 = 50;
[~, i0] = min(abs(f_hz_v-f0));
Y11_b(1:i0) = eps;

%% Plotting
figure, plot( omega_rad_v/(2*pi), real(Y11_b) )
title('TEST REAL F compute FRF (Y body) after setting to zero')
xlabel('\omega')
xlim([0 5000])
figure, plot( omega_rad_v/(2*pi), db(Y11_b) )
title('TEST DB F compute FRF (Y body) after setting to zero')
xlabel('\omega')
xlim([0 5000])

%% Invert and listen
res = F_duplicate_with_hermitian_symmetry( Y11_b );

g = ifft( res );
g = g/max(abs(g));

figure, plot(f_hz_v, db(Y11_b)), title('TEST ifft(Y body)')

soundsc( g, Fs );
audiowrite( 'test_F_compute_FRF_Ybody.wav', g, Fs );


end
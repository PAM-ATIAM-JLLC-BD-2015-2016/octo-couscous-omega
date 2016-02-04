
clear all, close all, clc;

string_modes_number = 100;
Nfft = 2^18;
str_note_name = 'E2';
DEBUG_MODE = 0;
Fs = 25600;
f = [0:Nfft/2]*Fs/Nfft;

excitation_bridge_dist = 0.15;

[ H_string, Z_string ] = ...
    F_string_frfs( string_modes_number, Nfft, str_note_name, excitation_bridge_dist, DEBUG_MODE );

figure
hold on
plot(f(1:end),db(1./Z_string(1:end)))
title('Z_string');
xlim([50 5000])
%stem(f0*[1:string_modes_number],0.5*max(db(Z_string(2:end)))*ones(1,string_modes_number));
hold off

%%
Z_sym = Z_string(1:Nfft/2+1);
Z_sym(1) = Z_sym(2);
Z_sym = [ Z_sym ; flip(conj(Z_sym(2:end-1)))];
gz = ifft(Z_sym.^(-1),'symmetric');

%figure, plot(real(gz));
%soundsc(real(gz),Fs);
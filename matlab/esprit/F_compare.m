
Fs = 25600;

signal_mes = load('..\measures\yamaha-c40_1\string_90-E4\mesure_z2.mat');
signal_mes = cumtrapz(signal_mes.data.X(500:10500));
signal_frf = audioread('..\..\sounds\frf\RAPPORT\FRF_synthesis_17mm_pointExc.wav');
signal_mod = audioread('..\..\sounds\synthesis\modal\experiment_like\guitar-E4-40_string_modes-15_body_modes.wav');
signal_mod = diff(signal_mod(1000:11001));

[f_mes,delta_mes] = F_extract(signal_mes,Fs,15,2.^nextpow2(length(signal_mes)));
[f_frf,delta_frf] = F_extract(signal_frf,Fs,15,2.^nextpow2(length(signal_frf)));
[f_mod,delta_mod] = F_extract(signal_mod,Fs,15,2.^nextpow2(length(signal_mod)));
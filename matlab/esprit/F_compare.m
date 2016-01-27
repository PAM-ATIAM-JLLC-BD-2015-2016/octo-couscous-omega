

Fs = 25600;
signal = load('..\measures\yamaha-c40_1\string_90-E4\mesure_z2.mat');
signal = signal.data.X;

[f_extract,delta_extract] = F_extract(signal,Fs,15,2.^nextpow2(length(signal)));
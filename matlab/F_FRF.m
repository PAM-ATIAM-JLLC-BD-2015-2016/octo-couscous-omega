clc; close all; clear all

% Parameters
Fs = 25600;


% Loading the measure of admittance
total_z = open('mesures/total_z.mat');
Y_z = total_z.data_FRF_1;
Y_y = total_z.data_FRF_2;
xfreqs = [0:length(Y_z)-1]*.5*Fs/length(Y_z);

figure
subplot 211
plot(xfreqs, db(Y_z))
title( 'Admittance Y11 (normal direction)' ) 
xlabel('Frequency (Hz)' )
ylabel('Gain (dB)' )
subplot 212
plot(xfreqs, db(Y_y))
title( 'Admittance Y12 (transverse direction)' ) 
xlabel('Frequency (Hz)' )
ylabel('Gain (dB)' )

% Computing the response transfer function 
[H,~,~,f] = F_string_model(200);
figure
plot(f,db(H))
title( 'String displacement transfer function from excitation point to bridge' ) 
xlabel('Frequency (Hz)' )
ylabel('Gain (dB)' )

% Interpolating the measure to have the same number of points
Y_za = interp1(linspace(0,Fs,length(Y_z)),Y_z,linspace(0,Fs,length(H)),'spline');
Y_y = interp1(linspace(0,Fs,length(Y_y)),Y_y,linspace(0,Fs,length(H)),'spline');

% Multiplying admittance with transfer function to complete the model
G = H.*Y_za;

% Computing the green function of the system 
g = real(ifft(1./[G fliplr(G)]));

% Plotting
plot(db(G))

%%

soundsc(g(1:Fs),Fs)
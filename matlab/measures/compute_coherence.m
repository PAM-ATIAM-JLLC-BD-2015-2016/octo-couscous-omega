clear all
close all
clc

%% Coherence computation 

Fs = 25600;
Nfft = 2^(nextpow2(Fs)-1);

Nb_mesure = 5;
signal_name = 'yamaha-c40_1/body-no_string_E4/mesure_z';
measure_struct = load([signal_name num2str(1) '.mat']);
Y_1 = repmat(measure_struct.data_FRF_1, 1, Nb_mesure-1);    
Y_2 = repmat(measure_struct.data_FRF_2, 1, Nb_mesure-1);

Y_temp = F_duplicate_with_hermitian_symmetry( [Y_1(:,1);0] );
y_1 = ifft(Y_temp);

clear struct;

% S_ref_1 = spectral_density(Y_1,Y_1);
% S_ref_2 = spectral_density(Y_2,Y_2);
 %for k = 2:Nb_mesure-1
 count = 1;
 for k = [2 3 4]
 
   measure_struct = load([signal_name num2str(k) '.mat']);
   X_1(:,count) = measure_struct.data_FRF_1;
   X_2(:,count) = measure_struct.data_FRF_2;
   X_temp = F_duplicate_with_hermitian_symmetry( [X_1(:,count);0] );
   x_1(:,count) = ifft(X_temp);
   
   %x_1(:,count) = measure_struct.data_Temporel_1(:,2); 
   
   count = count + 1;
   clear struct

 end

[coherence,f] = mscohere(y_1,x_1,hanning(Nfft),Nfft/2,Nfft,Fs);
coherence_tot = sum(coherence,2)/3;

figure, plot(f,coherence_tot);
title('Coherence estimation E4')
xlabel('Frequencies')
ylabel('Magnitude')

xlim([50 5000]);

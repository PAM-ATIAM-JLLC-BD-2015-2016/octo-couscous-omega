
Fs = 25600;

number_mod = 30;

signal_mes = load('..\measures\yamaha-c40_1\string_90-E4\mesure_z2.mat');
signal_mes = (signal_mes.data.X);
signal_mes = (signal_mes(500:10500));
signal_frf = audioread('..\..\sounds\frf\RAPPORT\FRF_synthesis_17mm_pointExc_E4.wav');
signal_frf = signal_frf(1000:11000);
[signal_mod,Fs_mod] = audioread('..\..\sounds\synthesis\modal\experiment_like\guitar-E4-40_string_modes-15_body_modes.wav');
signal_mod = diff(signal_mod(1000:11001));

[f_mes,delta_mes] = F_extract(signal_mes,Fs,number_mod,2.^nextpow2(length(signal_mes)+2));
[f_frf,delta_frf] = F_extract(signal_frf,Fs,number_mod,2.^nextpow2(length(signal_frf)));
[f_mod,delta_mod] = F_extract(signal_mod,Fs_mod,number_mod,2.^nextpow2(length(signal_mod)));

subplot 211
hold on
stem(f_mes(1:5),ones(1,5))
stem(f_frf(1:5),ones(1,5))
stem(f_mod(1:5),ones(1,5))
legend('mes','frf','mod')
xlabel('frequency [Hz]')
set(gca,'YTick',[]);
hold off

subplot 212
hold on
scatter(f_mes,delta_mes)
scatter(f_frf,delta_frf)
scatter(f_mod,delta_mod)
hold off
%plot(f_mes,delta_mes,f_frf,delta_frf,f_mod,delta_mod)
legend('mes','frf','mod')
xlabel('frequency [Hz]')
ylabel('damping [Hz]')
axis tight
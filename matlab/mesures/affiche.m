clc
close all
clear all
body_z = open('Temp_1.mat');
total_z = open('Temp_3.mat');
parfait_90 = open('parfait_90.mat');
parfait_90 = parfait_90.data; 

Fs = 25600;
f0 = 77;
f = linspace(0,Fs,length(total_z.data_FRF_1));
%%


figure
subplot 211
plot(f,db(total_z.data_FRF_1))
ax = gca;
ax.XTick = 78:78:Fs;
hold on
grid on
xlim([0 2000])
plot(f,db(body_z.data_FRF_1))
legend('total', 'body')


subplot 212
plot(f,angle(total_z.data_FRF_1))
ax = gca;
ax.XTick = 78:78:Fs;
hold on
plot(f,0*(1:length(f)));
grid on
xlim([0 2000])

%%
%{
figure

plot(f,unwrap(angle(body_z.data_FRF_1)))
ax = gca;
ax.YTick = -700*pi:pi:0;
legend('total', 'body')
grid on

%%
figure
plot(f,angle(body_z.data_FRF_1))
grid on
%%
%}
figure
plot(f,db(1./(1./total_z.data_FRF_1  - 1./body_z.data_FRF_1)))
xlim([0 2000])
ax = gca;
grid on
ax.XTick = 78:78:Fs;

%%

figure
subplot 211
pwelch(parfait_90.X,1024,512,2^12,5000)
xlim([0 0.5])

subplot 212
pwelch(total_z.data_Temporel_1(:,2),8496,2048,2^16,Fs)
xlim([0 0.5])


hold off




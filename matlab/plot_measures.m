%%%%% PLOTTING MEASURES
%
%
%
clear all, close all, clc;

%%
f = [0:65536-1]*12800/65536;
midiTF = 12*log2(f/440)+69;
Nz = [1 2 3 4 5];
Ny = [1 2 3 4 5];

f1 = 50;
f2 = 500;
f1_bin = floor(65536*f1/12800);
f2_bin = floor(65536*f2/12800);

measure_name = 'body no string E4 : ';

integrate_b = true;

%% Normal Direction Admittances
%
% Y11
name = 'mesure_z';

figure_fullscreen
subplot 221
hold on
for k = Nz
    load([name sprintf('%d',k) '.mat']);
    if integrate_b
        y = abs(data_FRF_1./(i*f.'+eps));
    else
        y = abs(data_FRF_1);
    end
    y = y(f1_bin:f2_bin);
    semilogx(f(f1_bin:f2_bin).',db(y));
end
title([measure_name 'Y11'])
legend('1','2','3','4','5')
xlim([f1 f2])
hold off

% Y12

subplot 222
hold on
for k = Nz
    load([name sprintf('%d',k) '.mat']);
    if integrate_b
        y = abs(data_FRF_2./(i*f.'+eps));
    else
        y = abs(data_FRF_2);
    end
    y = y(f1_bin:f2_bin);
    semilogx(f(f1_bin:f2_bin).',db(y));
end
legend('1','2','3','4','5')
title([measure_name 'Y12'])
xlim([f1 f2])
hold off

%% Transverse Direction Admittances
%
% 
name = 'mesure_y';

% Y22
subplot 224
hold on
for k = Ny
    load([name sprintf('%d',k) '.mat']);
    if integrate_b
        y = abs(data_FRF_2./(i*f.'+eps));
    else
        y = abs(data_FRF_2);
    end
    y = y(f1_bin:f2_bin);
    semilogx(f(f1_bin:f2_bin).',db(y));
end
title([measure_name 'Y22'])
legend('1','2','3','4','5')
xlim([f1 f2])
hold off


% Y21
subplot 223
hold on
for k = Ny
    load([name sprintf('%d',k) '.mat']);
    if integrate_b
        y = abs(data_FRF_1./(i*f.'+eps));
    else
        y = abs(data_FRF_1);
    end
    y = y(f1_bin:f2_bin);
    semilogx(f(f1_bin:f2_bin).',db(y));
end
title([measure_name 'Y21'])
legend('1','2','3','4','5')
xlim([f1 f2])
hold off
clc; close all; clear all

% Parameters
Fs = 25600;
Nfft = 2^18;

df = Fs/Nfft;
f1 = 50;
f2 = 5000;
f1_bin = floor(f1/df);
f2_bin = floor(f2/df);
f = [0:Nfft-1]*Fs/Nfft;

% Loading the measure of admittance
[Y11_b,~] = F_compute_FRF('measures/yamaha-c40_1/body-no_string_E2/mesure_z1.mat',Fs,Nfft);

% Computing the response transfer function 
[H,Z,~,f] = F_string_model(200);
Hint = H(:);
Zint = Z(:);

%% Multiplying admittance with transfer function to complete the model
G = Hint.*1./(1./Y11_b+Zint);

% Making sure G satisfies the hermitian symmetry
G_sym = G(1:Nfft/2+1);
G_sym(1:f1_bin) = eps; % This sets to zero G in the very low frequencies.
% it might be needed after integrating the measures
G_sym = [G_sym;flip(conj(G_sym(2:end-1)))];

% the last term has an angle equal to zero
G_sym(Nfft/2+1) = abs(G_sym(Nfft/2+1));

% Computing the green function of the system 
g = ifft(G_sym); % g must be real.

% Plotting
figure_fullscreen 
subplot 411
    plot(f,db(H)), xlim([f1 f2]), title('H')
subplot 412
    plot(f,db(1./(Z+eps))), xlim([f1 f2]), title('1/Z_{string}')
subplot 413
    plot(f,db(Y11_b)), xlim([f1 f2]), title('Y_{body}')
subplot 414
    plot(f,db(G_sym)), xlim([f1 f2]), title('G_{whole}')
    
%%
t = [0:length(g)-1]/Fs;    
figure, plot(t,g), title('g')  
g2 = [g(floor(length(g)*0.4):end);g(1:floor(length(g)*0.4)-1)];
figure, plot(t,g2), title('g2')  

%%
 g = g/(max(abs(g))+eps);
 soundsc(g(1:floor(length(g)*0.4)),Fs);
%g2 = g2/(max(abs(g2))+eps);
%soundsc(g2,Fs)

%% 
g3 = g(1:floor(length(g)*0.4));
exc_size = 100;
x = zeros(1,3*Fs);
x(1:exc_size) = ones(1,exc_size);
y1 = conv(x,g3);
figure, plot(g3), title('g')
figure, plot(x), title('x1')
figure, plot(y1), title('y1 = conv(g,x)')

%%
y1 = y1/(max(abs(y1))+eps);
soundsc(y1,Fs);
pause(2)
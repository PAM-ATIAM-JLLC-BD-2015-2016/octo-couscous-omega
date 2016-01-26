
function sound_frf = F_FRF_synthesis( str_path_measure_mat, note_str, excitation_str, DEBUG_MODE)
% Synthesizes the guitar sound thanks to a frequency domain synthesis
% INPUTS
%   str_path_measure_mat : path to the mesure of admittance
%   note_str : 'E2', 'A2', 'D3', 'G3', 'B3', 'E4'
%   mode_debug (optional) : displays plots if true.
%   excitation_str : 'point' or 'wide'

%% Parameters
Fs = 25600; Nfft = 2^19; df = Fs/Nfft;
f1 = 50; f2 = 5000; f1_bin = floor(f1/df); f2_bin = floor(f2/df);
f = [0:Nfft/2]*Fs/Nfft;
f = f(1:Nfft/2+1);
nb_modes = 40;

%% Loading the measure of admittance
[Y11_b,~] = F_compute_FRF(str_path_measure_mat,Fs,Nfft);
Y11_b = -Y11_b;

%% Computing the response transfer function 
[H,Z] = F_string_frfs_2(nb_modes, Nfft, note_str,DEBUG_MODE);

%% Multiplying admittance with transfer function to complete the model
G = H.*Y11_b./(1+Z.*Y11_b);
%G = H.*Z.*Y11_b./(Z+Y11_b);


%% Inverting the FFT
G_sym = F_duplicate_with_hermitian_symmetry( G );

g = ifft(G_sym); 

%% Plotting
if DEBUG_MODE
    figure_fullscreen 
    subplot 411
        plot(f,db(H)), xlim([f1 f2]), title('H')
        %plot(f,real(H)), xlim([f1 f2]), title('H')
    subplot 412
        plot(f,db(1./(Z+eps))), xlim([f1 f2]), title('1/Z_{string}')
        %plot(f,real(1./(Z+eps))), xlim([f1 f2]), title('1/Z_{string}')
    subplot 413
        plot(f,db(Y11_b)), xlim([f1 f2]), title('Y_{body}')
        %plot(f(1:Nfft/2+1),real(Y11_b)), xlim([f1 f2]), title('Y_{body}')
    subplot 414
        plot([0:Nfft-1]*Fs/Nfft,db(G_sym)), xlim([f1 f2]), title('G_{whole}')
        %plot([0:Nfft-1]*Fs/Nfft,real(G_sym)), xlim([f1 f2]), title('G_{whole}')
end    
%% 
t = [0:length(g)-1]/Fs;     
g2 = [g(floor(length(g)*0.4):end),g(1:floor(length(g)*0.4)-1)];

if DEBUG_MODE
    figure, plot(t,g), title('g') 
    figure, plot(t,g2), title('g2')  
end

% if DEBUG_MODE
%     soundsc(g(1:floor(length(g)*0.4)),Fs);
%     pause(6)
% end
%g2 = g2/(max(abs(g2))+eps);
%soundsc(g2,Fs)

%% 
g3 = g(1:floor(length(g)*0.4));

if (strcmp(excitation_str,'point') == 1)
    sound_frf = g3;
elseif (strcmp(excitation_str,'wide') == 1)
    exc_size = 100;
    x = zeros(1,3*Fs);
    x(1:exc_size) = ones(1,exc_size);

    sound_frf = conv(x,g3);
end
% if DEBUG_MODE
%     figure, plot(g3), title('g')
%     figure, plot(x), title('x1')
%     figure, plot(y1), title('y1 = conv(g,x)')
% end
%%
%y1 = y1/(max(abs(y1))+eps);
% if DEBUG_MODE
%     soundsc(y1,Fs);
%     pause(6);
% end
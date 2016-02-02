
function [sound_frf,G,Y11_b,H,Z] = F_FRF_synthesis( structIn, DEBUG_MODE)
% Synthesizes the guitar sound thanks to a frequency domain synthesis
% INPUTS
%   structIn.str_path_measure_mat : path to the mesure of admittance
%   structIn.note_str : 'E2', 'A2', 'D3', 'G3', 'B3', 'E4'
%   structIn.excitation_str : 'point' or 'wide'
%   mode_debug (optional) : displays plots if true. 


disp(structIn);

%% Parameters
path_measure_mat_str    = structIn.path_measure_mat_str;
note_str                = structIn.note_str;
excitation_type         = structIn.excitation_type;
excitation_length       = structIn.excitation_length;
excitation_bridge_dist  = structIn.excitation_bridge_dist;
string_modes_number     = structIn.string_modes_number;
listening_mode          = structIn.listening_mode;

Fs = 25600; Nfft = 2^19; df = Fs/Nfft;
f1 = 50; f2 = 20000; f1_bin = floor(f1/df); f2_bin = floor(f2/df);
f = Fs*linspace(0,1,Nfft);
f = f(1:Nfft/2+1);

%% Loading the measure of admittance
[Y11_b,~] = F_compute_FRF(path_measure_mat_str,Fs,Nfft);
Y11_b = -Y11_b;

%% Computing the response transfer function 
[H,Z] = F_string_frfs(string_modes_number, Nfft, note_str, excitation_bridge_dist, DEBUG_MODE);

%% Multiplying admittance with transfer function to complete the model
G = H./(1./Y11_b+Z);

%% Integrating the admittance
if (strcmp(listening_mode,'Position') == 1)
    G = G./(1i*f'+eps);
    f0 = 50;
    [~, i0] = min(abs(f-f0));
    G(1:i0) = eps;
elseif (strcmp(listening_mode,'Acceleration') == 1)
    G = G.*f';
end
    
%% Inverting the FFT
G_sym = F_duplicate_with_hermitian_symmetry( G );

g = ifft(G_sym); 

%% Plotting
if DEBUG_MODE
    figure_fullscreen 
    hold on
        plot(f,real(H)), xlim([f1 f2]), 
        plot(f,real(1./(Z+eps))), xlim([f1 f2]), 
        %plot(f,real(Z)), xlim([f1 f2]), 
        plot(f,real(Y11_b)), xlim([f1 f2])
        %legend('H', 'Y_{string}', 'Y_{body}')
        legend('H', 'Z_{string}', 'Y_{body}')
    hold off
    figure
    subplot 311
        plot(f,db(H)), xlim([f1 f2]), title('H')
        %plot(f,real(H)), xlim([f1 f2]), title('H')
    subplot 312
        %plot(f,db(1./(Z+eps))), xlim([f1 f2]), title('1/Z_{string}')
        plot(f,db(Z)), xlim([f1 f2]), title('Z_{string}')
        %plot(f,real(1./(Z+eps))), xlim([f1 f2]), title('1/Z_{string}')
    subplot 313
        plot(f,db(Y11_b)), xlim([f1 f2]), title('Y_{body}')
        %plot(f(1:Nfft/2+1),real(Y11_b)), xlim([f1 f2]), title('Y_{body}')
    figure
     subplot 121
        plot([0:Nfft-1]*Fs/Nfft,db(G_sym)), title('Guitar FRF \delta_{bridge} / F_{excitation}')
        xlim([50 800]), xlabel('Frequency(Hz)'), ylabel('Gain(dB)')
     subplot 122
        plot([0:Nfft-1]*Fs/Nfft,db(G_sym)), title('Guitar FRF \delta_{bridge} / F_{excitation}')
        xlim([3000 3800]), xlabel('Frequency(Hz)'), ylabel('Gain(dB)')
        %plot([0:Nfft-1]*Fs/Nfft,real(G_sym)), xlim([f1 f2]), title('G_{whole}')
end    
%% 
t = [0:length(g)-1]/Fs;     
g2 = [g(floor(length(g)*0.9):end),g(1:floor(length(g)*0.9)-1)];

% if DEBUG_MODE
%     figure, plot(t,g), title('g') 
%     figure, plot(t,g2), title('g2')  
% end

% if DEBUG_MODE
%     soundsc(g(1:floor(length(g)*0.4)),Fs);
%     pause(6)
% end
%g2 = g2/(max(abs(g2))+eps);
%soundsc(g2,Fs)

%% 
g3 = g(1:floor(length(g)*0.4));
%g3 = g2;
disp('*** FRF Synthesis done ***')
if (strcmp(excitation_type,'Impulse') == 1)
    sound_frf = g3;
elseif (strcmp(excitation_type,'Rectangular') == 1)
    exc_size = excitation_length;
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

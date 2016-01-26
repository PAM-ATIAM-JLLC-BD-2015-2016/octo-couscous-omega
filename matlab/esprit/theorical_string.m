function [y,Fs,string_frequency,string_damping_coeffs_v] = theorical_string(str_note_name)


% str_note_name = 'E2', 'A2', 'D3', 'G3', 'B3', or 'E4'

if nargin < 2
    str_note_name = 'E2';
    if nargin < 3
        Nfft = 2^18;
    end
end
Fs = 25600;    % Sampling frequency
dt = 1/Fs;     % time step
Tmax = 6;      % waving time
t=0:dt:Tmax;   % time vector
%f = 1:Fs;
f = Fs*linspace(0,1,Nfft);
omega = 2*pi*f;

%% String modelling parameters + string admittance / impedance
% Values obtained from Woodhouse's 'Plucked guitar transients' paper

%% String physical characteristics

[lin_mass, bend_stif, tens, eta_F, eta_B, eta_A] = select_string_parameters(str_note_name);

string_length = 0.65;
string_linear_mass = lin_mass; %6.24*10^(-3);
% xi = 10^(-3);  % Damping 2*xi = 1/Q = eta  Q = quality factor
string_bending_stiffness = bend_stif; %57e-6;
string_tension = tens; %71.6;
celerity = sqrt(string_tension/string_linear_mass);  


%% Observation parameters
initial_height = 5*10^(-3);
x_listening = string_length/8;  % Listening point
x_excitation = string_length/4;                        
string_modes_number = 10;  % Number of modes

%% Parameters container
string_params = {};

string_params.string_length = string_length;
string_params.string_linear_mass = string_linear_mass;
string_params.string_bending_stiffness = string_bending_stiffness;
string_params.string_tension = string_tension;
string_params.celerity = celerity;

string_params.initial_height = initial_height;
string_params.x_listening = x_listening;
string_params.x_excitation = x_excitation;

%% Modes computation
string_frequency = (1:string_modes_number)*pi*celerity/string_length .* ...
    (1 + (string_bending_stiffness/(2*string_tension)) * ...
    ((1:string_modes_number)*pi/string_length).^2);
string_wave_number = string_frequency/celerity;
%% Damping coefficient as described in Woodhouse (b)
string_damping_coeffs_v = ...
    (string_tension*(eta_F+(eta_A ./ string_frequency)) + ...
        string_bending_stiffness*eta_B * ...
        ( (1:string_modes_number) *pi/string_length).^2) ./ ...
    (string_tension+string_bending_stiffness * ...
        ( (1:string_modes_number) *pi/string_length).^2);

string_damping_coeffs_v = 100*string_damping_coeffs_v;

%% Inclusion of Initial Conditions
yn = zeros(string_modes_number,length(t));
y = zeros(1,length(t));
for n = 1:string_modes_number
    yn(n,:)=sin(string_wave_number(n)*x_excitation)*sin(string_wave_number(n)*x_listening)*((initial_height/(string_length-x_excitation))+(initial_height/x_excitation))/(string_wave_number(n))*cos(string_frequency(n)*t).*exp(-string_damping_coeffs_v(n)*string_frequency(n)*t);
    y = y+yn(n,:);
end

end


%% Fonction selection paramètres
function [lin_mass, bend_stif, tens, etaF, etaB, etaA] = select_string_parameters(str_note_name)

if strcmp(str_note_name,'E2')
    nb_note = 1;
elseif strcmp(str_note_name,'A2')
    nb_note = 2;
elseif strcmp(str_note_name,'D3')
    nb_note = 3;
elseif strcmp(str_note_name,'G3')
    nb_note = 4;
elseif strcmp(str_note_name,'B3')
    nb_note = 5;
elseif strcmp(str_note_name,'E4')
    nb_note = 6;
end             
   
% Arrays
linear_mass_arr = (1e-3)*[6.24, 3.61, 1.95, 0.9, 0.52, 0.38];
bending_stiffness_arr = (1e-6)*[57, 40, 51, 310, 160, 130];
tension_arr = [71.6, 73.9, 71.2, 58.3, 53.4, 70.3];
eta_F_arr = (1e-6)*[2,7,5,14,40,40];
eta_B_arr = (1e-5)*[2,2.5,2,2,2,2.4];
eta_A_arr = (1e-2)*[1.2, 0.9, 1.2, 1.7, 1.2, 1.5];

lin_mass = linear_mass_arr(nb_note);
bend_stif = bending_stiffness_arr(nb_note);
tens = tension_arr(nb_note);
etaF = eta_F_arr(nb_note);
etaB = eta_B_arr(nb_note);
etaA = eta_A_arr(nb_note);

end
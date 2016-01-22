function [ H_string, Z_string, string_params,f ] = ...
    F_string_model( string_modes_number, Nfft )

if nargin < 2
    Nfft = 2^18;
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

string_length = 0.65;
string_linear_mass = 6.24*10^(-3);
% xi = 10^(-3);  % Damping 2*xi = 1/Q = eta  Q = quality factor
string_bending_stiffness = 57e-6;
string_tension = 71.6;
celerity = sqrt(string_tension/string_linear_mass);     

%% Observation parameters
initial_height = 5*10^(-3);
x_listening = string_length/8;  % Listening point
x_excitation = string_length/4;                        
% string_modes_n = 10;  % Number of modes

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
eta_F = 2*10^(-6);
eta_B = 2*10^(-5);
eta_A = 1.2*10^(-2);

% for n=1:string_modes_number
%     string_damping_coeffs_v(n) = (string_tension*(eta_F+(eta_A/string_frequency(n))) + ...
%         string_bending_stiffness*eta_B*( n *pi/string_length)^2) / ...
%         (string_tension+string_bending_stiffness*( n *pi/string_length)^2);
% end

string_damping_coeffs_v = ...
    (string_tension*(eta_F+(eta_A ./ string_frequency)) + ...
        string_bending_stiffness*eta_B * ...
        ( (1:string_modes_number) *pi/string_length).^2) ./ ...
    (string_tension+string_bending_stiffness * ...
        ( (1:string_modes_number) *pi/string_length).^2);

string_damping_coeffs_v = 1000 * string_damping_coeffs_v;

%% Inclusion of Initial Conditions


yn = zeros(string_modes_number,length(t));
y = zeros(1,length(t));
for n = 1:string_modes_number
    yn(n,:)=sin(string_wave_number(n)*x_excitation)*sin(string_wave_number(n)*x_listening)*((initial_height/(string_length-x_excitation))+(initial_height/x_excitation))/(string_wave_number(n))*cos(string_frequency(n)*t).*exp(-string_damping_coeffs_v(n)*string_frequency(n)*t);
    y = y+yn(n,:);
end

%% String Impedance Z for Nmodes
TMP = zeros(string_modes_number,length(f));

for n =1:string_modes_number
  TMP(n,:) = (2*omega - 1i*string_frequency(n)*string_damping_coeffs_v(n))./...
      (omega.^2 - 1i*omega*string_frequency(n)*string_damping_coeffs_v(n) - (string_frequency(n)^2)*(1-(string_damping_coeffs_v(n)^2)/4));
end


Z_string = -(1i*string_tension/string_length)*((1./omega) + sum(TMP));  % String impedance equation (29)
clear TMP
%% Transfer function displacement/displacement

for n =1:string_modes_number
%   TMP(n,:) = (-1)^n*(2*omega*sin(n*pi*x_excitation/string_length))./...
%       (omega.^2 - 1i*omega*string_frequency(n)*string_damping_coeffs_v(n) - (string_frequency(n)^2)*(1-(string_damping_coeffs_v(n)^2)/4));
TMP(n,:) = (-1)^n*(2*omega*sin(n*pi*x_excitation/string_length))./...
       (omega.^2 - 1i*omega*string_frequency(n)*string_damping_coeffs_v(n) - string_frequency(n)^2);
end

H_string = x_excitation/string_length + (celerity/string_length)*sum(TMP);

%figure;
%plot(f,abs(fft(y)));

end

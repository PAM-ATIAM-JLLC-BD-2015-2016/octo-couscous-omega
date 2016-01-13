function [ H_string, Z_string, string_params ] = ...
    F_string_model( string_modes_n )

%% Discretisation fr�quentielle et temporelle

Fs = 44100;    % Sampling frequency
dt = 1/Fs;     % time step
Tmax = 6;      % waving time
t=0:dt:Tmax;   % time vector
f = Fs*linspace(0,1,length(t));
w = 2*pi*f;

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

%% D�termination des modes
string_wave_number=zeros(1,string_modes_n); % Pre-allocation

for n=1:string_modes_n
    string_frequency(n) = (n*pi*celerity/string_length)*(1+(string_bending_stiffness/(2*string_tension))*(n*pi/string_length)^2);   
end

string_wave_number = string_frequency/celerity;

%% Damping coefficient as described in Woodhouse (b)
eta_F = 2*10^(-6);
eta_B = 2*10^(-5);
eta_A = 1.2*10^(-2);

for n=1:string_modes_n
string_damping_coeff(n) = (string_tension*(eta_F+(eta_A/string_frequency(n))) + string_bending_stiffness*eta_B*(n*pi/string_length)^2)/(string_tension+string_bending_stiffness*(n*pi/string_length)^2);
end

%% Application des CI

yn = zeros(string_modes_n,length(t));
y = zeros(1,length(t));
for n = 1:string_modes_n
yn(n,:)=sin(string_wave_number(n)*x_excitation)*sin(string_wave_number(n)*x_listening)*((initial_height/(string_length-x_excitation))+(initial_height/x_excitation))/(string_wave_number(n))*cos(string_frequency(n)*t).*exp(-string_damping_coeff(n)*string_frequency(n)*t);
y = y+yn(n,:);
end


%% String Impedance Z for Nmodes
TMP = zeros(string_modes_n,length(t));

for n =1:string_modes_n
  TMP(n,:) = (2*w - 1i*string_frequency(n)*string_damping_coeff(n))./...
      (w.^2 - 1i*w*string_frequency(n)*string_damping_coeff(n) - (string_frequency(n)^2)*(1-(string_damping_coeff(n)^2)/4));
end

Z_string = -(1i*string_tension/string_length)*((1./w) + sum(TMP));  % String impedance equation (29)

clear TMP
%% Transfer function displacement/displacement

for n =1:string_modes_n
  TMP(n,:) = (-1)^n*(2*w*sin(n*pi*x_excitation/string_length))./...
      (w.^2 - 1i*w*string_frequency(n)*string_damping_coeff(n) - (string_frequency(n)^2)*(1-(string_damping_coeff(n)^2)/4));
end

H_string = x_excitation/string_length + (celerity/string_length)*sum(TMP);

%figure;
%plot(f,abs(fft(y)));

end

function [Z_string] = modele_corde(string_modes_n)

%% Discretisation fréquentielle et temporelle

Fs = 44100;    % Sampling frequency
dt = 1/Fs;     % time step
Tmax = 6;      % waving time
t=0:dt:Tmax;   % time vector
f = Fs*linspace(0,1,length(t));
w = 2*pi*f;
%% Caractéristiques de la corde

string_length = 0.65;              
string_linear_mass = 6.24*10^(-3);    
%xi = 10^(-3);                                % damping 2*xi = 1/Q = eta  Q = facteur de qualité 
string_bending_stiffness = 57e-6;            
initial_height = 5*10^(-3);                        
xe = string_length/8;                         % listening point
string_tension = 71.6;                         
celerity = sqrt(string_tension/string_linear_mass);     
excitation_point = string_length/4;                        
string_modes_n = 10;                                 % NUmber of modes

parameters=[string_length string_linear_mass];


%% Détermination des modes
string_wave_number=zeros(1,string_modes_n); % Pré-allocation
for n=1:string_modes_n
    %k_n(n)=n*pi/L;
    string_frequency(n) = (n*pi*celerity/string_length)*(1+(string_bending_stiffness/(2*string_tension))*(n*pi/string_length)^2);   
end
%w_n=k_n*c;
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
yn(n,:)=sin(k_n(n)*excitation_point)*sin(k_n(n)*xe)*((initial_height/(string_length-excitation_point))+(initial_height/excitation_point))/(k_n(n))*cos(w_n(n)*t).*exp(-string_damping_coeff(n)*w_n(n)*t);
y = y+yn(n,:);
end


%% String Impedance Z for Nmodes
TMP = zeros(string_modes_n,length(t));

for n =1:string_modes_n
  TMP(n,:) = (2*w - 1i*string_frequency(n)*string_damping_coeff(n))./...
      (w.^2 - 1i*w*string_frequency(n)*string_damping_coeff(n) - (string_frequency(n)^2)*(1-(string_damping_coeff(n)^2)/4));
end
Z_string = -(1i*string_tension/string_length)*((1./w) + sum(TMP));  % String impédance equation (29)

%% Transfer function displacement/displacement



%figure;
%plot(f,abs(fft(y)));

end

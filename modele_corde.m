clear all
close all
clc

%% Discretisation fréquentielle et temporelle

Fe = 44100;    % Fréquence d'échantillonnage
dt = 1/Fe;     % Discrétisation temporelle
Tmax = 6;      % Temps de vibration
t=0:dt:Tmax;   % Vecteur temps
f = Fe*linspace(0,1,length(t));
w = 2*pi*f;
%% Caractéristiques de la corde

L = 0.65;             % Longueur corde de mi
ml = 6.24*10^(-3);    % rho*l masse linéique
%xi = 10^(-3);         % 2*xi = 1/Q = eta  Q = facteur de qualité 
B = 57e-6;            % Bending Stiffness
h = 5*10^(-3);        % hauteur
xe = L/8;             % Point d'écoute
T = 71.6;            % Tension            
c = sqrt(T/ml);      % Célérité
x0 = L/4;             % Point d'excitation
Nmodes = 100;           % Nombre de modes



%% Détermination des modes
k_n=zeros(1,Nmodes); % Pré-allocation
for n=1:Nmodes
    %k_n(n)=n*pi/L;
    w_n(n) = (n*pi*c/L)*(1+(B/(2*T))*(n*pi/L)^2);   
end
%w_n=k_n*c;
k_n = w_n/c;

%% Coefficient d'amortissement définit dans woodhouse(b)
eta_F = 2*10^(-6);
eta_B = 2*10^(-5);
eta_A = 1.2*10^(-2);

for n=1:Nmodes
eta(n) = (T*(eta_F+(eta_A/w_n(n))) + B*eta_B*(n*pi/L)^2)/(T+B*(n*pi/L)^2);
end



% %% Application des CI
% 
% yn = zeros(Nmodes,length(t));
% y = zeros(1,length(t));
% for n = 1:Nmodes
% yn(n,:)=sin(k_n(n)*x0)*sin(k_n(n)*xe)*((h/(L-x0))+(h/x0))/(k_n(n))*cos(w_n(n)*t).*exp(-eta(n)*w_n(n)*t);
% y = y+yn(n,:);
% end

som = zeros(Nmodes,length(t));

for n =1:Nmodes
  som(n,:) = 1./(w - w_n(1,n)*(1+1i*eta(n)/2)) + 1./(w + w_n(1,n)*(1-1i*eta(n)/2));
    
end

Z = -(1i*T/L)*((1./w) + sum(som));  % Impédance de la corde equation (29)

% figure;
% plot(f,abs(fft(y)));

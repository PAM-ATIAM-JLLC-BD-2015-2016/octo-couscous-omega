function [ string_params, string_damping_coeffs_v ] = ...
    F_string_model( string_modes_number, str_note_name )
% 
% str_note_name = 'E2', 'A2', 'D3', 'G3', 'B3', or 'E4'

if nargin < 2
    str_note_name = 'E2';
end

%% String physical characteristics

[lin_mass, bend_stif, tens, eta_F, eta_B, eta_A] = select_string_parameters(str_note_name);

string_length = 0.65;
string_linear_mass = lin_mass; %6.24*10^(-3);
% xi = 10^(-3);  % Damping 2*xi = 1/Q = eta  Q = quality factor
string_bending_stiffness = bend_stif; %57e-6;
string_tension = tens; %71.6;
celerity = sqrt(string_tension/string_linear_mass);  

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


%% Damping coefficient as described in Woodhouse (b)

string_damping_coeffs_v = ...
    (string_tension*(eta_F+(eta_A ./ string_frequency)) + ...
        string_bending_stiffness*eta_B * ...
        ( (1:string_modes_number) *pi/string_length).^2) ./ ...
    (string_tension+string_bending_stiffness * ...
        ( (1:string_modes_number) *pi/string_length).^2);

end

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
function [ string_params ] = F_select_string_parameters( str_note_name )
%% String parameters selection wrapper, using values provided by Woodhouse

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

%% String physical characteristics

string_length = 0.65;
string_linear_mass = lin_mass;
string_bending_stiffness = bend_stif;
string_tension = tens;
celerity = sqrt(string_tension/string_linear_mass);  

%% Observation parameters
initial_height = 0.01;  % 1cm
x_listening = string_length/8;  % Listening point
x_excitation = string_length/4;                        

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

end
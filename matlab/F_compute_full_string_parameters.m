function [ string_params ] = F_compute_full_string_parameters( ...
    str_note_name, string_modes_number )
% This function returns a structure with the parameters of the string
% according to a given note, as well as the frequencies and the damping
% coefficients.
%
% str_note_name = 'E2', 'A2', 'D3', 'G3', 'B3', or 'E4'


%% String physical characteristics
% String specific values
[string_linear_mass, string_bending_stiffness, string_tension, ...
    eta_F, eta_B, eta_A] = F_select_basic_string_parameters(str_note_name);

% Common values for all strings
string_length   = 0.65;
celerity        = sqrt(string_tension/string_linear_mass);
initial_height  = 0.01;
x_listening     = string_length/8;
x_excitation    = string_length/4;

%% Parameters container
string_params = {};

string_params.length             = string_length;
string_params.linear_mass        = string_linear_mass;
string_params.bending_stiffness  = string_bending_stiffness;
string_params.tension            = string_tension;
string_params.celerity           = celerity;
string_params.etaA               = eta_A;
string_params.etaB               = eta_B;
string_params.etaF               = eta_F;

string_params.initial_height    = initial_height;
string_params.x_listening       = x_listening;
string_params.x_excitation      = x_excitation;

%% String frequencies as described in Woodhouse (a)
string_natural_frequencies_rad_v = ...
    F_compute_string_natural_frequencies_rad_v( ...
        string_params, string_modes_number ); 

string_params.natural_frequencies_rad_v = string_natural_frequencies_rad_v;

%% Damping coefficients as described in Woodhouse (b)
string_loss_factors_v = F_compute_string_loss_factors_v( ...
    string_params, string_modes_number ); 
    
string_params.loss_factors_v = string_loss_factors_v ;

end
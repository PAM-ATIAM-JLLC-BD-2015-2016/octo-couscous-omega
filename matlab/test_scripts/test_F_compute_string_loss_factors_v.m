function res = test_F_compute_string_loss_factors_v ()

str_note_name = 'E2';
string_modes_number = 40;

[string_linear_mass, string_bending_stiffness, string_tension, ...
    eta_F, eta_B, eta_A] = F_select_string_parameters(str_note_name);

string_length   = 0.65;
celerity        = sqrt(string_tension/string_linear_mass);
initial_height  = 0.01;
x_listening     = string_length/8;  
x_excitation    = string_length/4;     

%% Parameters container
string_params = {};

string_params.string_length             = string_length;
string_params.string_linear_mass        = string_linear_mass;
string_params.string_bending_stiffness  = string_bending_stiffness;
string_params.string_tension            = string_tension;
string_params.celerity                  = celerity;
string_params.etaA                      = eta_A;
string_params.etaB                      = eta_B;
string_params.etaF                      = eta_F;

string_params.initial_height    = initial_height;
string_params.x_listening       = x_listening;
string_params.x_excitation      = x_excitation;

%% TEST
res = F_compute_string_loss_factors_v( string_params, string_modes_number );

%% Display
figure, plot( res )
title('TEST F compute string loss factors');
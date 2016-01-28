function [ string_linear_mass, string_bending_stiffness, ...
    string_tension, eta_F, eta_B, eta_A ] = ...
    F_select_basic_string_parameters( str_note_name )
%% String parameters selection wrapper, using values provided by Woodhouse

if strcmp(str_note_name,'E2')
    note_n = 1;
elseif strcmp(str_note_name,'A2')
    note_n = 2;
elseif strcmp(str_note_name,'D3')
    note_n = 3;
elseif strcmp(str_note_name,'G3')
    note_n = 4;
elseif strcmp(str_note_name,'B3')
    note_n = 5;
elseif strcmp(str_note_name,'E4')
    note_n = 6;
else
    error('Must input note name');
end             
   
% Values given in Woodhouse (B)
linear_masses_v = (1e-3)*[6.24, 3.61, 1.95, 0.9, 0.52, 0.38];
bending_stiffnesses_v = (1e-6)*[57, 40, 51, 310, 160, 130];
tensions_v = [71.6, 73.9, 71.2, 58.3, 53.4, 70.3];

eta_F_v = (1e-5)*[2,7,5,14,40,40];
eta_B_v = (1e-2)*[2,2.5,2,2,2,2.4];
eta_A_v = [1.2, 0.9, 1.2, 1.7, 1.2, 1.5];

% Select appropriate values according to the chosen string
string_linear_mass = linear_masses_v(note_n);
string_bending_stiffness = bending_stiffnesses_v(note_n);
string_tension = tensions_v(note_n);
eta_F = eta_F_v(note_n);
eta_B = eta_B_v(note_n);
eta_A = eta_A_v(note_n);

end
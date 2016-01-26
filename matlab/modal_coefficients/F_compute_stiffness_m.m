function [ stiffness_m ] = F_compute_stiffness_m( string_modes_number, ...
    string_params, body_effective_stiffnesses_v )
%% Stiffness matrix, K, computation
% 

L = string_params.length;
T = string_params.tension;
B = string_params.bending_stiffness;

%% String block
squared_string_modes_n_v = ((1:string_modes_number).^2).';
stiffness_1_1_v = squared_string_modes_n_v * pi^2/(2*L) .* ( ...
    T + B*(pi/L)^2 * squared_string_modes_n_v);

stiffness_1_1_m = diag(stiffness_1_1_v);

%% Body block
stiffness_2_2_v = T/L + diag(body_effective_stiffnesses_v);

%% Block-wise matrix definition
stiffness_m = blkdiag( stiffness_1_1_m, stiffness_2_2_v );

end
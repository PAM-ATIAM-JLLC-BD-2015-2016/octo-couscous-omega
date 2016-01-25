function [ stiffness_m ] = F_compute_stiffness_m( ...
    string_modes_number, body_modes_number, string_bending_stiffness, ...
    string_length, string_tension, ...
    effective_stiffnesses_v )
%% Stiffness matrix, K, computation
% 

%% String block
squared_string_modes_n_v = ((1:string_modes_number).^2).';
stiffness_1_1_v = squared_string_modes_n_v * pi^2/(2*string_length) .* ( ...
    string_tension + ...
        string_bending_stiffness*(pi/string_length)^2 * ...
        squared_string_modes_n_v);

stiffness_1_1_m = diag(stiffness_1_1_v);

%% Body block
stiffness_2_2_v = string_tension/string_length + ...
    diag(effective_stiffnesses_v);

%% Block-wise matrix definition
stiffness_m = blkdiag( stiffness_1_1_m, stiffness_2_2_v );

end
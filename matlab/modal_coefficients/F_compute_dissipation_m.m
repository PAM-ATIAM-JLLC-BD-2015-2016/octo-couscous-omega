function [ dissipation_m ] = F_compute_dissipation_m( ...
    string_modes_number, ...
    string_linear_mass, string_tension, ...
    effective_stiffnesses_v, effective_masses_v, ...
    body_q_factors_v, string_q_factors_v )
%% Dissipation matrix, C, computation
% 

%% String block
dissipation_1_1_v = pi*sqrt(string_tension*string_linear_mass)/2 * ...
    (1:string_modes_number) ./ string_q_factors_v.';
dissipation_1_1_m = diag(dissipation_1_1_v);

%% Body block
dissipation_2_2_v = ...
    sqrt(effective_stiffnesses_v.*effective_masses_v) ./ body_q_factors_v;
dissipation_2_2_m = diag(dissipation_2_2_v);

%% Block-wise matrix definition
dissipation_m = blkdiag(dissipation_1_1_m, dissipation_2_2_m);

end
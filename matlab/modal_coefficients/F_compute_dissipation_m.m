function [ dissipation_m ] = F_compute_dissipation_m( ...
    string_modes_number, string_params, body_effective_stiffnesses_v, ...
    body_effective_masses_v, body_q_factors_v, string_q_factors_v )
%% Dissipation matrix, C, computation
% 

T = string_params.tension;
rho = string_params.linear_mass;

%% String block
dissipation_1_1_v = pi*sqrt(T*rho)/2 * (1:string_modes_number).' ./ ...
    string_q_factors_v;
dissipation_1_1_m = diag(dissipation_1_1_v);

%% Body block
dissipation_2_2_v = ...
    sqrt(body_effective_stiffnesses_v.*body_effective_masses_v) ./ body_q_factors_v;
dissipation_2_2_m = diag(dissipation_2_2_v);

%% Block-wise matrix definition
dissipation_m = blkdiag(dissipation_1_1_m, dissipation_2_2_m);

end
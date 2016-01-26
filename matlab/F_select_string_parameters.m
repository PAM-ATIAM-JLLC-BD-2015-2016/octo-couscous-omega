
function [lin_mass, bend_stif, tens, etaF, etaB, etaA] = F_select_string_parameters(str_note_name)

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


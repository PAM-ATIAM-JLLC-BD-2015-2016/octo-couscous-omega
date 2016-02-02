
function H_string = F_compute_h_string( string_params, omega_rad_v )

string_modes_number = length( string_params.loss_factors_v );

mode_n_v = 1:string_modes_number;
x = string_params.x_excitation;
c = string_params.celerity;
L = string_params.length;
B = string_params.bending_stiffness;
T = string_params.tension;

% Equation (31) de Woodhouse (a)
 Wn_v    = string_params.natural_frequencies_rad_v.';
 etan_v  = string_params.loss_factors_v.';

 Wn_v_plot = Wn_v;
% Introduction de d?viations par rapport au mod?le id?al 
%Wn_v = mode_n_v.' * pi * c/L ...
%        .* ( 1 + B*(mode_n_v.').^2 );
  
%  figure, hold on, plot(abs(Wn_v_plot)), plot(abs(Wn_v)), hold off
%  title('abs(Wn)'), legend( 'Wn1','Wn2')
%  figure, hold on, plot(real(Wn_v_plot)), plot(real(Wn_v)), hold off
%  title('abs(Wn)'), legend( 'Wn1','Wn2')
%  figure, hold on, plot(imag(Wn_v_plot)), plot(imag(Wn_v)), hold off
%  title('abs(Wn)'), legend( 'Wn1','Wn2')
%  figure, hold on, plot(angle(Wn_v_plot)), plot(angle(Wn_v)), hold off
%  title('abs(Wn)'), legend( 'Wn1','Wn2')
%  disp(Wn_v(end))
%  disp(Wn_v_plot(end))
 
 Wn_v = Wn_v.*(1+1i*etan_v/2);
 Wn_v2 = Wn_v.*(1-1i*etan_v/2);

Wn_m    = repmat(Wn_v, 1, length(omega_rad_v));
Wn_m2   = repmat(Wn_v2, 1, length(omega_rad_v));
etan_m  = repmat(etan_v.', 1, length(omega_rad_v));

W_m     = repmat(omega_rad_v, string_modes_number, 1);
power_m = repmat((-1).^mode_n_v.', 1, length(omega_rad_v));

mode_n_m = repmat(mode_n_v.', 1, length(omega_rad_v));

%temp = sum( power_m ./ ( W_m - Wn_m + eps) );
temp = sum( power_m .* (1./ ( W_m - Wn_m ) + 0./ ( W_m + Wn_m2 )) );

H_string = x/L + (c/L)*sin(omega_rad_v*x/c) .* temp;

end
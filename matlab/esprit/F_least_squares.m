function [a,phi]=F_least_squares(signal,delta,freq)

N = length(signal);

V = exp((0:N-1)'*(delta+1j*2*pi*freq));

alpha = pinv(V)*signal;
a = (abs(alpha)).';
phi = (angle(alpha)).';

end


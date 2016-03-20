function [ value ] = huberFunctionG( U, gamma )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

v = zeros(size(U));
Uab = abs(U);
ind = Uab <= gamma;
v(ind) = 0.5*Uab(ind);
v(~ind) = gamma * Uab(~ind)-0.5*gamma*gamma;
value = sum(sum(v));

end


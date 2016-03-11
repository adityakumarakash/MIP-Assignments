function [ D ] = huberFunctionH(U, gamma)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

Uab = abs(U);
ind = Uab <= gamma;
D = zeros(size(Uab));
D(ind) = U(ind);
D(~ind) = gamma*sign(U(~ind));

end


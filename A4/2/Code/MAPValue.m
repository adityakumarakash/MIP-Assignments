function [ estimate ] = MAPValue( X, Mask, Y, k, mew, var, beta )
% Calculates the MAP estimate for the X
%   Detailed explanation goes here

Potential = zeros(size(X));
Potential = Potential + beta * (circshift(X, 1, 1) ~= X) .* circshift(Mask, 1, 1);
Potential = Potential + beta * (circshift(X, -1, 1) ~= X) .* circshift(Mask, -1, 1);
Potential = Potential + beta * (circshift(X, 1, 2) ~= X) .* circshift(Mask, 1, 2);
Potential = Potential + beta * (circshift(X, -1, 2) ~= X) .* circshift(Mask, -1, 2);
Prior = exp(-1 * Potential);
Likelihood = zeros(X);
for i = 1 : k
    Ind = X == i;
    temp = normpdf(Y, mew(i), sqrt(var(i)));
    Likelihood(Ind) = temp(Ind);
end
MAP = Prior .* Likelihood;
estimate = sum(sum(log(MAP) .* Mask));
end


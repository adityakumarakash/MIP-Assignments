function [ estimate ] = MAPValue( X, Mask, Y, k, mew, var, beta )
% Calculates the MAP estimate for the X
%   Detailed explanation goes here

Prior = zeros(size(X, 1), size(X, 2), k);
NormPrior = zeros(size(X, 1), size(X, 2));
for i = 1 : k
    % find the potential sum from the cliques
    Potential = zeros(size(X));
    Potential = Potential + beta * (circshift(X, 1, 1) ~= i) .* circshift(Mask, 1, 1);
    Potential = Potential + beta * (circshift(X, -1, 1) ~= i) .* circshift(Mask, -1, 1);
    Potential = Potential + beta * (circshift(X, 1, 2) ~= i) .* circshift(Mask, 1, 2);
    Potential = Potential + beta * (circshift(X, -1, 2) ~= i) .* circshift(Mask, -1, 2);
    % calculate the prior
    Prior(:, :, i) = exp(-1 * Potential);
    NormPrior = NormPrior + Prior(:, :, i);
end

NormPrior = NormPrior + (1 - Mask);
Likelihood = ones(size(X));
PriorProb = ones(size(X));
for i = 1 : k
    Prior(:, :, i) = Prior(:, :, i) ./ NormPrior;
    
    Ind = (X == i);
    
    temp = normpdf(Y, mew(i), sqrt(var(i)));
    Likelihood(Ind) = temp(Ind);
    
    temp = Prior(:, :, i);
    PriorProb(Ind) = temp(Ind);
end

MAP = PriorProb .* Likelihood;
estimate = sum(sum(log(MAP) .* Mask));
end


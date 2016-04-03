function [ gamma ] = membership( X, Mask, Y, k, mew, var, beta )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

M = zeros(size(X, 1), size(X, 2), k);
Prior = zeros(size(X, 1), size(X, 2), k);
NormPrior = zeros(size(X));
temp = zeros(size(X));

for i = 1 : k
    M(:, :, i) = normpdf(Y, mew(i), sqrt(var(i)));
    Potential = zeros(size(X));
    Potential = Potential + beta * (circshift(X, 1, 1) ~= i) .* circshift(Mask, 1, 1);
    Potential = Potential + beta * (circshift(X, 1, 1) ~= i) .* circshift(Mask, 1, 1);
    Potential = Potential + beta * (circshift(X, 1, 1) ~= i) .* circshift(Mask, 1, 1);
    Potential = Potential + beta * (circshift(X, 1, 1) ~= i) .* circshift(Mask, 1, 1);
    Prior(:, :, i) = exp(-1 * Potential);
    NormPrior = NormPrior + Prior(:, :, i);
end

NormPrior = NormPrior + (1 - Mask);

NormMAP = zeros(size(X));
for i = 1 : k
    Prior(:, :, i) = Prior(:, :, i) ./ NormPrior;
    M(:, :, i) = M(:, :, i) .* Prior(:, :, i);
    NormMAP = NormMAP + M(:, :, i);
end

NormMAP = NormMAP + (1 - Mask);

gamma = zeros(size(X, 1), size(X, 2), k);
for i = 1 : k
    gamma(:, :, i) = M(:, :, i) ./ NormMAP;
    gamma(:, :, i) = gamma(:, :, i) .* Mask;
end

end


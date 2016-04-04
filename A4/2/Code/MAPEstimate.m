function [ LogJointMAP, Labels ] = MAPEstimate( X , Mask, Y, k, mew, var, beta)
% This function finds the MAP estimate of the image
%   Detailed explanation goes here

MAP = zeros(size(X));
Labels = zeros(size(X));
Prior = zeros(size(X, 1), size(X, 2), k);
NormPrior = zeros(size(X, 1), size(X, 2));
temp = zeros(size(X));
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

for i = 1 : k
    temp(:, :) = Prior(:, :, i);
    temp = temp ./ NormPrior;
    % Estimate likelihood
    Likelihood = normpdf(Y, mew(i), sqrt(var(i)));
    Likelihood = Likelihood + (1 - Mask);
    Posterior = temp .* Likelihood;
    Ind = (MAP < Posterior);
    MAP(Ind) = Posterior(Ind);
    Labels(Ind) = i;
end

Labels = Labels .* Mask;
% Joint MAP estimate
LogJointMAP = sum(sum(log(MAP) .* Mask));

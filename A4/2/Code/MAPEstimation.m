function [ estimate, Labels ] = MAPEstimation( X, Mask, Y, k, mew, var, beta )
% This function finds the MAP estimate of the optimal label values using
% the ICM procedure.
%   Detailed explanation goes here

estimatePrev = -1000;
[estimate, Labels] = MAPEstimate(X, Mask, Y, k, mew, var, beta);
epsilon = 0.00001;
iteration = 0;

while estimate - estimatePrev > epsilon
    estimatePrev = estimate;
    X = Labels;
    [estimate, Labels] = MAPEstimate(X, Mask, Y, k, mew, var, beta);
    iteration = iteration + 1;
end


end


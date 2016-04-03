function [ Labels ] = MAPEstimation( X, Mask, Y, k, mew, var, beta )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

estimatePrev = -1000;
[estimate, Labels] = MAPEstimate(X, Mask, Y, k, mew, var, beta);
epsilon = 0.0001;
iteration = 0;

while estimate - estimatePrev > epsilon
    estimatePrev = estimate;
    X = Labels;
    [estimate, Labels] = MAPEstimate(X, Mask, Y, k, mew, var, beta);
    iteration = iteration + 1;
end


end


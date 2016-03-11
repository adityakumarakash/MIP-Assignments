function [ D ] = priorGradient( X, Y, h )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

X1 = circshift(Y, 1) - X;
X2 = circshift(Y, -1) - X;
X3 = circshift(Y', 1)' - X;
X4 = circshift(Y', -1)' - X;

priorDerivative = gradient(h, X1) + gradient(h, X2) + gradient(h, X3)  + gradient(h, X4);


end


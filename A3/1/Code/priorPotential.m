function [ P ] = priorPotential( X, Y, g)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

X1 = X - circshift(X, 1);
X2 = X - circshift(X, -1);
X3 = X - circshift(X', 1)' ;
X4 = X - circshift(X', -1)';

P = g(X1) + g(X2) + g(X3) + g(X4);

end


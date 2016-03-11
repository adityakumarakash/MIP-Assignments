function [ value ] = discontAdapFunctionG(U, gamma)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

Uab = abs(U);
value = sum(sum(gamma * Uab - gamma*gamma*log(1 + Uab/gamma)));


end


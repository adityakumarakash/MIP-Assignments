function [ D ] = discontAdapFunctionH( U, gamma)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

Uab = abs(U);
temp = gamma./(gamma + Uab);
D = U.*temp;

end


function [ p ] = discontAdapHuberPriorH( u, gamma)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

u = abs(u);
if u <= gamma
    p = 0.5;
else
    p = gamma / (2.0 * u);
end

    
end


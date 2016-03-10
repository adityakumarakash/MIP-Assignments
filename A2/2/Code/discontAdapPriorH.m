function [ p ] = discontAdapPriorH( u, gamma)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

p = (0.5*gamma) / (gamma + abs(u));

end


function [ p ] = quadPriorG( u )
%UNTITLED Summary of this function goes here
%   The quadratic prior MRF

p = abs(u)^2;

end


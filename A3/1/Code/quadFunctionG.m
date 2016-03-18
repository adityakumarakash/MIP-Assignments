function [ v ] = quadFunctionG( U )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

v = sum(sum(abs(U).^2));

end


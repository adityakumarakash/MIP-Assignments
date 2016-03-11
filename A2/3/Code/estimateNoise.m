function [ std_dev ] = estimateNoise( Y )
%UNTITLED Summary of this function goes here
%   Estimates the noise from the air

% standard deviation from the real part

psize = 50;
Y = Y(1:psize-1, 1:psize-1);
Y = real(Y);
std_dev = sqrt(sum(sum(Y.^2))/(psize*psize));
end


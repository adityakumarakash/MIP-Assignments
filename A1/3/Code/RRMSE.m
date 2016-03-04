function [ rrmse ] = RRMSE( A, B )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
% This function finds the Relative Root Mean squared error which is rmse(A,
% B) / rms(A)

rrmse = sqrt(sum((A - B).^2)) / sqrt(sum(A.^2));

end


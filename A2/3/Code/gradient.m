function [ Y ] = gradient( f, X )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Y = X.*arrayfun(f, X);

end

    
function [D] = priorGradient( X, Y, h)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

X1 = X - circshift(Y, 1);
X2 = X - circshift(Y, -1);
X3 = X - circshift(Y', 1)' ;
X4 = X - circshift(Y', -1)' ;

D = h(X1) + h(X2) + h(X3) + h(X4); 
end


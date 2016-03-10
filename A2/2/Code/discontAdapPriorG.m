function [ p ] = discontAdapPriorG( u, gamma )
%UNTITLED3 Summary of this function goes here
%   discontinuity adaptive prior g

u = abs(u);
p = gamma * u - gamma * gamma * log(1 + u/gamma);

end


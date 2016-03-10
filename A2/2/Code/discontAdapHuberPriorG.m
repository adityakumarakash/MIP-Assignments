function [ p ] = discontAdapHuberPriorG(u, gamma )
%UNTITLED2 Summary of this function goes here
%   Discontinuity Adaptive Huber prior

u = abs(u);
if u <= gamma
    p = 0.5 * u * u;
else
    p = gamma * u - 0.5 * gamma * gamma;
end

end


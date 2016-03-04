function [ fRet ] = incompleteReconstruction( f, theta)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
% This function does the reconstruction of the image f using the radon
% transform from theta to theta + 150

[a, b] = size(f);
thetaRange = [theta : theta + 150];
[R, x] = radon(f, thetaRange);
fRet = iradon(R, thetaRange, a);

end


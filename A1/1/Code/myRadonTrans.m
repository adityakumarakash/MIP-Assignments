function [ rT ] = myRadonTrans(f, ds)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% initialization of the parameters for integration
t = [-90 : 5 : 90];     % t values
theta = [0 : 5 : 175];  % theta values

[temp, n] = size(t);
[temp, m] = size(theta);

rT = zeros(n, m);
h=waitbar(0,'Waiting for radon transform...');
for i = 1:n
    for j = 1:m
        rT(i, j) = myIntegration(f, t(i), theta(j), ds);
    end
    waitbar(i/n);
end
close(h);

end


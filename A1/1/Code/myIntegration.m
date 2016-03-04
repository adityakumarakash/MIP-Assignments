function [integral] = myIntegration(f, t, theta, ds)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

f = im2double(f);   % function
[n, m] = size(f);   % size of matrix function
integral = 0;       % initialize

% x = t * cos(theta) - s * sin(theta)
% y = t * cos(theta) + s * sin(theta)
% xc , yc = center
% row = y + yc, column = x + xc

xc = (m + 1)/2.0;
yc = (n + 1)/2.0;
xMax = m - xc;
yMax = n - yc;

s = 0;              % initialize s

% limits for s
sLine1 = (t*cos(theta) - xMax) / sin(theta);    % intersection with x = xMax
sLine2 = (t*cos(theta) + xMax) / sin(theta);    % intersection with x = -xMax
sLine3 = (-t*sin(theta) + yMax) / cos(theta);   % intersection with y = yMax
sLine4 = (-t*sin(theta) - yMax) / cos(theta);   % intersection with y = -yMax

sMin = max(min(sLine1, sLine2), min(sLine3, sLine4));   % max from x lines and y lines
sMax = min(max(sLine1, sLine2), max(sLine3, sLine4));   % min from x lines and y lines

if (sMax > sMin)
    [X, Y] = meshgrid(-xMax : xMax, -yMax : yMax);  % meshgrid to use for interpolation function
    for s = sMin : ds : sMax
        x = t * cos(theta) - s * sin(theta);
        y = t * sin(theta) + s * cos(theta);
        deltaArea = ds * interp2(X, Y, f, x, y, 'linear', 0);    % area of ds segment using interpolated value
        integral = integral + deltaArea;            % update the integral using the delta area found
    end
end

% function end
end


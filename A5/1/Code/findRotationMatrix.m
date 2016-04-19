function [ R ] = findRotationMatrix( mean, Y )
% this aligns the points Y wrt mean

[U, ~, V] = svd(Y * mean');
R = V * U';

if det(R) == -1
    % correcting for negation
    t = [1, 0; 0, -1];
    R = V * t * U';
end

end


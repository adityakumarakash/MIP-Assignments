function [ B, B0, T, P] = PLS1Regression(X, y, k)
% This function finds the parameters for the Partial least square regression 

n = size(X, 1);
m = size(X, 2);
T = zeros(n, k);
P = zeros(m, k);
W = zeros(m, k);
Q = zeros(k, 1);

for i = 1 : k
    % Find the variability remaining in y to find the remaining weigths
    w = X' * y;
    w = w / norm(w);    % scaling to norm 1
    
    % finding the X scores
    t = X * w;
    c = t' * t;
    t = t / c;
    
    % finding the X loading weigths
    p = X' * t;
    q = y' * t;

    % Update the matrices - loading and weights
    W(:, i) = w;
    T(:, i) = t;
    P(:, i) = p;
    Q(i) = q;
    
    % stoping criteria
    if q == 0
        k = i;
        break;
    end
    
    % Deflation of X
    X = X - c * t * p';
end

B = W * inv(P' * W) * Q;
B0 = Q(1) - P(:, 1)' * B;

end


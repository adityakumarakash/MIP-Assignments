% Loading the points
load('../Data/assignmentSegmentBrainGmmEmMrf.mat');
Y = imageData;
Mask = imageMask;

% initialization
k = 3;  % number of segments
mew = ones(k, 1) * sum(sum(Y .* Mask)) / sum(sum(Mask));
mewRep = repmat(mew(1), size(Y, 1), size(Y, 2));
var = ones(k, 1) * sum(sum(((Y - mewRep) .* (Y - mewRep)) .* Mask)) / sum(sum(Mask));
mewPrev = zeros(k, 1);
varPrev = zeros(k, 1);
X = randi(k, size(Y));
beta = 10;

epsilon = 0.0001;
iteration = 0;
maxIteration = 100;

% EM algorithm
while sum(abs(mew - mewPrev)) > epsilon && iteration < maxIteration
    iteration = iteration + 1
    mewPrev = mew;
    varPrev = var;
    % MAP estimation of the labels
    [X] = MAPEstimation(X, Mask, Y, k, mew, var, beta);
    
    % E step
    [gamma] = membership(X, Mask, Y, k, mew, var, beta);
    
    % M step
    [mew, var] = MStep(Y, Mask, gamma, k);
end

segmentedImage = gamma;
imagesc(gamma);

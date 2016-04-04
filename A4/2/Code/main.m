% Loading the points
load('../Data/assignmentSegmentBrainGmmEmMrf.mat');
Y = imageData;
Mask = imageMask;

%% initialization 
k = 3;  % number of segments

% Initialization using kmeans
% Kmeans intialization is fast. It also provides with k clusters which are
% of the same size
var = zeros(k,1);
varPrev = zeros(k, 1);
mew = zeros(k, 1);
mewPrev = zeros(k, 1);

maskedImage = Y(logical(Mask));
[maskedLabels, mew] = kmeans(maskedImage, k);   % K means is fast , good for initialization

%% image initialization using kmeans clustering
X = zeros(size(imageData));
X(logical(Mask)) = maskedLabels;

%% means and variance is intilialized using kmeans clustering
% computing the variance from k means
for i = 1:k
    XPart = maskedImage(maskedLabels == i);
    var(i) = sqrt(sumsqr(XPart - mew(i))/length(XPart));
end
beta = 2;

%% Segmentation using image clustering
epsilon = 0.00001;
iteration = 0;
maxIteration = 200;
estimateArr = [];

% EM algorithm
while sum(abs(mew - mewPrev)) > epsilon && iteration < maxIteration
    iteration = iteration + 1;
    mewPrev = mew;
    varPrev = var;
    % MAP estimation of the labels
    [estimate, X] = MAPEstimation(X, Mask, Y, k, mew, var, beta);
    estimateArr = [estimateArr estimate];
    % E step
    [gamma] = membership(X, Mask, Y, k, mew, var, beta);
    
    % M step
    [mew, var] = MStep(Y, Mask, gamma, k);
end


segmentedImage = gamma;
imagesc(segmentedImage);

%% This script applies the PLS implementations made
% The PLS is used for classification task

% load the data
imagesTrain = loadMNISTImages('../Data/mnist/train-images.idx3-ubyte');
labelsTrain = loadMNISTLabels('../Data/mnist/train-labels.idx1-ubyte');
imagesTest = loadMNISTImages('../Data/mnist/t10k-images.idx3-ubyte');
labelsTest = loadMNISTLabels('../Data/mnist/t10k-labels.idx1-ubyte');

P = zeros(size(imagesTest, 2), 10);
parfor i = 0 : 9
    [B, b, ~, ~] = PLS1Regression(imagesTrain', labelsTrain==i, 200);
    P(:, i + 1) = imagesTest' * B + b;
end

[~, labelsPredicted] = max(P, [], 2);
labelsPredicted = labelsPredicted - 1;
fprintf('Accurracy is %f\n', (sum(labelsPredicted == labelsTest))*100/size(labelsTest, 1));
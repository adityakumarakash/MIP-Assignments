%% This script applies the PLS implementations made

%% MNIST classification using PLS regression

% load the data
imagesTrain = loadMNISTImages('../Data/mnist/train-images.idx3-ubyte');
labelsTrain = loadMNISTLabels('../Data/mnist/train-labels.idx1-ubyte');
imagesTest = loadMNISTImages('../Data/mnist/t10k-images.idx3-ubyte');
labelsTest = loadMNISTLabels('../Data/mnist/t10k-labels.idx1-ubyte');

% ncomp = 5;
% 
% P = zeros(size(imagesTest, 2), 10);
% for i = 0 : 9
%     [B, b, ~, ~] = PLS1Regression(imagesTrain', labelsTrain==i, ncomp);
%     P(:, i + 1) = imagesTest' * B + b;
% end
% 
% [~, labelsPredicted] = max(P, [], 2);
% labelsPredicted = labelsPredicted - 1;
% fprintf('Accurracy with %d components is %f\n', ncomp, (sum(labelsPredicted == labelsTest))*100/size(labelsTest, 1));


%% MNIST using SVM

P = zeros(size(imagesTest, 2), 10);
for i = 0 : 9
    i
    Mdl = fitrsvm(imagesTrain', 1.0*(labelsTrain==i));
    P(:, i + 1) = predict(Mdl, imagesTest');
end

[~, labelsPredicted] = max(P, [], 2);
labelsPredicted = labelsPredicted - 1;
fprintf('Accurracy with %d components is %f\n', ncomp, (sum(labelsPredicted == labelsTest))*100/size(labelsTest, 1));
 
%% This script applies the PLS implementations made

%% MNIST classification using PLS regression

% load the data
% imagesTrain = loadMNISTImages('../Data/mnist/train-images.idx3-ubyte');
% labelsTrain = loadMNISTLabels('../Data/mnist/train-labels.idx1-ubyte');
% imagesTest = loadMNISTImages('../Data/mnist/t10k-images.idx3-ubyte');
% labelsTest = loadMNISTLabels('../Data/mnist/t10k-labels.idx1-ubyte');

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


% %% MNIST using SVM
% 
% P = zeros(size(imagesTest, 2), 10);
% for i = 0 : 9
%     i
%     %Mdl = fitrlinear(imagesTrain', 1.0*(labelsTrain==i));
%     %P(:, i + 1) = predict(Mdl, imagesTest');
%     [~, model] = adaboost('train', imagesTrain', labelsTrain==1, 10);
% end
% 
% [~, labelsPredicted] = max(P, [], 2);
% labelsPredicted = labelsPredicted - 1;
% fprintf('Accurracy with %d components is %f\n', ncomp, (sum(labelsPredicted == labelsTest))*100/size(labelsTest, 1));


%% Working with prostrate data
% For this data, labels are -> 50 normal in beginning, 52 tumour afterwards

%Data = readMicroArrayData('../Data/prostate_preprocessed.txt');
Label = [zeros(50, 1); ones(52, 1)];

% split the data ramdomly into 7 : 3 ratio for train and test
rndVal = rand(size(Label, 1), 1);
trainIndex = rndVal <= 0.7;
testIndex = rndVal > 0.7;

trainData = Data(trainIndex, :);
trainLabel = Label(trainIndex, :);
testData = Data(testIndex, :);
testLabel = Label(testIndex, :);

%% Using PLS regression for prediction
ncomp = 5;
%for ncomp = 1 : 30
[B, b, ~, ~] = PLS1Regression(trainData, trainLabel, ncomp);
P = testData * B + b;
predictedLabel = P > 0.5;
fprintf('Accurracy with %d components is %f\n', ncomp, (sum(predictedLabel == testLabel))*100/size(testLabel, 1));
%end

%% Using SVM for prediction
model = svmtrain(trainData, trainLabel);
predictedLabel =  svmclassify(model, testData);
fprintf('Accurracy with svm is %f\n', (sum(predictedLabel == testLabel))*100/size(testLabel, 1));


%% using adaboost for prediction
iterationLimit = 5;
[~, model] = adaboost('train', trainData, trainLabel, iterationLimit);
predictedLabel = adaboost('apply', testData);
fprintf('Accurracy with Adaboost is %f\n', (sum(predictedLabel == testLabel))*100/size(testLabel, 1));

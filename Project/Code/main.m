%% This script applies the PLS implementations made

fId = fopen('../Output/results.txt', 'a');

%% MNIST classification using PLS regression
fprintf(fId, '\n\n----------------------------------------------------------\n\n');
fprintf(fId, 'MNIST Dataset\n');

% load the data
imagesTrain = loadMNISTImages('../Data/mnist/train-images.idx3-ubyte');
labelsTrain = loadMNISTLabels('../Data/mnist/train-labels.idx1-ubyte');
imagesTest = loadMNISTImages('../Data/mnist/t10k-images.idx3-ubyte');
labelsTest = loadMNISTLabels('../Data/mnist/t10k-labels.idx1-ubyte');

ncomp = 4;

P = zeros(size(imagesTest, 2), 10);
for i = 0 : 9
    [B, b, ~, ~] = PLS1Regression(imagesTrain', labelsTrain==i, ncomp);
    P(:, i + 1) = imagesTest' * B + b;
end

[~, labelsPredicted] = max(P, [], 2);
labelsPredicted = labelsPredicted - 1;
fprintf(fId, 'Accurracy with %d components is %f\n', ncomp, (sum(labelsPredicted == labelsTest))*100/size(labelsTest, 1));




%% Working with prostrate data
% For this data, labels are -> 50 normal in beginning, 52 tumour afterwards

fprintf(fId, 'Prostrate Dataset\n');
Data = readMicroArrayData('../Data/prostate_preprocessed.txt');
Label = [zeros(50, 1); ones(52, 1)];

experimentCount = 100;
fprintf(fId, 'Experiments = %d\n', experimentCount);
avgAccuracyPLS = 0;
avgAccuracySVM = 0;
% avgAccuracySVMPLS = 0;


for exp = 1 : experimentCount
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
    accuracy = (sum(predictedLabel == testLabel))*100/size(testLabel, 1);
    avgAccuracyPLS = accuracy + avgAccuracyPLS;
    
    %% Using SVM for prediction
    model = svmtrain(trainData, trainLabel);
    predictedLabel =  svmclassify(model, testData);
    accuracy = (sum(predictedLabel == testLabel))*100/size(testLabel, 1);
    avgAccuracySVM = accuracy + avgAccuracySVM;
    
%     %% Using SVM on the scores from PLS
%     [~, ~, T, P] = PLS1Regression(trainData, trainLabel, ncomp);
%     model = svmtrain(T, trainLabel);
%     testDataScore = testData * P;
%     predictedLabel =  svmclassify(model, testDataScore);
%     accuracy = (sum(predictedLabel == testLabel))*100/size(testLabel, 1);
%     avgAccuracySVMPLS = accuracy + avgAccuracySVMPLS;
%     
    
end

avgAccuracyPLS = avgAccuracyPLS / experimentCount;
avgAccuracySVM = avgAccuracySVM / experimentCount;
% avgAccuracySVMPLS = avgAccuracySVMPLS / experimentCount;

fprintf(fId, 'For PLS Avg Accurracy with %d components is %f\n', ncomp, avgAccuracyPLS);
fprintf(fId, 'For SVM Avg Accurracy with svm is %f\n', avgAccuracySVM);
% fprintf(fId, 'For SVM based on PLS Avg Accurracy with svm is %f\n', avgAccuracySVMPLS);


%%% using adaboost for prediction
% iterationLimit = 5;
% [~, model] = adaboost('train', trainData, trainLabel, iterationLimit);
% predictedLabel = adaboost('apply', testData);
% fprintf('Accurracy with Adaboost is %f\n', (sum(predictedLabel == testLabel))*100/size(testLabel, 1));

%% Plotting the dataset 
[~, ~, T, ~] = PLS1Regression(Data, Label, 2);
figure;
hold on;
scatter(T(1:50, 1), T(1 : 50, 2), [], 'g', 'filled');
scatter(T(50:end, 1), T(50:end, 2), [], 'r', 'filled');
title('Prostate cancer dataset');
hold off;



%% Working with dlbc lymphoma data
% For this data, labels are -> 50 normal in beginning, 52 tumour afterwards
fprintf(fId, 'DLBCL dataset\n');
Data = readMicroArrayData('../Data/dlbcl_preprocessed.txt');
Label = [ones(58, 1); zeros(19, 1)];

experimentCount = 100;
fprintf(fId, 'Experiments = %d\n', experimentCount);
avgAccuracyPLS = 0;
avgAccuracySVM = 0;

for exp = 1 : experimentCount
    % split the data ramdomly into 7 : 3 ratio for train and test
    rndVal = rand(size(Label, 1), 1);
    trainIndex = rndVal <= 0.7;
    testIndex = rndVal > 0.7;

    trainData = Data(trainIndex, :);
    trainLabel = Label(trainIndex, :);
    testData = Data(testIndex, :);
    testLabel = Label(testIndex, :);

    %% Using PLS regression for prediction
    ncomp = 3;
    %for ncomp = 1 : 30
    [B, b, ~, ~] = PLS1Regression(trainData, trainLabel, ncomp);
    P = testData * B + b;
    predictedLabel = P > 0.5;
    accuracy = (sum(predictedLabel == testLabel))*100/size(testLabel, 1);
    avgAccuracyPLS = accuracy + avgAccuracyPLS;
    
    %% Using SVM for prediction
    model = svmtrain(trainData, trainLabel);
    predictedLabel =  svmclassify(model, testData);
    accuracy = (sum(predictedLabel == testLabel))*100/size(testLabel, 1);
    avgAccuracySVM = accuracy + avgAccuracySVM;

end


avgAccuracyPLS = avgAccuracyPLS / experimentCount;
avgAccuracySVM = avgAccuracySVM / experimentCount;

fprintf(fId, 'For PLS Avg Accurracy with %d components is %f\n', ncomp, avgAccuracyPLS);
fprintf(fId, 'For SVM Avg Accurracy with svm is %f\n', avgAccuracySVM);


%% Plotting the dataset 
[~, ~, T, ~] = PLS1Regression(Data, Label, 2);
figure;
hold on;
scatter(T(1:58, 1), T(1 : 58, 2), [], 'r', 'filled');
scatter(T(58:end, 1), T(58:end, 2), [], 'g', 'filled');
title('DLBC Lymphoma dataset');
hold off;

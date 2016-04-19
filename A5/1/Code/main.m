%% Loading Data
load('../Data/assignmentShapeAnalysis.mat');

%% Transforming to preShape 
centroid = sum(pointSets,2) / numOfPoints;
preShapePoints = pointSets - centroid(:, ones(1, 32), :);
norms = sqrt(sum(sum(preShapePoints.^2, 2), 1));
preShapePoints = preShapePoints./norms(ones(1, 2), ones(1, 32), :);


%% Iterative calculation of mean shape
% initialization using sample mean
mean = preShapePoints(:, :, 3);
oldMean = mean + 100;

% parameters for loop
epsilon = 0.000001;
maxIteration = 50;
iteration = 0;

% loop
while sqrt(sumsqr(mean - oldMean)) > epsilon && iteration < maxIteration
    % update in the loop
    oldMean = mean;
    iteration = iteration + 1;
    
    % for each set find the rotation matrix
    for i = 1 : numOfPointSets
        RotMatrix = findRotationMatrix(mean, preShapePoints(:, :, i));
        preShapePoints(:, :, i) = RotMatrix * preShapePoints(:, :, i);
    end
    
    % mean shape calculation 
    mean = sum(preShapePoints, 3) / numOfPointSets;
    
    % normalization of mean
    norm = sqrt(sumsqr(mean));
    mean = mean ./ norm;
end

colors = jet(numOfPointSets);


%% Intial point set
figure;
hold on;
title('Original Point Sets');
for i= 1 : numOfPointSets
   scatter(pointSets(1,:,i), pointSets(2,:,i), 8, 'MarkerFaceColor', colors(i, :)); 
end
hold off;



%% Aligned point sets
figure;
hold on;
plot(mean(1,:),mean(2,:),'-x','LineWidth',4,'Marker','*');
for i=1:numOfPointSets
   scatter(preShapePoints(1,:,i),preShapePoints(2,:,i),...
       4,'MarkerFaceColor',colors(i,:)); 
end
title('Aligned Point Sets');
hold off

xl = xlim;
yl = ylim;

figure;
scatter(mean(1,:),mean(2,:));
xlim(xl);
ylim(yl);
title('Final Mean shape');

%% Computing principal modes of variation

cov = 0;
% mean subtracted vectorized points
for i=1:numOfPointSets
    pointSet = preShapePoints(:,:,i) - mean;
    cov = cov + pointSet*pointSet';
end
cov = cov/numOfPointSets;


% Eigenvalue decomposition
[V,D] = eig(cov);

eigenvals = diag(D);

figure;
scatter(1:length(eigenvals),eigenvals(end:-1:1));
title('Variances along each principal mode');


%% Calculating shapes corresponding to modes of variations

% Corresponding to 2*sd along 1st eigenvector
sd = sqrt(eigenvals(2));
ps1_1(1,:) = mean(1,:) + 2*sd*V(:,2)'*mean;
ps1_1(2,:) = mean(2,:) + 2*sd*V(:,2)'*mean;


% Corresponding to -2*sd along 1st eigenvector
sd = sqrt(eigenvals(2));
ps2_1(1,:) = mean(1,:) - 2*sd*V(:,2)'*mean;
ps2_1(2,:) = mean(2,:) - 2*sd*V(:,2)'*mean;

% Corresponding to 2*sd along 2nd eigenvector
sd = sqrt(eigenvals(1));
ps1_2(1,:) = mean(1,:) + 2*sd*V(:,1)'*mean;
ps1_2(2,:) = mean(2,:) + 2*sd*V(:,1)'*mean;



% Corresponding to -2*sd along 2nd eigenvector
sd = sqrt(eigenvals(1));
ps2_2(1,:) = mean(1,:) - 2*sd*V(:,1)'*mean;
ps2_2(2,:) = mean(2,:) - 2*sd*V(:,1)'*mean;

%% Plotting variations
figure;
hold on;
scatter(ps1_1(1,:),ps1_1(2,:),'ro');
scatter(ps2_1(1,:),ps2_1(2,:),'mo');
scatter(mean(1,:),mean(2,:),'b*');
xlim(xl);
ylim(yl);
legend('+2sd','-2sd','mean');
title('1st mode of variation');
hold off;

figure;
hold on;
scatter(ps1_2(1,:),ps1_2(2,:),'ro');
scatter(ps2_2(1,:),ps2_2(2,:),'mo');
scatter(mean(1,:),mean(2,:),'b*');
xlim(xl);
ylim(yl);
legend('+2sd','-2sd','mean');
hold off;

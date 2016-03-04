%%
% CS 736: Medical Image Processing
% Assignment 1
% Aditya Kumar Akash 120050046, Praveen Agrawal 12D020030
%%
% Question 3
% First data set CT_Chest.mat

% load the file
img = load('../Data/CT_Chest.mat');
img = double(img.imageAC);

figure;
imshow(mat2gray(img));
title('CT\_Chest original image', 'FontWeight', 'bold');

thetaRange = 0:180;
rrmseVals = zeros(1, 181);
h = waitbar(0, 'Waiting for RRMSE for CT\_Chest...');
for theta = 0:180
    incompleteImg = incompleteReconstruction(img, theta);
    rrmseVals(theta + 1) = RRMSE(img, incompleteImg);
    waitbar(theta/181);
end
close(h);
figure;
plot(thetaRange, rrmseVals);
title('RRMSE values for 150 span each theta, CT\_Chest', 'FontWeight', 'bold');
xlabel('theta values');
ylabel('RRMSE Values');

[minRrmse, minTheta] = min(rrmseVals);
reconstructedImage = incompleteReconstruction(img, minTheta);

figure;
imshow(mat2gray(reconstructedImage));
title(strcat('Image with least RRMSE for CT\_Chest for theta = ',num2str(minTheta)), 'FontWeight', 'bold');
save ('../Output Images/CT_Chest_reconstructed_minRRMSE', 'reconstructedImage');

%%
% Second data set, myPhantom.mat

% load the file
img = load('../Data/myPhantom.mat');
img = double(img.imageAC);

figure;
imshow(mat2gray(img));
title('myPhantom original image', 'FontWeight', 'bold');

thetaRange = 0:180;
rrmseVals = zeros(1, 181);
h = waitbar(0, 'Waiting for RRMSE for myPhantom...');
for theta = 0:180
    incompleteImg = incompleteReconstruction(img, theta);
    rrmseVals(theta + 1) = RRMSE(img, incompleteImg);
    waitbar(theta/181);
end
close(h);

figure;
plot(thetaRange, rrmseVals);
title('RRMSE values for 150 span each theta, myPhantom', 'FontWeight', 'bold');
xlabel('theta values');
ylabel('RRMSE Values');

[minRrmse, minTheta] = min(rrmseVals);
reconstructedImage = incompleteReconstruction(img, minTheta);

figure;
imshow(mat2gray(reconstructedImage));
title(strcat('Image with least RRMSE for myPhantom for theta =', num2str(minTheta)), 'FontWeight', 'bold');
save ('../Output Images/myPhantom_reconstructed_minRRMSE', 'reconstructedImage');


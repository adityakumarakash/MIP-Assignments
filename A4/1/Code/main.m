%% CS 736: Medical Image Processing
% Assignment 4 (Image Segmentation)
% Praveen Agrawal 12D020030
% Aditya Kumar 120050046
%%
load('../Data/assignmentSegmentBrain.mat');
imgSize = size(imageData);

K = 3;  % Number of classes
q = 4;
windowSize = 25; % 25 x 25 weight window
windowRadius = floor(windowSize/2);
sigma = 2;
numOfIterations = 7;

u = zeros(imgSize(1), imgSize(2), K);   % Membership
u(:,:,:) = 1/K;  % Initialisation of membership. Ensuring summation(u_k) = 1
w = fspecial('gaussian', windowSize, sigma);    % Weights. They sum to 1
b = ones(imgSize); % Initial estimate for the bias field is chosen to be a constant image
c = zeros(1,K); % Class Means
d = zeros(1,K); % Distance vector
c = [0,0.5,1];  % Initialize the class means
J = zeros(1, numOfIterations);

for iterationCount = 1:1:numOfIterations
    
    h = waitbar(0,strcat('Iteration-',num2str(iterationCount),'  Updating Memberships. Please wait...'));
    %Keeping class means and bias fixed, updating MEMBERSHIPS
    for i = 1:1:imgSize(1)
        for j = 1:1:imgSize(2)
            if (imageMask(i,j)== 1)
                d(1,:) = 0;
                for k = 1:1:K     
                    for l = -windowRadius:1:windowRadius
                       for m =  -windowRadius:1:windowRadius
                           if(imageMask(i+l,j+m) == 1)
                                d(k) = d(k) + w(l+windowRadius+1, m+windowRadius+1)*(imageData(i,j) - c(k)*b(i+l,j+m))^2;
                           end
                       end
                    end
                end
                u(i,j,:) = (1./d).^(1/(q-1));
                u(i,j,:) = u(i,j,:)/(sum(u(i,j,:)));
            end
        end
        waitbar(i/imgSize(1));
    end
    close(h);
    
    % Keeping memberships, and bias fixed, updating CLASS MEANS
    h = waitbar(0,strcat('Iteration-',num2str(iterationCount),'  Updating Class means. Please wait...'));
    convBias = conv2(b, w); % Since summation over wij performs convolution with the neighborhood mask
    convBiasSquare = conv2(b.^2, w);
    for k = 1:1:K
        numerator = 0;
        denominator = 0;
        for i = 1:1:imgSize(1)
            for j = 1:1:imgSize(2)
                if (imageMask(i,j) == 1)
                    numerator = numerator + convBias(i,j)*(u(i,j,k)^q)*imageData(i,j);
                    denominator = denominator + convBiasSquare(i,j)*(u(i,j,k)^q);
                end
            end
        end
        c(k) = numerator/denominator;
        waitbar(k/K);
    end
    close(h);
    
    % Keeping memberships, and class means fixed, solve for BIAS
    h = waitbar(0,strcat('Iteration-',num2str(iterationCount),'  Updating Bias. This takes time. Please wait...'));
    for i = 1:1:imgSize(1)
        for j = 1:1:imgSize(2)
            if (imageMask(i,j)== 1)
               numerator1 = 0;
               denominator1 = 0;
               for l = -windowRadius:1:windowRadius
                   for m =  -windowRadius:1:windowRadius
                       if(imageMask(i+l,j+m) == 1)
                           numerator2 = 0;
                           denominator2 = 0;
                           for k = 1:1:K
                               numerator2 = numerator2 + (u(i+l,j+m,k)^q)*c(k);
                               denominator2 = denominator2 + (u(i+l,j+m,k)^q)*c(k)*c(k);
                           end
                           numerator1 = numerator1 + w(l+windowRadius+1, m+windowRadius+1)*imageData(i+l,j+m)*numerator2;
                           denominator1 = denominator1 + w(l+windowRadius+1, m+windowRadius+1)*denominator2;
                       end
                   end
               end
               b(i,j) = numerator1/denominator1;
            end
        end
        waitbar(i/imgSize(1));
    end
    close(h);
   
    % Find Value of the objective function
    h = waitbar(0,strcat('Iteration-',num2str(iterationCount),'  Finding value of objective function. Please wait...'));
    for i = 1:1:imgSize(1)
        for j = 1:1:imgSize(2)
            if (imageMask(i,j)== 1)
                for k = 1:1:K
                    d(1,:) = 0;
                    for l = -windowRadius:1:windowRadius
                       for m =  -windowRadius:1:windowRadius
                           if(imageMask(i+l,j+m)== 1)
                                d(k) = d(k) + w(l+windowRadius+1, m+windowRadius+1)*((imageData(i,j) - c(k)*b(i+l,j+m))^2);
                           end
                       end
                    end
                    J(iterationCount) = J(iterationCount) + (u(i,j,k)^q)*d(k);
                end
            end
        end
        waitbar(i/imgSize(1));
    end
    close(h);
    figure;
    imshow(u);
    title(num2str(iterationCount));
end
%%
% Bias removed image
biasRemovedImage = zeros(imgSize(1),imgSize(2));
for k = 1:1:K
    biasRemovedImage = biasRemovedImage + c(k)*u(:,:,k);
end
biasRemovedImage = biasRemovedImage.*imageMask;
figure;
imagesc(biasRemovedImage);
truesize;

% Residual Image
residualImage = imageData - biasRemovedImage.*b;
figure; imagesc(residualImage); truesize;
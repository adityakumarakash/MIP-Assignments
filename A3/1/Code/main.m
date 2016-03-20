%% CS 736
%% Part A

% Loading the images
load('../Data/assignmentImageReconstructionPhantom.mat');
imageNoisy = ifft2(imageKspaceData);
Y = imageKspaceData;
S = imageKspaceMask;
Y = S.*Y;

% parameters
alpha = 0.08;
gamma = 0.01;
epsilonThreshold = 0.01;
epsilon = 0.0000001;
gradThreshold = 0.00001;

minVal = Inf;
minAlpha = 0;
minGamma = 0;

fxValues = zeros(3, 100, 1);
iterValues = zeros(3, 1);
denoisedImages = zeros(3, size(imageNoisy, 1), size(imageNoisy, 2));
mult = [1,1; 1.2,1; 0.8, 1; 1,1.2; 1,0.8];
rrmseValues = zeros(3, 5, 1);

for prior = 1:1
   prior
   % selecting the optimal parameters
   if prior == 1
       alpha = 0.20;
       gamma = 0;      % not relevant
   elseif prior == 2
       alpha = 0.60;
       gamma = 0.15;
   else
       alpha = 0.83;
       gamma = 0.04;
   end
   
  for alpha = linspace(0.999,1.0,11)
 %     for gamma = linspace(0.1, 1.0, 10)
%           prior = 2;

    % find the derivative w.r.t prior and the penalty w.r.t potential
    if prior == 1
        % quadratic prior
        h = @(x) quadFunctionH(x);
        g = @(x) quadFunctionG(x);

    elseif prior == 2
        % discontinuous adaptive huber prior
        h = @(x) huberFunctionH(x, gamma);
        g = @(x) huberFunctionG(x, gamma);

    else
        % discontinuoue adaptive proir
        h = @(x) discontAdapFunctionH(x, gamma);
        g = @(x) discontAdapFunctionG(x, gamma);
    end

    %for index = 1:5

%             alpha = alpha * mult(index, 1);
%             gamma = gamma * mult(index, 2);

            % Gradient Descent to optimize the values
            X = imageNoisy;           % initial guess
            prevX = imageNoisy;       % holds previous solution
            
            tau = 0.1;
            prevFx = alpha * priorPotential(X, imageNoisy, g);
            iteration = 1;  
%             if index == 1
%                 fxValues(prior, iteration) = prevFx;
%             end
            
            while tau > epsilon && iteration < 50
                % main loop 
                
                % calculating the likelihood part of X
                likelihoodX = Y - S.*fft2(prevX);
                
                priorDerivative = priorGradient(prevX, imageNoisy, h);
                likelihoodDerivative = ifft2(S.*fft2(prevX)) - imageNoisy;
                
                dX = (1-alpha) * 2 * likelihoodDerivative + alpha * priorDerivative;

                if sum(sum(abs(dX))) < gradThreshold
                    disp('break in here');
                    break
                end

                X = prevX - tau * dX;
                
                priorV = priorPotential(X, imageNoisy, g);
                likelihoodX = Y - S.*fft2(X);
                fx = alpha * priorV + (1-alpha) * sum(sum(abs(likelihoodX).^2));

                % selecting required value of tau
                while  fx > prevFx && tau > epsilon
                    X = prevX - tau * dX;
                    priorV = priorPotential(X, imageNoisy, g);
                    likelihoodX = Y - S.*fft2(X);
                    fx = alpha * priorV + (1-alpha) * sum(sum(abs(likelihoodX).^2));
                    tau = tau * 0.5;
                end

                if fx <= prevFx
                    prevX = X;
                    prevFx = fx;
                    iteration = iteration + 1;
%                     if index == 1
%                         fxValues(prior, iteration) = fx;
%                     end
                    tau = tau * 1.1;
                end 

            end

            X = prevX;
%             if index == 1
%                 iterValues(prior) = iteration;
%                 denoisedImages(prior,:,:) = X;
%             end
%             rrmseValues(prior, index) = RRMSE(imageNoiseless, X);

            sprintf('%f %f %f %d\n', RRMSE(imageNoiseless, X), alpha, gamma, iteration)
            if RRMSE(imageNoiseless, X) < minVal
                minVal = RRMSE(imageNoiseless, X);
                minAlpha = alpha;
                minGamma = gamma;
            end

        end
  %end
end

    % 
    minVal
    minAlpha
    minGamma


    % gradient descent done
    % show the optimized values
    disp(RRMSE(imageNoiseless, X));
    imshow(imageNoiseless);
    figure; imshow(imageNoisy);
    figure; imshow(X);


%     % part A
%     % The initial RRMSE
     disp(RRMSE(imageNoiseless, imageNoisy));

% %% part B
% 
% for prior = 1:3
%     if prior == 1
%         fprintf('For quadratic prior, alpha* = 0.2\n');
%     elseif prior == 2
%         fprintf('For Discontinuity-adaptive Huber function, alpha* = 0.60, gamma*= 0.15\n');
%     else
%         fprintf('For Discontinuity-adaptive function, alpha* = 0.83, gamma*= 0.04\n');
%     end
% 
%     if prior ~= 1
%         for index = 1:5
%             fprintf('RRMSE at %.1falpha*, %.1fgamma* = %f\n', mult(index, 1), mult(index, 2), rrmseValues(prior, index));
%         end
%     else
%         for index = 1:3
%             fprintf('RRMSE at %.1falpha*= %f\n', mult(index, 1), rrmseValues(prior, index));
%         end
%     end
% end
% 
% %% part C
% 
% figure; imshow(imageNoiseless); title ('NoiseLess Image');
% figure; imshow(abs(imageNoisy));     
% X(:,:) = denoisedImages(1,:,:); title ('Noisy Image');
% figure; imshow(abs(X));
% X(:,:) = denoisedImages(2,:,:);title ('Quadratic Function Image');
% figure; imshow(abs(X));
% X(:,:) = denoisedImages(3,:,:);  title ('Huber function Image');
% figure; imshow(abs(X));title ('Discontinuous Adaptive Image');
% 
% %% part D
% for prior = 1:3
%     figure;
%     plot(fxValues(prior, 1:iterValues(prior)));
%     if prior == 1
%         title('Quadratic Prior');
%     elseif prior == 2
%         title('Discontinuous Adaptive Huber Prior');
%     else 
%         title('Discontinuous Adaptive Prior');
%     end
%     xlabel('Iteration number');
%     ylabel('Objective function');
% end

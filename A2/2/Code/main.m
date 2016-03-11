% Loading the images
load('../Data/assignmentImageDenoisingPhantom.mat');

 %imageNoiseless  = imageNoiseless(110:140, 110:140);
 %imageNoisy = imageNoisy(110:140, 110:140);

% parameters
alpha = 0.08;
gamma = 0.01;
epsilonThreshold = 0.01;
epsilon = 0.000001;

minVal = Inf;
minAlpha = 0;
minGamma = 0;

fxValues = zeros(3, 100, 1);
iterValues = zeros(3, 1);
denoisedImages = zeros(3, size(imageNoisy, 1), size(imageNoisy, 2));
mult = [1,1; 1.2,1; 0.8, 1; 1,1.2; 1,0.8];
rrmseValues = zeros(3, 5, 1);

for prior = 1:3
   
   % selecting the optimal parameters
   if prior == 1
       alpha = 0.2;
       gamma = 0;      % not relevant
   elseif prior == 2
       alpha = 0.62;
       gamma = 0.1;
   else
       alpha = 0.87;
       gamma = 0.027;
   end
   
%  for alpha = linspace(0.87,0.87,1)
%      for gamma = linspace(0.027, 0.027, 1)
prior

for index = 1:5
    index
        alpha = alpha * mult(index, 1);
        gamma = gamma * mult(index, 2);
    
        % Gradient Descent to optimize the values
        X = imageNoisy;           % initial guess
        prevX = zeros(size(X));   % holds previous solution

        tau = 1;
        %prior = 3;
        prevFx = Inf;
        iteration = 1;        
        
        
        while RRMSE(prevX, X) > epsilonThreshold
            % main loop 
            
            % calculating the likelihood part of X
            likelihoodX = X - imageNoisy;

            % calculate the potential from the neighbours observation
            %X0 = imageNoisy - X;
            X1 = circshift(imageNoisy, 1) - X;
            X2 = circshift(imageNoisy, -1) - X;
            X3 = circshift(imageNoisy', 1)' - X;
            X4 = circshift(imageNoisy', -1)' - X;
            

            % find the derivative w.r.t prior and the penalty w.r.t potential
            if prior == 1
                % quadratic prior
                priorDerivative = X1 .* arrayfun(@(x) quadPriorH(x), X1) + X2 .* arrayfun(@(x) quadPriorH(x), X2) + X3 .* arrayfun(@(x) quadPriorH(x), X3) + X4 .* arrayfun(@(x) quadPriorH(x), X4); 
                priorPotential = arrayfun(@(x) quadPriorG(x), X1) + arrayfun(@(x) quadPriorG(x), X2) + arrayfun(@(x) quadPriorG(x), X3) + arrayfun(@(x) quadPriorG(x), X4); 

            elseif prior == 2
                % discontinuous adaptive huber prior
                priorDerivative = X1 .* arrayfun(@(x) discontAdapHuberPriorH(x, gamma), X1) + X2 .* arrayfun(@(x) discontAdapHuberPriorH(x, gamma), X2) + X3 .* arrayfun(@(x) discontAdapHuberPriorH(x, gamma), X3) + X4 .* arrayfun(@(x) discontAdapHuberPriorH(x, gamma), X4); 
                priorPotential = arrayfun(@(x) discontAdapHuberPriorG(x, gamma), X1) + arrayfun(@(x) discontAdapHuberPriorG(x, gamma), X2) + arrayfun(@(x) discontAdapHuberPriorG(x, gamma), X3) + arrayfun(@(x) discontAdapHuberPriorG(x, gamma), X4); 

            else
                % discontinuoue adaptive proir
                priorDerivative = X1 .* arrayfun(@(x) discontAdapPriorH(x, gamma), X1) + X2 .* arrayfun(@(x) discontAdapPriorH(x, gamma), X2) + X3 .* arrayfun(@(x) discontAdapPriorH(x, gamma), X3) + X4 .* arrayfun(@(x) discontAdapPriorH(x, gamma), X4); 
                priorPotential = arrayfun(@(x) discontAdapPriorG(x, gamma), X1) + arrayfun(@(x) discontAdapPriorG(x, gamma), X2) + arrayfun(@(x) discontAdapPriorG(x, gamma), X3) + arrayfun(@(x) discontAdapPriorG(x, gamma), X4); 
            end

            % finding derivative 
            dX = 2 * ((1-alpha) * likelihoodX - alpha * priorDerivative);

            % updating the objective function
            fx = (1-alpha) * (sum(sum(abs(likelihoodX).^2))) + alpha * sum(sum(priorPotential));    
            fxValues(prior, iteration) = fx;
            
            % updating the value of X
            prevX = X;
            X = X - tau * dX;

            % updating tau
            if fx > prevFx
                tau = 0.5 * tau;
            else 
                tau = 1.1 * tau;
            end

            % updating the objective function value
            prevFx = fx;
            iteration = iteration + 1;

        end
        
        if index == 1
            iterValues(prior) = iteration - 1;
            denoisedImages(prior,:,:) = X;
        end
        rrmseValues(prior, index) = RRMSE(imageNoiseless, X);
        
%         sprintf('%f %f %f\n', RRMSE(imageNoiseless, X), alpha, gamma)
%         if RRMSE(imageNoiseless, X) < minVal
%             minVal = RRMSE(imageNoiseless, X);
%             minAlpha = alpha;
%             minGamma = gamma;
%         end
           
    end
end

% end
% 
% minVal
% minAlpha
% minGamma


% % gradient descent done
% % show the optimized values
% disp(RRMSE(imageNoiseless, X));
% imshow(imageNoiseless);
% figure; imshow(imageNoisy);
% figure; imshow(X);


% part A
% The initial RRMSE
disp(RRMSE(imageNoiseless, imageNoisy));


% part B

for prior = 1:3
    if prior == 1
        fprintf('For quadratic prior, alpha* = 0.2\n');
    elseif prior == 2
        fprintf('For Discontinuity-adaptive Huber function, alpha* = 0.62, gamma*= 0.1\n');
    else
        fprintf('For Discontinuity-adaptive function, alpha* = 0.87, gamma*= 0.027\n');
    end
    
    if prior ~= 1
        for index = 1:5
            fprintf('RRMSE at %.1falpha*, %.1fgamma* = %f\n', mult(index, 1), mult(index, 2), rrmseValues(prior, index));
        end
    else
        for index = 1:3
            fprintf('RRMSE at %.1falpha*= %f\n', mult(index, 1), rrmseValues(prior, index));
        end
    end
end
    
% part C

figure; imshow(imageNoiseless);
figure; imshow(imageNoisy);
X(:,:) = denoisedImages(1,:,:);
figure; imshow(X);
X(:,:) = denoisedImages(2,:,:);
figure; imshow(X);
X(:,:) = denoisedImages(3,:,:);
figure; imshow(X);

%part D
for prior = 1:3
    figure;
    plot(fxValues(prior, 1:iterValues(prior)));
    if prior == 1
        title('Quadratic Prior');
    elseif prior == 2
        title('Discontinuous Adaptive Huber Prior');
    else 
        title('Discontinuous Adaptive Prior');
    end
    xlabel('Iteration number');
    ylabel('Objective function');
end

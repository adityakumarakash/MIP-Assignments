% Loading the images
load('../Data/assignmentImageDenoisingPhantom.mat');

%imageNoiseless  = imageNoiseless(100:140, 100:140);
%imageNoisy = imageNoisy(100:140, 100:140);

% The initial RRMSE
disp(RRMSE(imageNoiseless, imageNoisy));

% parameters
alpha = 0.08;
gamma = 0.01;
epsilonThreshold = 0.01;
epsilon = 0.000001;

minVal = Inf;
minAlpha = 0;
minGamma = 0;

%for alpha = linspace(0.01,0.1,10)
%    for gamma = linspace(0.005,0.05,10)

        % Gradient Descent to optimize the values
        X = imageNoisy;           % initial guess
        prevX = zeros(size(X));   % holds previous solution

        tau = 1;
        prior = 2;
        prevFx = Inf;
        iteration = 1;        
        
        
        while RRMSE(prevX, X) > epsilonThreshold
            % main loop 
            prevX = X;
            likelihoodX = X - imageNoisy;

            % calculate the potential from the neighbours observation
            X1 = circshift(imageNoisy, 1) - X;
            X2 = circshift(imageNoisy, -1) - X;
            X3 = circshift(imageNoisy', 1)' - X;
            X4 = circshift(imageNoisy', -1)' - X;

            % find the derivative w.r.t prior and the penalty w.r.t potential
            if prior == 1
                % quadratic prior
                priorDerivative = X1 .* arrayfun(@(x) quadPriorH(x), X1) + X2 .* arrayfun(@(x) quadPriorH(x), X2) + X3 .* arrayfun(@(x) quadPriorH(x), X3) + X4 .* arrayfun(@(x) quadPriorH(x), X4); %X2 .* quadPriorH(X2) + X3 .* quadPriorH(X3) + X4 .* quadPriorH(X4);
                priorPotential = arrayfun(@(x) quadPriorG(x), X1) + arrayfun(@(x) quadPriorG(x), X2) + arrayfun(@(x) quadPriorG(x), X3) + arrayfun(@(x) quadPriorG(x), X4); %quadPriorG(X2) + quadPriorG(X3) + quadPriorG(X4);

            elseif prior == 2
                % discontinuous adaptive huber prior
                %priorDerivative = X1 .* discontAdapHuberPriorH(X1, gamma) + X2 .* discontAdapHuberPriorH(X2, gamma) + X3 .* discontAdapHuberPriorH(X3, gamma) + X4 .* discontAdapHuberPriorH(X4, gamma);
                %priorPotential = discontAdapHuberPriorG(X1, gamma) + discontAdapHuberPriorG(X2, gamma) + discontAdapHuberPriorG(X3, gamma) + discontAdapHuberPriorG(X4, gamma);
                priorDerivative = X1 .* arrayfun(@(x) discontAdapHuberPriorH(x, gamma), X1) + X2 .* arrayfun(@(x) discontAdapHuberPriorH(x, gamma), X2) + X3 .* arrayfun(@(x) discontAdapHuberPriorH(x, gamma), X3) + X4 .* arrayfun(@(x) discontAdapHuberPriorH(x, gamma), X4); 
                priorPotential = arrayfun(@(x) discontAdapHuberPriorG(x, gamma), X1) + arrayfun(@(x) discontAdapHuberPriorG(x, gamma), X2) + arrayfun(@(x) discontAdapHuberPriorG(x, gamma), X3) + arrayfun(@(x) discontAdapHuberPriorG(x, gamma), X4); 

            else
                % discontinuoue adaptibe proir
                %priorDerivative = X1 .* discontAdapPriorH(X1, gamma) + X2 .* discontAdapPriorH(X2, gamma) + X3 .* discontAdapPriorH(X3, gamma) + X4 .* discontAdapPriorH(X4, gamma);
                %priorPotential = discontAdapPriorG(X1, gamma) + discontAdapPriorG(X2, gamma) + discontAdapPriorG(X3, gamma) + discontAdapPriorG(X4, gamma);
                priorDerivative = X1 .* arrayfun(@(x) discontAdapPriorH(x, gamma), X1) + X2 .* arrayfun(@(x) discontAdapPriorH(x, gamma), X2) + X3 .* arrayfun(@(x) discontAdapPriorH(x, gamma), X3) + X4 .* arrayfun(@(x) discontAdapPriorH(x, gamma), X4); %X2 .* discontAdapPriorH(X2) + X3 .* discontAdapPriorH(X3) + X4 .* discontAdapPriorH(X4);
                priorPotential = arrayfun(@(x) discontAdapPriorG(x, gamma), X1) + arrayfun(@(x) discontAdapPriorG(x, gamma), X2) + arrayfun(@(x) discontAdapPriorG(x, gamma), X3) + arrayfun(@(x) discontAdapPriorG(x, gamma), X4); %discontAdapPriorG(X2) + discontAdapPriorG(X3) + discontAdapPriorG(X4);

            end

            % finding derivative 
            dX = 2 * (alpha * likelihoodX - (1 - alpha) * priorDerivative);

            % updating the objective function
            fx = alpha * (sum(sum(likelihoodX.^2))) + (1 - alpha) * sum(sum(priorPotential));    

            % updating the value of X
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
            RRMSE(prevX, X);

        end
        sprintf('%f %f %f\n', RRMSE(imageNoiseless, X), alpha, gamma)
        if RRMSE(imageNoiseless, X) < minVal
            minVal = RRMSE(imageNoiseless, X);
            minAlpha = alpha;
            minGamma = gamma;
        end
           
%    end
%end

minVal
minAlpha
minGamma


% gradient descent done
% show the optimized values
disp(RRMSE(imageNoiseless, X));
imshow(imageNoiseless);
figure; imshow(imageNoisy);
figure; imshow(X);



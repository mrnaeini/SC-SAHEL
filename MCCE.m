function [X,F,fcal] = MCCE(varargin)
% The evolutionary method based on the SPI_UCI algorithm, developed by 
% Dr. Wei Chu, 08/2012
% 
% References:
% - Chu, Wei, Xiaogang Gao, and Soroosh Sorooshian. "A new evolutionary 
% search strategy for global optimization of high-dimensional problems." 
% Information Sciences 181, no. 22 (2011): 4909-4927.
% - Chu, Wei, Xiaogang Gao, and Soroosh Sorooshian. "Improving the shuffled 
% complex evolution scheme for optimization of complex nonlinear 
% hydrological systems: Application to the calibration of the Sacramento 
% soil moisture accounting model." Water Resources Research 46, no. 9(2010).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by Matin Rahnamay Naeini. Last modified on January 2018.
% Email: rahnamam@uci.edu
%
% Please reference to:
% Matin Rahnamay Naeini, Tiantian Yang, Mojtaba Sadegh, Amir Aghakouchak,
% Kuo-lin Hsu, Soroosh Sorooshian, Qingyun Duan, and Xiaohui Lei. "Shuffled 
% complex-self adaptive hybrid evolution (SC-SAHEL) optimization
% framework." Environmental Modelling & Software, 104:215 - 235, 2018.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define input variables
X = varargin{1};
F = varargin{2};
fobj = varargin{3};
EvolStep = varargin{4};
bh = varargin{5};
Data = varargin{8};
fcal = varargin{9};
% X is the complex samples
% F is the samples objective function values
% fobj is the objective function, function handle
% EvolStep is the number of evolutions
% bh is the boundary handling structure
% Data is the observed data (optional)
% fcal is the number of function evaluation counter
%% Output
% X is the evolved complex samples
% F is the evolved complex objective function
% fcal is the number of function evaluation counter
%% Evolution
% Get the dimension of population
[n,d] = size(X); 
% Assign memory for r
r = nan(1,d+1);      
% Evolve complex for the maximum number of allowed evolutionary steps
for i = 1:EvolStep
    % Sort the complex;
    [F,idx] = sort(F); X=X(idx,:);
    % Select simplex by sampling the complex according to a linear
    % probability distribution
    % Sample other points
    % Assign triangular probability to points
    p = 2*(n:-1:1)./(n*(n+1));
    % randomly sample d+1 points according to the probability 
    % Select the best point in complex
    r(1) = 1;
    r(2:d+1) = datasample(2:n,d,'Replace',false,'Weights',p(2:end));
    % Sort the selected points
    r = sort(r);
    % Construct the simplex:
    s = X(r,:); sf = F(r);
    % Evolve the simplex
    [s,sf,fcal] = MCCE_Evol(s,sf,bh,fcal,fobj,Data);
    % Replace the simplex into the complex;
    X(r,:) = s;
    F(r) = sf;
end



function [s,sf,fcal] = MCCE_Evol(s,sf,bh,fcal,fobj,data)
% The adapted simplex algorithm written by Dr. Wei Chu, 08/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Modified by Matin Rahnamay Naeini.Jan-24-2017               %
%                         Email: rahnamam@uci.edu                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input
% s is the simplex points
% sf is the simplex objective function
% bh is the structure for boundary handling
% fcal is the objective function, function handle
% data is the input data for the objective function (optional)
%% Output
% s is the evolved complex
% sf is the objective functions of evolved complex
% fcal is the number of function call
% AR is the acceptance rate for the evolutionary method
%% Evolution
n = size(s,1);                        % Number of points in simplex
alpha = 1.0;                          % Reflection coefficient
beta = 0.5;                           % Contraction coefficient

% Find the best, second worst and the worst point
fb = sf(1);                           % The best point
fsW = sf(n-1);                        % Second worst point
sw = s(n,:); fW = sf(n);              % Worst point

% Compute the centroid of the simplex excluding the worst point:
ce = mean(s(1:n-1,:));

% Attempt a reflection
snew = ce + alpha*(ce-sw);

% Check for boundary handling
if sum(snew > bh.ub) || sum(snew < bh.lb)
    snew = bh.fun(snew,bh.lb,bh.ub);
end
% Calculate the objective function of the new point
fnew = fobj(snew,data);
% Count function evaluation
fcal = fcal + 1;
% Compare the new point with the best point in the complex
if fnew < fsW
    % If the new point is better than the second worst point in the simplex
    if fnew < fb
        % If the new point is better than the best point in the complex
        % Derive a new best point with EXPANSION
        snew1 = snew + alpha*(snew-ce);
        % Check for boundary handling
        if any(snew1 > bh.ub) || any(snew1 < bh.lb)
            snew1 = bh.fun(snew1,bh.lb,bh.ub);
        end
        % Calculate the new point objective function
        fnew1 = fobj(snew1,data);
        % Count function evaluation
        fcal = fcal + 1;
        % Compare the new point with the point generated with reflection
        if fnew1 < fnew
            % If the new point is better than reflection point replace it
            fnew = fnew1;
            snew = snew1;
        end
    end
else
    if fnew < fW
        % If new point is better than the worst point
        % Attempt a contract outside
        snew1 = ce + beta*(snew-ce);
        % Check for boundary handling
        if sum(snew1 > bh.ub) || sum(snew1 < bh.lb)
            snew1 = bh.fun(snew1,bh.lb,bh.ub);
        end
        % calculate the new point objective function
        fnew1 = fobj(snew1,data);
        % Count function evaluation
        fcal = fcal + 1;
        % Compare the new point with reflection point
        if fnew1 < fnew
            % If the new point is better replace the new point
            fnew=fnew1;
            snew=snew1;
        end
    else
        % IF the new point is worst than the worst point
        % Attempt a contract inside (shrink)
        snew = sw + beta*(ce-sw);
        % Check for boundary handling
        if sum(snew > bh.ub) || sum(snew < bh.lb)
            snew = bh.fun(snew,bh.lb,bh.ub);
        end
        % Calculate the new point objective function
        fnew = fobj(snew,data);
        % Count function evaluation
        fcal = fcal + 1;
        if fnew > fW
            % If the new point is worst than the worst point 
            % Derive the covariance matrix for the points in the simplex
            sig = cov(s);
            % Get the variance of the dimensions
            Dia = diag(sig);
            % Generate a new covariance matrix with (Dia + mean(Dia))*2 as 
            % diagonal and zero everywhere else
            sig = diag((Dia+mean(Dia))*2);
            % Generate a new point with multinormal distribution
            % with mean of centroid and covariance sig
            snew = mvnrnd(ce,sig,1);
            % Check boundary handling
            if sum(snew > bh.ub) || sum(snew < bh.lb)
                snew = bh.fun(snew,bh.lb,bh.ub);
            end
            % Calculate the new point objective function
            fnew = fobj(snew,data);
            % Count function evaluation
            fcal = fcal + 1;
        end
    end
end
% Replace the new points in the simplex
s(n,:) = snew;
sf(n) = fnew;
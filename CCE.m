function [X,F,fcal] = CCE(varargin)
% Competetive Complex Evolution, 
% written by Q.Duan, 9/2004
% Reference:
% - Duan, Qingyun, Soroosh Sorooshian, and Vijai Gupta. "Effective and 
% efficient global optimization for conceptual rainfall-runoff models." 
% Water resources research 28, no. 4 (1992): 1015-1031.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by Matin Rahnamay Naeini. 
% Last modified on January-2018
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
% Sort the objective function values and samples in increasing order
[F,idx] = sort(F); X = X(idx,:);
% Get the dimension of population
[n,d] = size(X);  
% Assign memory for sampling (r)
r = nan(1,d+1);      
% Evolve complex for the maximum number of allowed evolutionary steps
for i = 1:EvolStep
    % Select simplex by sampling the complex according to a linear
    % probability distribution
    p = 2*(n:-1:1)./(n*(n+1));
    % Select the best point in complex
    r(1) = 1;
    % randomly sample d points according to the probability 
    r(2:d+1) = datasample(2:n,d,'Replace',false,'Weights',p(2:end));
    % Sort sampled points
    r=sort(r);
    % Construct the simplex:
    s=X(r,:); sf = F(r);
    % Evolve the simplex
    [s,sf,fcal]=CCE_Evol(s,sf,bh,fcal,fobj,Data);
    % Replace the simplex into the complex;
    X(r,:) = s;
    F(r) = sf;
    % Sort the samples
    [F,idx] = sort(F); X=X(idx,:);
end


function [s,sf,fcal] = CCE_Evol(s,sf,bh,fcal,fobj,Data)
% CCE_Evol function, evolve the simplex 
% Developed by Q.Duan, 9/2004
% Modified by Matin Rahnamay Naeini. Jan-23-2017
% Email: rahnamam@uci.edu
%Inputs
% s is the points in the simplex
% sf is the objective function value for the points in the simplex
% bh is the boundary handling structure
% fcal is the number of function evaluation counter
% fobj is the objective function, function handle
% Data is the observed data (optional)
% Output
% s is the evolved simplex
% sf is the evolved simplex objective function values
% fcal is the number of function evaluation counter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the dimension of the simplex
[n,m]=size(s);
% Set alpha and beta
alpha = 1.0;
beta = 0.5;
% Assign the best and worst points
sw=s(n,:); fw=sf(n);
% Compute the centroid of the simplex excluding the worst point
ce=mean(s(1:n-1,:));
% Attempt a reflection point
snew = ce + alpha*(ce-sw);
% Do boundary handling test
if any(snew > bh.ub) || any(snew < bh.lb)
    snew = bh.fun(snew,bh.lb,bh.ub);
end
% Calculate the objective function of the new point
fnew = fobj(snew,Data);
% Count function evaluation
fcal = fcal + 1;
if fnew > fw
    % If reflection failed, attempt a contraction
    snew = sw + beta*(ce-sw);
    % Do boundary handling test
    if any(snew > bh.ub) || any(snew < bh.lb)
        snew = bh.fun(snew,bh.lb,bh.ub);
    end
    % Calculate the objective function of the new point
    fnew = fobj(snew,Data);
    % Count function evaluation
    fcal = fcal + 1;
    if fnew > fw
        % If both reflection and contraction have failed, attempt
        % generating a random point
        snew = bh.lb + rand(1,m).*(bh.ub-bh.lb);
        % Calculate the objective function of the new point
        fnew = fobj(snew,Data);
        % Count function evaluation
        fcal = fcal + 1;
    end
end
% Replace the new points in the simplex
s(n,:) = snew;
sf(n) = fnew;
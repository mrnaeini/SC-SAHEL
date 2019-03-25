function [X,F,fcal] = FL(varargin)
% This function evolve complexes based on the Modified Frog Leap algorithm.
%
% Reference:
% - Eusuff, Muzaffar, Kevin Lansey, and Fayzul Pasha. "Shuffled frog-leaping 
% algorithm: a memetic meta-heuristic for discrete optimization." 
% Engineering Optimization 38.2 (2006): 129-154.
% - Eusuff, Muzaffar M., and Kevin E. Lansey. "Optimization of water 
% distribution network design using the shuffled frog leaping algorithm." 
% Journal of Water Resources planning and management 129, no. 3 (2003): 
% 210-225.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Developed by Matin Rahnamay Naeini. Last modified on January-2018    %
%                         Email: rahnamam@uci.edu                         %
%                    University of California, Irvine                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Please reference to:
% Matin Rahnamay Naeini, Tiantian Yang, Mojtaba Sadegh, Amir Aghakouchak,
% Kuo-lin Hsu, Soroosh Sorooshian, Qingyun Duan, and Xiaohui Lei. "Shuffled 
% complex-self adaptive hybrid evolution (SC-SAHEL) optimization
% framework." Environmental Modelling & Software, 104:215 - 235, 2018.
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
% First get the dimension of population
[n,d] = size(X);  
% Evolve complex for the maximum number of allowed evolutionary steps:
for i = 1:EvolStep
    % Sort the memplex
    [F,idx] = sort(F); X = X(idx,:);
    p = 2*(n:-1:1)./(n*(n+1));
    r = datasample(1:n,d+1,'Replace',false,'Weights',p);
    % Sort the selected points
    r = sort(r);
    % Construct the subcomplex
    s = X(r,:); sf = F(r);
    % Evolve the subcomplex
    [s,sf,fcal] = FL_e(s,sf,bh,fcal,fobj,Data);
    % Replace the subcomplex into the complex
    X(r,:) = s;
    F(r) = sf;
end


function [s,sf,fcal]=FL_e(s,sf,bh,fcal,fobj,Data)
% This function evolve complexes based on the Modified Frog Leap algorithm.
%
% Reference:
% - Eusuff, Muzaffar, Kevin Lansey, and Fayzul Pasha. "Shuffled frog-leaping 
% algorithm: a memetic meta-heuristic for discrete optimization." 
% Engineering Optimization 38.2 (2006): 129-154.
% - Eusuff, Muzaffar M., and Kevin E. Lansey. "Optimization of water 
% distribution network design using the shuffled frog leaping algorithm." 
% Journal of Water Resources planning and management 129, no. 3 (2003): 
% 210-225.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Developed by Matin Rahnamay Naeini. Jan-03-2016             %
%                         Email: rahnamam@uci.edu                         %
%                    University of California, Irvine                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input
% s is the simplex before evolution
% sf is the simplex objective function
% bh is the boundary handling structure
% fcal is the number of function evaluation
% fobj is the function objective function
% Data is the observed data (optional)
%% Output
% S is the evolved simplex
% SF is the evolved simplex objective function
% fcal is the number of function evaluation
%% Evolution
% Get the dimension of the simplex
[m,d] = size(s);
% sort the simplex in increasing order of objective function
[sf,idx] = sort(sf); s = s(idx,:);
% D is the jump rate based on the best point in the subcomplex
D = (0.5*rand+1.5)*(s(1,:)-s(m,:));
% Make a new point
Z = s(m,:) + D;
% Boundary handling
if any(Z > bh.ub) > 0 || any(Z < bh.lb) > 0
    Z = bh.fun(Z,bh.lb,bh.ub);
end
% Calculate the new point objective function
F_Z = fobj(Z,Data);
% update the function call counter
fcal = fcal+1;
% Compare the new point with the worst point
if F_Z < sf(m)
    % if the new point has better objective function replace the point
    sf(m) = F_Z;
    s(m,:) = Z;
else
    % if the new point is worst than the worst point creat new point
    % Define new jump based on the global best point
    D = (0.5*rand)*(s(1,:)-s(m,:));
    % Create the new point
    Z = s(m,:) + D;
    % Boundary handling
    if any(Z > bh.ub) > 0 || any(Z < bh.lb) > 0
        Z = bh.fun(Z,bh.lb,bh.ub);
    end
    % Calculate the new point objective function
    F_Z = fobj(Z,Data);
    % Update the counter
    fcal = fcal+1;
    % Compare the new point with the worst point
    if F_Z < sf(m)
    % If the new point is better replace it with the worst point
        sf(m) = F_Z;
        s(m,:) = Z;
    else
        lb = min(s); ub = max(s);
        % If the new point is worst than the worst point generate random number
        Z = lb + rand(1,d).*(ub-lb);
        % Calculate the objective function
        F_Z = fobj(Z,Data);
        % Update the counter
        fcal = fcal+1;
        % Replace the new points
        sf(m) = F_Z;
        s(m,:) = Z;
    end
end
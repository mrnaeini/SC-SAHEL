function [X,F,fcal] = DEF(varargin)
% Modified Differential Evolution Algorithm based for SC-SAHEL framework.
% 
% Reference:
% - Qin, A. Kai, Vicky Ling Huang, and Ponnuthurai N. Suganthan. 
% "Differential evolution algorithm with strategy adaptation for global 
% numerical optimization." IEEE transactions on Evolutionary Computation 
% 13.2 (2009): 398-417.
%
% Please reference to:
% Matin Rahnamay Naeini, Tiantian Yang, Mojtaba Sadegh, Amir Aghakouchak,
% Kuo-lin Hsu, Soroosh Sorooshian, Qingyun Duan, and Xiaohui Lei. "Shuffled 
% complex-self adaptive hybrid evolution (SC-SAHEL) optimization
% framework." Environmental Modelling & Software, 104:215 - 235, 2018.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Developed by Matin Rahnamay Naeini. Last modified on January-2018    %
%                         Email: rahnamam@uci.edu                         %
%                    University of California, Irvine                     %
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
% Get the number of points in the complex and dimension of the problem
[n,d] = size(X);
% Set the mutation and cross-over rate
f = 1;                                  % Mutation rate
CR = 0.75;                              % Cross-over rate
% Evolution
% Assign memory for sampling (r)
r = nan(1,d+1);
for i = 1:EvolStep
    % Sort the points in the complex
    [F,idx] = sort(F); X = X(idx,:);
    % Randomly sample d+1 points
    p = 2*(n:-1:1)./(n*(n+1));
    % Select the best point in the complex
    r(1) = 1;
    % Select d points from the complex
    r(2:end) = datasample(2:n,d,'Replace',false,'Weights',p(2:end));
    % Sort the selected points
    r = sort(r);
    % Mutation with large jumps
    ZR = X(r(end),:) + 2*f*(X(r(1),:)-X(r(end),:))+2*f*(X(r(2),:)-X(r(3),:));
    % Cross-over
    c = rand(1,d);
    c = c<CR;
    % Cross-over
    Z = X(r(end),:);
    Z(c) = ZR(c);
    % Boundary handling
    if any(Z > bh.ub) > 0 || any(Z < bh.lb) > 0
        Z = bh.fun(Z,bh.lb,bh.ub);
    end
    % Calculate the fitness of the new point
    F_Z = fobj(Z,Data);
    % update the number of function evaluation
    fcal = fcal+1;
    if F_Z < F(r(end))
        % If the new point is better than worst point, replace the worst
        % point with the new point
        X(r(end),:) = Z;
        F(r(end)) = F_Z;
    else
        % Otherwise generate new point
        % Mutation
        ZR = X(r(end),:) + 0.5*f*(X(r(1),:)-X(r(end),:))+0.5*f*(X(r(2),:)-X(r(3),:));
        % Cross-over
        c = rand(1,d);
        c = c<CR;
        % Cross-over
        Z = X(r(end),:);
        Z(c) = ZR(c);
        % Boundary handling
        if any(Z > bh.ub) > 0 || any(Z < bh.lb) > 0
            Z = bh.fun(Z,bh.lb,bh.ub);
        end
        % Calculate the fitness of the new point
        F_Z = fobj(Z,Data);
        % update the number of function evaluation
        fcal = fcal+1;
        if F_Z < F(r(end))
            % If the new point is better than worst point, replace the worst
            % point with the new point
            X(r(end),:) = Z;
            F(r(end)) = F_Z;
        else
            % Otherwise generate new point
            % Mutation
            ZR = X(r(end),:) + f*(X(r(1),:)-X(r(end),:))+f*(X(r(2),:)-X(r(3),:));
            % Cross-over
            c = rand(1,d);
            c = c<CR;
            % Cross-over
            Z = X(r(end),:);
            Z(c) = ZR(c);
            % Boundary handling
            if any(Z > bh.ub) > 0 || any(Z < bh.lb) > 0
                Z = bh.fun(Z,bh.lb,bh.ub);
            end
            % Calculate the fitness of the new point
            F_Z = fobj(Z,Data);
            % Count function evaluation
            fcal = fcal+1;           
            if F_Z < F(r(end))
                % If the new point is better than worst point, replace the worst
                % point with the new point
                X(r(end),:) = Z;
                F(r(end)) = F_Z;
            else
                lb = min(X); ub = max(X);
                % If the new point is worst than the worst point generate
                % random point within the range of the parameters within
                % the complex
                Z = lb + rand(1,d).*(ub-lb);
                % Calculate the new point objective function
                F_Z = fobj(Z,Data);
                % Count function evaluation
                fcal = fcal+1;
                % Replace the new point
                X(r(end),:) = Z;
                F(r(end)) = F_Z;
            end
        end
    end
end
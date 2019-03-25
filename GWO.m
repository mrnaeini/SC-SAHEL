function [X,F,fcal] = GWO(varargin)
% Modified Grey Wolf Optimizer for SC-SAHEL algorithm.
%
% References:
% - Mirjalili, Seyedali, Seyed Mohammad Mirjalili, and Andrew Lewis.
%   "Grey wolf optimizer." Advances in Engineering Software 69 (2014): 46-61.
% Equations are refrenced to the reference above.
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
%% Input
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
% Get the number of points in each complex and dimension of the problem
[n,d] = size(X); 
% Assign memory for sampling
r = nan(1,d+1);
for i = 1:EvolStep
    % Sort the points in order of increasing objective function
    [F,idx] = sort(F); X = X(idx,:);
    % Assign triangular probability to points
    p = 2*(n:-1:1)./(n*(n+1));
    % randomly sample d+1 points according to the probability 
    r(1) = 1;
    r(2:d+1) = datasample(2:n,d,'Replace',false,'Weights',p(2:end));
    % Sort the selected points
    r = sort(r);
    % Select the top three points in the subcomplex
    % Find the alpha position
    Alpha_pos = X(r(1),:);
    % Find the Beta position
    Beta_pos = X(r(2),:);
    % Find the Delta position
    Delta_pos = X(r(3),:);
    % select the worst point
    w = r(end);
    % Generate points
    % generate random number
    r1 = rand(1,d); % r1 is a random number in [0,1]
    r2 = rand(1,d); % r2 is a random number in [0,1]
    A1 = 4*r1-2; % Equation (3.3) modified
    C1 = 2*r2; % Equation (3.4)
    D_alpha = abs(C1(1,:).*Alpha_pos(1,:) - X(w,:)); % Equation (3.5)-part 1
    X1 = Alpha_pos - A1.*D_alpha; % Equation (3.6)-part 1
    
    % generate random number
    r1 = rand(1,d); % r1 is a random number in [0,1]
    r2 = rand(1,d); % r2 is a random number in [0,1]
    A2 = 4*r1-2; % Equation (3.3) modified
    C2 = 2*r2; % Equation (3.4)
    D_beta = abs(C2(1,:).*Beta_pos(1,:) - X(w,:)); % Equation (3.5)-part 1
    X2 = Beta_pos - A2.*D_beta; % Equation (3.6)-part 1
    
    % generate random number
    r1 = rand(1,d); % r1 is a random number in [0,1]
    r2 = rand(1,d); % r2 is a random number in [0,1]
    A3 = 4*r1-2; % Equation (3.3) modified
    C3 = 2*r2; % Equation (3.4)
    D_delta = abs(C3(1,:).*Delta_pos(1,:) - X(w,:)); % Equation (3.5)-part 1
    X3 = Delta_pos - A3.*D_delta; % Equation (3.6)-part 1
    
    Z = (X1+X2+X3)./3;
    % Now check for boundary handling
    if any(Z > bh.ub) > 0 || any(Z < bh.lb) > 0
        Z = bh.fun(Z,bh.lb,bh.ub);
    end
    % Calculate the fitness of the new point
    F_Z = fobj(Z,Data);
    % Count function evaluation
    fcal = fcal+1;
    
    if F_Z < F(w)
        % Replace the new point with the worst point
        X(w,:) = Z;
        F(w) = F_Z;
    else
        % Sort the selected points
        r = sort(r);
        % Select the top three points in the subcomplex
        % Find the alpha position
        Alpha_pos = X(r(1),:);
        % Find the Beta position
        Beta_pos = X(r(2),:);
        % Find the Delta position
        Delta_pos = X(r(3),:);
        % select the worst point
        w = r(end);
        % Generate points
        % generate random number
        r1 = rand(1,d); % r1 is a random number in [0,1]
        r2 = rand(1,d); % r2 is a random number in [0,1]
        A1 = 2*r1-1; % Equation (3.3) modified
        C1 = 2*r2; % Equation (3.4)
        D_alpha = abs(C1(1,:).*Alpha_pos(1,:) - X(w,:)); % Equation (3.5)-part 1
        X1 = Alpha_pos - A1.*D_alpha; % Equation (3.6)-part 1

        % generate random number
        r1 = rand(1,d); % r1 is a random number in [0,1]
        r2 = rand(1,d); % r2 is a random number in [0,1]
        A2 = 2*r1-1; % Equation (3.3) modified
        C2 = 2*r2; % Equation (3.4)
        D_beta = abs(C2(1,:).*Beta_pos(1,:) - X(w,:)); % Equation (3.5)-part 1
        X2 = Beta_pos - A2.*D_beta; % Equation (3.6)-part 1

        % generate random number
        r1 = rand(1,d); % r1 is a random number in [0,1]
        r2 = rand(1,d); % r2 is a random number in [0,1]
        A3 = 2*r1-1; % Equation (3.3) modified
        C3 = 2*r2; % Equation (3.4)
        D_delta = abs(C3(1,:).*Delta_pos(1,:) - X(w,:)); % Equation (3.5)-part 1
        X3 = Delta_pos - A3.*D_delta; % Equation (3.6)-part 1

        Z = (X1+X2+X3)./3;
        % Now check for boundary handling
        if any(Z > bh.ub) > 0 || any(Z < bh.lb) > 0
            Z = bh.fun(Z,bh.lb,bh.ub);
        end
        % Calculate the fitness of the new point
        F_Z = fobj(Z,Data);
        % Count function evaluation
        fcal = fcal+1;
        if F_Z < F(w)
            % Replace the new point with the worst point
            X(w,:) = Z;
            F(w) = F_Z;
        else
            lb = min(X); ub = max(X);
            % If the new point is worst than the worst point generate random number
            Z = lb + rand(1,d).*(ub-lb);
            % Evaluate the new point
            F_Z = fobj(Z,Data);
            % Count function evaluation
            fcal = fcal+1;
            % Replace the points into complex
            X(w,:) = Z;
            F(w) = F_Z;
        end
    end
end
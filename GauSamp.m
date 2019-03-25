function [Snew,Sfnew,fc]=GauSamp(S,Sf,bh,fc,fobj,Data)
% Function for Gaussian Resampling for handling rough spaces.
% This function is developed by Dr. Wei Chu, 2012
%
% References:
% - Chu, Wei, Xiaogang Gao, and Soroosh Sorooshian. "A new evolutionary 
% search strategy for global optimization of high-dimensional problems." 
% Information Sciences 181, no. 22 (2011): 4909-4927.
% - Chu, Wei, Xiaogang Gao, and Soroosh Sorooshian. "Improving the shuffled 
% complex evolution scheme for optimization of complex nonlinear 
% hydrological systems: Application to the calibration of the Sacramento 
% soil?moisture accounting model." Water Resources Research 46, no. 9(2010).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by Matin Rahnamay Naeini. Last modified on January 2018
% Email: rahnamam@uci.edu
% Please reference to:
% Matin Rahnamay Naeini, Tiantian Yang, Mojtaba Sadegh, Amir Aghakouchak,
% Kuo-lin Hsu, Soroosh Sorooshian, Qingyun Duan, and Xiaohui Lei. "Shuffled 
% complex-self adaptive hybrid evolution (SC-SAHEL) optimization
% framework." Environmental Modelling & Software, 104:215 - 235, 2018.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
% S is the complex samples
% Sf is the complex objective function value
% bh is the boundary handling structure
% fc is the number of function evaluation counter
% fobj is the objective function, function handle
% Data is the data required for calculating the objective function
% Output
% Snew Resampled complex
% Sfnew Resampled complex objective function values
% fc is the number of function evaluation counter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get dimension of the complex
[n,m] = size(S);
% Find the mean and covariance of the dimensions within the complex
Smean = mean(S);
Ssig = cov(S);
% Do a resampling using multivariate normal sampling
Srand = 2*mvnrnd(zeros(1,m),Ssig,n)+repmat(Smean,n,1);
% Assign memory
Sfrand = nan(1,n);
for i = 1:n
    % Boundary handling
    if any(Srand(i,:) > bh.ub) || any(Srand(i,:) < bh.lb)
        Srand(i,:) = bh.fun(Srand(i,:),bh.lb,bh.ub);
    end
    % Calculate the objective function value for the new points
    Sfrand(i) = fobj(Srand(i,:),Data); 
    fc = fc + 1;
end
% Find the top n points within the complex and the random sampled points
Stotal = [S; Srand];
Sftotal = [Sf Sfrand];
% Sort the points
[Sftotal,idx] = sort(Sftotal); Stotal = Stotal(idx,:);
% Select the first n points
Snew = Stotal(1:n,:);
Sfnew = Sftotal(1:n);
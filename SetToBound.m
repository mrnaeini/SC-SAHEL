function [X] = SetToBound(X,lb,ub)
% Set to bound, boundary handling method set the parameters, which are out
% of the bounds to the bound of feasible parameter range
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
% X is the sample
% lb is the parameter lower bound
% ub is the parameter upper bound
%% Output
% X is the Adjusted sample
%% Adjustment
% find the dimensions larger than upper bound
idx = find( X > ub);
X(idx) = ub(idx);
% find the dimensions smaller than lower bound
idx = find( X < lb);
X(idx) = lb(idx);
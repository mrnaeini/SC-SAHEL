function [X] = ReflectBH(X,lb,ub)
% reflection boundary handling function reflects the out of bound point to
% the feasible range
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
% Get the parameters range
bound = ub - lb;
% find the dimensions larger than upper bound
idx = find( X > ub);
rm = rem(X(idx)-ub(idx),bound(idx));
X(idx) = ub(idx) - abs(rm);
% find the dimensions smaller than lower bound
idx = find( X < lb);
rm = rem(X(idx)-lb(idx),bound(idx));
X(idx) = lb(idx) + abs(rm);
function [X] = LHsamp(N,lb,ub)
% Latin Hypercube sampling method for sampling problem space
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
% N is number of samples
% lb is the parameters lower bounds
% ub is the parameters upper bounds
%% Output
% X is the generated samples
%% Sampling
% First get the dimension of the problem
d = length(lb);
% Find the range of parameters
bound = (ub(:) - lb(:))';
% Now generate population
X = repmat(lb(:)',N,1) + lhsdesign(N,d).*repmat(bound,N,1);
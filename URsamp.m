function X = URsamp(N,lb,ub)
% The uniform random sampling function
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
% N is the number of samples
% lb is the parameters lower bound
% ub is the parameters upper bound
%% Output
% X is the sampled data
%% Sampling
% Get the dimension of the problem
d = length(lb);
% Get the parameters range
bound = (ub(:)-lb(:))';
% Sample points
X = repmat(lb(:)',N,1) + rand(N,d).*repmat(bound,N,1);
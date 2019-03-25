function [CX,FX] = PartitionComp(X,F,NumComp)
% The SCE_complex function partition the samples into complexes based on 
% the SCE-UA code written by DR. Q. Duan 9/2004 
% Reference:
% - Duan, Qingyun, Soroosh Sorooshian, and Vijai Gupta. "Effective and 
% efficient global optimization for conceptual rainfall-runoff models." 
% Water resources research 28, no. 4 (1992): 1015-1031.
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
%% input
% X is the sorted sample points in order of increasing F_s (Objective function)
% F is the criterion (objective function) sorted in increasing order
% NumComp is the number of complexes
%% output
% CX is the partitioned complexes
% FX is the partitioned objective function values
%% Partitioning
% First find the length of complexes and dimension of the problem
CompSize = size(X,1)/NumComp;
d = size(X,2);
% Assign memory for complexes individuals and fitness
CX = nan(NumComp,CompSize,d);
FX = nan(NumComp,CompSize);
for i = 1:CompSize
    % Get the index of samples
    K1 = randperm(NumComp)+(i-1)*NumComp;
    % Save samples into complexes
    CX(:,i,:) = X(K1,:);
    FX(:,i) = F(K1);
end
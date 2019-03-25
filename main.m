% Main script for running Shuffled Complex - Self Adaptive Hybrid Evolution
% (SC-SAHEL) optimization algorithm. A hybrid framework for optimization.
% Code is written based on the SCE code written by DR. Q. Duan 9/2004 and
% the SP-UCI algorithm,written by Dr. Wei Chu, 08/2012 with added
% components and features.
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
%
% Please refer to the user guide before running SC-SAHEL
% Setting for example(1) with two dimension (For other examples please 
% refer to the manual)
addpath('TestCases\');
lb = [-10,-10,-10];                % Parameters lower bounds
ub = [10,10,10];                   % Parameters upper bounds
MaxFcal = 100000;                  % Maximum number of function evaluation
ObjFun = 'F2';                     % Objective function name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call SC-SAHEL algorithm
[X_optimum,F_optimum,misc] = SC_SAHEL(lb,ub,MaxFcal,ObjFun,...
    'EAs',{'FL','DEF','MCCE','GWO'},'NumOfComplex',8,'Parallel',true,...
    'ReSamp',true);
% Plot the performance of the SC-SAHEL algorithms
Plot_SC_SAHEL(misc)
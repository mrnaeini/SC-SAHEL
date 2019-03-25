function [CX,FX,EMP,fcal] = Evol(CX,FX,X_best,F_best,EAs,EA_select,EvolStep,ObjFun,BoundHand,Data,DimRest,ReSamp,Parallel)
% The evol function evolve each complex based on the selected evolutionary
% methods
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
% CX is the matrix of partitioned sampled (3D matrix)
% FX is the samples objective function values
% X_best is the best point found so far
% F_best is the current best point objective function value
% EAs is the list of evolutionary method
% EA_select is the list of the selected evolutionary methods
% EvolStep is the number of evolution steps allowed for each complex
% fobj is the objective function handle
% BoundHand is the boundary handling function
% Data is the observed data required for calculating the objective function
% DimRest is the dimension degeneration control setting
% ReSamp is the gaussian resampling control setting
%% output
% CX is the evolved complexes
% FX is the evolved samples objective function
% EMP is the criteria for measuring performance of the evolutionary methods 
% fcal is the number of function evaluation
%% Evolution
% Get the dimension of complexes
[NumOfComplex,ComplexSize,dim] = size(CX);          
% Assign memory for function evaluation counter
fc = zeros(1,NumOfComplex);
% Evolve each complex independently
% Assign memory for EMP (Evolutionary Methods Performance Criteria)
EMP = nan(1,NumOfComplex);
% Start Evolution
% Control if parallel setting is selected
if Parallel
    parfor i = 1:NumOfComplex
        % Get the complex
        Xd = reshape(CX(i,:,:),ComplexSize,dim);
        Fd = FX(i,:);
        % Check for dimension degeneration
        if DimRest
            % Check if the population degeneration occured
            [Xd,Fd,fc(i)] = DimensionRestore(Xd,Fd,BoundHand,ObjFun,Data);
        end
        % Evolve the complex using the selected method
        [XN,FN,fc(i)] = EAs(EA_select(i)).Fun(Xd,Fd,ObjFun,EvolStep,BoundHand,X_best,F_best,Data,fc(i));
        % Calculate the performance of the method for the complex
        % abs is removed from denominator to handle negetive objective
        % function values
        EMP(i) = (abs(mean(Fd))- abs(mean(FN)))/(mean(Fd));
        % Check the random sampliing setting
        if ReSamp
            [XN,FN,fc(i)] = GauSamp(XN,FN,BoundHand,fc(i),ObjFun,Data);
        end
        % Replace points into complexes
        CX(i,:,:) = XN;
        FX(i,:) = FN;
    end
else
    for i = 1:NumOfComplex
        % Get the complex
        Xd = reshape(CX(i,:,:),ComplexSize,dim);
        Fd = FX(i,:);
        % Check for dimension degeneration
        if DimRest
            % Check if the population degeneration occured
            [Xd,Fd,fc(i)] = DimensionRestore(Xd,Fd,BoundHand,ObjFun,Data);
        end
        % Evolve the complex using the selected method
        [XN,FN,fc(i)] = EAs(EA_select(i)).Fun(Xd,Fd,ObjFun,EvolStep,BoundHand,X_best,F_best,Data,fc(i));
        % Calculate the performance of the method for the complex
        % abs is removed from denominator to handle negetive objective function
        EMP(i) = (abs(mean(Fd))- abs(mean(FN)))/(mean(Fd));
        % Check the random sampliing setting
        if ReSamp
            [XN,FN,fc(i)] = GauSamp(XN,FN,BoundHand,fc(i),ObjFun,Data);
        end
        % Replace points into complexes
        CX(i,:,:) = XN;
        FX(i,:) = FN;
    end
end
% Get the number of function call
fcal = sum(fc);
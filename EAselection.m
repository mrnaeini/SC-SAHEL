function [EA_select,EApr] = EAselection(EvolNum,EA_select,EMP)
% Function for selecting evolutionary methods based on the previous
% performance
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
% EvolNum is the number of evolutionary methods
% NGS is the number of complexes
% EA_select is the selected evolutionary methods in the previous evolution
% EMP is the  criteria for measuring performance of the evolutionary methods
% EApr is the performance for previous shuffling step
%% Output
% EA_select the selected evolutionary methods for each complex
% EApr is the performance criteria for the current shuffling step
%% Method Selection
% Remove negative EMP values
EMP(EMP<0) = 0; EMP(isnan(EMP)) = 0;
% Check if this is the first iteration or if all the EAs have similar
% performance
if length(unique(EMP))==1
    EApr = zeros(1,EvolNum);
else
    EApr = nan(1,EvolNum);
    id = nan(1,EvolNum);
    % Check the performance of each method and count the number of
    % complexes assigned to each method
    for i = 1:EvolNum
        % Get the total number of complexes for each method
        id(i) = sum(EA_select == i);
        % Find the method
        EApr(i) = mean(EMP(EA_select == i));
    end
    % Sort the methods performance in decreasing order
    [~,idx] = sort(EApr,'descend');
    % Now the best method get extra complex and the worst method loose a
    % complex, if the worst method has only one complex, the second worst
    % method will loose one complex and so on
    for i = 1:EvolNum
        if id(idx(EvolNum-i+1)) > 1
            id(idx(EvolNum-i+1)) = id(idx(end-i+1)) - 1;
            id(idx(1)) = id(idx(1)) + 1;
            break
        end
    end
    % Now assign complexes based on the updated number
    count = 1;
    for i = 1:EvolNum
        for j = 1:id(i)
            EA_select(count) = i;
            count = count + 1;
        end
    end
end
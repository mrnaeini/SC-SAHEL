function Plot_SC_SAHEL(misc)
% This function generate two figures for the output of the SC-SAHEl
% framework. First, it generates a figure which shows the changes in the
% objective function value vs. the number of function evaluation at each
% optimization step. Second, it generates a figure which shows the number
% of complexes assigned to each optimization method, at each shuffling
% step.
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
figure(1); clf
% Make the figure full screen
set(gcf, 'Position', get(0, 'Screensize'));
% Plot improvement of objective function
plot(misc.FunCal,misc.BestF,'linewidth',2);
set(gca,'linewidth',1.2);
xlabel('Number of function evaluation','fontsize',14);
ylabel('Best objective function value','fontsize',14);
set(gca,'fontweight','bold');
% Plot the method selection
figure(2); clf
set(gcf, 'Position', get(0, 'Screensize'));
% Find the number of assigned complexes to each method
% first get the number of evolutionary methods
n = max(max(misc.EAselect));
% Assign memory for counter
count = nan(n,length(misc.EAselect));
for i = 1:length(misc.EAselect)
    for j = 1:n
        count(j,i) = sum(misc.EAselect(i,:) == j);
    end
end
% Plot the selected method for each shuffling step
for i = 1:n
    plot(count(i,:),'linewidth',2); hold on
end
set(gca,'linewidth',1.2);
xlabel('Shuffling step','fontsize',14);
ylabel('Number of Complexes assigned to EAs','fontsize',14);
legend(misc.EAs);
set(gca,'fontweight','bold');
xlim([1,length(misc.EAselect)]);
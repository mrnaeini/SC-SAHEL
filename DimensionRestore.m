function [Snew,Sfnew,fc]=DimensionRestore(S,Sf,bh,fobj,Data)
% Function for finding and restoring the lost dimensions. This function is
% developed by Dr. Wei Chu, 2012
%
% References:
% - Chu, Wei, Xiaogang Gao, and Soroosh Sorooshian. "A new evolutionary 
% search strategy for global optimization of high-dimensional problems." 
% Information Sciences 181, no. 22 (2011): 4909-4927.
% - Chu, Wei, Xiaogang Gao, and Soroosh Sorooshian. "Improving the shuffled 
% complex evolution scheme for optimization of complex nonlinear 
% hydrological systems: Application to the calibration of the Sacramento 
% soil moisture accounting model." Water Resources Research 46, no. 9(2010).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by Matin Rahnamay Naeini. Last modified on January-2018
% Email: rahnamam@uci.edu
%
% Please reference to:
% Matin Rahnamay Naeini, Tiantian Yang, Mojtaba Sadegh, Amir Aghakouchak,
% Kuo-lin Hsu, Soroosh Sorooshian, Qingyun Duan, and Xiaohui Lei. "Shuffled 
% complex-self adaptive hybrid evolution (SC-SAHEL) optimization
% framework." Environmental Modelling & Software, 104:215 - 235, 2018.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% S is the complex samples
% Sf is the complex samples objective function values
% bh is the boundary handling strucutre
% fobj is the objective function, function handle
% Data is the required data for calculating the objective function value
% Output
% Snew restored complex
% Sfnew restored complex objective function values
% fc is the number of function evaluation counter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the function evaluation counter to zero
fc = 0;
% Get the dimension of the complex
[N,Dim] = size(S);
% Store the complex samples and objective function values
Snew=S;
Sfnew=Sf;
% Find the mean and standard deviation of the points in the complex
Nmean=mean(S);
Nstd=std(S);
% If standard deviation is zero return 
if any(Nstd == 0)
    warning('One of the dimensions has zero standard deviation');
    return
end
% Normalize the samples
a = S';
for i = 1:Dim
    a(i,:) = (a(i,:) -Nmean(i)) /Nstd(i);
end
r = max(max(a) -min(a));
% Peform Principal Component Analysis
c = (a*a')/N;
[v,d] = eig(c);
d = diag(d);
vtemp = v;
dtemp = d;
for i = 1:Dim
    v(:,i) = vtemp(:,Dim-i+1);
    d(i) = dtemp(Dim-i+1);
end
d = d./sum(d);
% Find the number of lost dimensions.  A lost diemnsion is defined as a
% dimension that has a relative variances less than one percent of the
% total variance divided by the dimensionality.
lastdim = find(d > (0.01/Dim),1,'last');
nlost = Dim-lastdim; 
% If the number of the lost dimensions is greater than one-tenth of the total
% dimensionality, restore the lost dimensions.
if nlost > floor(Dim/10)+1 
    for i = lastdim+1:Dim
        stemp = ((randn+2)*r*v(:,i))';
        % Restore the lost dimension
        stemp = stemp.*Nstd + Nmean;
        % Boundary handling
        if any(stemp > bh.ub) || any(stemp < bh.lb)
            stemp = bh.fun(stemp,bh.lb,bh.ub);
        end
        % Calculate the objective function value for the new point
        ftemp=fobj(stemp,Data); 
        % Update the number of function evaluation counter
        fc=fc+1;
        if ftemp > max(Sfnew)
            % If the new point is worst than the worst point in the complex
            % generate another point
            stemp = ((randn-2)*r*v(:,i))';
            stemp = stemp.*Nstd + Nmean;
            % Boundary handling
            if any(stemp > bh.ub) || any(stemp < bh.lb)
                stemp = bh.fun(stemp,bh.lb,bh.ub);
            end
            % Calculate the objective function value for the new point
            ftemp=fobj(stemp,Data); 
            % Update the number of function evaluation counter
            fc=fc+1;
        end
        if ftemp < max(Sfnew)
            Snew(N,:)=stemp;
            Sfnew(N)=ftemp;
            [Sfnew,idx]=sort(Sfnew);
            Snew=Snew(idx,:);
        end
    end
end
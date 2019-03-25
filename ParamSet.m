function [opt] = ParamSet(lb,ub,MaxFcal,ObjFun,settings)
% Function for controlling the settings of the algorithm and setting the
% algorithms default values. For information on the settings and default
% values please refer to the algorithm manual.
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
% Generate all the necessary variables
% Control the number inputs
if nargin < 4
    error('Please provide the required inputs!')
end
% Set the algorithm default
opt.lb = lb;                                          % Parameters lower bounds
opt.ub = ub;                                          % Parameters upper bounds
opt.dim = length(lb);                                 % Dimension of the problem
opt.MaxFcal = MaxFcal;                                % Maximum number of function evaluation
opt.ObjFun = str2func(ObjFun);                        % Objective function name
opt.NumOfComplex =  4;                                % Number of complexes (Optional)
opt.ComplexSize = 2*opt.dim+1;                        % Number of points in each complex (Optional)
opt.PopSize = opt.NumOfComplex*opt.ComplexSize;       % Population size
opt.EvolStep = max(opt.dim+1,10);                     % Number of evolution for each complex before shuffling (Optional)
opt.EAs = {'MCCE','CCE'};                             % List of evolutionary methods (Optional)
opt.NumEAs = length(opt.EAs);                         % Number of evolutionary methods
opt.SampMethod = 'LHsamp';                            % Initial sampling method (Optional)
opt.BoundHand = 'ReflectBH';                          % Boundary handling function (Optional)
opt.Parallel = false;                                 % Parallel computing (Optional)
opt.DimRest = true;                                   % Check for degeneration (Optional)
opt.ReSamp = false;                                   % Enable gaussian resampling (Optional)
opt.StopSP = 1e-7;                                    % Stopping Criteria the range of variables span the search space (Optional)
opt.StopStep = 50;                                    % Number of steps for evaluating the stopping criteria (Optional)
opt.StopIMP = 0.1;                                    % Stopping Criteria minimum objective function improvement in last m steps (Optional)
opt.Data = [];                                        % The input data for the objective function
% Set the algorithms defaults
for i = 1:2:length(settings)
    if isfield(opt,settings{i})
        opt.(settings{i}) = settings{i+1};
        if strcmp(settings{i},'EvolMethod') && ~any(ismember(settings,'NumOfComplex'))
            opt.NumOfComplex = 2*length(settings{i+1});
        end
    else
        msg = ['Setting "',settings{i},'" is not a valid setting! Please refer to the manual for the settings!'];
        error(msg)
    end
end
% Generate function handles for evolutionary methods
for i = 1:length(opt.EAs)
    opt.EA(i).Fun = str2func(opt.EAs{i});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now control the settings
% Make lower and upper bound a column vector
opt.lb = lb(:);
opt.ub = ub(:);
% Control the settings which are not optional
if isempty(opt.lb) || isempty(opt.ub)
    error('Parameters lower and upper bound should be provided!')
end
if ~isvector(opt.lb) || ~isvector(opt.ub)
    error('Parameters lower and upper bound should be a vector!')
end
if length(opt.lb)~=length(opt.ub)
    error('Lower and upper bound vector should have same dimension!')
end
if any(opt.lb==opt.ub)
    error('Lower and upper bound should have different values!')
end
if any(opt.lb > opt.ub)
    error('Lower bound should be smaller than the upper bound!')
end
if isempty(opt.MaxFcal)
    error('The maximum number of function evaluation is not specified!')
end
if isempty(opt.ObjFun)
    error('Objective function is not defined!')
end
% Control the Number of Complexes and the number of Evolutionary methods
if ~~mod(opt.NumOfComplex,length({opt.EAs}))
    error('Number of complexes should be proportional to the number of evolutionary methods!')
end
% Control the logical variables
if ~islogical(opt.Parallel) 
    error('The parallel setting should be true or false!')
end
if ~islogical(opt.DimRest)
    error('The DimRest setting should be true or false!')
end
if ~islogical(opt.ReSamp)
    error('The DimRest setting should be true or false!')
end
% Control the initial sampling and boundary handling settings
if ~exist(opt.SampMethod,'file')
    error('Initial sampling function is missing!')
end
if ~exist(opt.BoundHand,'file')
    error('Boundary handling function is missing!')
end
% Control the stopping criteria
if floor(opt.StopStep) ~= opt.StopStep
    error('StopStep should be integer!')
end
% Define other settings
opt.EvolNum = length(opt.EAs);
opt.PopSize = opt.NumOfComplex*opt.ComplexSize;
opt.NumEAs = length(opt.EAs);
% Define function handles
opt.SampMethod = str2func(opt.SampMethod);
opt.bh.fun = str2func(opt.BoundHand);
opt.bh.lb = lb;
opt.bh.ub = ub;
% Check if parallel is supported
if ~license('test','Distrib_Computing_Toolbox') && opt.Parallel 
    opt.Parallel = false;
    warning('Parallel computation is not available for your system!')
end
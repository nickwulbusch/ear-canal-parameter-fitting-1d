function options = setParameterFittingOptions(scenario)
%
% Set options for the parameter fitting. Add another case for different
% settings.
%
% SYNTAX:
%   options = setParameterFittingOptions(scenario)
% 
% DESCRIPTION:
% - options = setParameterFittingOptions(scenario) sets options according
% to scenario defined below
% 
% INPUTS:   - scenario: integer value
% 
% OUTPUTS:  - options: struct with fieldnames
%                 'nRuns' - number of runs during parameterization (i.e.,
%                 how many different initial parameter sets)
%                 'nIterations' - number of restarts + 1
%                 'nGeoVar' - number of sine and cosine summands in area
%                 function expansion
%                 'costFunction' - struct with fielnames
%                        'type' - type of cost function, as defined in
%                        computeJ.m
%                        'weights' - weights belonging to type
%                 'estimateL' - 1, if length of ear canal should not be
%                 estimated for the initialization
%                 'initParameters' - basic parameter values
%                 'LB' - lower bounds for parameter during fitting
%                 'UB' - upper bounds for parameters during fitting
%                 'minS' - minimal allowed area function value without
%                 penalization
%                 'minSpenalty' - coefficient for penalization
%                 'EDareaFromMin' - maximum difference allowed for eardrum
%                 area with respect to minimum of area function
%                 'EDareaFromMinPenalty' - coefficient for penalization
%                 'numel' - struct regarding number of elements in discretization with field names
%                         'type' - type as defined in getNumel.m
%                         'coeff' - corresponding coefficient
%                 'freqIndex' - indices of freq vector that should be used
%                 during the parameter fitting
%                 'maxFreq' - 1 if additionally maximum and minimum
%                 frequencies of input impedance should be added to
%                 freqIndex
%                 'optionsFminsearch' - struct regarding the options of the Nelder-Mead
%                 algorithm with fieldnames
%                         'MaxIter' - maximum number of iterations
%                         'MaxFunEvals' - maximum number of function evaluations
%
% 
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --
switch scenario
    case 1 % Standard options

        % Number of runs, i.e., different starting parameter sets
        options.nRuns = 1; 

        % Number of iterations, e.g., 4 means three restarts for the
        % Nelder-Mead optimization
        options.nIterations = 4;
        
        % Number of Fourier coefficients
        options.nGeoVar = 4;
      
        % Type of cost functional
        options.costFunction.type = 'coupled';
        options.costFunction.weights = [10,1];

        % 1, if length of ear canal should be estimated from first maximum
        % in the data
        options.estimateL = 1;

        % initial parameter pairs, variation and bounds
        V0 = pi*(2.5e-3)^2*4e-3/3;
        options.initParameters = [6e-5,30e-3,2e-6,zeros(1,2*options.nGeoVar-1),161,20,1.2,1.2,900,4000,V0];
        options.initVaration = 0.25;
        geoBounds = 1./2.^(0:options.nGeoVar-1)*1e-5*2;
        options.LB = [1e-5,15e-3,-geoBounds,-geoBounds,50,0,0.3,0.3,500,2500,V0/2];
        options.UB = [2e-4,45e-3,geoBounds,geoBounds,200,40,10,10,2500,6000,V0*2];

        % penalizations values
        options.minS = 1e-5;
        options.minSpenalty = 1e4;
        options.EDareaFromMin = 0;
        options.EDareaFromMinPenalty = 1e4;

        % number of elements for the discretization, see getNumel()
        options.numel.type = 'L/lambda^2';
        options.numel.coeff = 4;

        % set frequency/data indices that should be used during the fitting
        % the template setting uses logarithmic distributed frequencies
        % up to 10 kHz if data consists of 100,200,300,...,10000 Hz (or
        % higher)
        options.freqIndex = unique([1,ceil(1.2.^(1:25)),100]);

        % maximum frequency for the case if characteristic frequencies
        % should be added
        options.maxFreq = 10000;
        
        % options for the Nelder-Mead optimization
        options.optionsFminsearch.MaxIter = 1000;
        options.optionsFminsearch.MaxFunEvals = 1000;
end
end

%--------------------License ---------------------------------------------
% Copyright (C) 2023  Nick Wulbusch
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.
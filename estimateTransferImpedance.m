function result = estimateTransferImpedance(data,options)
%
% Parameter fitting to estimate transfer impedance
%
% SYNTAX:
%   result = estimateTransferImpedance(data,options)
% 
% DESCRIPTION:
% result = estimateTransferImpedance(data,options) starts parameter fitting
% with respect to data and options
% 
% INPUTS:   - data: (measured) input impedance
%           - options: struct with fieldnames
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
% 
% OUTPUTS:  - result: struct with results after parameter fitting with fieldnames
%                 'Ztr' - transfer impedance, Pa s/m^3 
%                 'Zin' - input impedance, Pa s/m^3 
%                 'S' - area function as function handle, m^2
%                 'ZED' - eardrum impedance (without lumped compliance), Pa s/m^3
%                 'Zvol' - volume impedance resulting from the cone, Pa s/m^3
%                 'Zd' - ZED and Zvol in parallel, Pa s/m^3
%                 'L' - length of ear canal, m
%                 'V' - volume of cone, m^3
%
% 
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --

% parameter fitting for given data and settings
run = parameterFitting(options,data.freq,data.Zin);

% compute transfer impedance Ztr, area function S and ear drum impedance
% ZED from fitted parameters
Ztr = cell(options.nRuns,1); Zin = Ztr; S = Ztr; ZED = Ztr; Zd = Ztr; Zvol = Ztr;
for r=1:options.nRuns
    [Ztr{r},Zin{r},S{r},ZED{r},Zd{r},Zvol{r},J] = computeInputAndTransferImpedance(data.freq,run.parameter{r}(end,:),options,data);
end
[~,index] = min(J);
result.Ztr = Ztr{index};
result.Zin = Zin{index};
result.S = S{index};
result.ZED = ZED{index};
result.Zd = Zd{index};
result.Zvol = Zvol{index};
result.L = run.parameter{index}(end,2);
result.V = run.parameter{index}(end,end);

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
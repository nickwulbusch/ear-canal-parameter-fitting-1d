function run = parameterFitting(options,freq,data)

% Parameter fitting for given options
%
% SYNTAX:
%   run = parameterFitting(options,freq,data)
% 
% DESCRIPTION:
%   run = parameterFitting(options,freq,data) fits parameter of area function and eardrum impedance
%   based on options, freq and data 
% 
% INPUTS:   - options: struct with fieldnames
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
%           - freq: frequency set, Hz
%           - data: corresponding data set, i.e., (measured) input
%               impedance, Pa s/m^3
%
% OUTPUTS:  - numel: number of elements, i.e., intervals for discretization
%
%
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --

            run.freq = freq;
            run.data = data;
                [fi] = getFrequencies(run.freq,run.data);
                fi = fi(freq(fi)<options.maxFreq);
                options.freqIndex = unique([options.freqIndex,fi]);

            if options.estimateL == 1
                estL = estimateLengthFromData(run.freq,run.data);
                options.initParameters(2) = estL;
            else
                estL = 0;
            end

            parsave = cell(options.nRuns,1);
            J = zeros(options.nRuns,1);

            for r=1:options.nRuns % use parfor for faster parallel computation
                temprun = run;
                optionstemp = options;
                x0 = options.initParameters .* (1+(2*rand(size(options.initParameters))-1)*options.initVaration);
                if options.estimateL == 1
                    x0(2) = estL;
                    optionstemp.LB(2) = estL-3e-3;
                    optionstemp.UB(2) = estL+1e-3;
                end
                parsave{r}(1,:) = x0;
                for j=1:options.nIterations
                        tic
                        [parsave{r}(j+1,:),J(r)] = opt(temprun.freq(options.freqIndex),temprun.data(options.freqIndex),optionstemp,parsave{r}(j,:));
                end
                
            end
            run.J = J;
            run.parameter = parsave;
end


function [x,J] = opt(freq,data,options,x0)

optionsFminsearch = optimset('fminsearch');
optionsFminsearch.MaxIter = options.optionsFminsearch.MaxIter;
optionsFminsearch.MaxFunEvals = options.optionsFminsearch.MaxFunEvals;
f = @(x) computeJ(x,options,'data',data,'freq',freq);
[x,~,~,~] = fminsearchbnd(f,x0,options.LB(1:length(x0)),options.UB(1:length(x0)),optionsFminsearch);
J = f(x);

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
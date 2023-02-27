function numel = getNumel(model,options)

% Determine number of elements used in the discretization
%
% SYNTAX:
%   numel = getNumel(model,options)
% 
% DESCRIPTION:
%   numel = getNumel(model,options) determines number of elements used in the discretization
% 
% INPUTS:   - model: struct with parameters needed to solve the horn
%                   equation
%                 'parameter' - struct with additional parameters
%                       'f' -
%                       'omega' -
%                       'c' - 
%                       'rho' - 
%                       'wavelength' -
%                       'Z' - 
%                       'k' - 
%                       'q' - volume velocity
%                       'L' - length of ear canal
%                 'numEl' - input impedance, Pa s/m^3 
%                 'nodes' - area function as function handle, m^2
%                 'numVert' - eardrum impedance (without lumped compliance), Pa s/m^3
%                 'elements' - volume impedance resulting from the cone, Pa s/m^3
%                 'a' - coefficient in PDE
%                 'b' - coefficient in PDE
%                 'c' - coefficient in robin boundary condition of PDE
%                 'f' - right-hand-side of PDE
%                 'g' - right-hand-side of neumann boundary condition of
%                 PDE
%                 'h' - right-hand-side of robin boundary condition of  PDE
%                 'rnodes' - index of robin nodes
%                 'nnodes' - index of neumann nodes
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
% OUTPUTS:  - numel: number of elements, i.e., intervals for discretization
%
%
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --

if strcmp(options.numel.type,'L/lambda^2')
    numel = options.numel.coeff * ceil(model.parameter.L/model.parameter.wavelength^2);
else
    numel = 120;
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
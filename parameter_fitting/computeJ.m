function y = computeJ(P,options,varargin)

% Computes cost function using equation (16), and therefore (2), (14), (15), in [1]
%
% SYNTAX:
%   y = computeJ(P,options,'data',data,'freq',freq)
% 
% DESCRIPTION:
%   y = computeJ(P,options,'data',data,'freq',freq) compute cost function
%   for given frequency set and corresponding data
% 
% INPUTS:   - P: parameter set describing area function and eardrum
%               impedance
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
%           - data: data set
%           - freq: corresponding frequency set
%
% OUTPUTS:  - y: cost function for given data and frequency set
%
% REFERENCES:
% [1] Nick Wulbusch et al. (2023), "Using a one-dimensional finite-element
% approximation of Webster's horn equation to estimate individual ear canal
% acoustic transfer from input impedances", JASA
%
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --
parser = inputParser;
addParameter(parser,'data',[]);
addParameter(parser,'freq',[]);
parse(parser,varargin{:});

data = parser.Results.data;
freq = parser.Results.freq;

switch options.costFunction.type
    case 'coupled'
        A = options.costFunction.weights(1);
        B = options.costFunction.weights(2);
        
        J = @(p) sum(A*log10(abs(p./data)).^2+B*abs(atan2(imag(p).*real(data)-imag(data).*real(p),...
            real(p).*real(data)+imag(p).*imag(data))).^2);
end

index.A0 = 1;
index.L = 2;
index.c = 2+(1:options.nGeoVar);
index.s = 2+options.nGeoVar+(1:options.nGeoVar);
index.Z = 2+2*options.nGeoVar+(1:2);
index.Q = 2+2*options.nGeoVar+2+(1:2);
index.f = 2+2*options.nGeoVar+4+(1:2);
index.V = 2+2*options.nGeoVar+6+1;

y = zeros(length(freq),1);
for fk=1:length(freq)
    Zdrum = computeImpedanceDrumTwoRes(P(index.Z),P(index.f),P(index.Q),2*pi*freq(fk));
    Zvol = computeImpedanceVolume(P(index.V),freq(fk));
    Zd = computeImpedance(Zdrum,Zvol);
    model = modelSetup(freq(fk),P(index.A0),P(index.L),P(index.c),P(index.s),Zd,options);
    matrices = assembleMatrices(model);
    u = solvepde(matrices);
    y(fk) = u(1)/model.parameter.q;
end
y = J(y);

%%% Penalty for very small area function
tt = linspace(0,P(index.L),100);
if min(model.a(tt))<options.minS
    y = y + options.minSpenalty*abs(min(model.a(tt))-options.minS)/options.minS;
end


%%% Penalty if area function increases largely in the end
tt = linspace(0,P(index.L),100);
if min(model.a(tt))<model.a(tt(end))-options.EDareaFromMin
    y = y + options.EDareaFromMinPenalty*abs(min(model.a(tt))-model.a(tt(end))-options.EDareaFromMin)/abs(min(model.a(tt)));
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
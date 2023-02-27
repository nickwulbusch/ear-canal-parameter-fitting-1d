function [Ztr,Zin,S,ZED,Zd,Zvol,varargout] = computeInputAndTransferImpedance(freq,parameter,options,varargin)

% Compute input impedance, transfer impedance, area function and eardrum
% impedance from results from the parameter fitting
% SYNTAX:
%   [Ztr,Zin,S,ZED,Zd,Zvol] = computeInputAndTransferImpedance(freq,parameter,options)
%   [Ztr,Zin,S,ZED,Zd,Zvol,J] = computeInputAndTransferImpedance(freq,parameter,options,data)
% 
% DESCRIPTION:
% [Ztr,Zin,S,ZED,Zd,Zvol] = computeInputAndTransferImpedance(freq,parameter,options) 
% computes input impedance, transfer impedance, area function and eardrum
% impedance from results from the parameter fitting with respect to data and options
% [Ztr,Zin,S,ZED,Zd,Zvol,J] = computeInputAndTransferImpedance(freq,parameter,options,data) 
% additionally computes cost function. For this data must fit to
% frequencies in freq.
% 
% INPUTS:   - freq: frequencies for which input impedance, transfer
%               impedance, area function and eardrum impedance shall be
%               computed, Hz
%           - parameter: results from parameter fitting
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
%           - data: input impedance data (for frequencies in freq)
%
% 
% OUTPUTS:  - result: struct with results after parameter fitting with fieldnames
%                 'Ztr' - transfer impedance, Pa s/m^3 
%                 'Zin' - input impedance, Pa s/m^3 
%                 'S' - area function as function handle, m^2
%                 'ZED' - eardrum impedance (without lumped compliance), Pa s/m^3
%                 'Zvol' - volume impedance resulting from the cone, Pa s/m^3
%                 'Zd' - ZED and Zvol in parallel, Pa s/m^3
%                 'J' - cost function
%
% 
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --
if nargin==4
    data = varargin{1};
end

S0 = parameter(1);
L = parameter(2);
c = parameter(2+(1:options.nGeoVar));
s = parameter(2+options.nGeoVar+(1:options.nGeoVar));

m = [1:length(c)]';
S = @(x) (S0+c*cos(m*pi*x/L)+s*sin(m*pi*x/L));

L0 = parameter(2+2*options.nGeoVar+(1:2));
Q = parameter(2+2*options.nGeoVar+2+(1:2));
f0 = parameter(2+2*options.nGeoVar+4+(1:2));
V = parameter(2+2*options.nGeoVar+6+1);

Zin = zeros(length(freq),1);
Ztr = Zin; ZED = Zin; Zvol = Zin; Zd = Zin;

for fk=1:length(freq)
    ZED(fk) = computeImpedanceDrumTwoRes(L0,f0,Q,2*pi*freq(fk));
    Zvol(fk) = computeImpedanceVolume(V,freq(fk));
    Zd(fk) = computeImpedance(ZED(fk),Zvol(fk));

    model=modelSetup(freq(fk),S0,L,c,s,Zd(fk),options);
    matrices = assembleMatrices(model);
    u = solvepde(matrices);
    Zin(fk) = u(1)/model.parameter.q;
    Ztr(fk) = u(end)/model.parameter.q;
end


if nargin==4
    A = options.costFunction.weights(1);
    B = options.costFunction.weights(2);
    J = @(Zin) sum(A*log10(abs(Zin./data.Zin)).^2+B*abs(atan2(imag(Zin).*real(data.Zin)-imag(data.Zin).*real(Zin),...
        real(Zin).*real(data.Zin)+imag(Zin).*imag(data.Zin))).^2);

    varargout{1} = J(Zin);
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
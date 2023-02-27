function Zvol = computeImpedanceVolume(V,f)

% Computes volume impedance Zvol using equation (7) in [1]
%
% SYNTAX:
%   Zvol = computeImpedanceVolume(V,f)
% 
% DESCRIPTION:
%   Zvol = computeImpedanceVolume(V,f)
% 
% INPUTS:   - V: volume of cone
%           - f: frequency
%
% OUTPUTS:  - Zvol: volume impedance Zvol, Pa s/m^3
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
    parameter.f = f;
    parameter.omega = 2*pi*parameter.f;
    parameter.c = 343;
    parameter.rho = 1.17;
    Zvol = parameter.rho*parameter.c^2./(1i*parameter.omega*V);

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
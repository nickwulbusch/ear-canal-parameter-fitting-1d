function ZED = computeImpedanceDrumTwoRes(L,f,Q,w)
% Computes ZED with two-resonator model (4) in [1]
%
% SYNTAX:
%   ZED = computeImpedanceDrumTwoRes(L,f,Q,w)
% 
% DESCRIPTION:
%   ZED = computeImpedanceDrumTwoRes(L,f,Q,w) computes ZED with two-resonator model (4) in [1]
% 
% INPUTS:   - L: impedance level at resonance (in dB re 1 Pa s/m^3)
%           - f: resonance frequency
%           - Q: quality factor
%           - w: angular frequency
%
% OUTPUTS:  - ZED: eardrum impedance (without lumped compliance), Pa s/m^3
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
if size(L,1)<size(L,2)
    L = L';
end
if size(f,1)<size(f,2)
    f = f';
end
if size(Q,1)<size(Q,2)
    Q = Q';
end
if length(L)>=2
    L(2) = L(1)+L(2);
end
v = w./(f*2*pi)-2*pi*f./w;
ZED = 1./(sum(1./(10.^(L/20).*(v*1i.*Q+1)),1));

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
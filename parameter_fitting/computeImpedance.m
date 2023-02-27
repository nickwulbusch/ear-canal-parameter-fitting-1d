function Zd = computeImpedance(ZED,Zvol)
% Computes eardrum impedance of ZED and Zvol in parallel
%
% SYNTAX:
%   Zd = computeImpedance(ZED,Zvol)
% 
% DESCRIPTION:
% Zd = computeImpedance(ZED,Zvol) computes eardrum impedance of ZED and Zvol in parallel
% 
% INPUTS:   - ZED: eardrum impedance (without lumped compliance), Pa s/m^3
%           - Zvol: volume impedance resulting from the cone, Pa s/m^3
% OUTPUTS:  - Zd: ZED and Zvol in parallel, Pa s/m^3
%
% 
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --
    Zd = ZED.*Zvol./(ZED+Zvol);

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
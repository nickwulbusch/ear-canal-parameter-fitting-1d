function fi = getFrequencies(freq,data)

% Add minimum and maximum frequencies to frequency set
%
% SYNTAX:
%   fi = getFrequencies(freq,data)
% 
% DESCRIPTION:
%   fi = getFrequencies(freq,data) adds minimum and maximum 
% frequencies (of input impedance) to frequency set
% 
% INPUTS:   - freq: frequency set, Hz
%           - data: corresponding data set, i.e., (measured) input
%               impedance, Pa s/m^3
%
% OUTPUTS:  - fi: indices of freq that correspond to maximum/minimum
%               frequency of abs(data)
%
%
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --

fi = [];
for k=2:length(freq)-1
    if abs(data(k-1))<abs(data(k)) && abs(data(k+1))<abs(data(k))
        fi = [fi,k];
    elseif abs(data(k-1))>abs(data(k)) && abs(data(k+1))>abs(data(k))
        fi = [fi,k];
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
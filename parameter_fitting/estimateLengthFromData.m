function L = estimateLengthFromData(freq,data)

% Estimates length of ear canal from first maximum in input impedance
%
% SYNTAX:
%   L = estimateLengthFromData(freq,data)
% 
% DESCRIPTION:
%   L = estimateLengthFromData(freq,data) estimates length of ear canal 
%       from first maximum in input impedance
% 
% INPUTS:   - freq: frequency set, Hz
%           - data: corresponding data set, i.e., (measured) input
%               impedance, Pa s/m^3
%
% OUTPUTS:  - L: estimated length, m
%
%
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --
    indexFreq = find(freq>=3000 & freq<=8000);
    [~,maxFreqIndex] = max(abs(data(indexFreq)));
    firstMaximum = freq(indexFreq(maxFreqIndex));
    L = 353.1/(firstMaximum*2);

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
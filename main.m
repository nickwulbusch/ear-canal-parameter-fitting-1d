addpath('parameter_fitting')
addpath('fe')
addpath('example_data')

load('IHA_database_subject_08_right_umbo_twoRes.mat');
% data.freq should be a column-vector of frequencies
% data.Zin should be a column-vector of input impedances

% Create own scenarios for other template settings in
% setParameterFittingOptions()

scenario = 1;
% assuming data.freq = 100:100:20000;
% if data.freq is different, change options.freqIndex accordingly

options = setParameterFittingOptions(scenario);
% up to 20 kHz:
% options.freqIndex = unique([1,ceil(1.2.^(1:29))]);
% options.maxFreq = 20000;

result = estimateTransferImpedance(data,options);

%% plot results, include reference if available
% plotResults(result,data,freq);
plotResults(result,data,data.freq,'reference',reference);

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
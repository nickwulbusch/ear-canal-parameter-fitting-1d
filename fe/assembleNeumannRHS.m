function G = assembleNeumannRHS(model)

% Assembles neumann right-hand-side vector
% SYNTAX:
%   G = assembleNeumannRHS(model)
% 
% DESCRIPTION:
% G = assembleNeumannRHS(model) assembles neumann right-hand-side vector
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
%
% 
% OUTPUTS: - G: neumann right-hand-side vector
%
% 
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --

G = zeros(length(model.nodes),1);
if isa(model.g,'function_handle')
    for i=1:size(model.nnodes,1)
        a = model.nodes(model.nnodes(i));
        G(model.nnodes(i)) = model.g(a);
    end
else
    for i=1:size(model.nnodes,1)
        G(model.nnodes(i)) = model.g;
    end
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
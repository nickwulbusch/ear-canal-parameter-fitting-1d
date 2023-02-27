function A = assembleStiffnessMatrix(model)
% Assembles stiffness matrix
% SYNTAX:
%  A = assembleStiffnessMatrix(model)
% 
% DESCRIPTION:
%  A = assembleStiffnessMatrix(model) assembles stiffness matrix
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
% OUTPUTS: - A: stiffness matrix 
%
% 
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --
if isa(model.a,'function_handle')
    h = diff(model.nodes);
    k = (model.a(model.nodes(2:end))+model.a(model.nodes(1:end-1))+4*model.a(0.5*model.nodes(2:end)+0.5*model.nodes(1:end-1)))/6;
    A = diag(-1./h.*k,-1)+ diag(-1./h.*k,1) + diag([0,1./h.*k] + [1./h.*k,0]);
else
    A = model.a* (diag(-1./diff(model.nodes),-1) + diag(-1./diff(model.nodes),1) + diag([0,1./diff(model.nodes)] + [1./diff(model.nodes),0]));
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
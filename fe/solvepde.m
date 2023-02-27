function u=solvepde(matrices)

% Computes finite element solution from matrices
% SYNTAX:
%   u=solvepde(matrices)
% 
% DESCRIPTION:
% u=solvepde(matrices) computes finite element solution from matrices
%
% INPUTS:   - matrices: struct with finite element matrices
%                 'A' - stiffness matrix
%                 'M' - mass matrix
%                 'B' - robin boundary matrix
%                 'F' - right hand side
%                 'G' - neumann right hand side
%                 'H' - robin right hand side
%
% 
% OUTPUTS: - u: finite element solution
%
% 
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --

u = (matrices.A+matrices.M+matrices.B)\matrices.G;
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
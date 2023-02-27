function M = assembleMassMatrix(model)

% Assembles mass matrix
% SYNTAX:
%   M = assembleMassMatrix(model)
% 
% DESCRIPTION:
% M = assembleMassMatrix(model) assembles mass matrix
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
% OUTPUTS: - M: mass matrix 
%
% 
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --

numEl = model.numEl;
if isa(model.b,'function_handle')
    ctr = 1;
    for i=1:numEl
        P = model.nodes(model.elements(i,:));
        h = abs(diff(P));
        bloc = model.b([P(1),(P(1)+P(2))/2,P(2)]);
        phi = [1,0.5,0;0,0.5,1];
        Mloc = 1/6*bloc(1)*phi(:,1)*phi(:,1)'+2/3*bloc(2)*phi(:,2)*phi(:,2)'+1/6*bloc(3)*phi(:,3)*phi(:,3)';
        Mval(ctr:ctr+3) = h*Mloc(:);
        I(ctr:ctr+3) = reshape(repmat(model.elements(i,1:2),2,1),1,4);
        J(ctr:ctr+3) = reshape(repmat(model.elements(i,1:2),1,2),1,4);
        ctr = ctr+4;
    end
    M = sparse(I,J,Mval);
else
    h = [0,diff(model.nodes),0];
    M = model.b * (1/3*diag(h(1:end-1)+h(2:end))+1/6*diag(h(2:end-1),-1)+1/6*diag(h(2:end-1),1));
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
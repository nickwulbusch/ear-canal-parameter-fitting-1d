function F = assembleRHS(model)


% Assembles right-hand-side vector
% SYNTAX:
%   F = assembleRHS(model)
% 
% DESCRIPTION:
%   F = assembleRHS(model) assembles right-hand-side vector
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
% OUTPUTS: - F: right-hand-side vector
%
% 
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --

numVert = model.numVert;
numEl = model.numEl;

if isa(model.f,'function_handle')
    F = zeros(numVert,1);
    
    wq = [1/6,2/3,1/6];
    xq = [0,0.5,1];
    for i=1:numEl
        P = model.nodes(model.elements(i,:));
        B = P(2)-P(1);
        
        floc = zeros(2,1);
        
        fq = model.f(xq*B+P(1));
        for k=1:length(wq)
            phi = [1-xq(k); xq(k)];
            floc = floc + wq(k) * fq(k)*phi;
        end
        F(model.elements(i,:)) = F(model.elements(i,:)) + abs(B)*floc;
    end
else
    F = zeros(numVert,1);
    for i=1:numEl
        a = model.nodes(model.elements(i,1));
        b = model.nodes(model.elements(i,2));
        B = abs(b-a);
        
        floc = B * model.f * [1;1]/2;
        F(model.elements(i,:)) = F(model.elements(i,:)) + floc(:);
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
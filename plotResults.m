function plotResults(result,data,freq,varargin)
%
% Plots input impedance, transfer impedance, area function and eardrum
% impedance of fitted parameters. If available also plots reference.
%
% SYNTAX:
%   plotResults(result,data,freq)
%   plotResults(result,data,freq,reference)
% 
% DESCRIPTION:
% - plotResults(result,data,freq) plots input impedance (result from parameter fitting and data), transfer impedance, area function and eardrum
% impedance of fitted parameters.
% - plotResults(result,data,freq,reference) additionally plots reference
% 
% INPUTS:   - result: struct with results after parameter fitting with fieldnames
%                 'Ztr' - transfer impedance, Pa s/m^3 
%                 'Zin' - input impedance, Pa s/m^3 
%                 'S' - area function as function handle, m^2
%                 'ZED' - eardrum impedance (without lumped compliance)
%                 'L' - length of ear canal, m
%                 'V' - volume of cone, m^3
%            - data: input impedance from measurements, Pa s/m^3
%            - freq: frequencies corresponding to measurements, Hz
%            - reference: struct with reference data (if available) with
%            fieldnames:
%                 Ztr - (measured) transfer impedance, Pa s/m^3 
%                 freq: frequencies corresponding to measurements, Hz
%                 ZED - eardrum impedance
%                 S - area function as vector, m^2
%                 x - corresponding axial distance
% 
% OUTPUTS:  - none
%
% 
% AUTHOR:   Nick Wulbusch
% DATE:     2023
% LICENSE:  see EOF

% CHANGELOG: --
    if nargin>3
        reference = varargin{1};
    end

    figure(1)
    sgtitle('transfer impedance','fontsize',20)
    subplot(2,1,1);
    loglog(freq,20*log10(abs(result.Ztr)),'linewidth',2);
    if isfield(reference,'Ztr')
        hold on
        loglog(reference.freq,20*log10(abs(reference.Ztr)),'--','linewidth',2);
        hold off
    end
    xlabel('frequency [Hz]')
    ylabel({'magnitude in';'dB re 1 $$\rm{Pa}\cdot \rm{s/m}^3$$'},'interpreter','latex')
    set(gca,'FontSize',15);
    grid on
    subplot(2,1,2);
    semilogx(freq,angle(result.Ztr),'linewidth',2);
    if isfield(reference,'Ztr')
        hold on
        loglog(reference.freq,angle(reference.Ztr),'--','linewidth',2);
        hold off
        legend({'result','reference'},'location','northwest');
    end
    ylim([-pi,pi])
    yticks([-pi,-pi/2,0,pi/2,pi])
    yticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'})
    xlabel('frequency [Hz]')
    ylabel('phase in rad')
    set(gca,'FontSize',15);
    grid on
    set(gcf,'Position',[100,700,700,550])

    figure(2)
    sgtitle('input impedance','fontsize',20)
    subplot(2,1,1);
    loglog(freq,20*log10(abs(result.Zin)),'linewidth',2);
    hold on
    loglog(data.freq,20*log10(abs(data.Zin)),'--','linewidth',2);
    hold off
    xlabel('frequency [Hz]')
    ylabel({'magnitude in';'dB re 1 $$\rm{Pa}\cdot \rm{s/m}^3$$'},'interpreter','latex')
    set(gca,'FontSize',15);
    grid on
    subplot(2,1,2);
    semilogx(freq,angle(result.Zin),'linewidth',2);
    hold on
    loglog(data.freq,angle(data.Zin),'--','linewidth',2);
    hold off
    ylim([-pi,pi])
    yticks([-pi,-pi/2,0,pi/2,pi])
    yticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'})
    xlabel('frequency [Hz]')
    ylabel('phase in rad')
    legend({'result','data'},'location','northwest')
    set(gca,'FontSize',15);
    grid on
    set(gcf,'Position',[800,700,700,550])
    
    figure(3)
    sgtitle('area function','fontsize',20)
    x = linspace(0,result.L);
    plot(x,result.S(x),'linewidth',2);
    hold on
    h = 3*result.V/result.S(result.L);
    plot([result.L,result.L+h],[result.S(result.L),0],'k:');
    hold off
    if isfield(reference,'S')
        hold on
        if isa(reference.S,'function_handle')
            plot(x,reference.S(x));
        else
            plot(reference.x,reference.S,'--','linewidth',2);
        end
        hold off
        legend({'result','cone','reference'},'location','northeast')
    end
    xlabel('axial distance [m]')
    ylabel('area [m^{2}]')
    set(gca,'FontSize',15);
    XL = get(gca,'xlim');
    xlim([0,XL(2)]);
    YL = get(gca,'ylim');
    ylim([0,YL(2)]);
    grid on
    set(gcf,'Position',[100,50,700,550])

    figure(4)
    sgtitle('ear drum impedance','fontsize',20)
subplot(2,1,1);
    loglog(freq,20*log10(abs(result.ZED)),'LineWidth',2);
    if isfield(reference,'ZED')
        hold on
        if isa(reference.ZED,'function_handle')
            plot(freq,reference.ZED(freq));
        else
            plot(reference.freq,20*log10(abs(reference.ZED)),'--','linewidth',2);
        end
        hold off
        legend({'result','reference'},'location','north')
    end
    xlabel('frequency [Hz]');
    ylabel({'magnitude in';'dB re 1 $$\rm{Pa}\cdot \rm{s/m}^3$$'},'interpreter','latex')
    set(gca,'FontSize',15);
    grid on
    subplot(2,1,2);
    semilogx(freq,angle(result.ZED),'LineWidth',2);
        if isfield(reference,'ZED')
        hold on
        if isa(reference.ZED,'function_handle')
            plot(freq,reference.ZED(freq));
        else
            plot(reference.freq,angle(reference.ZED),'--','linewidth',2);
        end
        hold off
    end
    ylim([-pi,pi])
    yticks([-pi,-pi/2,0,pi/2,pi])
    yticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'})
    xlabel('frequency [Hz]');
    ylabel('phase in rad');
    set(gca,'FontSize',15);
    grid on
    set(gcf,'Position',[800,50,700,550])
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
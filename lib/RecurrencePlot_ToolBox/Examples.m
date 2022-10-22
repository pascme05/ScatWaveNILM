% This file shows the examples to use the tool box of recurrence plot and
% recurrence quantification analysis

% If you find this toolbox useful, please cite the following paper:
% [1]	H. Yang, “Multiscale Recurrence Quantification Analysis of Spatial Vectorcardiogram (VCG)
% Signals,” IEEE Transactions on Biomedical Engineering, Vol. 58, No. 2, p339-347, 2011
% DOI: 10.1109/TBME.2010.2063704
% [2]	Y. Chen and H. Yang, "Multiscale recurrence analysis of long-term nonlinear and
% nonstationary time series," Chaos, Solitons and Fractals, Vol. 45, No. 7, p978-987, 2012
% DOI: 10.1016/j.chaos.2012.03.013

clear all
close all
clc


ecg = load('Ecgn.dat');

% mutual information test to determine the time delay
mutual(ecg);

% fnn test to determine the embedding dimension
out=false_nearest(ecg,1,10,8);
fnn = out(:,1:2);
figure('Position',[100 400 460 360]);
plt=plot(fnn(:,1),fnn(:,2),'o-','MarkerSize',4.5);
title('False nearest neighbor test','FontSize',10,'FontWeight','bold');
xlabel('dimension','FontSize',10,'FontWeight','bold');
ylabel('FNN','FontSize',10,'FontWeight','bold');
get(gcf,'CurrentAxes');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
grid on;

% phase space plot
y = phasespace(ecg,3,8);
figure('Position',[100 400 460 360]);
plot3(y(:,1),y(:,2),y(:,3),'-','LineWidth',1);
title('EKG time-delay embedding - state space plot','FontSize',10,'FontWeight','bold');
grid on;
set(gca,'CameraPosition',[25.919 27.36 13.854]);
xlabel('x(t)','FontSize',10,'FontWeight','bold');
ylabel('x(t+\tau)','FontSize',10,'FontWeight','bold');
zlabel('x(t+2\tau)','FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');

% color recurrence plot
cerecurr_y(y);
recurdata = cerecurr_y(y);

% black-white recurrence plot
tdrecurr_y(recurdata,0.3);
recurrpt = tdrecurr_y(recurdata,0.3);

%Recurrence quantification analysis
% rqa_stat - RQA statistics - [recrate DET LMAX ENT TND LAM TT]
rqa_stat = recurrqa_y(recurrpt)



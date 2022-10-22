%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Scattered NILM for device classification                         %
% Topic: Energy Disaggregation                                            %
% File: start                                                             %
% Date: 26.06.2022                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear variables
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('data')
addpath('doc')
addpath('fnc')
addpath('lib')
addpath('mdl')
addpath('results')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Experiment 
%---------------------------------------------------
setupExp.name = 'Test';                                                     % name of the experiment
setupExp.kfold = 10;                                                        % number of k data splits
setupExp.perVal = 0.1;                                                      % percentage of validation data
setupExp.perTest = 0.1;                                                     % percentage of test data (if kfold == 1)

%---------------------------------------------------
% Data 
%---------------------------------------------------
setupData.name = 'plaid2017_05sec';                                         % name of the dataset
setupData.fs = 30000;                                                       % sampling frequency data (Hz)
setupData.fel = 60;                                                         % electrical frequency data (Hz)
setupData.time = 1/12;                                                      % length of data snapshot in (sec)
setupData.limit = 1793;                                                     % number of data snapshots
setupData.app = ['AC','CFL','FAN','FRI','HDR', ...
                 'HEA','ILB','LAP','MIC','VAC','WM'];                       % list of the number of appliances ()
setupData.norm = [60, 180];                                                 % normalization of current (I) and voltage (V)

%---------------------------------------------------
% Model 
%---------------------------------------------------
setupMdl.dim = '2D';                                                        % select 1D or 2D model
setupMdl.name = 'CNN';                                                      % model name (ML: SVM, RF, KNN / DL: CNN, LSTM)
setupMdl.opti = 1;

%---------------------------------------------------
% Parameter 
%---------------------------------------------------
setupPara.down = 10;                                                        % integer factor downsampling
setupPara.filt = "none";                                                    % filter for pre-processing
setupPara.filtLen = 10;                                                     % length of the filter (samples)
setupPara.fryze = 0;                                                        % Pre-processing according to fryze power theorem
setupPara.feat = 'I';                                                       % 1D Features: 'I' (raw current), 'FFT' (current frequency domain) / 2D Features: 'VI' (voltage current trajectory), 'PQ' (active-reactive power plane), 'DFIA' (double Fourier integral analysis)
setupPara.fmax = 25;                                                        % maximum number of harmonics
setupPara.scat = 0;                                                         % 0) no scattering, 1) using scattering

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(setupData.name)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Start Main Script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Single Run 
%---------------------------------------------------
if setupMdl.name == "SVM" || setupMdl.name == "KNN" || setupMdl.name == "RF"
    [ACC_maj, F1_maj, ACC_min, F1_min] = main(data, labelsChr, classesChr, setupExp, setupData, setupMdl, setupPara);
else
    [ACC_maj, F1_maj, ACC_min, F1_min] = main(data, labelsNum, classesNum, setupExp, setupData, setupMdl, setupPara);
end

% %---------------------------------------------------
% % Opti 
% %---------------------------------------------------
% for i = 1:10
%     % Parameter (add here any parameter you want to change)
% 
%     % Run
%     if setupMdl.name == "SVM" || setupMdl.name == "KNN" || setupMdl.name == "RF"
%         [ACC_maj, F1_maj, ACC_min, F1_min] = main(data, labelsChr, classesChr, setupExp, setupData, setupMdl, setupPara);
%     else
%         [ACC_maj, F1_maj, ACC_min, F1_min] = main(data, labelsNum, classesNum, setupExp, setupData, setupMdl, setupPara);
%     end
% 
%     % Results
%     ACC_maj_total(i) = ACC_maj;
%     F1_maj_total(i) = F1_maj;
%     ACC_min_total(i) = ACC_min;
%     F1_min_total(i) = F1_min;
% end
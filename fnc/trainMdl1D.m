%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Scattered NILM for device classification                         %
% Topic: Energy Disaggregation                                            %
% File: trainMdl1D                                                        %
% Date: 26.06.2022                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mdl] = trainMdl1D(XTrain, yTrain, XTest, yTest, XVal, yVal, classes, setupMdl, setupExp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
options = statset('UseParallel',true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Data
%---------------------------------------------------
if setupExp.kfold == 1
    X = XTrain;
    y = yTrain;
else
    X = [XTrain; XTest];
    y = [yTrain; yTest];
end

%---------------------------------------------------
% Init Mdl
%---------------------------------------------------
if setupMdl.name == "SVM"
    opt = templateSVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 2, ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);
elseif setupMdl.name == "KNN"
    opt = templateKNN(...
        "NumNeighbors",5,...
        "Standardize",true);
elseif setupMdl.name == "RF"
    opt = templateTree(...
        'Surrogate','on',...
        'MaxNumSplits',1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Standard
%---------------------------------------------------
if setupMdl.opti == 0
    mdl = fitcecoc(X, y, 'Learners', opt, ...
                   'Coding', 'onevsone', ...
                   'ClassNames', classes, ...
                   'Options',options);
end

%---------------------------------------------------
% Opti Parameter
%---------------------------------------------------
if setupMdl.opti == 1
    mdl = fitcecoc(X, y, 'Learners', opt, ...
    'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus', 'UseParallel',true, 'ShowPlots', false));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end
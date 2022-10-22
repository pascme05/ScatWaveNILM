%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Scattered NILM for device classification                         %
% Topic: Energy Disaggregation                                            %
% File: trainMdl1D                                                          %
% Date: 26.06.2022                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mdl] = trainMdl1D_NN(XTrain, yTrain, XTest, yTest, XVal, yVal, ~, setupMdl, ~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Data
%---------------------------------------------------
yTrain = categorical(yTrain);
XTrain = XTrain';
XTrain = num2cell(XTrain,1)';
% XTrain = permute(XTrain,[2 3 1]);
% XTrain = reshape(XTrain, size(XTrain,1), 1, 1, size(XTrain,3));

yTest = categorical(yTest);
XTest = XTest';
XTest = num2cell(XTest,1)';
% XTest = permute(XTest,[2 3 1]);
% XTest = reshape(XTest, size(XTest,1), 1, 1, size(XTest,3));

yVal = categorical(yVal);
XVal = XVal';
XVal = num2cell(XVal,1)';
% XVal = permute(XVal,[2 3 1]);
% XVal = reshape(XVal, size(XVal,1), 1, 1, size(XVal,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Parameters
%---------------------------------------------------
options = trainingOptions('adam', ...
                          'MaxEpochs',200,...
                          'InitialLearnRate',1e-4, ...
                          'Verbose',true, ...
                          'Plots','none', ...
                          'ExecutionEnvironment','gpu',...
                          'ValidationData',{XVal,yVal});

%---------------------------------------------------
% Model
%---------------------------------------------------
if setupMdl.name == "LSTM"
    layers = [ ...
    sequenceInputLayer(size(XTrain{1},1))
    lstmLayer(128,OutputMode="sequence")
    lstmLayer(256,OutputMode="last")
    fullyConnectedLayer(512)
    fullyConnectedLayer(512)
    fullyConnectedLayer(512)
    fullyConnectedLayer(length(unique(yTrain)))
    softmaxLayer
    classificationLayer];

elseif setupMdl.name == "CNN"

elseif setupMdl.name == "ANN"

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mdl = trainNetwork(XTrain,yTrain,layers,options);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
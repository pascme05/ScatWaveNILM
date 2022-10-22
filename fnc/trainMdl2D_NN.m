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
function [mdl] = trainMdl2D_NN(XTrain, yTrain, XTest, yTest, XVal, yVal, ~, setupMdl, ~, ~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Data
%---------------------------------------------------
% X
XTrain = permute(XTrain,[2 3 1]);
XTrain = reshape(XTrain, size(XTrain,1), size(XTrain,2), 1, size(XTrain,3));
XTest = permute(XTest,[2 3 1]);
XTest = reshape(XTest, size(XTest,1), size(XTest,2), 1, size(XTest,3));
XVal = permute(XVal,[2 3 1]);
XVal = reshape(XVal, size(XVal,1), size(XVal,2), 1, size(XVal,3));

% y
yTrain = categorical(yTrain);
yTest = categorical(yTest);
yVal = categorical(yVal);

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

elseif setupMdl.name == "CNN"
% layers = [ ...
%     imageInputLayer([size(XTrain,1) size(XTrain,2) 1])
%     convolution2dLayer(5,20)
%     reluLayer
%     maxPooling2dLayer(2,'Stride',2)
%     fullyConnectedLayer(length(unique(yTrain)))
%     softmaxLayer
%     classificationLayer];

layers = [ ...
    imageInputLayer([size(XTrain,1) size(XTrain,2) 1])
    convolution2dLayer(10,30)
    reluLayer
    convolution2dLayer(8,30)
    reluLayer
    convolution2dLayer(6,40)
    reluLayer
    convolution2dLayer(5,50)
    reluLayer
    convolution2dLayer(5,50)
    reluLayer
    maxPooling2dLayer(5,'Stride',5)
    fullyConnectedLayer(512)
    fullyConnectedLayer(512)
    fullyConnectedLayer(512)
    fullyConnectedLayer(length(unique(yTrain)))
    softmaxLayer
    classificationLayer];

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
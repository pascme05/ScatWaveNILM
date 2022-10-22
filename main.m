%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Scattered NILM for device classification                         %
% Topic: Energy Disaggregation                                            %
% File: main                                                              %
% Date: 26.06.2022                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ACC_maj, F1_maj, ACC_min, F1_min] = main(data, labels, classes, setupExp, setupData, setupMdl, setupPara)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[XTrain, yTrain, XTest, ...
 yTest, XVal, yVal] = loadData(data, labels, setupData, setupExp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Data
%---------------------------------------------------
[XTrain, yTrain] = preprocessing(XTrain, yTrain, setupData, setupPara);
[XTest, yTest] = preprocessing(XTest, yTest, setupData, setupPara);
[XVal, yVal] = preprocessing(XVal, yVal, setupData, setupPara);

%---------------------------------------------------
% Changes Variables
%---------------------------------------------------
setupData.fs = setupData.fs/setupPara.down;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Feature Extraction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Features
%---------------------------------------------------
[XTrain] = features(XTrain, setupPara, setupData);
[XTest] = features(XTest, setupPara, setupData);
[XVal] = features(XVal, setupPara, setupData);

%---------------------------------------------------
% Scattering
%---------------------------------------------------
if setupPara.scat == 1
    [XTrain, yTrain_sc] = scattering(XTrain, yTrain, setupData, setupMdl);
    [XTest, yTest_sc] = scattering(XTest, yTest, setupData, setupMdl);
    [XVal, yVal_sc] = scattering(XVal, yVal, setupData, setupMdl);
else
    yTrain_sc = yTrain;
    yTest_sc = yTest;
    yVal_sc = yVal;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Model Training
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Start 
%---------------------------------------------------
tic

%---------------------------------------------------
% 1D mdl
%---------------------------------------------------
if setupMdl.dim == "1D"
    if setupMdl.name == "SVM" || setupMdl.name == "KNN" || setupMdl.name == "RF"
        [mdl] = trainMdl1D(XTrain, yTrain_sc, XTest, yTest_sc, XVal, yVal_sc, classes, setupMdl, setupExp);
    else
        [mdl] = trainMdl1D_NN(XTrain, yTrain_sc, XTest, yTest_sc, XVal, yVal_sc, classes, setupMdl, setupExp);
    end
end

%---------------------------------------------------
% 2D mdl
%---------------------------------------------------
if setupMdl.dim == "2D"
    if setupMdl.name == "SVM" || setupMdl.name == "KNN" || setupMdl.name == "RF"
        [mdl] = trainMdl2D(XTrain, yTrain_sc, XTest, yTest_sc, XVal, yVal_sc, classes, setupMdl, setupExp);
    else
        [mdl] = trainMdl2D_NN(XTrain, yTrain_sc, XTest, yTest_sc, XVal, yVal_sc, classes, setupMdl, setupExp, setupPara);
    end
end

%---------------------------------------------------
% End 
%---------------------------------------------------
toc

%---------------------------------------------------
% Size
%---------------------------------------------------
s = whos('mdl'); 
fprintf(1, '%d Mbytes\n', s.bytes/1000/1000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Model Testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Start 
%---------------------------------------------------
tic

%---------------------------------------------------
% 1D mdl
%---------------------------------------------------
if setupMdl.dim == "1D"
    if setupMdl.name == "SVM" || setupMdl.name == "KNN" || setupMdl.name == "RF"
        [yPred] = testMdl1D(mdl, XTest, setupExp);
    else
        [yPred] = testMdl1D_NN(mdl, XTest, setupExp);
    end
end

%---------------------------------------------------
% 2D mdl
%---------------------------------------------------
if setupMdl.dim == "2D"
    if setupMdl.name == "SVM" || setupMdl.name == "KNN" || setupMdl.name == "RF"
        [yPred] = testMdl1D(mdl, XTest, setupExp);
    else
        [yPred] = testMdl2D_NN(mdl, XTest, setupExp);
    end
end

%---------------------------------------------------
% End 
%---------------------------------------------------
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post-processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Performance Evaluation 
%---------------------------------------------------
[statsMin, statsMaj] = performance(yPred, yTrain, yTest, ...
                                   yTrain_sc, yTest_sc, classes, ...
                                   setupExp, setupPara, setupMdl);

%---------------------------------------------------
% Output
%---------------------------------------------------
ACC_maj = table2array(statsMaj(8,4));
F1_maj = table2array(statsMaj(9,4));
ACC_min = table2array(statsMin(8,4));
F1_min = table2array(statsMin(9,4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MSG Out
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
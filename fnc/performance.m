%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Scattered NILM for device classification                         %
% Topic: Energy Disaggregation                                            %
% File: performance                                                       %
% Date: 26.06.2022                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [statsMin, statsMaj] = performance(yPred, yTrain, yTest, yTrain_sc, yTest_sc, classes, setupExp, setupPara, setupMdl)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Data
%---------------------------------------------------
if setupMdl.name == "SVM" || setupMdl.name == "KNN" || setupMdl.name == "RF"
    if setupExp.kfold > 1
        yTest = [yTrain; yTest];
        yTest_sc = [yTrain_sc; yTest_sc];
    end
else
    yTest_sc2 = zeros(length(yTest_sc),11);
    for i = 1:length(yTest_sc)
        for ii = 1:11
            if yTest_sc(i,1) == ii
                yTest_sc2(i,ii) = 1;
            end
        end
    end
end

%---------------------------------------------------
% Majority Vote
%---------------------------------------------------
if setupPara.scat == 1 
    cat = categorical(classes);
    [TestVotes, ~] = helperMajorityVote(yPred, yTest, cat);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Appliance Level
%---------------------------------------------------
% Minor
if exist("yTest_sc2", "var")
    for i = 1:size(yPred, 2)
        tempCMin = confusionmat(yTest_sc2(:,i), yPred(:,i));
        if i == 1
            CMin = tempCMin;
        else
            CMin = CMin + tempCMin;
        end
    end
else
    CMin = confusionmat(yTest_sc,yPred);
end
statsMin = statsOfMeasure(CMin, 1);

% Major
if setupPara.scat == 1
    CMaj = confusionmat(categorical(yTest),TestVotes);
    statsMaj = statsOfMeasure(CMaj, 1);
else
    statsMaj = statsMin;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
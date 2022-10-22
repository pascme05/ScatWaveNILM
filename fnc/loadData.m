%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Scattered NILM for device classification                         %
% Topic: Energy Disaggregation                                            %
% File: loadData                                                          %
% Date: 26.06.2022                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [XTrain, yTrain, XTest, yTest, XVal, yVal] = loadData(data, labels, setupData, setupExp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idx = ones(1,length(labels));
N = setupData.time * setupData.fs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Limit data
%---------------------------------------------------
% Number of snapshots
X = data(1:setupData.limit,:,:);
y = labels(1:setupData.limit)';

% Time duration per frame
X = X(:,1:N,:,:);

%---------------------------------------------------
% Select Appliances
%---------------------------------------------------
% Find IDs
if isempty(setupData.app) == 0
else
    for i = 1:length(setupData.app)
        for ii = 1:length(y)
            if y{ii} == setupData.app(i)
            else
                idx(i) = 0;
            end
        end
    end
end

% Delete rows
if isempty(setupData.app) == 0
    for i = 1:length(labels)
        if idx(i) == 0
            X(i,:,:) = [];
            y{i} = [];
        else
        end
    end
end


%---------------------------------------------------
% Split data
%---------------------------------------------------
% Splits
cv = cvpartition(size(X,1),'HoldOut',setupExp.perTest);
idx = cv.test;

% Separate to training and test data
XTrain = X(~idx, :, :);
XTest  = X(idx, :, :);
yTrain = y(~idx)';
yTest = y(idx)';

% Splits
cv = cvpartition(size(XTrain,1),'HoldOut',setupExp.perVal);
idx = cv.test;

% Separate to validation data
XVal = XTrain(idx, :, :);
yVal = yTrain(idx);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Scattered NILM for device classification                         %
% Topic: Energy Disaggregation                                            %
% File: features                                                          %
% Date: 26.06.2022                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X, y] = scattering(X, y, setupData, setupMdl)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = size(X,2);                                                              % length of the signal
T = setupData.time;                                                         % time (sec)
fs = setupData.fs;                                                          % sampling frequency (Hz)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if setupMdl.dim == "1D"
    sn = waveletScattering('SignalLength', N,...
                           'InvarianceScale', T/2,...
                           'SamplingFrequency',fs);
else
    sn = waveletScattering2('ImageSize',[size(X,2) size(X,3)],...
                            'InvarianceScale',size(X,2)/16);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% 1D
%---------------------------------------------------
if setupMdl.dim == "1D"
    % X
    F = featureMatrix(sn,X');
    W = size(F,2);
    F = permute(F,[2 3 1]);
    F = reshape(F, size(F,1)*size(F,2),[]);
    
    % y
    [y] = createLabels(y,W,setupMdl);
end

%---------------------------------------------------
% 2D
%---------------------------------------------------
if setupMdl.dim == "2D"
    % Convert to Cell
    for i = 1:size(X,1)
        F{i,1} = squeeze(X(i,:,:));
    end

    % X
    F = cellfun(@(x)helperScatImages_mean(sn,x,setupMdl),F,'Uni',0);
    F = double(cat(1,F{:}));
    W = size(F,1)/length(y);

    % y
    [y] = createLabels(y,W,setupMdl);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Fusion
%---------------------------------------------------
X = F;

end

function F = helperScatImages_mean(sn,x,setupMdl)
    F = featureMatrix(sn,x);
    if setupMdl.name == "SVM" || setupMdl.name == "KNN" || setupMdl.name == "RF"
        F = permute(F,[2 3 1]);
        F = reshape(F, size(F,1)*size(F,2),[]);
    else
%         F = mean(F,4);
%         F = reshape(F, size(F,1),20,20,[]);
%         F = permute(F,[2 3 1]);
%         F = F';
    end
end
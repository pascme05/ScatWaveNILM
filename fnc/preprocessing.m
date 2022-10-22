%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Scattered NILM for device classification                         %
% Topic: Energy Disaggregation                                            %
% File: pre-processing                                                    %
% Date: 26.06.2022                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X, y] = preprocessing(X, y, setupData, setupPara)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Down-sampling
%---------------------------------------------------
X1 = downsample(X(:,:,1)',setupPara.down)';
X2 = downsample(X(:,:,2)',setupPara.down)';
X = zeros(size(X,1),size(X1,2));
X(:,:,1) = X1;
X(:,:,2) = X2;

%---------------------------------------------------
% Normalization
%---------------------------------------------------
for iii = 1:size(X,3)
    X(:,:,iii) = X(:,:,iii)/setupData.norm(iii);
end

%---------------------------------------------------
% Filtering
%---------------------------------------------------
if setupPara.filt == "median"
    for i = 1:size(X,1)
        for iii = 1:size(X,3)
            X(i,:,iii) = medfilt1(X(i,:,iii),setupPara.filtLen);
        end
    end
end

%---------------------------------------------------
% Fryze Power Theorem 
%---------------------------------------------------
if setupPara.fryze == 1
    i_n = zeros(size(X,1), size(X,2));
    for i = size(X,1)
        for ii = size(X,2)
            Vrms = rms(X(i,ii,2)).^2;
            i_n(i,ii) = X(i,ii,1) - X(i,ii,1)/(Vrms*size(X,2)) * sum(X(i,:,1).*X(i,:,2)); 
        end
    end
    X(:,:,1) = i_n;
end

end
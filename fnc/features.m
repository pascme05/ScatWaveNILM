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
function [X] = features(X, setupPara, setupData)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Parameter
%---------------------------------------------------               
L = size(X,2);                                                              % Length of signal (samples)
dt = setupData.time;                                                        % time (sec)
fel = setupData.fel;                                                        % electrical frequency (Hz)
N = fel*dt;                                                                 % number of samples
N_el = setupData.fs/setupData.fel;                                          % pulse number
N_cyc = L/N_el;                                                             % data samples per cycle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Time Domain 
%---------------------------------------------------
% 1D Current
if setupPara.feat == "I"
    F = squeeze(X(:,:,1));
end

% 2D PQ
if setupPara.feat == "PQ"
    for i = 1:size(X,1)
        F(i,:,:) = X(i,:,1).*X(i,:,2)';
    end
end

% 2D VI
if setupPara.feat == "VI"
    for i = 1:size(X,1)
        % Max Values
        Imax = max(abs(X(i,:,1)));
        Vmax = max(abs(X(i,:,2)));

        % Normalize
        I = X(i,:,1)/Imax;
        V = X(i,:,2)/Vmax;

        % Define Grid
        di = 2/(N_el-1);
        dv = 2/(N_el-1);

        % Mapping
        temp = zeros(N_el,N_el,N_cyc);
        for j = 1:N_cyc
            for jj = 1:N_el
                n_i = ceil(I(jj+(j-1)*N_cyc)/di) + N_el/2;
                n_v = ceil(V(jj+(j-1)*N_cyc)/dv) + N_el/2;
                temp(n_i,n_v,j) = 1;
            end
        end
        F(i,:,:) = mean(temp, 3);
    end
end

%---------------------------------------------------
% Freq Domain 
%---------------------------------------------------
% 1D Current
if setupPara.feat == "FFT"
    for i = 1:size(X,1)
        Y = fft(squeeze(X(i,:,1)));
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        for ii = 1:setupPara.fmax+1
            F(i,ii) = P1(N*(ii-1)+1);
        end
    end
end

% 2D DFIA
if setupPara.feat == "DFIA"
    for i = 1:size(X,1)
        Y= fft2(X(i,:,1).*X(i,:,2)');
        P1 = abs(Y);
        for ii = 1:setupPara.fmax+1
            for iii = 1:setupPara.fmax+1 
                F(i,ii,iii) = P1(N*(ii-1)+1,N*(iii-1)+1);
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Reshape
%---------------------------------------------------

%---------------------------------------------------
% Fusion
%---------------------------------------------------
X = F;
end
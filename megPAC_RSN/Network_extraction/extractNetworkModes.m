function [networkModesFile] = extractNetworkModes_MS_all_subject(avgCorrCoefFile,Med_state,Study_state, varargin)
%function [networkModesFile] = extractNetworkModes(avgCorrCoefFile, avgRandCorrCoefFile)
% Computes the main PCA modes of the connectivity patterns in the array
% stored in avgCorrFile. If avgRandCorrFile is defined, the signal modes
% are projected away from the first mode of the noise connectivity patterns
% found from the array in avgRandCorrCoefFile.

iSave = 0; %Save intermediate files iSave = 1

nDims = 1175; % Number of dimensions used to compute principal modes.

if nargin > 2
    avgRandCorrCoefFile = varargin{1};
    isnoiseProj = 1;
else
    isnoiseProj = 0;
end

connArray = load(avgCorrCoefFile);

% Define basis for connectivity similarity analysis
% Here = random selection of nDims cortical vertices
Scout = round(linspace(1,size(connArray.ImageGridAmp,2),nDims));

% Consider only absolute values of correlation coefs, which denote connectivity
%connArray.ImageGridAmp = abs(connArray.ImageGridAmp); % Comment if using
%z-score maps 

% Average connectivity pattern; for the record
MeanConn = mean(connArray.ImageGridAmp, 2);

% Generate results structure where to later save the results
clusterResults = connArray; 
clusterResults.ImageGridAmp = []; 

% Compute connectivity similarity metrics
ttmp = connArray.ImageGridAmp * connArray.ImageGridAmp(Scout, :)';
%ttmp = normr( bsxfun(@minus, ttmp , mean(ttmp, 2) ) );

if isnoiseProj
    % Projection away from noise modes
    
    sprintf(' - Compute projector(s) away from principal noise connectivity pattern(s)')
    
    % Same data prep as for data time series
    noise = load(avgRandCorrCoefFile, 'ImageGridAmp');
    %noise.ImageGridAmp = abs(noise.ImageGridAmp); % Comment if using
    %z-score maps
    %noise.ImageGridAmp = normr(noise.ImageGridAmp); % Comment if using
    %z-score maps
    noise_ttmp = noise.ImageGridAmp * noise.ImageGridAmp(Scout, :)';
    
    %Compute singular values and vectors to identify principal noise modes
    [noiseU S V] = svd(noise_ttmp' * noise_ttmp , 0); clear V
    S = diag(S);
    countS = cumsum(S)/sum(S);clear S; 
    
    disp(sprintf('-- First singular values, noise modes:'))
    countS(1:10)'
    
    nprojNoise = 1; %max(find(countS<=.9)); % was set to 1
    
    if isempty(nprojNoise)
        nprojNoise = 1;
    end
   
    % Just keep first nprojNoise principal noise modes(s)
    noiseU = noiseU(:,1:nprojNoise);
    
    % Generate orthogonal projector away from principal noise mode(s)
    noisePattern = noise_ttmp * noiseU;
    noiseProj = eye(length(Scout)) - noiseU * noiseU';
   
    % Project noise corrcoef maps away from nprojNoise noise modes
    noise_ttmp = noise_ttmp * noiseProj;
%     noise_ttmp = normr(noise_ttmp); 
        noise_ttmp = normmatrix(noise_ttmp); 

    if iSave
        % And save for the record
        clusterResults.ImageGridAmp = noise_ttmp;
        clusterResults.Comment = ...
            sprintf(['NOISE_MODES_%d_noise_modes_removed_%d_modes_all_Subjects_' Med_state '_' Study_state], nprojNoise, nDims);
        clusterResults.Time =  1:size(clusterResults.ImageGridAmp, 2);
        clusterResults.ImageGridTime = 1:size(clusterResults.ImageGridAmp, 2);
%         clusterFile = strrep(avgCorrCoefFile,'results_', 'results_AllSubjects_0000_noiseModes.mat');
        clusterFile = ['results_noiseModes_all_Subjects_' Med_state '_' Study_state '.mat'];
        save(clusterFile, '-struct', 'clusterResults')
        clusterResults.ImageGridAmp = [];
    end
  
    if iSave
        % Project away noise correlation coefficients from their principal
        % mode(s) and save residuals
        Proj = normmatrix(noisePattern')';
        
        %Proj = norm(noisePattern')';
        Proj = eye(size(Proj,1)) - Proj * Proj';
        %     clusterResults.ImageGridAmp = bsxfun(@minus, noise.ImageGridAmp,...
        %         mean(noise.ImageGridAmp, 2));
        
        clusterResults.ImageGridAmp = Proj * noise.ImageGridAmp;
        % And save
        clusterResults.Comment = ...
            sprintf(['NOISE_RESIDUALS_%d_noise_modes_removed_all_Subjects_' Med_state '_' Study_state], nprojNoise);
        clusterResults.Time =  1:size(clusterResults.ImageGridAmp, 2);
        clusterResults.ImageGridTime = 1:size(clusterResults.ImageGridAmp, 2);
%         clusterFile = strrep(avgCorrCoefFile,'results_', 'results_AllSubjects_0100_projectedNoiseCorrCoef.mat');
        clusterFile = ['results_projectedNoiseCorrCoef_all_Subjects_' Med_state '_' Study_state '.mat'];
        save(clusterFile, '-struct', 'clusterResults')
        clusterResults.ImageGridAmp = [];
    end
    
else % No projection away from noise
    
    noiseProj = 1; noisePattern =  []; nprojNoise = 0;

end

% Project away signal corrcoef from noise modes
ttmp = ttmp * noiseProj;

disp(sprintf('-- First singular values, signal modes:'))
[U S V] = svd( ttmp'*ttmp ,0); clear V
S = diag(S);
countS = cumsum(S)/sum(S);
countS(1:10)'

nproj = 5; %max(find(countS<.995)); % was set to 5

if isempty(nproj)
    nproj = 1;
end

% Keep only first nproj signal modes
Proj = U(:,1:nproj);
% Compute orthogonal projectors away from these modes, to study residuals
Proj = eye(size(Proj,1)) - Proj * Proj';

% Projections
U2 = ttmp * U(:,1:nproj);
ttmp2 = ttmp * Proj;

%Save mean connectivity pattern, residuals, and maps of first nproj modes
clusterResults.ImageGridAmp = [MeanConn, sqrt(sum((ttmp2.*ttmp2), 2)),  U2];
                                
clusterResults.Comment = sprintf(['Mean_Conn_pattern_Residuals_SIGNAL MODES_%d_noise_modes_%d_signal_modes_all_Subjects_' Med_state '_' Study_state], nprojNoise, nproj);
clusterResults.Time =  1:size(clusterResults.ImageGridAmp, 2);
clusterResults.ImageGridTime = 1:size(clusterResults.ImageGridAmp, 2);
% networkModesFile = strrep(avgCorrCoefFile,'results_', 'results_AllSubjects_100_signalModes.mat');
networkModesFile = ['results_signalModes_all_Subjects_' Med_state '_' Study_state '.mat'];
save(networkModesFile, '-struct', 'clusterResults')


% Now save positive and negative valued mode maps separately
ntmp = U2;
ptmp = U2; clear U2

% Keep only negative mode values
ntmp(ntmp>0) = 0;
% And rectify for display
ntmp = abs(ntmp);

% Keep only positive mode values
ptmp(ptmp<0) = 0;

%And save
clusterResults.ImageGridAmp = [ntmp, ptmp];
clusterResults.ImageGridAmp =  bsxfun(@rdivide, clusterResults.ImageGridAmp , max(abs(clusterResults.ImageGridAmp), [] , 1));
%[clusterResults.ImageGridAmp] = normr(clusterResults.ImageGridAmp');
%clusterResults.ImageGridAmp = clusterResults.ImageGridAmp';
                            
clusterResults.Comment = sprintf(['positive_negative_SIGNAL MODES_%d_signal_modes_all_Subjects_' Med_state '_' Study_state], nproj);
clusterResults.Time =  1:size(clusterResults.ImageGridAmp, 2);
clusterResults.ImageGridTime = 1:size(clusterResults.ImageGridAmp, 2);
% networkModesFile = strrep(avgCorrCoefFile,'results_', 'results_AllSubjects_000_posandnegSignalModes.mat');
networkModesFile = ['results_posandnegSignalModes_all_Subjects_' Med_state '_' Study_state '.mat'];
save(networkModesFile, '-struct', 'clusterResults')

% labelled map depending on local max mode
% [clusterResults.ImageGridAmp] = normr(clusterResults.ImageGridAmp(:,...
%     setdiff(1:size(clusterResults.ImageGridAmp,2),[1,nproj+1] ))');

% [clusterResults.ImageGridAmp] = normr(clusterResults.ImageGridAmp');
% clusterResults.ImageGridAmp = clusterResults.ImageGridAmp';

[tmp, itmp] = max(clusterResults.ImageGridAmp,[],2);
indices = unique(itmp);
tmp = zeros(size(clusterResults.ImageGridAmp,1), length(indices));
for k = 1:length(indices)
    tmp(itmp==indices(k),k) = k;
end
clusterResults.ImageGridAmp = tmp;
clusterResults.ImageGridAmp = [itmp, tmp];
%clusterResults.ImageGridAmp = repmat(clusterResults.ImageGridAmp,1,2);
                                
clusterResults.Comment = sprintf(['SIGNAL_MODES_LABELS_%d_modes_all_Subjects_' Med_state '_' Study_state], nproj);
clusterResults.Time =  1:size(clusterResults.ImageGridAmp, 2);
clusterResults.ImageGridTime = 1:size(clusterResults.ImageGridAmp, 2);
% networkModesFile = strrep(avgCorrCoefFile,'results_', 'results_AllSubjects_001_labelsSignalModes.mat');
networkModesFile = ['results_labelsSignalModes_all_Subjects_' Med_state '_' Study_state '.mat'];
save(networkModesFile, '-struct', 'clusterResults')




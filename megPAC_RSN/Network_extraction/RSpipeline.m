% See information on input types on comment lines below
pathStr = 'C:\Users\florine\Documents\brainstorm3\'; %path to brainstorm
addpath(genpath(pathStr));
FWHM =0.005; % Spatial smoothing (7mm)

dataPath = 'C:\Users\florine\Documents\brainstorm_db\resting_young\data\Group_analysis\megPAC_EEG\';
resultFiles= {...
    {...
  'results_Conv_megPAC_model_demeaned_S001.mat',...
    'results_Conv_megPAC_model_demeaned_S002.mat',...
    'results_Conv_megPAC_model_demeaned_S003.mat',...
    'results_Conv_megPAC_model_demeaned_S004.mat'...
    'results_Conv_megPAC_model_demeaned_S006.mat',...
    'results_Conv_megPAC_model_demeaned_S007.mat',...
    'results_Conv_megPAC_model_demeaned_S008.mat',...
    'results_Conv_megPAC_model_demeaned_S009.mat',...
    'results_Conv_megPAC_model_demeaned_S010.mat',...
    'results_Conv_megPAC_model_demeaned_S011.mat',...
    'results_Conv_megPAC_model_demeaned_S012.mat',...
    'results_Conv_megPAC_model_demeaned_S013.mat'...    
    }
    };


scoutFile = 'scout_IFGonly.mat';
%
% INPUTS:
% dataPath: indicates the path where sourceFiles are located
% sourceFiles is a cell-array of Brainstorm Results file, each cell from a different subject or a different acquisition run
% Note that all time series need to be defined on the same template brain for all subjects
% (TO DO: include a step to project all individual time series on template brain)
%
% OUTPUTS:
% Multiple files are generated by the pipeline:
%
% - the group-wise average array of correlation coefficients across all source time series
% - the Z-scaled connectivity array for seed-based exploration of networks
% - the same array obtained from random time series as inputs (surrogate data to assess significance)
% - the PCA modes of dominant connectivity patterns (RS networks) projected away from the dominant noise mode
%
% Written by the Neurospeed & MEG Program at McGill
% Contact: sylvain.baillet@mcgill.ca
% 2012


% Apply pipeline on all data series available

t00 = tic;

for k=1:length(resultFiles)
    
    t0 = tic;
    
    disp(sprintf('Computing entry-wise source maps of correlation coefficients + group average...'))
    t1 = tic;
    [avgCorrCoefFile,nTime] = computeCorrCoef_all(dataPath, resultFiles{k},FWHM);
    %         [corrCoefFiles, avgCorrCoefFile] = computeCorrCoef(dataPath, resultFiles{k});
    
    disp(sprintf('Done in %3.2f',toc(t1)))
    
    sprintf('Computing group-average correlation coefs from random noise data...')
    t1 = tic;
    [avgRandCorrCoefFile] = averageRandCorrCoef_all_EEG(dataPath, resultFiles{k},nTime);
    disp(sprintf('Done in %3.2f',toc(t1)))
    
    sprintf('Standardize noise and data connectivity arrays...')
    t1 = tic;
    %     [ZavgRandCorrCoefFile, ZavgCorrCoefFile] = ZscoreAverageCorrCoef(avgRandCorrCoefFile, avgCorrCoefFile);
    %         [ZavgRandCorrCoefFile, ZavgCorrCoefFile] = ZscoreAverageCorrCoef('/scratch/megPAC/results_000_NoiseAverageCorrmapEsther_FlorinConv_megPAC_model_demeaned.mat', '/scratch/megPAC/results_00_AverageCorrmap_concatenatedTherese_LennertConv_megPAC_model_demeaned.mat');
    
    disp(sprintf('Done in %3.2f',toc(t1)))
    
    disp(sprintf('Extracting principal modes of connectivity...'))
    t1 = tic;
    [networkModesFile] = extractNetworkModes(avgCorrCoefFile,avgRandCorrCoefFile);
    
    %     [networkModesFile] = extractNetworkModes(ZavgCorrCoefFile, ZavgRandCorrCoefFile);
    disp(sprintf('Done in %3.2f',toc(t1)))
    
    disp(sprintf('Labeling cortex according to ROIs (scouts)...'))
    t1 = tic;
    [scoutLabelingFile] = labelingFromScouts(avgCorrCoefFile, scoutFile);
    disp(sprintf('Done in %3.2f',toc(t1)))
    
    disp(sprintf('Pipeline %s %d/%d completed in %3.2f sec', mfilename, k, length(resultFiles), toc(t0)))
    
end

disp(sprintf('Entire Pipeline %s %d/%d completed in %3.2f sec', mfilename, k, length(resultFiles), toc(t00)))


return

%RSpipeline(dataPath, resultFiles)
function [avgRandCorrCoefFile] = averageRandCorrCoef_all_MEG_elekta_MS(dataPath, sourceFiles,nTime, FWHM, iRun,tpl_brain_kernel,subjects,study_state)
% Generate surrogate correlation coefficient arrays from random sensor data time series
% to assess spurious spatial correlations due to the spatial resolution of
% MEG imaging. The random time series are low-pass filtered and sampled
% equivalently to the megBOLD and megPAC signal models
% ZavgRandCorrCoefFile contains the z-scores of each row of the average
% corrcoef array
% ZavgCorrCoefFile contains the z-scores of the data average
% corrcoef array, each row standardized with respect to the mean and std of
% the rows of the random corrcoef array

iSave = 1;
% EF 27.4.2016
% FWHM should be in m. Therefore if FWHM is 7mm it should be defined as 0.007 
% Works if sourcefiles are within the dabase. Otherwise the surface file
% cannot be found.

% Load ImagingKernel for template brain
% TO DO: define this latter better: from individual channel files from
%Kernel for template brain
load('.../results_PNAI_MEG_GRAD_MEG_MAG_KERNEL_190930_1532.mat') % inv
inv.ImagingKernel=ImagingKernel;
inv.Whitener=Whitener;
inv.nComponents=nComponents;
% load '/export02/restingstate/Sylvain_network_extraction/ImagingKernelTemplateBrainCTF.mat'

% Generate randomized time series of source series
% with characteristic akin to megPAC and megBOLD signal models
% and compute corresponding correlation coefficients




tmp = load(fullfile(dataPath, sourceFiles{1}));

% Sampling rate of low-passed versions of source series

sRate = 1./abs(diff(tmp.Time(1:2))); % Hz 


% Generate surrogate random time series
tmp.ImageGridAmp = randn(size(inv.ImagingKernel,2) , nTime );
% Low-pass filter below sRate<3
tmp.ImageGridAmp = bst_bandpass_fft(tmp.ImageGridAmp, sRate, 0, sRate/3, 1, 0);
% TO DO: could be better = generate time series from randomized FFT phase coefficients

% Compute corresponding source maps
tmp.ImageGridAmp  = inv.ImagingKernel * tmp.ImageGridAmp;

% % % apply spatial smoothing %uncommend if needed
% % tmp2=strfind(dataPath,'data');
% % database=dataPath(1:tmp2-1);
% % SurfaceMat=load(fullfile(database,'anat',tmp.SurfaceFile));
% % 
% % cortS.tri = SurfaceMat.Faces;
% % cortS.coord = SurfaceMat.Vertices';
% % % Get the average edge length
% % [vi,vj] = find(SurfaceMat.VertConn);
% % Vertices = SurfaceMat.VertConn;
% % meanDist = mean(sqrt((Vertices(vi,1) - Vertices(vj,1)).^2 + (Vertices(vi,2) - Vertices(vj,2)).^2 + (Vertices(vi,3) - Vertices(vj,3)).^2));
% % % FWHM in surfstat is in mesh units: Convert from millimeters to "edges"
% % FWHMedge = FWHM ./ meanDist;
% % tmp.ImageGridAmp=SurfStatSmooth(tmp.ImageGridAmp', cortS, FWHMedge)';


tmp.ImageGridAmp  = corrcoef( tmp.ImageGridAmp' );
%tmp.ImageGridAmp = bsxfun(@rdivide, tmp.ImageGridAmp , max(abs(tmp.ImageGridAmp), [] , 1)); % scale max correlation back to one for each source

if iSave
    tmp.Comment = sprintf(['JK | ' study_state ' | average | random corr maps | without ' subjects{iRun} ' | ' study_state]);
    tmp.Time =  1:size(tmp.ImageGridAmp, 2);
    tmp.ImageGridTime = 1:size(tmp.ImageGridAmp, 2);
%     avgRandCorrCoefFile = strrep(sourceFiles{1},'results_', 'results_000_NoiseAverageCorrmap');
    avgRandCorrCoefFile = ['results_00_NoiseAverageCorrmap_' study_state '.mat'];
    avgRandCorrCoefFile = fullfile(dataPath,avgRandCorrCoefFile);
    save(avgRandCorrCoefFile, '-struct', 'tmp')
else
    avgRandCorrCoefFile = '';
end



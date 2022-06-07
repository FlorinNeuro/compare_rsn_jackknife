function [avgCorrCoefFile,nTime] = computeCorrCoef_all_MS(dataPath, sourceFiles, FWHM, iRun, subjects,study_state)
% Computes the individual arrays of correlation coefficients from source
% time series stored in sourceFiles (result stored in corrCoefFiles) 
% Also compute the average of all individual arrays, following spatial smoothing; results is stored in avgCorrCoefFile


% EF 27.4.2016
% FWHM should be in m. Therefore if FWHM is 7mm it should be defined as 0.007 
% Works if sourcefiles are within the dabase. Otherwise the surface file
% cannot be found.

iSave = 0;

load smoothing_kernel_FS.mat
% load /export02/restingstate/Sylvain_network_extraction/smoothing_kernel_FS.mat
nfiles = length(sourceFiles);

% Data length restriction to minimal dataset
% dl=3000;
ImageGridAmp=[];

for ifile = 1:nfiles 
    
    disp(sprintf('- Processing data file #%d/%d',ifile, nfiles))
    
    % load source/results file
    sourceResults = load(fullfile(dataPath, sourceFiles{ifile})) ;
    
%     ImageGridAmp=[ImageGridAmp sourceResults.ImageGridAmp(:,1:dl)];
    
      ImageGridAmp=[ImageGridAmp sourceResults.ImageGridAmp];
end

nTime=size(ImageGridAmp,2)
% Data length restriction to minimal dataset
%     sourceResults.ImageGridAmp=sourceResults.ImageGridAmp(:,1:dl);
%      sourceResults.ImageGridTime=sourceResults.ImageGridTime(:,1:dl);

    % apply spatial smoothing %% uncommend if needed
% tmp=strfind(dataPath,'data');
% database=dataPath(1:tmp-1);
% SurfaceMat=load(fullfile(database,'anat',sourceResults.SurfaceFile));
%     
%     % Better use SurfStatSmooth
%     cortS.tri = SurfaceMat.Faces;
%     cortS.coord = SurfaceMat.Vertices';
%     % Get the average edge length
%     [vi,vj] = find(SurfaceMat.VertConn);
%     Vertices = SurfaceMat.VertConn;
%     meanDist = mean(sqrt((Vertices(vi,1) - Vertices(vj,1)).^2 + (Vertices(vi,2) - Vertices(vj,2)).^2 + (Vertices(vi,3) - Vertices(vj,3)).^2));
%     % FWHM in surfstat is in mesh units: Convert from millimeters to "edges"
%     FWHMedge = FWHM ./ meanDist;
%     ImageGridAmp=SurfStatSmooth(ImageGridAmp', cortS, FWHMedge)';
%     
    % ImageGridAmp = W * ImageGridAmp; 
    % compute correlation coefficients
    [sourceResults.ImageGridAmp] = corrcoef(ImageGridAmp');
     
% Properly scale average values 

% And save to file
if 1
    sourceResults.Comment = sprintf(['JK | ' study_state ' | average | corr maps | without ' subjects{iRun} ' | ' study_state]);
    sourceResults.Time =  1:size(sourceResults.ImageGridAmp, 2);
    sourceResults.ImageGridTime = 1:size(sourceResults.ImageGridAmp, 2);
  
    %avgCorrCoefFile = strrep(sourceFiles{ifile},'results_', 'results_00_AverageCorrmap_concatenated');
    avgCorrCoefFile = ['results_00_AverageCorrmap_concatenated_without_ ' subjects{iRun} '_' study_state '.mat'];
    avgCorrCoefFile = fullfile(dataPath,avgCorrCoefFile);
    save(avgCorrCoefFile, '-struct', 'sourceResults')
else
    avgCorrCoefFile = '';
end


return

% Compute row-wise Z-scores to emphasize the relative weight of the
% correlation coefficients for each cortical location
stdBaseline  = std(sourceResults.ImageGridAmp, 0, 2);
meanBaseline = mean(sourceResults.ImageGridAmp, 2);
% Remove null variance values
stdBaseline(stdBaseline == 0) = 1e-12;
% Compute zscore
avgCorrCoef.ImageGridAmp = bst_bsxfun(@minus, sourceResults.ImageGridAmp, meanBaseline);
avgCorrCoef.ImageGridAmp = bst_bsxfun(@rdivide, sourceResults.ImageGridAmp, stdBaseline);

avgCorrCoef.Comment = sprintf(['JK | average | corr maps - row Z-scores | without ' subjects{iRun} ' | ' study_state]);
%ZavgCorrCoefFile = strrep(sourceFiles{ifile},'results_', 'results_000_zscoreAverageCorrmap');
ZavgCorrCoefFile = ['results_000_zscoreAverageCorrmap_without_ ' subjects{iRun} '_' study_state '.mat'];
ZavgCorrCoefFile = fullfile(dataPath,ZavgCorrCoefFile);
save(ZavgCorrCoefFile, '-struct', 'avgCorrCoef')

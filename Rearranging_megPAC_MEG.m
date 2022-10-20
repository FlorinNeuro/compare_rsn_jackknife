% Pipline for MEG-PAC Analysis:
% 1. MEG-PAC.m
% 2. megPAC_all.m
% 3. Rearranging_megPAC_MEG.m
% 4. Project data on template brain and spatial smoothing with 7 mm
% 5. RSpipeline_MEG.m

%%Script is rearranging the PAC_MEG resulsts into Brainstorm format
%Check for OFF and ON
clear 

Med_State = 'ON'; 
Filename_append='Conv_megPAC_model_demeaned';
Filepart='megPAC_lf_2-48';
GroupPath=['.../brainstorm_db/database_' Med_State '/data/'];
switch Med_State
    case 'ON'
    %% ON
    subjects = {'S001','S002','S003','...'};    
    subject = {...
        'S001' {'data1', ...
        'data2', ...
        'data3'}; ...
        'S002' {'data1', ...
        'data2', ...
        'data3'}; ...
        'S003' {'data1', ...
        'data2', ...
        'data3'}};
    case 'OFF'
    %% OFF
    subjects = {'S001','S002','S003','...'};    
    subject = {...
        'S001' {'data1', ...
        'data2', ...
        'data3'}; ...
        'S002' {'data1', ...
        'data2', ...
        'data3'}; ...
        'S003' {'data1', ...
        'data2', ...
        'data3'}};
end

for iSubj=1:length(subjects)
    Inputpath=['/Output/megPAC_all/ON_' Med_State '/' subjects{iSubj}];
    Files=dir(fullfile(Inputpath));    
    Conv=[];
    for iBlock = 1:101
        iCond=[];
        for iFile=1:length(Files)
            if ~isempty(strfind(Files(iFile).name,['results_' subject{iSubj} '_sd_' num2str(iBlock) Filepart]))
                iCond(end+1) = iFile;
            end
        end
           load([Inputpath  '\' Files(iCond).name]);
        Conv=[Conv; ImageGridAmp];
    end

    meanBaseline = mean(Conv, 2);
    % Compute zscore
    Conv =         bsxfun(@minus, Conv, meanBaseline);

    kernelMat.ImageGridAmp = Conv;
    kernelMat.Comment      = [  'megPAC_demeaned_cortex'];
    kernelMat.sRate      = sRate;
    kernelMat.ImageGridTime         = 1/sRate:1/sRate:size(Conv,2)/sRate;
    kernelMat.DataFile=[];
    kernelMat.Time         = 1:size(Conv,2);
    kernelMat.GoodChannel=GoodChannel;
    kernelMat.SurfaceFile=[subjects{iSubj} '/tess_cortex_pial_low.mat'];
    kernelMat.HeadModelType='surface';
    OPTIONS.ResultFile = fullfile(GroupPath, subject{iSubj}, ['/megPAC_MEG/results_'  Filename_append ] );
     % Save file
    save(OPTIONS.ResultFile, '-struct', 'kernelMat');

end
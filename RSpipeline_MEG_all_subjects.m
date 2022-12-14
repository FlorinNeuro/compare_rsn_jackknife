% Pipline for MEG-PAC Analysis:
% 1. MEG-PAC.m
% 2. megPAC_all.m
% 3. Rearranging_megPAC_MEG.m
% 4. Project data on template brain and spatial smoothing with 7 mm
% 5. RSpipeline_MEG.m
% See information on input types on comment lines below
%path to brainstorm
pathStr = '.../brainstorm3/'; %path to the canolty code
addpath(genpath(pathStr));
% path to RSN code
pathStr = '.../hilbert-ica-rsn';
addpath(genpath(pathStr));
% FWHM is needed if spatial smoothing was not applied in brainstorm
% is needed for averageRandCorrCoef and computeCorrCoef_all
FWHM =0.007; % Spatial smoothing (7mm)


Med_state = 'ON';
Study_state = 'pre';
%path to on template brain projected MEG_PAC_data
dataPath = ['.../brainstorm_db/database_' Med_State '/data/Group_analysis/megPAC_MEG_' Study_state '/'];
Output_path = '.../Output/RSN/';
cd(dataPath)
% kernel (Brainstorm) on template brain --> needed in averageRandCorrCoef
% (maybe hard coded in the function)
tpl_brain_kernel = ['.../brainstorm_db/database_' Med_State '/data/Group_analysis/@default_study/Kernel.mat'];

subjects = {'S001','S002','S003','...'};  
switch Study_state
    case 'peri'
        switch Med_state
            case 'OFF'             
                Files= {...
                    'results_Conv_megPAC_model_demeaned_OFF_S001_PD_peri_ssmooth.mat', ...
                    'results_Conv_megPAC_model_demeaned_OFF_S002_PD_peri_ssmooth.mat', ...
                    'results_Conv_megPAC_model_demeaned_OFF_S003_PD_peri_ssmooth.mat', ...
                    '...';
                    };                
            case 'ON'              
                Files= {...
                    'results_Conv_megPAC_model_demeaned_ON_S001_PD_peri_ssmooth.mat', ...
                    'results_Conv_megPAC_model_demeaned_ON_S002_PD_peri_ssmooth.mat', ...
                    'results_Conv_megPAC_model_demeaned_ON_S003_PD_peri_ssmooth.mat', ...
                    '...';
                    };
        end
    case 'pre'
         switch Med_state
             case 'OFF'                
                Files= {...
                    'results_Conv_megPAC_model_demeaned_OFF_S001_PD_pre_ssmooth.mat', ...
                    'results_Conv_megPAC_model_demeaned_OFF_S002_PD_pre_ssmooth.mat', ...
                    'results_Conv_megPAC_model_demeaned_OFF_S003_PD_pre_ssmooth.mat', ...
                    '...';
                    };              
            case 'ON'             
                Files= {...
                    'results_Conv_megPAC_model_demeaned_ON_S001_PD_pre_ssmooth.mat', ...
                    'results_Conv_megPAC_model_demeaned_ON_S002_PD_pre_ssmooth.mat', ...
                    'results_Conv_megPAC_model_demeaned_ON_S003_PD_pre_ssmooth.mat', ...
                    '...';
                    };
         end
    case 'HC'
        Files= {...
           'results_Conv_megPAC_model_demeaned_S101_HC_ssmooth.mat', ...
           'results_Conv_megPAC_model_demeaned_S102_HC_ssmooth.mat', ...
           'results_Conv_megPAC_model_demeaned_S103_HC_ssmooth.mat', ...
           '...';
         };
        
end
  
%Scouts
scoutFile = '...megPAC_RSN/Network_extractionscout_IFGonly.mat';
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
    clearvars -except i Files scoutFile dataPath FWHM subjects Output_path Med_state Study_state
    resultFiles = Files;
    t00 = tic;

    t0 = tic;

    disp(sprintf('Computing entry-wise source maps of correlation coefficients + group average...'))
    t1 = tic;
    [avgCorrCoefFile,nTime] = computeCorrCoef_all(dataPath, resultFiles,FWHM,Med_state,Study_state);

    disp(sprintf('Done in %3.2f',toc(t1)))
    sprintf('Computing group-average correlation coefs from random noise data...')
    t1 = tic;
    [avgRandCorrCoefFile] = averageRandCorrCoef_all_MEG_elekta(dataPath, resultFiles,nTime, FWHM,Med_state,Study_state);
    disp(sprintf('Done in %3.2f',toc(t1)))
    sprintf('Standardize noise and data connectivity arrays...')
    t1 = tic;
    disp(sprintf('Done in %3.2f',toc(t1)))
    disp(sprintf('Extracting principal modes of connectivity...'))
    t1 = tic;
    [networkModesFile] = extractNetworkModes(avgCorrCoefFile,Med_state,Study_state,avgRandCorrCoefFile);

    disp(sprintf('Done in %3.2f',toc(t1)))
    disp(sprintf('Labeling cortex according to ROIs (scouts)...'))
    t1 = tic;
    [scoutLabelingFile] = labelingFromScouts(avgCorrCoefFile, scoutFile,Med_state,Study_state);
    disp(sprintf('Done in %3.2f',toc(t1)))

    disp(sprintf('Pipeline completed'))



    new_folder = [ Study_state '\' Med_state '\all_Subjects' ];
    mkdir(fullfile(Output_path,new_folder));
    folder_item = dir(dataPath);
    for i_folder_item = 1 : size(folder_item,1)
        if ~isempty(strfind(folder_item(i_folder_item).name,[ Study_state '\' Med_state '\all_Subjects' ]))
            movefile([dataPath folder_item(i_folder_item).name],[Output_path new_folder '\'])
        elseif ~isempty(strfind(folder_item(i_folder_item).name,'brainstormstudy'))
            copyfile([dataPath folder_item(i_folder_item).name],[Output_path new_folder '\'])            
        end
    end
    
return


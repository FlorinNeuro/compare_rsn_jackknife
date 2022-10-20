% Pipline for MEG-PAC Analysis:
% 1. MEG-PAC.m
% 2. megPAC_all.m
% 3. Rearranging_megPAC_MEG.m
% 4. Project data on template brain and spatial smoothing with 7 mm (by hand Brainstorm gui)
% 5. RSpipeline_MEG.m
clear
warning('off','all')

%% link to brainstorm data base
Med_State = 'OFF';
%path for MEG_PAC output
OutputPath=['.../Output/MEG_PAC_' Med_State '_output'];
database= ['.../brainstorm_db/database_' Med_State '/'];
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

%%
% low frequencies
flow1 = [2 30];
% high frequencies
gamma_lowend=80;
gamma_low_high_end=150;
% blocks to save RAM, less blocks more RAM is needed
blocks=100;
% path to brainstorm code
pathStr = '.../brainstorm3/';
addpath(genpath(pathStr));
% path to RSN code
pathStr = '.../hilbert-ica-rsn';
addpath(genpath(pathStr));

%%
for iSubj=1:size(subject,1) %loop over subjects
    for sourcediv=1:blocks+1 %loop over source_blocks
        Trigger_Bad=[];
        Data=[];
        iCond=[];

        for irun=1:length(subject{iSubj,2}) % loop over runs
        iCond=[];
        % Loading the data

        Files=dir(fullfile([database 'data/' subject{iSubj,1} '/'  subject{iSubj,2}{irun}  '/']));
        %% loading the imaging Kernel
        for iFile=1:length(Files)
            if ~isempty(strfind(Files(iFile).name, 'results_PNAI_'))
                Kernel = load ([database 'data/' subject{iSubj,1} '/' subject{iSubj,2}{irun} '/' Files(iFile).name]);
            end
        end

        for i=1:length(Files)
            if ~isempty(strfind(Files(i).name, 'block'))
                iCond(end+1) = i;
            end
        end
        if length(iCond)>1
            disp('There were more than one datafile')
            quit
        end
        for i = 1:length(iCond)
            data=  load ([database '/data/'  subject{iSubj,1} '/' subject{iSubj,2}{irun} '/' Files(iCond(i)).name]);
            if ~isempty(data)
                sRate = round(abs(1 / (data.Time(2) - data.Time(1)))); %new sampling rate
                if sourcediv<blocks+1 %check if last block, because that one is smaller
                data.F=Kernel.ImagingKernel((sourcediv-1)* floor(size(Kernel.ImagingKernel,1)/blocks)+1:sourcediv* floor(size(Kernel.ImagingKernel,1)/blocks),:)*data.F(Kernel.GoodChannel,:);            
                else
                data.F=Kernel.ImagingKernel((sourcediv-1)* floor(size(Kernel.ImagingKernel,1)/blocks)+1:end,:)*data.F(Kernel.GoodChannel,:);
                end
                for iEvent=1:length(data.Events)
                    if strcmp(data.Events(1,iEvent).label,'BAD')
                        Bad_tmp=(data.Events(1,iEvent).times*sRate)-data.Time(1)*sRate;
                    end
                end

                %% Remove bad segments from time series and change the events accordingly
                BAD=ones(1,size(data.F,2));

                for iBAD=1:length(Bad_tmp)
                    if (Bad_tmp(1,iBAD)-5)>5 && (Bad_tmp(2,iBAD)+5)<size(data.F,2)
                        BAD(Bad_tmp(1,iBAD)-5:Bad_tmp(2,iBAD)+5)=0;
                    elseif (Bad_tmp(1,iBAD)-5)<=5
                        BAD(1:Bad_tmp(2,iBAD)+5)=0;
                    elseif (Bad_tmp(2,iBAD)+5)>=size(data.F,2)
                        BAD(Bad_tmp(1,iBAD)-5:end)=0;
                    end
                end
                %% removes mean block by block

                for iBAD=2:length(Bad_tmp)
                    if (Bad_tmp(1,iBAD)-5)>5 && (Bad_tmp(2,iBAD)+5)<size(data.F,2)
                        meanBaseline = mean(data.F(:,Bad_tmp(2,iBAD-1)+5:Bad_tmp(1,iBAD)-5), 2);
                        % Remove mean
                        data.F(:,Bad_tmp(2,iBAD-1)+5:Bad_tmp(1,iBAD)-5) =  bsxfun(@minus, data.F(:,Bad_tmp(2,iBAD-1)+5:Bad_tmp(1,iBAD)-5), meanBaseline);
                    end
                end

                meanBaseline = mean(data.F(:,1:Bad_tmp(1,1)-5), 2);
                % Remove mean
                data.F(:,1:Bad_tmp(1,1)-5) =  bsxfun(@minus, data.F(:,1:Bad_tmp(1,1)-5), meanBaseline);
                meanBaseline = mean(data.F(:,Bad_tmp(2,length(Bad_tmp))+5:end), 2);
                % Remove mean
                data.F(:,Bad_tmp(2,length(Bad_tmp))+5:end) =  bsxfun(@minus, data.F(:,Bad_tmp(2,length(Bad_tmp))+5:end), meanBaseline);


                meanBaseline = mean(data.F(:,BAD==1), 2);

                %% Remove mean over all good segments. Not necessary
                data.F =  bsxfun(@minus, data.F, meanBaseline);
                Data=[Data data.F(:,BAD==1)];
            else
                sprintf(['missing data in ' Files(iCond(i)).name])
            end
        clear Kernel

        end
        end
        PACestimate_cluster(Data,sRate,flow1,[gamma_lowend gamma_low_high_end],[OutputPath subject{iSubj,1} '_PAC_rest_' Med_State '_' num2str(sourcediv)])
    %     HilbertEnvelope(Data,sRate,frequency_bins, [subject{isubject,1} '_' condition '_' num2str(sourcediv)], OutputPath)
    end
clear Data data sRate meanBaseline BAD Bad_tmp Trigger_Bad
end

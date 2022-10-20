% Pipline for MEG-PAC Analysis:
% 1. MEG-PAC.m
% 2. megPAC_all.m
% 3. Rearranging_megPAC_MEG.m
% 4. Project data on template brain and spatial smoothing with 7 mm
% 5. RSpipeline_MEG.m
clear
warning('off','all')

Med_State = 'OFF';
database= ['.../brainstorm_db/database_' Med_State '/'];
OutputPath=['/Output/megPAC_all/ON_' Med_State]; 
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
%low frequencies
flow1 = [2:0.5:12 14:2:30];
%high frequencies
gamma_lowend=80;
gamma_low_high_end=150;
blocks=100;
% blocks to save RAM, less blocks more RAM is needed
%path to MEG_PAC output
PAC_path=['.../MEG_PAC_' Med_State '_output'];
%path to brainstorm
pathStr = '.../brainstorm3/'; %path to the canolty code
addpath(genpath(pathStr));
% path to RSN code
pathStr = '.../hilbert-ica-rsn';
addpath(genpath(pathStr));

%%
for iSubj=1:size(subject,1) %loop over subjects
    for sourcediv=1:blocks+1 %loop over source_blocks
        Trigger_Bad=[];
        Data=[];
        Kernel =[];
        
        
        for irun=1:length(subject{isubject,2}) % loop over runs
            iCond=[];
            % Loading the data
            
            Files=dir(fullfile([database 'data/' subject{isubject,1} '/'  subject{isubject,2}{irun}  '/']));
            % loading the imaging Kernel
            Kernel =[];
            for iFile=1:length(Files)
                if ~isempty(strfind(Files(iFile).name, 'results_PNAI_'))
                    Kernel = load ([database 'data/' subject{isubject,1} '/' subject{isubject,2}{irun} '/' Files(iFile).name]);
                end
            end
            
            for iFile=1:length(Files)
                if ~isempty(strfind(Files(iFile).name, 'block'))
                    iCond(end+1) = iFile;
                end
            end
            if size(iCond)>1
                disp('There were more than one datafile')
                quit
            end
            for i = 1:length(iCond)
                data=  load ([database '/data/'  subject{isubject,1} '/' subject{isubject,2}{irun} '/' Files(iCond(i)).name]);
                if ~isempty(data)
                    sRate = round(abs(1 / (data.Time(2) - data.Time(1)))); %new sampling rate
                    if sourcediv<blocks+1 %check if last block, because that one is smaller
                        data.F=Kernel.ImagingKernel((sourcediv-1)* floor(size(Kernel.ImagingKernel,1)/blocks)+1:sourcediv* floor(size(Kernel.ImagingKernel,1)/blocks),:)*data.F(Kernel.GoodChannel,:);
                    else
                        data.F=Kernel.ImagingKernel((sourcediv-1)* floor(size(Kernel.ImagingKernel,1)/blocks)+1:end,:)*data.F(Kernel.GoodChannel,:);
                    end
                    for i=1:length(data.Events)
                        
                        if strcmp(data.Events(1,i).label,'BAD')
                            Bad_tmp=(data.Events(1,i).times*sRate)-data.Time(1)*sRate;
                            
                        end
                    end
                    
                    % Remove bad segments from time series and change the events accordingly
                    BAD=ones(1,size(data.F,2));
                    
                    for ll=1:size(Bad_tmp,2)
                        if (Bad_tmp(1,ll)-5)>5 && (Bad_tmp(2,ll)+5)<size(data.F,2)
                            BAD(Bad_tmp(1,ll)-5:Bad_tmp(2,ll)+5)=0;
                        elseif (Bad_tmp(1,ll)-5)<=5
                            BAD(1:Bad_tmp(2,ll)+5)=0;
                        elseif (Bad_tmp(2,ll)+5)>=size(data.F,2)
                            BAD(Bad_tmp(1,ll)-5:end)=0;
                        end
                    end
                    % removes mean block by block
                    
                    for ll=2:size(Bad_tmp,2)
                        if (Bad_tmp(1,ll)-5)>5 && (Bad_tmp(2,ll)+5)<size(data.F,2)
                            meanBaseline = mean(data.F(:,Bad_tmp(2,ll-1)+5:Bad_tmp(1,ll)-5), 2);
                            % Remove mean
                            data.F(:,Bad_tmp(2,ll-1)+5:Bad_tmp(1,ll)-5) =  bsxfun(@minus, data.F(:,Bad_tmp(2,ll-1)+5:Bad_tmp(1,ll)-5), meanBaseline);
                            
                        end
                    end
                    
                    meanBaseline = mean(data.F(:,1:Bad_tmp(1,1)-5), 2);
                    % Remove mean
                    data.F(:,1:Bad_tmp(1,1)-5) =  bsxfun(@minus, data.F(:,1:Bad_tmp(1,1)-5), meanBaseline);
                    meanBaseline = mean(data.F(:,Bad_tmp(2,size(Bad_tmp,2))+5:end), 2);
                    % Remove mean
                    data.F(:,Bad_tmp(2,size(Bad_tmp,2))+5:end) =  bsxfun(@minus, data.F(:,Bad_tmp(2,size(Bad_tmp,2))+5:end), meanBaseline);
                    
                    
                    meanBaseline = mean(data.F(:,BAD==1), 2);
                    
                    % Remove mean over all good segments. Not necessary
                    data.F =  bsxfun(@minus, data.F, meanBaseline);
                    Data=[Data data.F(:,BAD==1)];
                else
                    sprintf(['missing data in ' Files(iCond(i)).name])
                end
                
            end
        end
        % clear Kernel nach letztem run muß gelöscht werden.
        %determine maxPAC for all sources
        load([PAC_path subject{isubject,1} '_PAC_rest_' Med_State '_' num2str(sourcediv) '.mat']);
        ind=find(flow1>=2);
        flow=flow1(ind);
        for PAC_ind=1:size(directPAC,1)
            pactmp=squeeze(directPAC(PAC_ind,ind,:));
            [max_pac,tmp]=max(pactmp,[],2);
            [~,ind2]=max(max_pac);
            
            lowfrequency(PAC_ind)=flow(ind2);
        end
        megPAC_bst( Data, sRate, [subject{isubject,1} '_sd_' num2str(sourcediv)], lowfrequency, Kernel.GoodChannel,OutputPath )
    end %loop over sources
end %loop over subjects
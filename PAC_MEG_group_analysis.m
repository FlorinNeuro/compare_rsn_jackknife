%This pipeline is to get the frequency pairs for the MEG-PAC
%1. PAC_significance_MEG
%2. PAC_MEG_group_analysis
clear
Med_State = 'ON';
datapath1=['.../Output/PAC_Sig_' Med_State '/'];
datapath2=['.../Output/MEG_PAC_' Med_State '_output/'];
% path to RSN code
pathStr = '.../hilbert-ica-rsn';
addpath(genpath(pathStr))

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


PAC_LF_AS=[];
gamma_lowend=80;
gamma_low_high_end=150;
flow1 = [2:0.5:12 14:2:30];
cf_list=make_center_frequencies(1,250,70,0.75); % min_freq, max_freq, numfreqs, min_freq_step
hfreq=find((cf_list>=gamma_lowend) & (cf_list<=gamma_low_high_end));


for iSubj = 1 : size(subjects,2)
    num_samp = 0;
    for iRun=1:length(subject{iSubj,2})
        load(fullfile([database 'data/' subject{iSubj,1} '_PD/'  subject{iSubj,2}{iRun}  '/data_block001.mat']),'Time')
        num_samp = num_samp + size(Time,2);
        clear Time
    end
    subject_new{iSubj,1} = subjects{iSubj};
    subject_new{iSubj,2} = ['Sig_dl_' mat2str(num_samp) '_' subjects{iSubj}];
end


for subjectind=1:size(subject_new,1)
Anatomy=[database 'anat/' subject_new{subjectind,1} '_PD/' ];
% if subjectind == 1
%     interp2= load ([Anatomy 'tess_cortex_white_low.mat']);
% else    
%     interp2= load ([Anatomy 'tess_cortex_pial_low.mat']);
% end
interp2= load ([Anatomy 'tess_cortex_pial_low.mat']);
noisePAC=load([datapath1 subject_new{subjectind,2}]);

for k=4:size(noisePAC.modest,2)
    for l=1:size(noisePAC.modest,3)
        Percer(k-3,l)=prctile(noisePAC.modest(:,k,l),95);
    end
end
for k=1:101
    
    mod2dDirectEst_all{k}=load([datapath2 subject_new{subjectind,1} '_PD_' Med_State '/' subject_new{subjectind,1} '_PD_PAC_rest_' num2str(k) '.mat' ]);
end

for k=1:101
    sources=size(mod2dDirectEst_all{k}.directPAC,1);%%%hier mod2directall in directPAC geändert
    PAC_low{k}=zeros(1,sources);
    PAC_frequency_low{k}=zeros(1,sources);
    PAC_frequency_high{k}=zeros(1,sources);
    
    for source=1:sources
        [max_pac,tmp]=max(squeeze(mod2dDirectEst_all{k}.directPAC(source,4:end,:)),[],2);%%%hier mod2directall in directPAC geändert
        
        [PAC_low{k}(source),PAC_frequency_low{k}(source)]=max(max_pac);
        if (PAC_low{k}(source))>Percer(PAC_frequency_low{k}(source),tmp(PAC_frequency_low{k}(source)))
            PAC_significance{k}(source)=1;
            PAC_frequency_high{k}(source)=cf_list(hfreq(1)-1+tmp(PAC_frequency_low{k}(source)));
            
            PAC_frequency_low{k}(source)=flow1(PAC_frequency_low{k}(source));
            
        else
            PAC_frequency_low{k}(source)=0;
            PAC_frequency_high{k}(source)=0;
            PAC_low{k}(source)=0;
        end
        
    end
end
PAC_frequency_low_all=[];
PAC_frequency_high_all=[];
PAC_low_all=[];
for k=1:101
    PAC_frequency_low_all= [PAC_frequency_low_all PAC_frequency_low{k}];
    PAC_frequency_high_all= [PAC_frequency_high_all PAC_frequency_high{k}];
    
    PAC_low_all=[PAC_low_all PAC_low{k}];
end
tmp=PAC_frequency_low_all*interp2.tess2tess_interp.Wmat';

kernelMat.ImageGridAmp = [PAC_frequency_low_all; PAC_frequency_low_all]';
kernelMat.Comment      = [ subject_new{subjectind,1} '\PAC_lowfrequency'];
kernelMat.sRate      = 1;
kernelMat.ImageGridTime         =1:2;
kernelMat.DataFile=[];
kernelMat.Time         = 1:2;
kernelMat.SurfaceFile=[subject_new{subjectind,1} '\tess_cortex_pial_low.mat'];
kernelMat.HeadModelType='surface';

% Output filename
OPTIONS.ResultFile = fullfile([ database 'data/' subject_new{subjectind,1} '_PD/megPAC_MEG_' Med_State], ['results_' subject_new{subjectind,1} '_PAC_lowf' ] );
% Save file
save(OPTIONS.ResultFile, '-struct', 'kernelMat');


kernelMat.ImageGridAmp = [PAC_frequency_high_all; PAC_frequency_high_all]';
kernelMat.Comment      = [ subject_new{subjectind,1} '\PAC_highfrequency'];
kernelMat.sRate      = 1;
kernelMat.ImageGridTime         =1:2;
kernelMat.DataFile=[];
kernelMat.Time         = 1:2;
kernelMat.SurfaceFile=[subject_new{subjectind,1} '\tess_cortex_pial_low.mat'];
kernelMat.HeadModelType='surface';

% Output filename
OPTIONS.ResultFile = fullfile([ database 'data/' subject_new{subjectind,1} '_PD/megPAC_MEG_' Med_State], ['results_' subject_new{subjectind,1} 'PAC_highf' ] );
% Save file
save(OPTIONS.ResultFile, '-struct', 'kernelMat');

kernelMat.ImageGridAmp = [PAC_low_all; PAC_low_all]';
kernelMat.Comment      = [ subject_new{subjectind,1} '\PAc Value'];
kernelMat.sRate      = 1;
kernelMat.ImageGridTime         =1:2;
kernelMat.DataFile=[];
kernelMat.Time         = 1:2;
kernelMat.SurfaceFile=[subject_new{subjectind,1} '\tess_cortex_pial_low.mat'];
kernelMat.HeadModelType='surface';

% Output filename
OPTIONS.ResultFile = fullfile([ database 'data/' subject_new{subjectind,1} '_PD/megPAC_MEG_' Med_State], ['results_' subject_new{subjectind,1} 'PAC_value' ] );
% Save file
save(OPTIONS.ResultFile, '-struct', 'kernelMat');




PAC_LF_AS=[PAC_LF_AS; tmp];

end
%%
PAC_LF_AS(PAC_LF_AS<1)=NaN;
MedianData=nanmedian(PAC_LF_AS,2);
MeanData=nanmean(PAC_LF_AS,1);


kernelMat.ImageGridAmp = [MeanData; MeanData]';
kernelMat.Comment      = ['Mean ' mat2str(size(subjects,2)) ' subjects without nonsignificant parts  low frequency'];
kernelMat.sRate      = 1;
kernelMat.ImageGridTime         = 1:2;
kernelMat.DataFile=[];
kernelMat.Time         = 1:2;
 kernelMat.SurfaceFile='@default_subject/tess_cortex_pial_low.mat';
kernelMat.HeadModelType='surface';
c = clock;
strTime = sprintf('_%02.0f%02.0f%02.0f_%02.0f%02.0f', c(1)-2000, c(2:5));
% Output filename
OPTIONS.ResultFile = fullfile(database, ['\data\Group_analysis\PAC_MEG_' Med_State '\results_mean_lf_' mat2str(size(subjects,2)) 'subjects_low_f_' strTime '.mat']);
% Save file
save(OPTIONS.ResultFile, '-struct', 'kernelMat');
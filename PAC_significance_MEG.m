%This pipeline is to get the frequency pairs for the MEG-PAC
%1. PAC_significance_MEG
%2. PAC_MEG_group_analysis
clear
Med_State = 'OFF';
OutputFiles=['.../Output/PAC_Sig_' Med_State '/'];
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
for iSubj = 1 : size(subjects,2)
    subject_ID=subjects{iSubj};
    flow1 = [0.5:0.5:12 14:2:30];
    gamma_lowend=80;
    gamma_low_high_end=150;

    sRate=1000;
    run_subject=subjects{iSubj};
    num_samp = 0;
    for iRun=1:length(subject{iSubj,2})
        load(fullfile([database 'data/' subject{iSubj,1} '/'  subject{iSubj,2}{iRun}  '/data_block001.mat']),'Time')
        num_samp = num_samp + size(Time,2);
        clear Time
    end

    for i=1:100
    [~,theta] = phase_noise(num_samp, 1,-1,100);
    [~,~,modest(i,:,:)]= PACestimate_cluster (theta,sRate,[0.5 30],[gamma_lowend gamma_low_high_end],[OutputFiles subject_ID '_PAC_rand']);
       %[maxPAC , nestingFreq, directPAC,hfreq] = PACestimate_cluster (theta,sRate,[0.5 30],[gamma_lowend gamma_low_high_end],[OutputFiles subject_ID '_PAC_rand']);
    % PACestimate_cluster(Data,sRate,flow1,[gamma_lowend gamma_low_high_end],[OutputPath subject{isubject,1} '_PAC_rest_' num2str(sourcediv)])

    end
    save([OutputFiles 'Sig_dl_' num2str(num_samp) '_' run_subject])
end
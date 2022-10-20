%% This script is used to determine the positions of HPI coils and an 
%  MEG sensor and to check for differences between runs and conditions.
%  Matthias Sure
%%
clear
Cond = 'Peri_ON';
med_state = 'ON';
switch med_state
    case 'ON'
    %% ON
    database1=['.../brainstorm_db/database_' med_state '/'];
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
    database1=['.../brainstorm_db/database_' med_state '/'];
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
    for iRun= 1 : length(subject{iSubj,2})
        load([database1 'data/' subject{iSubj,1} '/'  subject{iSubj,2}{iRun} '/channel_vectorview306_acc1.mat'],'HeadPoints','Channel')
        HPI_Index = find(strcmp(HeadPoints.Type, 'HPI'));
        Channel_Index = find(strcmp({Channel.Name}, 'MEG0711'));
        
        Position.(Cond).(subjects{iSubj}).(['Run_' mat2str(iRun)]).HPI = HeadPoints.Loc(:,HPI_Index);
        Position.(Cond).(subjects{iSubj}).(['Run_' mat2str(iRun)]).Channel = Channel(Channel_Index).Loc;
      
    end
end

%% OFF
Cond = 'Peri_OFF';
med_state = 'OFF';
switch med_state
    case 'ON'
    %% ON
    database1=['.../brainstorm_db/database_' med_state '/'];
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
    database1=['.../brainstorm_db/database_' med_state '/'];
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
    for iRun= 1 : length(subject{iSubj,2})
        load([database1 'data/' subject{iSubj,1} '/'  subject{iSubj,2}{iRun} '/channel_vectorview306_acc1.mat'],'HeadPoints','Channel')
        HPI_Index = find(strcmp(HeadPoints.Type, 'HPI'));
        Channel_Index = find(strcmp({Channel.Name}, 'MEG0711'));
        
        Position.(Cond).(subjects{iSubj}).(['Run_' mat2str(iRun)]).HPI = HeadPoints.Loc(:,HPI_Index);
        Position.(Cond).(subjects{iSubj}).(['Run_' mat2str(iRun)]).Channel = Channel(Channel_Index).Loc;      
    end
end


%%
Conditions = {'Pre_OFF','Pre_ON','Peri_OFF','Peri_ON'};
subjects = {'S001','S003','S004','S008','S009','S010','S011','S012','S013','S014','S016','S020','S021','S022','S023','S025','S027','S028','S029','S032','S033','S034','S036','S037','S038','S041','S043'};
n = 0;
P = [];
Diff1 = []; Diff2 = [];
for iCond = 1 : size(Conditions,2)% loop over the condition for which data is present
    if 1%strcmp(Channel(iChan).Type,'MEG MAG') 
        Data_HPI_1 = [];% Position from the first run 
        Data_HPI_2 = [];% Position from the last run
        Data_Channel_1 = [];% Position from the first run
        Data_Channel_2 = [];% Position from the last run
        Cond = Conditions{iCond};
        for iSubj = 1 : size(subjects,2)
            try
        % %         max_Run = mat2str(size(fields(Position.(Cond).(subjects{iSubj})),1));
        % %         Data_HPI_1(:,iSubj) = mean(Position.(Cond).(subjects{iSubj}).('Run_1').HPI,2);
        % %         Data_Channel_1(:,iSubj) = mean(Position.(Cond).(subjects{iSubj}).('Run_1').Channel,2);
        % %         Data_HPI_2(:,iSubj) = mean(Position.(Cond).(subjects{iSubj}).(['Run_' max_Run]).HPI,2);
        % %         Data_Channel_2(:,iSubj) = mean(Position.(Cond).(subjects{iSubj}).(['Run_' max_Run]).Channel,2); 

                max_Run = mat2str(size(fields(Position.(Cond).(subjects{iSubj})),1));
                Data_HPI_1(:,iSubj) = mean(Position.(Cond).(subjects{iSubj}).('Run_1').HPI(3,:),2);
                Data_Channel_1(:,iSubj) = mean(Position.(Cond).(subjects{iSubj}).('Run_1').Channel(3,:),2);
                Data_HPI_2(:,iSubj) = mean(Position.(Cond).(subjects{iSubj}).(['Run_' max_Run]).HPI(3,:),2);
                Data_Channel_2(:,iSubj) = mean(Position.(Cond).(subjects{iSubj}).(['Run_' max_Run]).Channel(3,:),2); 
            catch
        %         Data_HPI_1(:,iSubj) = [NaN;NaN;NaN];
        %         Data_Channel_1(:,iSubj) = [NaN;NaN;NaN];
        %         Data_HPI_2(:,iSubj) = [NaN;NaN;NaN];
        %         Data_Channel_2(:,iSubj) = [NaN;NaN;NaN];


                Data_HPI_1(:,iSubj) = [NaN];
                Data_Channel_1(:,iSubj) = [NaN];
                Data_HPI_2(:,iSubj) = [NaN];
                Data_Channel_2(:,iSubj) = [NaN];        
            end
        end
        diff_1 = Data_HPI_1-Data_Channel_1;
        diff_2 = Data_HPI_2-Data_Channel_2;
        Diff1 = [Diff1 diff_1];
        Diff2 = [Diff2 diff_2];
        [h,p,CI,STATS] = ttest(diff_1,diff_2);
        n = n +1;
        P(n) = p;
        T(n) = STATS.tstat;
        DF(n) = STATS.df;
    end
end
[h,p,CI,STATS] = ttest(Diff1,Diff2)


%% compare conditions
Cond1 = 'Peri_OFF'; Cond1_name = 'Peri-OFF';
Cond2 = 'Pre_OFF'; Cond2_name = 'Pre-OFF';
Conditions = {'Pre_OFF','Pre_ON','Peri_OFF','Peri_ON'};
subjects = {'S001','S003','S004','S008','S009','S010','S011','S012','S013','S014','S016','S020','S021','S022','S023','S025','S027','S028','S029','S032','S033','S034','S036','S037','S038','S041','S043'};
n = 0;
P = [];
Diff1 = []; Diff2 = [];


Data_HPI_1 = []; Data_HPI_2 = [];
Data_Channel_1 = []; Data_Channel_2 = [];
Cond = Conditions{iCond};
n1 = 0; n2 = 0;
for iSubj = 1 : size(subjects,2)
    if ~isfield(Position.(Cond1),subjects{iSubj})
        Position.(Cond1).(subjects{iSubj}) = struct;
    end
    if ~isfield(Position.(Cond2),subjects{iSubj})
        Position.(Cond2).(subjects{iSubj}) = struct;
    end      
    for iField = 1 : size(fields(Position.(Cond1).(subjects{iSubj})),1)
        n1 = n1 + 1;
        Data_HPI_1(:,n1) = mean(Position.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).HPI(3,:),2);
        Data_Channel_1(:,n1) = mean(Position.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).Channel(3,:),2);   
    end
    for iField = 1 : size(fields(Position.(Cond2).(subjects{iSubj})),1)
        n2 = n2 + 1;
        Data_HPI_2(:,n2) = mean(Position.(Cond2).(subjects{iSubj}).(['Run_' mat2str(iField)]).HPI(3,:),2);
        Data_Channel_2(:,n2) = mean(Position.(Cond2).(subjects{iSubj}).(['Run_' mat2str(iField)]).Channel(3,:),2);   
    end     
end

[h,p,CI,STATS] = ttest2(Data_HPI_1 - Data_Channel_1,Data_HPI_2 - Data_Channel_2,'Alpha',0.05/4)
% % diff_1 = Data_HPI_1-Data_Channel_1;
% % diff_2 = Data_HPI_2-Data_Channel_2;
% % Diff1 = [Diff1 diff_1];
% % Diff2 = [Diff2 diff_2];
% % [h,p,CI,STATS] = ttest(diff_1,diff_2);
% % n = n +1;
% % P(n) = p;
% % 
% % 
% % [h,p,CI,STATS] = ttest(Diff1,Diff2)
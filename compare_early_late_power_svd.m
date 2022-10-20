% This script is to determine differences in power spectra based on scouts
% 1. collect the power spectra
% 2. normalize by the total power if needed
% 3. compare the between runs or between condition
% 3a. compare the power for each frequency
% 3b. compare the power for frequency bands
% Matthias Sure
clear
Output_path = '...';
%load scouts from the Mindboogle atals
load('...\brainstorm_db\database\anat\@default_subject\tess_cortex_pial_low.mat', 'Atlas')
Scoutsname = 'Mindboggle';
for iScout = 1 : size(Atlas,2)
    if contains(Atlas(iScout).Name,Scoutsname)
        Scouts = Atlas(iScout).Scouts;
    end
end

%subject IDs
subjects = {'S001','S002','S003','...'};
%empty struct for mean power values
Power = struct;
%empty struct for normalized mean power values
Power_normalized = struct;

%% get the power (mean or svd of the power of the selected scout) 
Cond = 'Peri_OFF';
cd(['...\brainstorm_db\database\data\Group_analysis\Power_Spectra_' Cond])
Files = dir;
for iFile = 1 : size(Files,1)
    if ~contains(Files(iFile).name,'timefreq')
        continue
    end
    Subject_index = find(contains(subjects,Files(iFile).name(23:26)));
    Run_index = (Files(iFile).name(end-4));
    load(Files(iFile).name,'TF','RowNames','Freqs')
    TF = squeeze(TF);
    for iScout = 1 : size(Scouts,2)
        Scout_name = replace(Scouts(iScout).Label,' ','_');
        % get the powerspectra of all vertices
        %  Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = TF(Scouts(iScout).Vertices,:);
        % get the mean powerspectra of all vertices
        % Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = mean(TF(Scouts(iScout).Vertices,:));
        % get the svd of the powerspectra of all vertices
        temp_pca = pca(TF(Scouts(iScout).Vertices,:));
        Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = temp_pca(:,1);
    end
    
end


Cond = 'Peri_ON';
cd(['...\brainstorm_db\database\data\Group_analysis\Power_Spectra_' Cond])
Files = dir;
for iFile = 1 : size(Files,1)
    if ~contains(Files(iFile).name,'timefreq')
        continue
    end
    Subject_index = find(contains(subjects,Files(iFile).name(23:26)));
    Run_index = (Files(iFile).name(end-4));
    load(Files(iFile).name,'TF','RowNames')
    TF = squeeze(TF);
    for iScout = 1 : size(Scouts,2)
        Scout_name = replace(Scouts(iScout).Label,' ','_');
        % get the powerspectra of all vertices
        %  Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = TF(Scouts(iScout).Vertices,:);
        % get the mean powerspectra of all vertices
        % Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = mean(TF(Scouts(iScout).Vertices,:));
        % get the svd of the powerspectra of all vertices
        temp_pca = pca(TF(Scouts(iScout).Vertices,:));
        Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = temp_pca(:,1);
    end
    
end

Cond = 'Pre_ON';
cd(['...\brainstorm_db\database\data\Group_analysis\Power_Spectra_' Cond])
Files = dir;
for iFile = 1 : size(Files,1)
    if ~contains(Files(iFile).name,'timefreq')
        continue
    end
    Subject_index = find(contains(subjects,Files(iFile).name(23:26)));
    Run_index = (Files(iFile).name(end-4));
    load(Files(iFile).name,'TF','RowNames')
    TF = squeeze(TF);
    for iScout = 1 : size(Scouts,2)
        Scout_name = replace(Scouts(iScout).Label,' ','_');
        % get the powerspectra of all vertices
        %  Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = TF(Scouts(iScout).Vertices,:);
        % get the mean powerspectra of all vertices
        % Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = mean(TF(Scouts(iScout).Vertices,:));
        % get the svd of the powerspectra of all vertices
        temp_pca = pca(TF(Scouts(iScout).Vertices,:));
        Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = temp_pca(:,1);
    end
    
end

Cond = 'Pre_OFF';
cd(['...\brainstorm_db\database\data\Group_analysis\Power_Spectra_' Cond])
Files = dir;
for iFile = 1 : size(Files,1)
    if ~contains(Files(iFile).name,'timefreq')
        continue
    end
    Subject_index = find(contains(subjects,Files(iFile).name(23:26)));
    Run_index = (Files(iFile).name(end-4));
    load(Files(iFile).name,'TF','RowNames')
    TF = squeeze(TF);
    for iScout = 1 : size(Scouts,2)
        Scout_name = replace(Scouts(iScout).Label,' ','_');
        % get the powerspectra of all vertices
        %  Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = TF(Scouts(iScout).Vertices,:);
        % get the mean powerspectra of all vertices
        % Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = mean(TF(Scouts(iScout).Vertices,:));
        % get the svd of the powerspectra of all vertices
        temp_pca = pca(TF(Scouts(iScout).Vertices,:));
        Power.(Cond).(subjects{Subject_index}).(['Run_' Run_index]).(Scout_name) = temp_pca(:,1);
    end
    
end

%% normalize by total power
Cond1 = 'Peri_ON';

for iScout = 1 : size(Scouts,2)
    Scout_name = replace(Scouts(iScout).Label,' ','_');
    for iSubj = 1 : size(subjects,2)
        if ~isfield(Power.(Cond1),subjects{iSubj})
            Power.(Cond1).(subjects{iSubj}) = struct;
        end     
        for iField = 1 : size(fields(Power.(Cond1).(subjects{iSubj})),1)
            Power_normalized.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name) = Power.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name)/nansum(Power.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name));
        end     
    end

end

Cond1 = 'Peri_OFF';
for iScout = 1 : size(Scouts,2)
    Scout_name = replace(Scouts(iScout).Label,' ','_');
    for iSubj = 1 : size(subjects,2)
        if ~isfield(Power.(Cond1),subjects{iSubj})
            Power.(Cond1).(subjects{iSubj}) = struct;
        end     
        for iField = 1 : size(fields(Power.(Cond1).(subjects{iSubj})),1)
            Power_normalized.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name) = Power.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name)/nansum(Power.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name));
        end     
    end

end

Cond1 = 'Pre_ON';
for iScout = 1 : size(Scouts,2)
    Scout_name = replace(Scouts(iScout).Label,' ','_');
    for iSubj = 1 : size(subjects,2)
        if ~isfield(Power.(Cond1),subjects{iSubj})
            Power.(Cond1).(subjects{iSubj}) = struct;
        end     
        for iField = 1 : size(fields(Power.(Cond1).(subjects{iSubj})),1)
            Power_normalized.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name) = Power.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name)/nansum(Power.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name));
        end     
    end

end

Cond1 = 'Pre_OFF';
for iScout = 1 : size(Scouts,2)
    Scout_name = replace(Scouts(iScout).Label,' ','_');
    for iSubj = 1 : size(subjects,2)
        if ~isfield(Power.(Cond1),subjects{iSubj})
            Power.(Cond1).(subjects{iSubj}) = struct;
        end     
        for iField = 1 : size(fields(Power.(Cond1).(subjects{iSubj})),1)
            Power_normalized.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name) = Power.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name)/nansum(Power.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name));
        end     
    end

end


%% test for differnces in single frequencies
%% compare the first and the last run
Cond = 'Peri_ON';
H = [];
P = [];
T = [];
Sign_map = [];
Scouts_of_interst = {'lateraloccipital_L','lateraloccipital_R','inferiorparietal_L','inferiorparietal_R','superiorparietal_L','superiorparietal_R'};
for iScout = 1 : size(Scouts_of_interst,2)
    for iSubj = 1 : size(subjects,2)
        try
            max_Run = mat2str(size(fields(Power_normalized.(Cond).(subjects{iSubj})),1));
            Data(iSubj,1) = mean(Power_normalized.(Cond).(subjects{iSubj}).('Run_1').(Scouts_of_interst{iScout})(1:4));
            Data(iSubj,2) = mean(Power_normalized.(Cond).(subjects{iSubj}).(['Run_' max_Run]).(Scouts_of_interst{iScout})(1:4));
        catch
            Data(iSubj,1) = NaN;
            Data(iSubj,2) = NaN;
        end
    end
    [h,p,CI,STATS] = ttest(Data(:,1),Data(:,2));
    STATS.tstat
    % only show significant results
    if h == 1
        [h,p,CI,STATS] = ttest(Data(:,1),Data(:,2))
        H = [H;h];
        P = [P;p];
        T = [T;max(abs(STATS.tstat))];
        
        Sign_map = [Sign_map; (nanmean(Data(:,1))>nanmean(Data(:,2))) + (nanmean(Data(:,1))<nanmean(Data(:,2)))*-1];        
    end
end

%% compare conditions
Cond1 = 'Pre_ON'; Cond1_name = 'Pre-ON';
Cond2 = 'Peri_ON'; Cond2_name = 'Post-ON';
clear Data1 Data2
H = [];
P = [];
T = [];
Sign_map = [];
for iScout = 1 : size(Scouts,2)
    Scout_name = replace(Scouts(iScout).Label,' ','_');
    n1 = 0;
    n2 = 0;
    for iSubj = 1 : size(subjects,2)
        if ~isfield(Power_normalized.(Cond1),subjects{iSubj})
            Power_normalized.(Cond1).(subjects{iSubj}) = struct;
        end
        if ~isfield(Power_normalized.(Cond2),subjects{iSubj})
            Power_normalized.(Cond2).(subjects{iSubj}) = struct;
        end        
        for iField = 1 : size(fields(Power_normalized.(Cond1).(subjects{iSubj})),1)
            if size(Power_normalized.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name),1) ~= 2001
                continue 
            end            
            n1 = n1 + 1;
            Data1(n1,:) = Power_normalized.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name);
        end
        for iField = 1 : size(fields(Power_normalized.(Cond2).(subjects{iSubj})),1)
            if size(Power_normalized.(Cond2).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name),1) ~= 2001
                continue 
            end
            n2 = n2 + 1;
            Data2(n2,:) = Power_normalized.(Cond2).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name);
        end        
    end
    [h,p,CI,STATS] = ttest2(Data1,Data2,'Alpha',0.05/(62*150*4));
    H = [H;h];
    P = [P;p];
    T = [T;max(abs(STATS.tstat))];
    Sign_map = [Sign_map; (nanmean(Data1)>nanmean(Data2)) + (nanmean(Data1)<nanmean(Data2))*-1];

end
f = figure;
f.Position = [10 10 1000 900];
colormap( f , [0 0 1; 1 1 1; 1 0 0] )
imagesc(H(:,2:601).*Sign_map(:,2:601))
yticks([1:size(Scouts,2)])
yticklabels({Scouts.Label})
ylabel('Scout names')
xticks([1:20:600])
xticklabels(Freqs(1:20:600))
xlabel('Freuency in Hz')
title([Cond2_name ' vs. ' Cond1_name])
set(gca,'FontSize',10, 'FontWeight', 'bold')
% set(gca,'LooseInset',get(gca,'TightInset')); % removing extra white space in figure
exportgraphics(gca,[Output_path '\Power_spectra_' Cond1_name ' vs. ' Cond2_name '.pdf'],'Resolution',500)

%% test for differences in frequency bands
%% compare the first and the last run
Cond = 'Pre_OFF';
Freqs = [0:0.25:500];
freq_band = [8 12];

Scouts_of_interst = {'lateraloccipital_L','lateraloccipital_R','inferiorparietal_L','inferiorparietal_R','superiorparietal_L','superiorparietal_R'};
for iScout = 1 : size(Scouts_of_interst,2)
    for iSubj = 1 : size(subjects,2)
        try
            max_Run = mat2str(size(fields(Power_normalized.(Cond).(subjects{iSubj})),1));
            Data(iSubj,1) = mean(Power_normalized.(Cond).(subjects{iSubj}).('Run_1').(Scouts_of_interst{iScout})(find(Freqs == freq_band(1)):find(Freqs == freq_band(2))));
            Data(iSubj,2) = mean(Power_normalized.(Cond).(subjects{iSubj}).(['Run_' max_Run]).(Scouts_of_interst{iScout})(find(Freqs == freq_band(1)):find(Freqs == freq_band(2))));
        catch
            Data(iSubj,1) = NaN;
            Data(iSubj,2) = NaN;
        end
    end
    [h,p,CI,STATS] = ttest(Data(:,1),Data(:,2));
    STATS.tstat
    % only show significant results
    if h == 1
        [h,p,CI,STATS] = ttest(Data(:,1),Data(:,2))
    end
end

%% compare conditions
Cond1 = 'Peri_ON'; Cond1_name = 'Post-ON';
Cond2 = 'Pre_ON'; Cond2_name = 'Pre-ON';
clear Data1 Data2
H = [];
P = [];
T = [];
Sign_map = [];
bands = [1 4; 4 8; 8 12; 12 35; 35 100];
bands = [8 12];
for iFreq = 1 : size(bands,1)
    for iScout = 1 : size(Scouts,2)
        Scout_name = replace(Scouts(iScout).Label,' ','_');
        n1 = 0;
        n2 = 0;
        for iSubj = 1 : size(subjects,2)
            if ~isfield(Power_normalized.(Cond1),subjects{iSubj})
                Power_normalized.(Cond1).(subjects{iSubj}) = struct;
            end
            if ~isfield(Power_normalized.(Cond2),subjects{iSubj})
                Power_normalized.(Cond2).(subjects{iSubj}) = struct;
            end        
            for iField = 1 : size(fields(Power_normalized.(Cond1).(subjects{iSubj})),1)
                if size(Power_normalized.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name),1) ~= 2001
                    continue 
                end            
                n1 = n1 + 1;
                Data1(n1,:) = mean(Power_normalized.(Cond1).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name)(find(Freqs == bands(iFreq,1)):find(Freqs == bands(iFreq,2))));
            end
            for iField = 1 : size(fields(Power_normalized.(Cond2).(subjects{iSubj})),1)
                if size(Power_normalized.(Cond2).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name),1) ~= 2001
                    continue 
                end
                n2 = n2 + 1;
                Data2(n2,:) = mean(Power_normalized.(Cond2).(subjects{iSubj}).(['Run_' mat2str(iField)]).(Scout_name)(find(Freqs == bands(iFreq,1)):find(Freqs == bands(iFreq,2))));
            end        
        end
        [h,p,CI,STATS] = ttest2(Data1,Data2,'Alpha',0.05/(62*1*4));
        H(iFreq,iScout) = [h];
        P(iFreq,iScout) = [p];
        T(iFreq,iScout) = [max(abs(STATS.tstat))];
        Sign_map(iFreq,iScout) = [(nanmean(Data1)>nanmean(Data2)) + (nanmean(Data1)<nanmean(Data2))*-1];

    end
end
f = figure;
f.Position = [10 10 1000 900];
colormap( f , [0 0 1; 1 1 1; 1 0 0] )
imagesc(H(:,2:601).*Sign_map(:,2:601))
yticks([1:size(Scouts,2)])
yticklabels({Scouts.Label})
ylabel('Scout names')
xticks([1:20:600])
xticklabels(Freqs(1:20:600))
xlabel('Freuency in Hz')
title([Cond2_name ' vs. ' Cond1_name])
set(gca,'FontSize',10, 'FontWeight', 'bold')
% set(gca,'LooseInset',get(gca,'TightInset')); % removing extra white space in figure
% exportgraphics(gca,[Output_path '\Power_spectra_' Cond1_name ' vs. ' Cond2_name '.pdf'],'Resolution',500)
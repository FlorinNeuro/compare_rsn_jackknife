%% This script is for perfomring a three way Anova on the PAC values of the RSN
% Matthias Sure
close all
clear
Output_path = '...\Output\RSN_frequencys\';
Parameter = {'PAC_value','PAC_lowf','PAC_highf'};
Anova_P = [];
Eta_2 = [];
for iPara = 1 : 3%size(Parameter,2)
    Eta_2 = [];
    % read in the table with all burst information
    % first collumn will be the values
    % second collumn will indicate the 9 Scout Regions
    % third collumn will indicatite the Condition (1 = peri; 2 = pre;)
    % fourth collumn will indicate the medication state (1 = OFF; 2 = ON;)
    PAC_table = table2array(readtable([Output_path 'RSN_frequencys\PAC_freq_' Parameter{iPara} '_Anova_table.xlsx']));
    PAC_values = PAC_table(:,1); 
    PAC_group_1 = PAC_table(:,2); %Contact orientation
    PAC_group_2 = PAC_table(:,3); %Frequency band
    PAC_group_3 = PAC_table(:,4); %Medication state
    groups = {'Region','Condition','Medication'};
    Medication = {'OFF','ON'};
    Region = {'Visual','Front_Occ','DMN','Motor'};
    Condition = {'peri','pre'};

    %% calculate the three way anova
    [p,t,stats] = anovan(PAC_values,{PAC_group_1,PAC_group_2,PAC_group_3},'model','full','varnames',groups);
    Eta_2 = [Eta_2 ([t{2:8,2}]./([t{2:8,2}]+[t{9,2}]))'];%% Calculate the Effect size
    Anova_P = [Anova_P p];% p values
    t{1,8} = 'Eta2';
    for iEta2 = 1 : size(Eta_2,1)
        t{1+iEta2,8} = Eta_2(iEta2);
    end
    Anova_table = cell2table(t);
    % posthoc Analysis
    [results,m,h,gnames] = multcompare(stats,'Dimension',[1 2 3],'CType','bonferroni');
    %% Create a matrix to show all test combinations
    compare_mat = zeros(size(Region,2)*size(Condition,2)*size(Medication,2),size(groups,2));
    n = 0;
    for iMed = 1 : size(Medication,2)
        for iFreq = 1 : size(Condition,2)
            for iCon = 1 : size(Region,2)
                n = n + 1;
                compare_mat(n,:) = [iCon,iFreq,iMed];
            end
        end
    end
    %% Write the posthoc analysis in a readable table
    for iResults = 1 : size(results,1)
        find_dif = compare_mat(results(iResults,1),:) - compare_mat(results(iResults,2),:);
        if find_dif(1,1) ~= 0 & find_dif(1,2) == 0 & find_dif(1,3) == 0
            %%Unterschied bei den Kontakten
            sprintf('Die %s unterscheided sich %s, %s zwischen %s und %s mit p = %0.5e', ...
                Parameter{iPara}, Condition{compare_mat(results(iResults,1),2)}, Medication{compare_mat(results(iResults,1),3)}, ...
                Region{compare_mat(results(iResults,1),1)},Region{compare_mat(results(iResults,2),1)},results(iResults,6))
            try
                temp_table = table({Parameter{iPara}},{Condition{compare_mat(results(iResults,1),2)}}, ...
                    {Medication{compare_mat(results(iResults,1),3)}}, ...
                    {[Region{compare_mat(results(iResults,1),1)} 'vs' Region{compare_mat(results(iResults,2),1)}]}, ...
                    results(iResults,4),results(iResults,6),'VariableNames',{'Parameter','Gruppe 1','Gruppe 2','Test zwischen', ...
                    'Mean: Differenz','p'});
                Post_Hoc_table(end+1,:) = temp_table;
            catch
                Post_Hoc_table = table({Parameter{iPara}},{Condition{compare_mat(results(iResults,1),2)}}, ...
                    {Medication{compare_mat(results(iResults,1),3)}}, ...
                    {[Region{compare_mat(results(iResults,1),1)} 'vs' Region{compare_mat(results(iResults,2),1)}]}, ...
                    results(iResults,4),results(iResults,6),'VariableNames',{'Parameter','Gruppe 1','Gruppe 2','Test zwischen', ...
                    'Mean: Differenz','p'});
            end
        elseif find_dif(1,1) == 0 & find_dif(1,2) ~= 0 & find_dif(1,3) == 0
            %%Unterschied bei der Frequenz
            sprintf('Die %s unterscheided sich %s, %s zwischen %s und %s mit p = %0.5e', ...
                Parameter{iPara}, Region{compare_mat(results(iResults,1),1)}, Medication{compare_mat(results(iResults,1),3)}, ...
                Condition{compare_mat(results(iResults,1),2)},Condition{compare_mat(results(iResults,2),2)},results(iResults,6))
            try
                temp_table = table({Parameter{iPara}},{Region{compare_mat(results(iResults,1),1)}}, ...
                    {Medication{compare_mat(results(iResults,1),3)}}, ...
                    {[Condition{compare_mat(results(iResults,1),2)} 'vs' Condition{compare_mat(results(iResults,2),2)}]}, ...
                    results(iResults,4),results(iResults,6),'VariableNames',{'Parameter','Gruppe 1','Gruppe 2','Test zwischen', ...
                    'Mean: Differenz','p'});
                Post_Hoc_table(end+1,:) = temp_table;
            catch
                Post_Hoc_table = table({Parameter{iPara}},{Region{compare_mat(results(iResults,1),1)}}, ...
                    {Medication{compare_mat(results(iResults,1),3)}}, ...
                    {[Condition{compare_mat(results(iResults,1),2)} 'vs' Condition{compare_mat(results(iResults,2),2)}]}, ...
                    results(iResults,4),results(iResults,6),'VariableNames',{'Parameter','Gruppe 1','Gruppe 2','Test zwischen', ...
                    'Mean: Differenz','p'});
            end        
        elseif find_dif(1,1) == 0 & find_dif(1,2) == 0 & find_dif(1,3) ~= 0
            %%Unterschied bei der Mediaktion
            sprintf('Die %s unterscheided sich %s, %s zwischen %s und %s mit p = %0.5e', ...
                Parameter{iPara}, Region{compare_mat(results(iResults,1),1)}, Condition{compare_mat(results(iResults,1),2)}, ...
                Medication{compare_mat(results(iResults,1),3)},Medication{compare_mat(results(iResults,2),3)},results(iResults,6))
            try
                temp_table = table({Parameter{iPara}},{Region{compare_mat(results(iResults,1),1)}}, ...
                    {Condition{compare_mat(results(iResults,1),2)}}, ...
                    {[Medication{compare_mat(results(iResults,1),3)} 'vs' Medication{compare_mat(results(iResults,2),3)}]}, ...
                    results(iResults,4),results(iResults,6),'VariableNames',{'Parameter','Gruppe 1','Gruppe 2','Test zwischen', ...
                    'Mean: Differenz','p'});
                Post_Hoc_table(end+1,:) = temp_table;
            catch
                Post_Hoc_table = table({Parameter{iPara}},{Region{compare_mat(results(iResults,1),1)}}, ...
                    {Condition{compare_mat(results(iResults,1),2)}}, ...
                    {[Medication{compare_mat(results(iResults,1),3)} 'vs' Medication{compare_mat(results(iResults,2),3)}]}, ...
                    results(iResults,4),results(iResults,6),'VariableNames',{'Parameter','Gruppe 1','Gruppe 2','Test zwischen', ...
                    'Mean: Differenz','p'});
            end             
        end
    end
    save([Output_path 'Anova_table_' Parameter{iPara} '.mat'],'Anova_table') ;
end
save([Output_path 'Post_Hoc_table.mat'],'Post_Hoc_table') ;
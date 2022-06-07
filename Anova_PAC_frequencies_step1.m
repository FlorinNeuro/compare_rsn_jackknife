%% This script is for the Anova analysis of the frequencies in the PAC-calculation
    % It wil select median values of a region of interest
    % first collumn will be the values
    % second collumn will indicate the 9 Scout Regions
    % third collumn will indicatite the Condition (1 = peri; 2 = pre;)
    % fourth collumn will indicate the medication state (1 = OFF; 2 = ON;)
    % Matthias Sure
clear
% all subjects
subjects = {'S001','S003','S004','...'};



threshold = 0.4;
template_path = '...\brainstorm_db\database\data\Group_analysis\All_subjects_RSN\';
%select the networks
Template_of_Interest = [4 5 9 10];
% name the networks
Networks = {'Visual','Front_Occ','DMN','Motor'};
%data path
datapath = '...\brainstorm_db\database\data\Group_analysis\';

Faktor_names = {'Region','Condition','Medication'};
Parameters = {'PAC_value','PAC_lowf','PAC_highf'};
Region_names = {'Visual','Front_Occ','DMN','Motor'};
Condition_names = {'peri','pre'};
Medication_names = {'OFF','ON'};

Table_final = [];
for iPara = 1 : size(Parameters,2)
    Table_all = [];
    Table_final = [];
    for iCond = 1 : size(Condition_names,2)
        for iMed = 1 : size(Medication_names,2)
            template = load([template_path 'results_Correl_phi_template_' Condition_names{iCond} '_' Medication_names{iMed} '.mat'],'ImageGridAmp');
            cd([datapath Condition_names{iCond} '_' Medication_names{iMed}])
            Files = dir;
            for iSubject = 1 : size(subjects,2)
                for iFile = 1 : size(Files,1)
                    if contains(Files(iFile).name,Parameters{iPara}) && contains(Files(iFile).name,subjects{iSubject})
                        load(Files(iFile).name,'ImageGridAmp')
                        for iFile2 = 1 : size(Files,1)
                            if contains(Files(iFile2).name,Parameters{2}) && contains(Files(iFile2).name,subjects{iSubject})
                                temp_low_freq = load(Files(iFile2).name,'ImageGridAmp');
                            end
                        end
                        for iOrient = 1 : size(Region_names,2)
                            template_Vertices = find(template.ImageGridAmp(:,iOrient) > threshold);
                            temp_freq = temp_low_freq.ImageGridAmp(template_Vertices,1);
                            temp = ImageGridAmp(template_Vertices,1);
                            Table_final(end+1,1) = median(temp(temp_freq > 1));
                            Table_final(end,2) = iOrient;
                            Table_final(end,3) = iCond;
                            Table_final(end,4) = iMed;
                            Table_final(end,5) = iSubject;
                        end                        
                    end
                end
            end
        end
    end
    
    Parameter = Table_final(:,1);
    Region = Table_final(:,2);
    Condition = Table_final(:,3);
    Medication = Table_final(:,4);
    Subjects = Table_final(:,5);
    T = table(Parameter,Region,Condition,Medication);
    % remove NaN
%     x = T{:,'Parameter'};
%     y = find(isnan(x));
%     T(y,:) = [];      
    writetable(T,['...\Output\RSN_frequencys\PAC_freq_' Parameters{iPara} '_Anova_table.xlsx']);
    clear T Contact Frequency Medicaton Denisty Duration Power;
end
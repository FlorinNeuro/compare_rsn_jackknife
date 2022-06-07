%% This script is for adapting the JackKnife Statisics file for further corrections
% So far it will only be corrected for the number of sources using the
% Brainstorm gui. But you should also correct for the number of Konditions
% and networks. What this scripts will do is to multiply the 15002x1 vector
% for the amount of networks and conditions. So each time step shows the same image. 
% Afterwards you can check the Time box in the statistics correction tab in
% the brainstorm gui and it will correct for the networks and conditions.
% Sometimes the first step shows nothing, even without correction, so you 
% have to look at the second time step for results.
% Matthias Sure
clear

% define the networks and conditions which 
% Networks = {'Control_L','Visual','Front_Occ','Control_R','DMN','Motor'};
Networks = {'Visual','Front_Occ','DMN','Motor'};
Conditions = {'peri_OFF_vs_peri_ON','peri_OFF_vs_pre_OFF','peri_ON_vs_pre_ON','pre_OFF_vs_pre_ON'};
% get the corrections factor
Corrections_factor = size(Networks,2)*size(Conditions,2);
% define the source and the save folder
main_path = '...\brainstorm_db\All_subjects_RSN\data\Group_analysis\JackKnife_results';
target_path = '...\brainstorm_db\All_subjects_RSN\data\Group_analysis\JackKnife_results_correction';

cd(main_path)
Files = dir;
%% loop over each file
for iFile = 1 : size(Files,1)
    for iCond = 1 : size(Conditions,2)
        for iNetworks = 1 : size(Networks,2)
            if contains(Files(iFile).name,Networks{iNetworks}) && contains(Files(iFile).name,Conditions{iCond}) && contains(Files(iFile).name,'PD') && contains(Files(iFile).name,'ttest')
                copyfile([main_path '/' Files(iFile).name],[target_path '/'])
                cd(target_path);
                temp = load(Files(iFile).name);
                temp.tmap = repmat(temp.tmap,1,Corrections_factor);
                temp.pmap = repmat(temp.pmap,1,Corrections_factor);
                temp.df = repmat(temp.df,1,Corrections_factor);
                temp.Time = 1:Corrections_factor;
                save(Files(iFile).name, '-struct', 'temp')
                cd(main_path);            
            end
        end
    end
end
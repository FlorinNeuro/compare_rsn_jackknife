%% This script is to a brainstorm file to present the JK statistics of the RSN
%  The statistics values are presented and the vertices which belong to the
%  RSN but don't have significant values
%  Indicate the vertices:
%  1,2 no significant differences but vertex belongs to RSN 1 or 2
%  3 no significant differneces but vertex belongs to RSN 1 and 2
%  4,5 RSN 1 or 2 is significantly stronger
%  Matthias Sure
%% set everything up
clear
% set the threshold
threshold = 0.4;
threshold1 = '0_4';
% pick the template networks from the HC RSN networks;
Template_of_Interest = [2 3 5 6];
% name the networks
% Networks = {'Control_L','Visual','Front_Occ','Control_R','DMN','Motor'};
Networks = {'Visual','Front_Occ','DMN','Motor'};
% name the conditions
Conditions = {'pre_OFF','pre_ON','peri_ON','peri_OFF'};
% paths
path_files = '...\brainstorm_db\database\data\Group_analysis\JackKnife_results_correction\';
path_save = '...\brainstorm_db\database\data\Group_analysis\JackKnife_results_templates\';
path_temp = '...\brainstorm_db\database\data\Group_analysis\All_subjects_RSN\results_Correl_phi_template_';
% load a template struct for the brainstorm file format
template_struct = load('...\brainstorm_db\database\data\Group_analysis\JackKnife_results_templates\results_pthresh_template.mat');

cd(path_files)
Files = dir;
for iFiles = 1 : size(Files,1)
    if contains(Files(iFiles).name,'results_pthresh')
        % load the statistic file
        temp = load(Files(iFiles).name);
        for iRSN = 1 : size(Networks,2)
            if contains(temp.Comment,Networks{iRSN})
                for iCond1 = 1 : size(Conditions,2)
                    if contains(temp.Comment,[Conditions{iCond1} '_vs'])
                        % load the first template
                        load([path_temp Conditions{iCond1} '.mat'],'ImageGridAmp')
                        template1 = ImageGridAmp(:,Template_of_Interest(iRSN));
                        template1_thresh = ImageGridAmp(:,Template_of_Interest(iRSN));
                        
                        for iCond2 = 1 : size(Conditions,2)
                            if contains(temp.Comment,['vs_' Conditions{iCond2}])
                                % load the second template
                                load([path_temp Conditions{iCond2} '.mat'],'ImageGridAmp')
                                template2 = ImageGridAmp(:,Template_of_Interest(iRSN));
                                template2_thresh = ImageGridAmp(:,Template_of_Interest(iRSN));
                                %indicate the vertices
                                template1(template1>threshold) = 1;
                                template2(template2>threshold) = 2;
                                final_struct = template_struct;
                                final_struct.Comment = ['JackKnife_PD_image_' Networks{iRSN} '_' Conditions{iCond1} '_vs_' Conditions{iCond2} '_thresh_' threshold1];
                                final_struct.ImageGridAmp = template1+template2;
                                final_struct.ImageGridAmp(temp.ImageGridAmp(:,2)<0) = 4;
                                final_struct.ImageGridAmp(temp.ImageGridAmp(:,2)>0) = 5;
                                final_struct.ImageGridAmp(intersect(find(template1_thresh <= threshold),find(template2_thresh <= threshold))) = 0;
                                final_struct.Time = 1;
                                save([path_save 'results_pthresh_' final_struct.Comment '.mat'],'-struct','final_struct')
                            end
                        end
                    end
                end
            end
        end
    end
end

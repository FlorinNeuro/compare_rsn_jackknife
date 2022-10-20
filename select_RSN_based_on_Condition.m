%% This script is for sorting the Networks of the JackKnives Runs based on RSN Networks of a predefiened condition
% The sorting is based on the phi-correlation.
% The script is semi-Automatic. If two networks could be assigned to the
% same template the user has to decide using the Brainstorm gui.
% Before starting the script Brainstorm should be started.
% Matthias Sure

clear
subjects = {'S001','S002','S003','...'};

%% define a threshold for the RSN networks amplitude
threshold = 0.4;
%define a minimal phi value
min_phi_value = 0;
% create an empty struct to save the sorted networks
results = struct;

clear HC_file ImageGridAmp
% select which condition should be tested
dataset = 'peri_OFF'; %The two conventions for the names were necessary, due to a flat naming in the original pipeline
dataset2 = 'OFF_peri';
template_set = 'Temp'; %% use a name to identify your Template selection

% get the Template networks from the RSN networks over all subjects of one
% condition
All_subjects_file = ['...\brainstorm_db\database\data\Group_analysis\All_subjects_RSN\results_Correl_phi_template_' dataset '.mat']; %Define the non JackKnife File
load(All_subjects_file,'ImageGridAmp');
Template_of_Interest = [1:6]; %% select which Templates should be used
Template_names = {'Control_L','Visual','Front_Occ','Control_R','DMN','Motor'}; % Name the templates
Template = ImageGridAmp(:,Template_of_Interest);
% make the Template binary for the phi Korrelation
Template(Template < threshold) = 0;
Template(Template ~= 0 & ~isnan(Template)) = 1; % the 1/0 matrix will only be used for the sorting

%make a list to see later on which networks were assigned to which template
matching_templates = zeros(size(subjects,2),size(Template_of_Interest,2));
cd(['E:\brainstorm_db\PAC_Single_Subject_JK\data\Group_analysis\' dataset])

Files = dir;
f = msgbox('This script will map the RSN of the desired condition to the Healthy Controls networks. If two networks are eligible for a template, then the user must make the decision. When prompted to make a choice, the Brainstorm Folder of the corresponding condition must be reloaded and the Check file opened. The first time shows the template, the second the first choice and the third the second choice. Then either 1 or 2 must be entered in the answer box for the corresponding choice.');
for nJK = 1 :  size(Files,1)%loop over the JackKnife runs
    if ~contains(Files(nJK).name,'results') || contains(Files(nJK).name,'phi')
        continue
    end
    Subject_ind = find(contains(subjects,Files(nJK).name(41:44)));
    %Load the JackKnife run
    load(Files(nJK).name,'ImageGridAmp')
    % Look only at the values above threshold and create a 1/0 matrix
    % and mark the noise network as Nan
    [~,noise_network] = max(nansum(ImageGridAmp));
    ImageGridAmp(:,noise_network) = NaN(size(ImageGridAmp,1),1);
    ImageGridAmptemp = ImageGridAmp;% the sorted networks will be saved with only the values below threshold set to 0
    ImageGridAmp(ImageGridAmp < threshold) = 0;
    ImageGridAmp(ImageGridAmp ~= 0 & ~isnan(ImageGridAmp)) = 1; % the 1/0 matrix will only be used for the sorting
    
    %% calculate the phi coefficient
    R = zeros(size(ImageGridAmp,2),size(Template,2));%% create a 10 by nTemplates matrix whichs shows the phi coefficient between template and networks
    for iNetwork = 1 : size(ImageGridAmp,2)%loop through all 10 networks
        for iTemplate = 1 : size(Template,2)% loop over all Template
            R(iNetwork,iTemplate) = phi_correl(ImageGridAmp(:,iNetwork),Template(:,iTemplate));            
        end
    end
    R(isnan(R)) = 0;    
    R(R<0) = 0;% only positiv correlation values

    while sum(sum(R)) ~= 0
        % set phi_values below a minimum ratio to zero
        R(R <= min_phi_value) = 0;
        % determine the template with the best spatial overlap
        [~,max_Template] = max(max(R));
        %% check if more than 1 template would be in order
        sort_R = sort(R(:,max_Template));
        % if so compare visually in the Brainstorm gui
        if sort_R(end)-sort_R(end-1) < 0.2 && sort_R(end-1) ~= 0
            %create brainstorm files
            check = struct;
            check = load(['results_posandnegSignalModes_JK' dataset2 '.mat']); % get a template file
            check.ImageGridAmp = [];
            check.ImageGridAmp(:,1) = Template(:,max_Template);
            check.ImageGridAmp(:,2) = ImageGridAmptemp(:,find(R(:,max_Template) == sort_R(end)));
            check.ImageGridAmp(:,3) = ImageGridAmptemp(:,find(R(:,max_Template) == sort_R(end-1)));
            check.Time = 1 : size(check.ImageGridAmp,2);
            check.ImageGridTime = 1 : size(check.ImageGridAmp,2);
            check.Comment = ['Check'];
            save(['results_test.mat'],'-struct','check')
            prompt = {'Enter which RSN matches the Template'};
            dlgtitle = 'Matching RSN';
            definput = {'1'};
            dims = [1 40];
            answer = inputdlg(prompt,dlgtitle,dims,definput);
            if str2num(answer{1}) == 1
                max_Network = find(R(:,max_Template) == sort_R(end));
            elseif str2num(answer{1}) == 2
                max_Network = find(R(:,max_Template) == sort_R(end-1));
            end
            close all
            delete('results_test.mat')
        else
            [~,max_Network] = max(R(:,max_Template));
        end

        %% Remove only the network with the highest correlation
        R(max_Network,:) = zeros(1,size(Template,2));
        %% to Remove all networks which have the same best matching template
        % remove this template
        R(:,max_Template) = zeros(size(ImageGridAmp,2),1);
        % note which network was assigned to which template
        matching_templates(Subject_ind,max_Template) = max_Network;
        % save the network/template pairs in a matrix 
        try 
            results.(Template_names{max_Template}).ImageGridAmp = [results.(Template_names{max_Template}).ImageGridAmp ImageGridAmptemp(:,max_Network)];
            results.(['Set_' Template_names{max_Template}]).ImageGridAmp(end+1) = nJK;
        catch
            results.(Template_names{max_Template}).ImageGridAmp = ImageGridAmptemp(:,max_Network);
            results.(['Set_' Template_names{max_Template}]).ImageGridAmp = nJK;
        end
    end
end

%%
%% create Brainstorm files
for nTemplate = 1 : size(Template_names,2)
    try
        final_set = load(['results_posandnegSignalModes_JK_' dataset2 '.mat']);
        final_set.ImageGridAmp = results.(Template_names{nTemplate}).ImageGridAmp;
        final_set.ImageGridAmp(:,end+1) = mean(final_set.ImageGridAmp,2);
        final_set.Time = 1 : size(results.(Template_names{nTemplate}).ImageGridAmp,2)+1;
        final_set.ImageGridTime = 1 : size(results.(Template_names{nTemplate}).ImageGridAmp,2)+1;
        final_set.Comment = ['BS | ' dataset ' | Template - Correl - phi ' Template_names{nTemplate} template_set];
        save(['results_BS_Correl_phi_template_' Template_names{nTemplate} '_' dataset '_' template_set '.mat'],'-struct','final_set')
        clear final_set
    catch
        continue
    end
    
end
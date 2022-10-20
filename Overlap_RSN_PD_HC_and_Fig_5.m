% This script will calculate the overlap based on the phi correlation
% between the JK RSN and the HC RSN. It will further test for differences
% between the condition and test for correlation to the UPDRS value
% This scipt is used to create Fig 5
% Matthias Sure
clear
subjects = {'S001','S002','S003'; ... %peri_OFF
            'S001','S002','S003'; ... %peri_ON
            'NaN' ,'S002','S003'; ...   %pre_OFF
            'S001','S002','S003'};      %pre_ON

subjects_all = {'S001','S002','S003',};

% pick the template networks from the HC RSN networks;
Template_of_Interest = [4 5 9 10];
threshold = 0.4;
% name the networks
Networks = {'Visual','Front_Occ','DMN','Motor'};
Network_names = {'Visual','Fronto-Occipital','Frontal','Sensory-Motor'};
% select the networks from file to create Theta_0 for the JackKnife
%HC data
HC_file = ['...\RSN_data\all_Subjects_RSN_HC_None\results_posandnegSignalModes_all_Subjects_None_HC.mat';
load(HC_file,'ImageGridAmp');
Template = ImageGridAmp(:,Template_of_Interest);
Template(Template < threshold) = 0;
Template(Template ~= 0 & ~isnan(Template)) = 1; % the 1/0 matrix will only be used for the sorting
% identify which files should be loaded and testet against each other
template_set = 'Cond'; %% use a name to identify your Template selection
Conditions = {'peri_OFF','peri_ON','pre_OFF','pre_ON'};
JackKnife_data = '...\brainstorm_db\database\data\Group_analysis\';
%define the Standard normal distribution
%%% --- Diese Formel habe ich von https://en.wikipedia.org/wiki/Normal_distribution
Phifun = @(z) (1/sqrt(2*pi))*exp(-(z.^2)/2);
Overlap = NaN(size(subjects,2),size(subjects,1),size(Template_of_Interest,2));
%loop over all template networks
for iNetworks = 1 : size(Template_of_Interest,2)
    for iCond = 1 : size(Conditions,2)
        condition = Conditions{iCond};
        %% get the JackKnife Networks
        load([JackKnife_data condition '\results_BS_Correl_phi_template_' Networks{iNetworks} '_' condition '_' template_set '.mat'],'ImageGridAmp')
        JackKnife_Network = ImageGridAmp; clear ImageGridAmp
        JackKnife_Network(JackKnife_Network < threshold) = 0;
        JackKnife_Network(JackKnife_Network ~= 0 & ~isnan(JackKnife_Network)) = 1; % the 1/0 matrix will only be used for the sorting
        iSubj = 0;
        for iJK = 1 : size(JackKnife_Network,2)-1
            iSubj = iSubj + 1;
%             if strcmp(subjects{iCond,iSubj},'NaN')
%                 iSubj = iSubj + 1;
%             end
            Overlap(iSubj,iCond,iNetworks) = phi_correl(JackKnife_Network(:,iJK),Template(:,iNetworks));
        end
    end
end
%% plot the Phi coefficents
f = figure('Renderer', 'painters', 'Position', [10 10 1000 800]);
subplot(2,2,1);
hold on
plot(Overlap(:,1,4),'*-','LineWidth',1.5,'Color','#F5793A')
plot(Overlap(:,2,4),'x-','LineWidth',1.5,'Color','#A95AA1')
plot(Overlap(:,3,4),'+-','LineWidth',1.5,'Color','#85C0F9')
plot(Overlap(:,4,4),'s-','LineWidth',1.5,'Color','#0F2080')
hold off
ylim([0.4 1])
xlim([1 26])
ylabel('Phi coefficient')
title(Network_names{4})
box off
set(gca,'FontSize',16,'FontWeight', 'bold')

subplot(2,2,2);
hold on
plot(Overlap(:,1,1),'*-','LineWidth',1.5,'Color','#F5793A')
plot(Overlap(:,2,1),'x-','LineWidth',1.5,'Color','#A95AA1')
plot(Overlap(:,3,1),'+-','LineWidth',1.5,'Color','#85C0F9')
plot(Overlap(:,4,1),'s-','LineWidth',1.5,'Color','#0F2080')
hold off
ylim([0.4 1])
xlim([1 26])
title(Network_names{1})
box off
set(gca,'FontSize',16,'FontWeight', 'bold')

subplot(2,2,3);
hold on
plot(Overlap(:,1,3),'*-','LineWidth',1.5,'Color','#F5793A')
plot(Overlap(:,2,3),'x-','LineWidth',1.5,'Color','#A95AA1')
plot(Overlap(:,3,3),'+-','LineWidth',1.5,'Color','#85C0F9')
plot(Overlap(:,4,3),'s-','LineWidth',1.5,'Color','#0F2080')
hold off
ylim([0.4 1])
xlim([1 26])
xlabel('Jackknife run')
ylabel('Phi coefficient')
title(Network_names{3})
box off
set(gca,'FontSize',16,'FontWeight', 'bold')

subplot(2,2,4);
hold on
plot(Overlap(:,1,2),'*-','LineWidth',1.5,'Color','#F5793A')
plot(Overlap(:,2,2),'x-','LineWidth',1.5,'Color','#A95AA1')
plot(Overlap(:,3,2),'+-','LineWidth',1.5,'Color','#85C0F9')
plot(Overlap(:,4,2),'s-','LineWidth',1.5,'Color','#0F2080')
hold off
ylim([0.4 1])
xlim([1 26])
xlabel('Jackknife run')
title(Network_names{2})
legend({'Post-OFF','Post-ON','Pre-OFF','Pre-ON'},...
    'Location','northeast','NumColumns',2)
box off
set(gca,'FontSize',16,'FontWeight', 'bold')
set(gca,'LooseInset',get(gca,'TightInset')); % removing extra white space in figure
exportgraphics(f,['...\Fig_5_Phi_coefficients.pdf'],'Resolution',500)
%%
Overlap_mean = nanmean(Overlap);
Overlap_std = nanstd(Overlap);
%% t-test between Phi coefficients
for iNetworks = 1 : size(Template_of_Interest,2)
    for iCond1 = 1 : size(Conditions,2)
        for iCond2 = 1 : size(Conditions,2)
            [h_Overlap(iCond1,iCond2,iNetworks),p_Overlap(iCond1,iCond2,iNetworks)] = ttest(Overlap(:,iCond1,iNetworks),Overlap(:,iCond2,iNetworks));
            [h,p,ci,test_struct] = ttest(Overlap(:,iCond1,iNetworks),Overlap(:,iCond2,iNetworks)); p = p *4 *4;
        end
    end
end
p_Overlap = p_Overlap*4*4; 
%% load the UPDRS values
for iCond = 1 : size(Conditions,2)
    temp = load(['V:\UPDRS_data\UPDRS_' Conditions{iCond}]);
    if mod(iCond,2) == 0 
        UPDRS.(Conditions{iCond}) = temp.UPDRS_ON;
    else
        UPDRS.(Conditions{iCond}) = temp.UPDRS_OFF;
    end
    clear temp
end
%% Korrelation between Phi coefficients and UPDRS scores
UPDRS_scores = {'UPDRS','non_Tremor','Tremor','Akinesia_Rigidity'};
for iUPDRS_score = 1 : size(UPDRS_scores,2)
    temp_UPDRS = [];
    pool_UPDRS = [];
    for iCond = 1 : size(Conditions,2)
%         temp_UPDRS = UPDRS.(Conditions{iCond}).(UPDRS_scores{iUPDRS_score})';
        for iSubj = 1 : size(subjects,2)
            temp_UPDRS(iSubj,1) = nanmean(UPDRS.(Conditions{iCond}).(UPDRS_scores{iUPDRS_score})(1:end ~= iSubj));
        end
        pool_UPDRS = [pool_UPDRS; temp_UPDRS];
        
        for iNetworks = 1 : size(Template_of_Interest,2)
            temp = Overlap(:,iCond,iNetworks);
            [r,p] = corrcoef(temp(intersect(find(~isnan(temp)), find(~isnan(temp_UPDRS)))),temp_UPDRS(intersect(find(~isnan(temp)), find(~isnan(temp_UPDRS)))));
            Correl_val(iNetworks,1,iCond,iUPDRS_score) = r(1,2);
            Correl_val(iNetworks,2,iCond,iUPDRS_score) = p(1,2); 
        end
    end
    for iNetworks = 1 : size(Template_of_Interest,2)
        temp = Overlap(:,:,iNetworks);
        temp  = temp(:);
        [r,p] = corrcoef(temp(intersect(find(~isnan(temp)), find(~isnan(pool_UPDRS)))),pool_UPDRS(intersect(find(~isnan(temp)), find(~isnan(pool_UPDRS)))));
        Correl_val_pool(iNetworks,1,iUPDRS_score) = r(1,2);
        Correl_val_pool(iNetworks,2,iUPDRS_score) = p(1,2);
    end
end
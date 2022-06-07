%% This script is to calculate a JackKnife based statistical test between two conditions.
% The RSN needed to be calculated in a JackKnife procedure with leave one
% out. You also need the orderd (based on the templated data) RSN calculated
% on all subjects of the condition of interest without leave one out. For the
% calculation of N1 (line 41) and N2 (line 59) check if your Network file is also 
% containing the mean of all networks or not. Depending on this you have to substract 1 or not
% Matthias Sure 
clear
% determine which conditions you want to compare
condition_1 = 'pre_OFF'; 
condition_2 = 'pre_ON';  
% set the data_path
JackKnife_data = '...\brainstorm_db\database\data\Group_analysis\';
% name the networks which you want to compare --> need to be in that order
% in your Theta_0 files.
Networks = {'Control_L','Visual','Front_Occ','Control_R','DMN','Motor'};
% select the networks from file to create Theta_0 for the JackKnife
% Statistics, Theta_0 should be specific for each condition
% first condition
H01_file = ['...\brainstorm_db\database\data\Group_analysis\All_subjects_RSN\results_Correl_phi_template_' condition_1 '.mat']; %Define the non JackKnife File
load(H01_file,'ImageGridAmp');
Theta_0_1 = ImageGridAmp;
%second condition
H02_file = ['...\brainstorm_db\database\data\Group_analysis\All_subjects_RSN\results_Correl_phi_template_' condition_2 '.mat']; %Define the non JackKnife File
load(H02_file,'ImageGridAmp');
Theta_0_2 = ImageGridAmp;
        
% identify which files should be loaded and testet against each other
template_set = 'Temp'; %% use a name to identify your Template selection
%define the Standard normal distribution in case you want to use the z-test
%%% --- Diese Formel habe ich von https://en.wikipedia.org/wiki/Normal_distribution
Phifun = @(z) (1/sqrt(2*pi))*exp(-(z.^2)/2);
%loop over all template networks
for iNetworks = 1 : size(Networks,2)
    %% get the JackKnife Networks condition 1
    load([JackKnife_data condition_1 '\results_BS_Correl_phi_template_' Networks{iNetworks} '_' condition_1 '_' template_set '.mat'],'ImageGridAmp')
    JackKnife_Network = ImageGridAmp; clear ImageGridAmp
    %determine the number of JackKnife runs
    %if the last network is the mean of all JackKnife runs than add -1
    %otherwhise don't add the -1
    N1 = size(JackKnife_Network,2)-1;
    %initiate matrix for pseudo values
    Theta_i1 = [];
    % Calculation of the Pseudovalue Theta_i, https://personal.utdallas.edu/~herve/abdi-Jackknife2010-pretty.pdf
    for iJackKnife = 1 : N1
        %%% --- The used function is function (3) from https://personal.utdallas.edu/~herve/abdi-Jackknife2010-pretty.pdf
        Theta_i1(:,iJackKnife) = N1*Theta_0_1(:,iNetworks)-(N1-1)*JackKnife_Network(:,iJackKnife);
    end
    %%% --- The mean of the pseudovalues is calculated based on function (4) from https://personal.utdallas.edu/~herve/abdi-Jackknife2010-pretty.pdf
    Theta_hat1 = (1/N1)*sum(Theta_i1,2);
    %%% --- The mean of the pseudovalues is calculated based on function (5) from https://personal.utdallas.edu/~herve/abdi-Jackknife2010-pretty.pdf    
    Theta_var1 = (1/(N1-1))*sum((Theta_i1-Theta_hat1).^2,2);
    
    %% get the JackKnife Networks condition 2
    load([JackKnife_data condition_2 '\results_BS_Correl_phi_template_' Networks{iNetworks} '_' condition_2 '_' template_set '.mat'],'ImageGridAmp')
    JackKnife_Network = ImageGridAmp; clear ImageGridAmp
    %if the last network is the mean of all JackKnife runs than add -1
    %otherwhise don't add the -1
    N2 = size(JackKnife_Network,2)-1;
    %initiate matrix for pseudo values
    Theta_i2 = [];
    % Calculation of the Pseudovalue Theta_i, https://personal.utdallas.edu/~herve/abdi-Jackknife2010-pretty.pdf
    for iJackKnife = 1 : N2          
        %%% --- The used function is function (3) from https://personal.utdallas.edu/~herve/abdi-Jackknife2010-pretty.pdf
        Theta_i2(:,iJackKnife) = N2*Theta_0_2(:,iNetworks)-(N2-1)*JackKnife_Network(:,iJackKnife);
    end
    %%% --- The mean of the pseudovalues is calculated based on function (4) from https://personal.utdallas.edu/~herve/abdi-Jackknife2010-pretty.pdf   
    Theta_hat2 = (1/N2)*sum(Theta_i2,2);
    %%% --- The mean of the pseudovalues is calculated based on function (5) from https://personal.utdallas.edu/~herve/abdi-Jackknife2010-pretty.pdf       
    Theta_var2 = (1/(N2-1))*sum((Theta_i2-Theta_hat2).^2,2);
    
    %% calculate the p-Value
    %% get the p-Value based on a t-value
    %unequal variance --- formula is from https://online.stat.psu.edu/stat500/lesson/7/7.3/7.3.1/7.3.1.2
    t = (Theta_hat1-Theta_hat2)./sqrt((Theta_var1/N1)+(Theta_var2/N2));
    %Degrees of freedom --- formula is from https://online.stat.psu.edu/stat500/lesson/7/7.3/7.3.1/7.3.1.2
    C = (Theta_var1/N1)./((Theta_var1/N1)+(Theta_var2/N2));
    dof = ((N1-1)*(N2-1))./((N2-1)*(C.*C)+((1-C).^2)*(N1-1));
    % threshold the t-values so the scale in Brainsorm is not going out of
    % range
    t(t < -10) = -10;
    t(t > 10) = 10;
    % p-value is calculated as seen here: https://www.omnicalculator.com/statistics/t-test

    p = 2*(1-tcdf(abs(t),dof));
    %% create Brainsotrm statistic file 'presults' and save the results
    stat.pmap = p;
    stat.tmap = t;
    stat.df = dof;
    stat.SPM = [];
    stat.Correction = 'no';
    stat.Type = 'results';
    stat.Comment = ['JackKnife_test_PD_' Networks{iNetworks} '_' template_set '_' condition_1 '_vs_' condition_2 '_ttest'];
    stat.Time = 1;
    stat.ChannelFlag = [];
    stat.HeadModelType = 'surface';
    stat.SurfaceFile = '@default_subject/tess_cortex_pial_low.mat';
    stat.nComponents = 1;
    stat.Atlas = [];
    stat.GridLoc = [];
    stat.GridOrient = [];
    stat.Atals = [];
    stat.GoodChannel = [];
    stat.ColormapTyp = 'stat2';
    stat.DisplayUnits = 't';
    stat.Description = [];
    stat.TFmask = [];
    stat.DataType = [];
    stat.Freqs = [];
    stat.Method = [];
    stat.Options.TimeWindow = [];
    stat.Options.SensorTypes = [];
    stat.Options.Rows = [];
    stat.Options.FreqRange = [];
    stat.Options.ScoutSel = {};
    stat.Options.ScoutFunc = 'mean';
    stat.Options.isAbolute = 0;
    stat.Options.isAvgTime = 0;
    stat.Options.isAvgRow = 0;
    stat.Options.isAvgFreq = 0;
    stat.Options.isMatchRows = 1;
    stat.Options.isZeroBad = 1;
    stat.Options.TestType = 'ttest_unequal';
    stat.Options.TestTail = 'two';
    stat.Options.nGoodSamplesA = N1*ones(size(p));
    stat.Options.nGoodSamplesB = N2*ones(size(p));
    stat.RefRowNames = [];
    stat.RowNames = [];
    stat.TimeBands = [];
    stat.Measure = [];
    stat.StatClusters = [];
    stat.History = {};
    save([JackKnife_data 'JackKnife_results\' 'presults_' stat.Comment '.mat'],'-struct','stat')    
end

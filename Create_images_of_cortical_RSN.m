%% This script is to create images of the RSN in a defined condition
% Matthias Sure
%% set everything up
clear
% Determine which views should be added
side = {'left','right','top','bottom','front','back','left_intern','right_intern'};
% pick the RSN networks;
Template_of_Interest = [2 3 5 6];
% name the networks
Networks = {'Visual','Front_Occ','DMN','Motor'};
% define the folders
home = '.../brainstorm_db/All_subjects_RSN/';
database = '.../brainstorm_db/All_subjects_RSN/data/';
BrainstormDbDir = '.../brainstorm_db';

%%how to start brainstorm
if ~brainstorm('status')
    brainstorm
end
bst_set('BrainstormDbDir',BrainstormDbDir)
ProtocolName = ['All_subjects_RSN'];
sProtocol.Comment = ProtocolName;
sProtocol.SUBJECTS = [home 'anat'];
sProtocol.STUDIES = [home 'data'];
db_edit_protocol('load',sProtocol);
% Get the protocol index
iProtocol = bst_get('Protocol', ProtocolName);
if isempty(iProtocol)
    error(['Unknown protocol: ' ProtocolName]);
end
% Select the current procotol
gui_brainstorm('SetCurrentProtocol', iProtocol);
% temporary folder
path1 = '...\brainstorm_db\database\data\Group_analysis\All_subjects_RSN';

%define the Output path
Output_path = '...\Output\Images\Template\';

cd(path1)
a = dir;
% Input files
sFiles = cell(1);
sFiles{1,1} = 'Group_analysis/All_subjects_RSN/results_posandnegSignalModes_all_Subjects_None_HC.mat';
for iTime = 1 : size(Template_of_Interest,2)
    for iSide = 1 : size(side,2) 
        %% create the single Images
        % Start a new report
        bst_report('Start', sFiles);

        % Process: Snapshot: Sources (one time)
        sFiles_im = bst_process('CallProcess', 'process_snapshot', sFiles, [], ...
            'target',         8, ...  % Sources (one time)
            'modality',       1, ...  % MEG (All)
            'orient',         iSide, ...  % top
            'time',           Template_of_Interest(iTime), ...
            'contact_time',   [1, 1], ...
            'contact_nimage', 1, ...
            'threshold',      40, ...
            'Comment',        '');        

        % Save report --> important to get the image from
        % brainstorm
        ReportFile = bst_report('Save', sFiles_im);
        %% save image to file
        bst_report('Open', ReportFile);
        % bst_report('Export', ReportFile, ExportDir);
        load(ReportFile);
    %   Reports = bst_report('GetReport','current');
        nRows = size(Reports,1);
        for iRow = 1:nRows
            if strcmp(Reports{iRow,1},'image')
                cd(Output_path)
                image_name = ['Template_HC_' Networks{iTime}];
                temp_image = Reports{iRow,4};
                % invert the images --> black to white
                for width_I = 1 : size(temp_image,1)
                    for length_I = 1 : size(temp_image,2)
                        if temp_image(width_I, length_I,:) == [0;0;0]
                            temp_image(width_I, length_I,:) = [255;255;255];
                        end                       
                   end
                end
                imwrite(temp_image,sprintf([image_name '_' side{iSide} '.png']));  
                clear temp_image
            end
        end            
    end
end

brainstorm stop

final_side = {'top','bottom','front','back','left','right','left_intern','right_intern'};
Network_Names = {'Left_fronto_parietal_text','Visual_text','Fronto_Occipital_text','Right_fronto_parietal_text','Frontal_text','Motor_text'};
%% combine images version 1:
A_final = [];
for iTime = 1 : size(Template_of_Interest,2)
    cd(Output_path)
    image_name = ['Template_HC_' Networks{iTime}];
    A_top = imread([image_name '_' final_side{1} '.png']);
    A_top = A_top(:,100:300,:);
    A_bottom = imread([image_name '_' final_side{2} '.png']);
    A_bottom = A_bottom(:,100:300,:);
    A_front = imread([image_name '_' final_side{3} '.png']);
    A_front = A_front(:,100:300,:);
    A_back = imread([image_name '_' final_side{4} '.png']);
    A_back = A_back(:,100:300,:);    
    A_left = imread([image_name '_' final_side{5} '.png']);
    A_left = A_left(:,75:325,:);
    A_right = imread([image_name '_' final_side{6} '.png']);
    A_right = A_right(:,75:325,:);
    A_left_int = imread([image_name '_' final_side{7} '.png']);
    A_left_int = A_left_int(:,75:325,:);
    A_right_int = imread([image_name '_' final_side{8} '.png']);
    A_right_int = A_right_int(:,75:325,:);         
    A_temp = cat(2,A_top,cat(2,A_bottom,cat(2,A_front,cat(2,A_back,cat(2,A_left,cat(2,A_right,cat(2,A_left_int,A_right_int)))))));
    for width_I = 220 : 250
        for length_I = 780 : 1580
            A_temp(width_I, length_I,:) = [255;255;255];                       
        end
    end
    cd('C:\Users\M Sure\sciebo\RSN_Results\Images\Names')
    A_name = imread([Network_Names{iTime} '.png']);
    Offset = round((size(A_temp,2)-size(A_name,2))/2);
    add_height = 85;
    add_name = uint8(255*ones(add_height,size(A_temp,2),3));
    add_name(1:size(A_name,1),Offset:Offset+size(A_name,2)-1,:) = A_name;
    A_temp = cat(1,add_name,A_temp);
    imwrite(A_temp,sprintf([image_name '.png'])); 
    if iTime == 1
        A_final = A_temp;
    else
        A_final = cat(1,A_final,A_temp);
    end
%     position = [500 9 20 20];
%     A_temp = insertObjectAnnotation(A_temp,position,Networks{iTime},'FontSize',18)
end
cd(Output_path)
imwrite(A_final,sprintf(['Overview_RSN_HC.png']));

% % %% combine images version 2:
% % Network_Names = {'Control left','Visual','Fronto-Occipital','Control right','DMN','Motor'};
% % A_final = [];
% % for iTime = 1 : size(Template_of_Interest,2)
% %     image_name = ['Template_HC_' Networks{iTime}];
% %     A_top = imread([image_name '_' final_side{1} '.png']);
% %     A_top = A_top(:,100:300,:);
% %     A_bottom = imread([image_name '_' final_side{2} '.png']);
% %     A_bottom = A_bottom(:,100:300,:);
% %     A_front = imread([image_name '_' final_side{3} '.png']);
% %     A_front = A_front(:,100:300,:);
% %     A_back = imread([image_name '_' final_side{4} '.png']);
% %     A_back = A_back(:,100:300,:);    
% %     A_left = imread([image_name '_' final_side{5} '.png']);
% %     A_left = A_left(:,75:325,:);
% %     A_right = imread([image_name '_' final_side{6} '.png']);
% %     A_right = A_right(:,75:325,:);  
% %     A_temp = cat(2,A_top,cat(2,A_bottom,cat(2,A_front,cat(2,A_back,cat(2,A_left,A_right)))));
% %     for width_I = 220 : 250
% %         for length_I = 780 : 1080
% %             A_temp(width_I, length_I,:) = [255;255;255];                       
% %         end
% %     end
% %     imshow(A_temp)
% %     letter = annotation('textbox', [0.475 0.95 0 0], 'String', Network_Names{iTime});
% %     letter.FontSize = 25;
% %     savefig(image_name)
% %     print(image_name,'-dtiff','-r600')
% %     if iTime == 1
% %         A_final = A_temp;
% %     else
% %         A_final = cat(1,A_final,A_temp);
% %     end
% % %     position = [500 9 20 20];
% % %     A_temp = insertObjectAnnotation(A_temp,position,Networks{iTime},'FontSize',18)
% % end
% % imwrite(A_final,sprintf(['Overview_RSN_HC.png']));
% % 
% % %     set(gca,'FontWeight','bold')
% % %     set(gca,'FontSize',18)    
% % %     if iOrient == 1
% % %         letter = annotation('textbox', [0 1 0 0], 'String', 'A');
% % %     elseif iOrient == 2
% % %         letter = annotation('textbox', [0 1 0 0], 'String', 'B');
% % %     elseif iOrient == 3
% % %         letter = annotation('textbox', [0 1 0 0], 'String', 'C');
% % %     end
% % %     letter.FontSize = 30;
% % % 
% % %     savefig(['Power_spectra_' orientation{iOrient}])
% % %     print(['Power_spectra_' orientation{iOrient}],'-dtiff','-r600')
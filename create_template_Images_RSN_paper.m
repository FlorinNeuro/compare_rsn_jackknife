%% This script is to combine the views of RSN calculated across all subjects
% of one condition selected for the paper
% Matthias Sure
Condition = 'HC_None';
side = {'left','right','top','bottom','front','back','left_intern','right_intern'};
% pick the template networks from the HC RSN networks;
Template_of_Interest = [2 3 5 6];
% name the networks
Networks = {'Visual','Front_Occ','DMN','Motor'};

final_side = {'top','bottom','front','back','left','right','left_intern','right_intern'};
Network_Names = {'Visual_text','Fronto_Occipital_text','Frontal_text','Motor_text'};

Output_path = 'Output\RSN_Results\Images\Template';
%% combine images version 1:
A_final = [];
%% Motor
iRSN = 4;
cd(Output_path)
image_name = ['Fig_Template_' Condition '_' Networks{iRSN}];
A_top = imread([image_name '_' final_side{1} '.png']);
A_top = A_top(:,100:300,:);
add_space = uint8(255*ones(size(A_top,1),25,3));
A_top = cat(2,add_space,cat(2,A_top,add_space));
A_left_int = imread([image_name '_' final_side{7} '.png']);
A_left_int = A_left_int(:,75:325,:);
A_right_int = imread([image_name '_' final_side{8} '.png']);
A_right_int = A_right_int(:,75:325,:); 
A_temp = cat(2,A_top,cat(2,A_left_int,A_right_int));
cd('C:\Users\M Sure\sciebo\RSN_Results\Images\Names')
A_name = imread([Network_Names{iRSN} '.png']);
Offset = round((size(A_temp,2)-size(A_name,2))/2);
add_height = 85;
add_name = uint8(255*ones(add_height,size(A_temp,2),3));
add_name(1:size(A_name,1),Offset:Offset+size(A_name,2)-1,:) = A_name;
A_temp = cat(1,add_name,A_temp);
cd(Output_path)
imwrite(A_temp,sprintf([image_name '_paper.png'])); 
A_final = A_temp;

%%
%% Visual
iRSN = 1;
cd(Output_path)
image_name = ['Fig_Template_' Condition '_' Networks{iRSN}];
A_back = imread([image_name '_' final_side{4} '.png']);
A_back = A_back(:,100:300,:); 
add_space = uint8(255*ones(size(A_back,1),25,3));
A_back = cat(2,add_space,cat(2,A_back,add_space));
A_left = imread([image_name '_' final_side{5} '.png']);
A_left = A_left(:,75:325,:);
A_right = imread([image_name '_' final_side{6} '.png']);
A_right = A_right(:,75:325,:); 
A_temp = cat(2,A_back,cat(2,A_left,A_right));
cd('C:\Users\M Sure\sciebo\RSN_Results\Images\Names')
A_name = imread([Network_Names{iRSN} '.png']);
Offset = round((size(A_temp,2)-size(A_name,2))/2);
add_height = 85;
add_name = uint8(255*ones(add_height,size(A_temp,2),3));
add_name(1:size(A_name,1),Offset:Offset+size(A_name,2)-1,:) = A_name;
A_temp = cat(1,add_name,A_temp);
for width_I = 300 : 335
    for length_I = 200 : 600
        A_temp(width_I, length_I,:) = [255;255;255];                       
    end
end
cd(Output_path)
imwrite(A_temp,sprintf([image_name '_paper.png'])); 
A_final = cat(1,A_final,A_temp);

%% Fron_Occ
iRSN = 2;
cd(Output_path)
image_name = ['Fig_Template_' Condition '_' Networks{iRSN}];
A_top = imread([image_name '_' final_side{1} '.png']);
A_top = A_top(:,100:300,:);
add_space = uint8(255*ones(size(A_top,1),25,3));
A_top = cat(2,add_space,cat(2,A_top,add_space));
A_front = imread([image_name '_' final_side{3} '.png']);
A_front = A_front(:,100:300,:); 
add_space = uint8(255*ones(size(A_front,1),25,3));
A_front = cat(2,add_space,cat(2,A_front,add_space));
A_back = imread([image_name '_' final_side{4} '.png']);
A_back = A_back(:,100:300,:); 
add_space = uint8(255*ones(size(A_back,1),25,3));
A_back = cat(2,add_space,cat(2,A_back,add_space));
A_temp = cat(2,A_top,cat(2,A_front,A_back));
cd('C:\Users\M Sure\sciebo\RSN_Results\Images\Names')
A_name = imread([Network_Names{iRSN} '.png']);
Offset = round((size(A_temp,2)-size(A_name,2))/2);
add_height = 85;
add_name = uint8(255*ones(add_height,size(A_temp,2),3));
add_name(1:size(A_name,1),Offset:Offset+size(A_name,2)-1,:) = A_name;
A_temp = cat(1,add_name,A_temp);
cd(Output_path)
imwrite(A_temp,sprintf([image_name '_paper.png'])); 
A_final = cat(1,A_final,A_temp);

%% Front
iRSN = 3;
cd(Output_path)
image_name = ['Fig_Template_' Condition '_' Networks{iRSN}];
A_top = imread([image_name '_' final_side{1} '.png']);
A_top = A_top(:,100:300,:);
add_space = uint8(255*ones(size(A_top,1),25,3));
A_top = cat(2,add_space,cat(2,A_top,add_space));
A_bottom = imread([image_name '_' final_side{2} '.png']);
A_bottom = A_bottom(:,100:300,:);
add_space = uint8(255*ones(size(A_bottom,1),25,3));
A_bottom = cat(2,add_space,cat(2,A_bottom,add_space));
A_front = imread([image_name '_' final_side{3} '.png']);
A_front = A_front(:,100:300,:); 
add_space = uint8(255*ones(size(A_front,1),25,3));
A_front = cat(2,add_space,cat(2,A_front,add_space));
A_temp = cat(2,A_top,cat(2,A_bottom,A_front));
cd('C:\Users\M Sure\sciebo\RSN_Results\Images\Names')
A_name = imread([Network_Names{iRSN} '.png']);
Offset = round((size(A_temp,2)-size(A_name,2))/2);
add_height = 85;
add_name = uint8(255*ones(add_height,size(A_temp,2),3));
add_name(1:size(A_name,1),Offset:Offset+size(A_name,2)-1,:) = A_name;
A_temp = cat(1,add_name,A_temp);
cd(Output_path)
imwrite(A_temp,sprintf([image_name '_paper.png'])); 
A_final = cat(1,A_final,A_temp);

cd(Output_path)
imwrite(A_final,sprintf(['Overview_RSN_' Condition '_paper.png']));


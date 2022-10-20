%% This script is used to create Figures 2 and 3 of the manuscript.
%Matthias Sure

side = {'left','right','top','bottom','front','back','left_intern','right_intern'};
% pick the template networks from the HC RSN networks;
Template_of_Interest = [2 3 5 6];
% name the networks
Networks = {'Visual','Front_Occ','DMN','Motor'};

final_side = {'top','bottom','front','back','left','right','left_intern','right_intern'};
Network_Names = {'Visual_text','Fronto_Occipital_text','Frontal_text','Sensory_Motor_text'};

Condition = {'pre_OFF','peri_OFF'};
Condition2 = {'pre_OFF','post_OFF'};
addpath('...\scripts')
%% Motor
iRSN = 4;
Output_path = ['...\Output'];%% in this case were the folder were the images created with Create_images_of_cortical_RSN.m are stored and the output
cd(Output_path)
for iCond = 1 : size(Condition,2)
    cd(Output_path)
    image_name = ['Template_' Condition{iCond} '_' Networks{iRSN}];
        %%
   %center
    A_top = imread([image_name '_' final_side{1} '.png']);
    A_top = A_top(:,76:325,:);
    A_top(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_left
    A_left = imread([image_name '_' final_side{5} '.png']);
    A_left = A_left(:,76:325,:);
    A_left(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_right
    A_right = imread([image_name '_' final_side{6} '.png']);
    A_right = A_right(:,76:325,:);
    A_right(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_left
    A_left_int = imread([image_name '_' final_side{7} '.png']);
    A_left_int = A_left_int(:,76:325,:);
    A_left_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_right
    A_right_int = imread([image_name '_' final_side{8} '.png']);
    A_right_int = A_right_int(:,76:325,:);
    A_right_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    
    A_temp = uint8(255*ones(630,630,3));
    A_temp(1:250,1:250,:) = A_left;%top_left
    A_temp(1:250,381:end,:) = A_right;%top_right
    A_temp(381:end,1:250,:) = A_left_int;%bottom_left
    A_temp(381:end,381:end,:) = A_right_int;%bottom_right
    A_temp(201:450,191:440,:) = A_top;%center
    if iCond == 1
        A_temp = AddTextToImage(A_temp,'A',[1 1],[0 0 0],'Arial',50);
    elseif iCond == 2
        A_temp = AddTextToImage(A_temp,'B',[1 1],[0 0 0],'Arial',50);
    end
    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_' Condition{iCond} '_paper.png']));       
end


%% Visual
iRSN = 1;

cd(Output_path)
for iCond = 1 : size(Condition,2)
    cd(Output_path)
    image_name = ['Template_' Condition{iCond} '_' Networks{iRSN}];
        %%
   %center
    A_back = imread([image_name '_' final_side{4} '.png']);
    A_back = A_back(:,76:325,:);
    A_back(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_left
    A_left = imread([image_name '_' final_side{5} '.png']);
    A_left = A_left(:,76:325,:);
    A_left(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_right
    A_right = imread([image_name '_' final_side{6} '.png']);
    A_right = A_right(:,76:325,:);
    A_right(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_left
    A_left_int = imread([image_name '_' final_side{7} '.png']);
    A_left_int = A_left_int(:,76:325,:);
    A_left_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_right
    A_right_int = imread([image_name '_' final_side{8} '.png']);
    A_right_int = A_right_int(:,76:325,:);
    A_right_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    
    A_temp = uint8(255*ones(630,630,3));
    A_temp(1:250,1:250,:) = A_left;%top_left
    A_temp(1:250,381:end,:) = A_right;%top_right
    A_temp(381:end,1:250,:) = A_left_int;%bottom_left
    A_temp(381:end,381:end,:) = A_right_int;%bottom_right
    A_temp(201:450,191:440,:) = A_back;%center
    if iCond == 1
        A_temp = AddTextToImage(A_temp,'C',[1 1],[0 0 0],'Arial',50);
    elseif iCond == 2
        A_temp = AddTextToImage(A_temp,'D',[1 1],[0 0 0],'Arial',50);
    end
    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_' Condition{iCond} '_paper.png']));     
end

%% Front_Occ
iRSN = 2;

cd(Output_path)
for iCond = 1 : size(Condition,2)
    cd(Output_path)
    image_name = ['Template_' Condition{iCond} '_' Networks{iRSN}];
        %%
   %center
    A_top = imread([image_name '_' final_side{1} '.png']);
    A_top = A_top(:,76:325,:);
    A_top(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_left
    A_front = imread([image_name '_' final_side{3} '.png']);
    A_front = A_front(:,76:325,:);
    A_front(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_right
    A_back = imread([image_name '_' final_side{4} '.png']);
    A_back = A_back(:,76:325,:);
    A_back(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_left
    A_left_int = imread([image_name '_' final_side{7} '.png']);
    A_left_int = A_left_int(:,76:325,:);
    A_left_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_right
    A_right_int = imread([image_name '_' final_side{8} '.png']);
    A_right_int = A_right_int(:,76:325,:);
    A_right_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    
    A_temp = uint8(255*ones(630,630,3));
    A_temp(1:250,1:250,:) = A_front;%top_left
    A_temp(1:250,381:end,:) = A_back;%top_right
    A_temp(381:end,1:250,:) = A_left_int;%bottom_left
    A_temp(381:end,381:end,:) = A_right_int;%bottom_right
    A_temp(201:450,191:440,:) = A_top;%center
    cd(Output_path)
    if iCond == 1
        A_temp = AddTextToImage(A_temp,'E',[1 1],[0 0 0],'Arial',50);
    elseif iCond == 2
        A_temp = AddTextToImage(A_temp,'F',[1 1],[0 0 0],'Arial',50);
    end
    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_' Condition{iCond} '_paper.png']));   
end
%% Frontal
iRSN = 3;

cd(Output_path)
for iCond = 1 : size(Condition,2)
    cd(Output_path)
    image_name = ['Template_' Condition{iCond} '_' Networks{iRSN}];
        %%
   %center
    A_front = imread([image_name '_' final_side{3} '.png']);
    A_front = A_front(:,76:325,:);
    A_front(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_left
    A_top = imread([image_name '_' final_side{1} '.png']);
    A_top = A_top(:,76:325,:);
    A_top(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_right
    A_bottom = imread([image_name '_' final_side{2} '.png']);
    A_bottom = A_bottom(:,76:325,:);
    A_bottom(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_left
    A_left_int = imread([image_name '_' final_side{7} '.png']);
    A_left_int = A_left_int(:,76:325,:);
    A_left_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_right
    A_right_int = imread([image_name '_' final_side{8} '.png']);
    A_right_int = A_right_int(:,76:325,:);
    A_right_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    
    A_temp = uint8(255*ones(630,630,3));
    A_temp(1:250,1:250,:) = A_top;%top_left
    A_temp(1:250,381:end,:) = A_bottom;%top_right
    A_temp(381:end,1:250,:) = A_left_int;%bottom_left
    A_temp(381:end,381:end,:) = A_right_int;%bottom_right
    A_temp(201:450,191:440,:) = A_front;%center
    if iCond == 1
        A_temp = AddTextToImage(A_temp,'G',[1 1],[0 0 0],'Arial',50);
    elseif iCond == 2
        A_temp = AddTextToImage(A_temp,'H',[1 1],[0 0 0],'Arial',50);
    end
    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_' Condition{iCond} '_paper.png']));         
end
%%
Final = [];
for iCond = 1 : size(Condition,2)
    Afinal = [];
    for iRSN = [4 1 2 3]
        cd(Output_path)
        image_name = ['Template_' Condition{iCond} '_' Networks{iRSN}];
        A = imread(sprintf([image_name '_' Condition{iCond} '_paper.png']));
        if iRSN == 4
            cd('...\Names')% Folder were images of the Network names are stored
            A_name = imread([Condition2{iCond} '.png']);
            Offset = round((size(A,2)-size(A_name,2))/2);
            add_height = 85;
            add_name = uint8(255*ones(add_height,size(A,2),3));
            add_name(1:size(A_name,1),Offset:Offset+size(A_name,2)-1,:) = A_name;
            A = cat(1,add_name,A);            
        end
        if iCond == 1
            cd('...\Names')% Folder were images of the Network names are stored
            A_name = rot90(imread([Network_Names{iRSN} '.png']));
            Offset = round((size(A,1)-add_height-size(A_name,1))/2);
            add_name = uint8(255*ones(size(A,1),size(A_name,2),3));
            add_name(Offset+add_height:Offset+add_height+size(A_name,1)-1,1:size(A_name,2),:) = A_name;
            A = cat(2,add_name,A);
        end
        if size(A,2) > size(Afinal,2) && ~isempty(Afinal)
            A = A(:,1:end-1,:);
        end
        Afinal = cat(1,Afinal,A);
    end
    if iCond == 1
        Final = Afinal;
    else
        Final = cat(2,Final,Afinal);
    end
end
%% add the colorbar
legend = imread('Template_color_bar_4.png');
add_height_1 = floor((size(Final,1)-size(legend,1))/2);
add_height_1 = uint8(255*ones(add_height_1,size(legend,2),3));
add_height_2 = ceil((size(Final,1)-size(legend,1))/2);
add_height_2 = uint8(255*ones(add_height_2,size(legend,2),3));
Final = cat(2,Final,cat(1,add_height_1,cat(1,legend,add_height_2)));
cd(Output_path)
imwrite(Final,sprintf(['Overview_RSN_' Condition{1} '_' Condition{2} '.png']));
image(Final);                
axis image               % resolution based on image
axis off                 % avoid printing axis 
set(gca,'LooseInset',get(gca,'TightInset')); % removing extra white space in figure
exportgraphics(gca,['Overview_RSN_' Condition{1} '_' Condition{2} '.pdf'],'Resolution',500)
    
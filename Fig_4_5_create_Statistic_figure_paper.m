%% This script is used to create Figures 4 and 5 of the manuscript.
%Matthias Sure
Condition = 'peri_OFF';
side = {'left','right','top','bottom','front','back','left_intern','right_intern'};
% pick the template networks from the HC RSN networks;
Template_of_Interest = [2 3 5 6];
% name the networks
Networks = {'Visual','Front_Occ','DMN','Motor'};

final_side = {'top','bottom','front','back','left','right','left_intern','right_intern'};
Network_Names = {'Visual_text','Fronto_Occipital_text','Frontal_text','Motor_text'};

%Names of the vs condition
test_cond = {'peri_OFF_vs_pre_OFF','peri_ON_vs_pre_ON'};
test_cond1 = {'post_OFF_vs_pre_OFF','post_ON_vs_pre_ON'};
legend_text = imread('...\legend_paper5.png'); % legend for the figures


addpath('...\scripts')
%% Motor
iRSN = 4;
Output_path = ['...\Output\\' Networks{iRSN} '\'];
cd(Output_path)
A_final = [];
for iCond = 1 : size(test_cond,2)
    cd(Output_path)
    image_name = [Networks{iRSN} '_' test_cond{iCond}];
        %%
   %center
    A_top = imread([image_name '_' final_side{1} '_signi.png']);
    A_top = A_top(:,76:325,:);
    A_top(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_left
    A_left = imread([image_name '_' final_side{5} '_signi.png']);
    A_left = A_left(:,76:325,:);
    A_left(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_right
    A_right = imread([image_name '_' final_side{6} '_signi.png']);
    A_right = A_right(:,76:325,:);
    A_right(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_left
    A_left_int = imread([image_name '_' final_side{7} '_signi.png']);
    A_left_int = A_left_int(:,76:325,:);
    A_left_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_right
    A_right_int = imread([image_name '_' final_side{8} '_signi.png']);
    A_right_int = A_right_int(:,76:325,:);
    A_right_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    
    A_temp = uint8(255*ones(630,630,3));
    A_temp(1:250,1:250,:) = A_left;%top_left
    A_temp(1:250,381:end,:) = A_right;%top_right
    A_temp(381:end,1:250,:) = A_left_int;%bottom_left
    A_temp(381:end,381:end,:) = A_right_int;%bottom_right
    A_temp(201:450,191:440,:) = A_top;%center
    
    A_temp = AddTextToImage(A_temp,'A',[1 1],[0 0 0],'Arial',50);

    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_paper_signi.png']));       

    cd('...\Names') % Folder were images of the Network names are stored
    A_name = rot90(imread(['Sensory_Motor_text.png']));
    Offset = round((size(A_temp,1)-add_height-size(A_name,1))/2);
    add_name = uint8(255*ones(size(A_temp,1),size(A_name,2),3));
    add_name(Offset+add_height:Offset+add_height+size(A_name,1)-1,1:size(A_name,2),:) = A_name;
    A_temp = cat(2,add_name,A_temp);
    A_final = A_temp;    
    
    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_paper.png'])); 
end

%% Visual
iRSN = 1;
Output_path = ['...\Output\' Networks{iRSN} '\'];
cd(Output_path)
A_final = [];
for iCond = 1 : size(test_cond,2)
    cd(Output_path)
    image_name = [Networks{iRSN} '_' test_cond{iCond}];
        %%
   %center
    A_back = imread([image_name '_' final_side{4} '_signi.png']);
    A_back = A_back(:,76:325,:);
    A_back(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_left
    A_left = imread([image_name '_' final_side{5} '_signi.png']);
    A_left = A_left(:,76:325,:);
    A_left(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_right
    A_right = imread([image_name '_' final_side{6} '_signi.png']);
    A_right = A_right(:,76:325,:);
    A_right(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_left
    A_left_int = imread([image_name '_' final_side{7} '_signi.png']);
    A_left_int = A_left_int(:,76:325,:);
    A_left_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_right
    A_right_int = imread([image_name '_' final_side{8} '_signi.png']);
    A_right_int = A_right_int(:,76:325,:);
    A_right_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    
    A_temp = uint8(255*ones(630,630,3));
    A_temp(1:250,1:250,:) = A_left;%top_left
    A_temp(1:250,381:end,:) = A_right;%top_right
    A_temp(381:end,1:250,:) = A_left_int;%bottom_left
    A_temp(381:end,381:end,:) = A_right_int;%bottom_right
    A_temp(201:450,191:440,:) = A_back;%center
    
    A_temp = AddTextToImage(A_temp,'B',[1 1],[0 0 0],'Arial',50);
    
    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_paper_signi.png']));     
      
 
    cd('...\Names') % Folder were images of the Network names are stored
    A_name = rot90(imread(['Visual_text.png']));
    Offset = round((size(A_temp,1)-size(A_name,1))/2);
    add_name = uint8(255*ones(size(A_temp,1),size(A_name,2),3));
    add_name(Offset:Offset+size(A_name,1)-1,1:size(A_name,2),:) = A_name;
    A_temp = cat(2,add_name,A_temp);
    A_final = A_temp;

    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_paper.png'])); 
end

%% Front_Occ
iRSN = 2;
Output_path = ['...\Output\' Networks{iRSN} '\'];
cd(Output_path)
A_final = [];
for iCond = 1 : size(test_cond,2)
    cd(Output_path)
    image_name = [Networks{iRSN} '_' test_cond{iCond}];
        %%
   %center
    A_top = imread([image_name '_' final_side{1} '_signi.png']);
    A_top = A_top(:,76:325,:);
    A_top(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_left
    A_front = imread([image_name '_' final_side{3} '_signi.png']);
    A_front = A_front(:,76:325,:);
    A_front(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_right
    A_back = imread([image_name '_' final_side{4} '_signi.png']);
    A_back = A_back(:,76:325,:);
    A_back(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_left
    A_left_int = imread([image_name '_' final_side{7} '_signi.png']);
    A_left_int = A_left_int(:,76:325,:);
    A_left_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_right
    A_right_int = imread([image_name '_' final_side{8} '_signi.png']);
    A_right_int = A_right_int(:,76:325,:);
    A_right_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    
    A_temp = uint8(255*ones(630,630,3));
    A_temp(1:250,1:250,:) = A_front;%top_left
    A_temp(1:250,381:end,:) = A_back;%top_right
    A_temp(381:end,1:250,:) = A_left_int;%bottom_left
    A_temp(381:end,381:end,:) = A_right_int;%bottom_right
    A_temp(201:450,191:440,:) = A_top;%center
    cd(Output_path)
    
    A_temp = AddTextToImage(A_temp,'C',[1 1],[0 0 0],'Arial',50);

    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_paper_signi.png']));     
      

    cd('...\Names') % Folder were images of the Network names are stored
    A_name = rot90(imread(['Fronto_Occipital_text.png']));
    Offset = round((size(A_temp,1)-size(A_name,1))/2);
    add_name = uint8(255*ones(size(A_temp,1),size(A_name,2)-1,3));
    add_name(Offset:Offset+size(A_name,1)-1,1:size(A_name,2)-1,:) = A_name(:,1:end-1,:);
    A_temp = cat(2,add_name,A_temp);
    A_final = A_temp;

    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_paper.png'])); 
end

%% Frontal
iRSN = 3;
Output_path = ['...\Output\' Networks{iRSN} '\'];
cd(Output_path)
A_final = [];
for iCond = 1 : size(test_cond,2)
    cd(Output_path)
    image_name = [Networks{iRSN} '_' test_cond{iCond}];
        %%
   %center
    A_front = imread([image_name '_' final_side{3} '_signi.png']);
    A_front = A_front(:,76:325,:);
    A_front(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_left
    A_top = imread([image_name '_' final_side{1} '_signi.png']);
    A_top = A_top(:,76:325,:);
    A_top(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %top_right
    A_bottom = imread([image_name '_' final_side{2} '_signi.png']);
    A_bottom = A_bottom(:,76:325,:);
    A_bottom(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_left
    A_left_int = imread([image_name '_' final_side{7} '_signi.png']);
    A_left_int = A_left_int(:,76:325,:);
    A_left_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    %bottom_right
    A_right_int = imread([image_name '_' final_side{8} '_signi.png']);
    A_right_int = A_right_int(:,76:325,:);
    A_right_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
    
    A_temp = uint8(255*ones(630,630,3));
    A_temp(1:250,1:250,:) = A_top;%top_left
    A_temp(1:250,381:end,:) = A_bottom;%top_right
    A_temp(381:end,1:250,:) = A_left_int;%bottom_left
    A_temp(381:end,381:end,:) = A_right_int;%bottom_right
    A_temp(201:450,191:440,:) = A_front;%center
    
    A_temp = AddTextToImage(A_temp,'D',[1 1],[0 0 0],'Arial',50);
 
    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_paper_signi.png']));         

    cd('...\Names') % Folder were images of the Network names are stored
    A_name = rot90(imread(['Frontal_text.png']));
    Offset = round((size(A_temp,1)-size(A_name,1))/2);
    add_name = uint8(255*ones(size(A_temp,1),size(A_name,2),3));
    add_name(Offset:Offset+size(A_name,1)-1,1:size(A_name,2),:) = A_name(:,1:end,:);
    A_temp = cat(2,add_name,A_temp);
    A_final = A_temp;

    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_paper.png']));  
end
for iCond = 1 : size(test_cond,2)
    Final = [];
    A = []; B = [];
    for iRSN = [4 1]
        image_name = [Networks{iRSN} '_' test_cond{iCond}];
        Output_path = ['...\Output\' Networks{iRSN} '\'];
        cd(Output_path)       
        A = cat(2,A,imread(sprintf([image_name '_paper.png'])));
    end
    for iRSN = [2 3]
        image_name = [Networks{iRSN} '_' test_cond{iCond}];
        Output_path = ['...\Output\' Networks{iRSN} '\'];
        cd(Output_path)       
        B = cat(2,B,imread(sprintf([image_name '_paper.png'])));
    end    
    
    Final = cat(1,A,B);

    cd('...\Names') % Folder were images of the Network names are stored
    A_name = imread([test_cond1{iCond} '.png']);
    Offset = round((size(Final,2)-size(A_name,2))/2);
    add_height = 85;
    add_name = uint8(255*ones(add_height,size(Final,2),3));
    add_name(1:size(A_name,1),Offset:Offset+size(A_name,2)-1,:) = A_name;
    Final = cat(1,add_name,Final);
    
    legend_text = imresize(legend_text,size(Final,2)/size(legend_text,2));
    if size(Final,2) ~= size(legend_text,2)
        add_space = uint8(255*ones(size(legend_text,1),size(Final,2)-size(legend_text,2),3));
        Final = cat(1,Final,cat(2,legend_text,add_space));
    else
        Final = cat(1,Final,legend_text);
    end
    % imwrite(A_final,sprintf([Networks{iRSN} '_JK_image_RSN_paper_5.png']));
    cd('...\Output')
    imwrite(Final,sprintf(['All_RSN_' test_cond{iCond} '.png']));
    image(Final);                
    axis image               % resolution based on image
    axis off                 % avoid printing axis 
    set(gca,'LooseInset',get(gca,'TightInset')); % removing extra white space in figure
    exportgraphics(gca,['All_RSN_' test_cond{iCond} '.pdf'],'Resolution',500)    
    
end

    
%% This scirpt is for combining the views of the RSN selected for the paper
%Matthias Sure
Condition = 'peri_OFF';
side = {'left','right','top','bottom','front','back','left_intern','right_intern'};
% pick the template networks from the HC RSN networks;
Template_of_Interest = [2 3 5 6];
% name the networks
Networks = {'Visual','Front_Occ','DMN','Motor'};

final_side = {'top','bottom','front','back','left','right','left_intern','right_intern'};
Network_Names = {'Visual_text','Fronto_Occipital_text','Frontal_text','Motor_text'};

% test_cond = {'pre_OFF_vs_pre_ON','peri_OFF_vs_peri_ON','peri_OFF_vs_pre_OFF','peri_ON_vs_pre_ON'};
test_cond = {'peri_OFF_vs_pre_OFF','peri_ON_vs_pre_ON'};
test_cond1 = {'post_OFF_vs_pre_OFF','post_ON_vs_pre_ON'};
legend_text = imread('...\Output\RSN_Results\legend_paper2.png');
% legend_text = legend_text(:,1:753,:);

addpath('V:\Skripte')
%% Motor
iRSN = 4;
Output_path = ['...\Output\RSN_Results\Images\' Networks{iRSN} '\'];
cd(Output_path)
A_final = [];
for iCond = 1 : size(test_cond,2)
    cd(Output_path)
    image_name = [Networks{iRSN} '_' test_cond{iCond}];
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
        A_temp = AddTextToImage(A_temp,'A',[1 1],[0 0 0],'Arial',42);
    elseif iCond == 2
        A_temp = AddTextToImage(A_temp,'B',[1 1],[0 0 0],'Arial',42);
    end
    cd(Output_path)
    imwrite(A_temp,sprintf([image_name '_paper.png']));       

    cd('...\Output\RSN_Results\Images\Names')
    A_name = imread([test_cond1{iCond} '.png']);
    Offset = round((size(A_temp,2)-size(A_name,2))/2);
    add_height = 85;
    add_name = uint8(255*ones(add_height,size(A_temp,2),3));
    add_name(1:size(A_name,1),Offset:Offset+size(A_name,2)-1,:) = A_name;
    A_temp = cat(1,add_name,A_temp);

    if iCond == 1
        cd('...\Output\RSN_Results\Images\Names')
        A_name = rot90(imread(['Motor_text.png']));
        Offset = round((size(A_temp,1)-add_height-size(A_name,1))/2);
        add_name = uint8(255*ones(size(A_temp,1),size(A_name,2),3));
        add_name(Offset+add_height:Offset+add_height+size(A_name,1)-1,1:size(A_name,2),:) = A_name;
        A_temp = cat(2,add_name,A_temp);
        A_final = A_temp;
    else
        A_final = cat(2,A_final,A_temp);
        A_final_all = A_final;
    end
%     cd(Output_path)
%     imwrite(A_temp,sprintf([image_name '_paper.png'])); 
end
% % if size(A_final,2) ~= size(legend_text,2)
% %     add_space = uint8(255*ones(size(legend_text,1),size(A_final,2)-size(legend_text,2),3));
% %     A_final = cat(1,A_final,cat(2,legend_text,add_space));
% % else
% %     A_final = cat(1,A_final,legend_text);
% % end
% % imwrite(A_final,sprintf([Networks{iRSN} '_JK_image_RSN_paper_5.png']));

%% Visual
iRSN = 1;
Output_path = ['...\Output\RSN_Results\Images\' Networks{iRSN} '\'];
cd(Output_path)
A_final = [];
for iCond = 1 : size(test_cond,2)
    cd(Output_path)
    image_name = [Networks{iRSN} '_' test_cond{iCond}];
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
    imwrite(A_temp,sprintf([image_name '_paper.png']));     
      
    if iCond == 1
        cd('...\Output\RSN_Results\Images\Names')
        A_name = rot90(imread(['Visual_text.png']));
        Offset = round((size(A_temp,1)-size(A_name,1))/2);
        add_name = uint8(255*ones(size(A_temp,1),size(A_name,2),3));
        add_name(Offset:Offset+size(A_name,1)-1,1:size(A_name,2),:) = A_name;
        A_temp = cat(2,add_name,A_temp);
        A_final = A_temp;
    else
        A_final = cat(2,A_final,A_temp);
        A_final_all = cat(1,A_final_all,A_final);
    end
%     cd(Output_path)
%     imwrite(A_temp,sprintf([image_name '_paper.png'])); 
end
% if size(A_final,2) ~= size(legend_text,2)
%     add_space = uint8(255*ones(size(legend_text,1),size(A_final,2)-size(legend_text,2),3));
%     A_final = cat(1,A_final,cat(2,legend_text,add_space));
% else
%     A_final = cat(1,A_final,legend_text);
% end
% imwrite(A_final,sprintf([Networks{iRSN} '_JK_image_RSN_paper_5.png']));



%% Front_Occ
iRSN = 2;
Output_path = ['...\Output\RSN_Results\Images\' Networks{iRSN} '\'];
cd(Output_path)
A_final = [];
for iCond = 1 : size(test_cond,2)
    cd(Output_path)
    image_name = [Networks{iRSN} '_' test_cond{iCond}];
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
    imwrite(A_temp,sprintf([image_name '_paper.png']));     
      

    if iCond == 1
        cd('...\Output\RSN_Results\Images\Names')
        A_name = rot90(imread(['Fronto_Occipital_text.png']));
        Offset = round((size(A_temp,1)-size(A_name,1))/2);
        add_name = uint8(255*ones(size(A_temp,1),size(A_name,2)-1,3));
        add_name(Offset:Offset+size(A_name,1)-1,1:size(A_name,2)-1,:) = A_name(:,1:end-1,:);
        A_temp = cat(2,add_name,A_temp);
        A_final = A_temp;
    else
        A_final = cat(2,A_final,A_temp);
        A_final_all = cat(1,A_final_all,A_final);
    end
%     cd(Output_path)
%     imwrite(A_temp,sprintf([image_name '_paper.png'])); 
end
% if size(A_final,2) ~= size(legend_text,2)
%     add_space = uint8(255*ones(size(legend_text,1),size(A_final,2)-size(legend_text,2),3));
%     A_final = cat(1,A_final,cat(2,legend_text,add_space));
% else
%     A_final = cat(1,A_final,legend_text);
% end
% imwrite(A_final,sprintf([Networks{iRSN} '_JK_image_RSN_paper_5.png']));

% % % %% Frontal
% % % iRSN = 3;
% % % Output_path = ['C:\Users\M Sure\sciebo\RSN_Results\Images\' Networks{iRSN} '\'];
% % % cd(Output_path)
% % % A_final = [];
% % % for iCond = 1 : size(test_cond,2)
% % %     cd(Output_path)
% % %     image_name = [Networks{iRSN} '_' test_cond{iCond}];
% % %         %%
% % %    %center
% % %     A_front = imread([image_name '_' final_side{3} '.png']);
% % %     A_front = A_front(:,76:325,:);
% % %     A_front(230:250,1:15,:) = uint8(255*ones(21,15,3));
% % %     %top_left
% % %     A_top = imread([image_name '_' final_side{1} '.png']);
% % %     A_top = A_top(:,76:325,:);
% % %     A_top(230:250,1:15,:) = uint8(255*ones(21,15,3));
% % %     %top_right
% % %     A_bottom = imread([image_name '_' final_side{2} '.png']);
% % %     A_bottom = A_bottom(:,76:325,:);
% % %     A_bottom(230:250,1:15,:) = uint8(255*ones(21,15,3));
% % %     %bottom_left
% % %     A_left_int = imread([image_name '_' final_side{7} '.png']);
% % %     A_left_int = A_left_int(:,76:325,:);
% % %     A_left_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
% % %     %bottom_right
% % %     A_right_int = imread([image_name '_' final_side{8} '.png']);
% % %     A_right_int = A_right_int(:,76:325,:);
% % %     A_right_int(230:250,1:15,:) = uint8(255*ones(21,15,3));
% % %     
% % %     A_temp = uint8(255*ones(630,630,3));
% % %     A_temp(1:250,1:250,:) = A_top;%top_left
% % %     A_temp(1:250,381:end,:) = A_bottom;%top_right
% % %     A_temp(381:end,1:250,:) = A_left_int;%bottom_left
% % %     A_temp(381:end,381:end,:) = A_right_int;%bottom_right
% % %     A_temp(201:450,191:440,:) = A_front;%center
% % %     if iCond == 1
% % %         A_temp = AddTextToImage(A_temp,'G',[1 1],[0 0 0],'Arial',50);
% % %     elseif iCond == 2
% % %         A_temp = AddTextToImage(A_temp,'H',[1 1],[0 0 0],'Arial',50);
% % %     end
% % %     cd(Output_path)
% % %     imwrite(A_temp,sprintf([image_name '_paper.png']));         
% % % 
% % % 
% % %     if iCond == 1
% % %         cd('...\Output\RSN_Results\Images\Names')
% % %         A_name = rot90(imread(['Frontal_text.png']));
% % %         Offset = round((size(A_temp,1)-size(A_name,1))/2);
% % %         add_name = uint8(255*ones(size(A_temp,1),size(A_name,2),3));
% % %         add_name(Offset:Offset+size(A_name,1)-1,1:size(A_name,2),:) = A_name(:,1:end,:);
% % %         A_temp = cat(2,add_name,A_temp);
% % %         A_final = A_temp;
% % %     else
% % %         A_final = cat(2,A_final,A_temp);
% % %         A_final_all = cat(1,A_final_all,A_final);
% % %     end
% % % %     cd(Output_path)
% % % %     imwrite(A_temp,sprintf([image_name '_paper.png']));  
% % % end

legend_text = imresize(legend_text,size(A_final_all,2)/size(legend_text,2));
if size(A_final_all,2) ~= size(legend_text,2)
    add_space = uint8(255*ones(size(legend_text,1),size(A_final_all,2)-size(legend_text,2),3));
    A_final_all = cat(1,A_final_all,cat(2,legend_text,add_space));
else
    A_final_all = cat(1,A_final_all,legend_text);
end
% imwrite(A_final,sprintf([Networks{iRSN} '_JK_image_RSN_paper_5.png']));
cd('...\Output\RSN_Results\Images\')
imwrite(A_final_all,sprintf(['All_RSN_paper_short.png']));  
function [networkModesFile] = labelingFromScouts( ZavgCorrCoefFile, scoutFile, iRun);

zThres = 2; % Keep ZavgCorrCoefFile only above zThres (zscore minimum value to keep) % 2.5

load(scoutFile)

orig = load(ZavgCorrCoefFile);
clusterResults = orig;
ImageGridAmp = orig.ImageGridAmp; clear orig

scoutVerts =  [Scouts(:).Vertices];
clusterResults.ImageGridAmp = zeros(size(ImageGridAmp,1),1);

if  1 %label is of region with max correlation with running voxel
    
    [maxImageGridAmp, iMax] = max((ImageGridAmp(scoutVerts,:)),[],1);
    
    for k = 1 : length(iMax)
        %k
        
        if max(ImageGridAmp(scoutVerts,k)) >= zThres;
            iclust = 0;
            while clusterResults.ImageGridAmp(k) == 0
                iclust = iclust +1;
                if ismember(scoutVerts(iMax(k)),Scouts(iclust).Vertices)
                    clusterResults.ImageGridAmp(k) = iclust;
                end
            end
            
        else
            clusterResults.ImageGridAmp(k) = 0;
        end
        
    end
    
else
    for k=1:size(ImageGridAmp,1)
        k
        for iscout = 1 : length(Scouts)
            M(iscout) = mean(ImageGridAmp(Scouts(iscout).Vertices,k));
        end
        [mm, clusterResults.ImageGridAmp(k)] = max(M);
    end
    
end

% and save
clusterResults.ImageGridAmp = [clusterResults.ImageGridAmp,clusterResults.ImageGridAmp];
clusterResults.Comment = sprintf('IFG labelling thres = %3.2f',zThres);
clusterResults.Time =  1:size(clusterResults.ImageGridAmp, 2);
clusterResults.ImageGridTime = 1:size(clusterResults.ImageGridAmp, 2);
% networkModesFile = strrep(ZavgCorrCoefFile,'results_', 'results_AllSubjects_000_labelingFromScouts.mat');
networkModesFile = ['results_AllSubjects_000_labelingFromScouts_R' num2str(iRun,'%04.f') '.mat'];
save(networkModesFile, '-struct', 'clusterResults')


%% Subplot of LHs for each bodypart of each experiment
% 20220526


function likelihoodPlots(rawData, files, outputPath)


%% Inputs

%number of experiments
expnum = size(rawData,1);

%number of bodyparts (bp) -- assumes every expt has same # of bp
% works by finding the # of bodyparts that include "_likelihood"
header = rawData{1,1}.Properties.VariableNames';
index = find(contains(header,'_likelihood'));
bpnum = length(index);

%subplot rows and cols
r = 3;
c = ceil(bpnum/r);

%num_bins for histogram plots
nbins = 20;

% colors (RGB) for likelihood plots, corresponding to DLC label colors
color = {[103/255 29/255 177/255];...
    [84/255 65/255 178/255];...
    [45/255 79/255 158/255];...
    [22/255 105/255 152/255];...
    [20/255 126/255 143/255];...
    [44/255 147/255 138/255];...
    [63/255 157/255 126/255];...
    [91/255 167/255 121/255];...
    [124/255 175/255 121/255];...
    [162/255 213/255 156/255];...
    [152/255 131/255 78/255];...
    [164/255 108/255 63/255];...
    [161/255 78/255 45/255];...
    [185/255 70/255 53/255];...
    [181/255 32/255 31/255]};

%% simplified bodypart header names and filenames
for i = 1:length(header)
    bdyparts{i,1} = extractBefore(header{i},"_");
end

for i = 1:length(files)
    fileNames{i,1} = extractBefore(files(i).name,"DLC");
end

%% Subplot of LH for each body part of each expt.
% distribution of LHs should be close to one if DLC model is good

% subplots
for i = 1:expnum
    f = figure;
    %position = [left bottom width height]
     f.Position = [680 300 1170 800];
     
    for j = 1:bpnum
        ax (j) = subplot(r,c,j);
        lh = rawData{i,1}{:,index(j)};
        histogram(lh, nbins,'EdgeColor','k','FaceColor',color{j},'FaceAlpha', 0.8);
        
        % plot labels, set y-axis to log scale
        set(gca, 'Color', 'w', 'YScale', 'log');
        xlabel('Likelihood', 'FontSize', 14);
        title (bdyparts(index(j)),'FontSize',14,'FontWeight','normal');
        
        set(gca, ...
            'LineWidth', 1,...
            'XColor', 'k',...
            'YColor', 'k',...
            'FontName', 'Arial',...
            'FontSize', 14,...
            'Box', 'on');
    end
    
    % Link the axes. Add labels.
    linkaxes(ax,'xy');
    set(gcf, 'Color', 'w');
    
    % add filename title
    sgtitle([fileNames{i}],'FontSize',12,'FontWeight','normal','Interpreter', 'none');
   
        %save as tiff and fig formats
        filename = [fileNames{i},'_likelihood'];
%       saveas(f,fullfile(fname, filename),'pdf');
        saveas(f,fullfile(outputPath, filename),'tif');
        saveas(f,fullfile(outputPath, filename),'fig');
    
end

end


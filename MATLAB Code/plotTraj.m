%% Plot Dal and larva trajectories
% 221020

function plotTraj (rawDatafilt, files, dalotiaAb1x, dalotiaAb1y, otherMidx, otherMidy, frameNum, otherOrg, outputPath)

%% Inputs

%number of experiments
expnum = size(rawDatafilt,1);

%number of bodyparts (bp) -- assumes every expt has same # of bp
% works by finding the # of bodyparts that include "_likelihood"
header = rawDatafilt{1,1}.Properties.VariableNames';
index = find(contains(header,'_likelihood'));
bpnum = length(index);

%rows
r = 1;
c = 5;

%subplot number
plotNum = r*c;

% frame to min conversion: eg, (1 sec/60 frames)*(1 min/60 sec)=time in min
fps = 60;
frame2time = (1/fps) * (1/60); %

%scatter plot marker size and alpha
sz = 11;
alpha = 0.4;

% fontsize of subplot titles
fntSz = 12;

%% simplified filenames

for i = 1:length(files)
    fileNames{i,1} = extractBefore(files(i).name,"DLC");
end

%% Make subplots for each experiment

% subplots of Dalotia mirror and base views and other organism mirror and base view
% each expt. in seperate fig.
% note: larger z-pos values are when animal goes up in elevation

for i = 1:2:expnum
    f = figure;
    %position = [left bottom width height]
    f.Position = [900 300 1000 700];
    % f.Position = [900 300 892 700];
    % f.Position = [100 54 717 951];

    % Dal base subplot
    ax1 = subplot(r,c,1);
    xDB = rawDatafilt{i,1}{:,dalotiaAb1x};
    yDB = rawDatafilt{i,1}{:,dalotiaAb1y};
    tDB = rawDatafilt{i,1}{:,frameNum} * frame2time;
    sDB = scatter(xDB, yDB, sz, tDB, 'filled','MarkerFaceAlpha', alpha);
                                % tDB accounts for the color
    % plot labels
    set(gca, 'color', 'w');
    xlabel('x-position', 'FontSize', 14);
    ylabel('y-position', 'FontSize', 14);
    title ('Dalotia, Top View','FontSize',fntSz,'FontWeight','normal');
    %     cD = colorbar;
    %     ylabel(cD,'Time (min)','FontSize', 14);
    pbaspect([1 5 1]);

    set(gca, ...
        'LineWidth', 1.5,...
        'XColor', 'k',...
        'YColor', 'k',...
        'FontName', 'Arial',...
        'FontSize', fntSz,...
        'Box', 'on', ...
        'XTickLabel', [], ...
        'YTickLabel', []);


    % Dal mirror subplot
    ax2 = subplot(r,c,3);
    xDM = rawDatafilt{i+1,1}{:,dalotiaAb1x};
    yDM = rawDatafilt{i+1,1}{:,dalotiaAb1y};
    tDM = rawDatafilt{i+1,1}{:,frameNum} * frame2time;
    sDM = scatter(xDM, yDM, sz, tDM, 'filled','MarkerFaceAlpha', alpha);

    % plot labels
    set(gca, 'Color', 'w');
    xlabel('z-position', 'FontSize', 14);
    %     ylabel('y-position', 'FontSize', 14);
    title ('Dalotia, Side View','FontSize',fntSz,'FontWeight','normal');
         % cD = colorbar;
    %     ylabel(cD,'Time (min)','FontSize', 14);
    pbaspect([1 5 1]);

    set(gca, ...
        'LineWidth', 1.5,...
        'XColor', 'k',...
        'YColor', 'k',...
        'FontName', 'Arial',...
        'FontSize', fntSz,...
        'Box', 'on', ...
        'XTickLabel', [], ...
        'YTickLabel', []);


    % other organism base subplot
    ax3 = subplot(r,c,2);
    xLB = rawDatafilt{i,1}{:,otherMidx};
    yLB = rawDatafilt{i,1}{:,otherMidy};
    tLB = rawDatafilt{i,1}{:,frameNum} * frame2time;
    sLB = scatter(xLB, yLB, sz, tLB, 'filled','MarkerFaceAlpha', alpha);

    % plot labels
    set(gca, 'Color', 'w');
    xlabel('x-position', 'FontSize', 14);
    %     ylabel('y-position', 'FontSize', 14);
    title ([otherOrg,', Top View'],'FontSize',fntSz,'FontWeight','normal');
    %     cD = colorbar;
    %     ylabel(cD,'Time (min)','FontSize', 14);
    pbaspect([1 5 1]);

    set(gca, ...
        'LineWidth', 1.5,...
        'XColor', 'k',...
        'YColor', 'k',...
        'FontName', 'Arial',...
        'FontSize', fntSz,...
        'Box', 'on', ...
        'XTickLabel', [], ...
        'YTickLabel', []);


    % other organism mirror subplot
    ax4 = subplot(r,c,4);
    xLM = rawDatafilt{i+1,1}{:,otherMidx};
    yLM = rawDatafilt{i+1,1}{:,otherMidy};
    tLM = rawDatafilt{i+1,1}{:,frameNum} * frame2time;
    sLM = scatter(xLM, yLM, sz, tLM, 'filled','MarkerFaceAlpha', alpha);

    % plot labels
    set(gca, 'Color', 'w');
    xlabel('z-position', 'FontSize', 14);
    %     ylabel('y-position', 'FontSize', 14);
    title ([otherOrg,', Side View'],'FontSize',fntSz,'FontWeight','normal');
    %     cD = colorbar;
    %     ylabel(cD,'Time (min)','FontSize', 14);
    pbaspect([1 5 1]);

    set(gca, ...
        'LineWidth', 1.5,...
        'XColor', 'k',...
        'YColor', 'k',...
        'FontName', 'Arial',...
        'FontSize', fntSz,...
        'Box', 'on', ...
        'XTickLabel', [], ...
        'YTickLabel', []);
 
    % colorbar subplot
    ax5 = subplot(r,c,5);
    cD = colorbar;
    caxis([0 20])
    ylabel(cD,'Time (min)','FontSize', 14);
    set(gca,'Visible','off')
    ax = gca;
    axpos = ax.Position;
    cD.Position(3) = 5*cD.Position(3);
    cD.Position(4) = 0.9*cD.Position(4);
    cD.LineWidth = 1.5;
    cD.FontSize = 14;
    ax.Position = axpos;

    % figure settings
    % linkaxes([ax1 ax3],'xy');
    % linkaxes([ax2 ax4],'xy');
    linkaxes([ax1 ax3],'x'); %the Dal & other organism top views
    linkaxes([ax2 ax4],'x'); %the Dal & other organism side views
    linkaxes([ax1 ax2 ax3 ax4],'y');
    sgtitle([fileNames{i},'  &  ', fileNames{i+1}],'FontSize',8,'FontWeight','normal','Interpreter', 'none');
    set(gcf, 'Color', 'w');


    % save as tif
    filename = [fileNames{i},['_DalAb1_', otherOrg, 'Mid_XYPos']];
    saveas(f,fullfile(outputPath, filename),'tif');

end

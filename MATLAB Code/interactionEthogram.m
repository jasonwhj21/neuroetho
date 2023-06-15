%% Interaction Ethogram
% 221101
%makes a figure of time of interactions

% rawDatafiltCollisions     format
% A cell column array with expnum/2 rows, each cell is a table of
% following       format
% frame_nums(arr)       final_collisions(arr)(logical arr with 1s as collisions)

%frame to minutes conversion factor
frame2min = 3600;

% create figure of interaction
totExp = size(rawDatafiltCollisions, 1);
f = figure;

for y = 1:totExp

    % col 1 -> frame #, col 2 -> final_collisions (0 or 1)
    frame_nums = rawDatafiltCollisions{y,1}{:, 1};
    time_col = frame_nums / frame2min;
    collision_data = rawDatafiltCollisions{y, 1}{:,2};

    ax(y) = subplot(totExp,1,y)
    bar(time_col, logical(collision_data),...
  'FaceColor',[0.6350 0.0780 0.1840],'EdgeColor',[0.6350 0.0780 0.1840],'LineWidth',1.5);
%         'FaceColor',[.2 .2 .2],'EdgeColor',[.2 .2 .2],'LineWidth',1.5);
   

    %     str_num = sprintf('%d', ogstrt);
    %     da_str = strcat('Experiment ', str_num);
    %     title(da_str);

    %pretty figure settings
    set(gca, ...
        'LineWidth', 1,...
        'XColor', 'k',...
        'YColor', 'k',...
        'FontName', 'Arial',...
        'FontSize', 8,...
        'Box', 'off');
    set(gca, 'Color', 'w');
    set(gcf, 'Color', 'w');

    %set figure window size
    set(gcf, 'Position',  [300, 50, 600, 900]);
    set(gca,'ytick',[]);
    set(gca,'xtick',[]);
    ylim([0.01,1]);
    linkaxes(ax,'xy');
    set(gca,'Xticklabel',[]);

    %   offsetAxes(gca);
    %   filename = [da_str,' ', otherOrg, ' Interactions'];
    %   saveas(f, fullfile(outputPath, filename),'fig');

end


set(gca,'xtickMode', 'auto');
set(gca,'xTickLabelMode', 'auto');
set(gca,'TickDir','out');
xlabel('Time (min)', 'FontSize', 16);



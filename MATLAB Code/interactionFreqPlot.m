%% Interaction Frequency
% 221101
%makes a figure of frequency of interactions from (wt vs. orco) conditions

%load orco data
load ("rawDatafiltCollisions_OrcoDalLioAnt.mat")

frame2min = 3600;

for i = 1:size(rawDatafiltCollisions,1)
    expt_time = size(rawDatafiltCollisions{i,1},1);
    expt_time_min = expt_time/frame2min;
    num_interactions = sum(rawDatafiltCollisions{i,1}.final_collisions,1);
    freq_orco(i,1) = num_interactions/expt_time_min;
end

%load wt data
load ("rawDatafiltCollisions_wtOrcoDalLioAnt.mat")

for i = 1:size(rawDatafiltCollisions,1)
    expt_time = size(rawDatafiltCollisions{i,1},1);
    expt_time_min = expt_time/frame2min;
    num_interactions = sum(rawDatafiltCollisions{i,1}.final_collisions,1);
    freq_wt(i,1) = num_interactions/expt_time_min;
end

%hard-coded temp to mak both cols same length
freq_wt(24,1) = nan;

freq = [freq_wt, freq_orco];

%%
figure
boxchart(freq, 'BoxFaceColor', [0.5,0.5,0.5]);
hold on 
s1 = swarmchart(1, freq_wt, 35, [0.1,0.1,0.1],'filled');
hold on 
s2 = swarmchart(2, freq_orco, 35, [1,0,0],'filled');
ylabel('Interaction Frequency (# of interactions/min)')

ylim([0 200]);
set(gca, ...
    'LineWidth', 2,...
    'XColor', 'k',...
    'YColor', 'k',...
    'FontSize', 14,...
    'Box', 'off',...
    'FontName', 'Arial');
set(gca, 'YScale', 'log')
set(gca, 'Color', 'w');

%save('freq_wt_orco_221108.mat', 'freq');

% figure
% h = notBoxPlot(freq, 'jitter', 0.3);
% d=[h.data];
% set(d(1:4:end),'markerfacecolor',[0.1,0.1,0.1],'color',[1,0,0]);
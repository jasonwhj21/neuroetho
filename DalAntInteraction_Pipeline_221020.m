%% Dal-Ant Freely Behaving Analysis
% 221020
%note: updated plotTraj from previous analysis pipeline

%% Clear all
clear all; clc; close all

%% User Inputs

% startPath = dir where DLC csv files from all vidoes are located
startPath = '/Users/jasonwong/Projects/Beetle_Learning_MATLAB/DalAnt_wt';
%startPath = 'Y:\Jonayet\Jonayet2022PostAnalysis\videos_all\videos_Liometopum\DalAnt_orco';

% str = ending str (including extension) of all files to use for anlaysis
str = '_filtered.csv';

%file path and name for which to save raw x,y data from all expts
output_path = '/Users/jasonwong/Projects/Beetle_Learning_MATLAB/DalAnt_wt';
% output_path = 'Y:\Jonayet\Jonayet2022PostAnalysis\videos_all\videos_Liometopum\DalAnt_orco';
new_filename = 'rawWtOrcoDalAnt.mat';
filepath_name = [output_path,'/', new_filename];

% expt interactors
organisms = 'wtOrcoDalLioAnt';
%organisms = 'OrcoDalLioAnt';

%string specifiying other organism (no spaces in this str)
otherOrg = 'LioAnt';

% likelihood cuttoff, lhcut scales from 0-1
lhcut = 0.7;

%filename for saving filtered data
filt_filename = ['xyDataFilt_',organisms,'.mat'];
fullFilePathName = [output_path,'/', filt_filename];

filtSizes_filename = ['rawDatafiltSizes_',organisms,'.mat'];
fullFilePathName_filtSizes = [output_path,'/', filtSizes_filename];

filtEllipses_filename = ['rawDatafiltEllipses_',organisms,'.mat'];
fullFilePathName_filtEllipses = [output_path,'/', filtEllipses_filename];

filtCollisions_filename = ['rawDatafiltCollisions_',organisms,'.mat'];
fullFilePathName_filtCollisions = [output_path,'/', filtCollisions_filename];


% set which bodypart to plot
% col index of desired bodypart for Dal and other organism
frameNum = 1;
dalotiaHeadx = 8;
dalotiaHeady = 9;
DalotiaElytrax = 14;
DalotiaElytray = 15;
dalotiaAb1x = 17;
dalotiaAb1y = 18;
dalotiaAb2x = 20;
dalotiaAb2y = 21;
dalotiaAb3x = 23;
dalotiaAb3y = 24;
otherHeadx = 32;
otherHeady = 33;
otherMidx = 35; %antMid (thorax)
otherMidy = 36; %antMid
otherTailx = 38;
otherTaily = 39;

% for getSizes2
dal_lw_ratio = 3.57; %dal from 1/19/22 expts
%other = antLio at moment 
other_lw_ratio = 2.16; %LioAnt from 1/19/22 expts

%% Step 1: Extract position (x,y) and likelihood data from all expts
%note, this step only needs to be run once, skip to step 2 if coming back to analyze already concatinated data

% function concatinates all data across expts into a single cell array
[rawData, files] = concatinate(startPath,str);

% save rawData, need the 'v7.3' for saving variable >2GB
% note: be in directory where you want to save the cell array
save(filepath_name,'rawData','files','-v7.3');

%% Clear all
clear all; clc; close all

% NOTE: re-run "user inputs section" if run this clearing section

%% Step 2: Filter x,y data based on chosen likelihood cutoff

%choose a likelihood cutoff (lhcut), if unsure, use can use likelihoodPlots
%function (see code from previous verison of analysis pipeline)

% load data of interest
load(filepath_name)

%filter and interpolate data
%filtInterp replaces any (x,y) points with cutoff<lhcut with a NaN
[rawDatafilt, rawDatafiltlin] = filtInterp(rawData, files, lhcut);

% save filtered matrices
save (fullFilePathName, 'rawDatafilt', 'files','-v7.3');

%filtLin_filename = ['xyDataFiltLinInterp_',organisms,'.mat'];
%fullFilePathName = [output_path,'\', filtLin_filename];
% save (fullFilePathName, 'rawDatafiltlin', 'files','-v7.3');

%% Clear all
clear all; clc; close all

% NOTE: re-run "user inputs section" if run this clearing section

%% Step 3: Plot filtered x,y plots for each expt

%create a new folder called "trajectories_filt" to save all plots in
traj_outputPath = [output_path,'\trajectories_filt'];
[status,msg] = mkdir(traj_outputPath)

%load relevant data 
load(fullFilePathName)

%decide if/how to interpolate missing points
plotTraj(rawDatafilt, files, dalotiaAb1x, dalotiaAb1y, otherMidx, otherMidy, frameNum, otherOrg, traj_outputPath)

%% Clear all
clear all; clc; close all

% NOTE: re-run "user inputs section" if run this clearing section

%% Step 4: getSizes2 for ellipses around each organism

% load filtered x,y data
load(fullFilePathName)

% xySizesFileName = ['xyDatafiltSizes', otherOrg, '.mat'];
[med_dalLength, med_dalWidth, med_otherLength, med_otherWidth, rawDatafiltSizes] = ...
    getSizes2(rawDatafilt, dalotiaHeadx, dalotiaHeady, dalotiaAb3x, dalotiaAb3y, ...
    otherHeadx, otherHeady, otherTailx, otherTaily, dal_lw_ratio, other_lw_ratio, otherOrg);

% save the output
save (fullFilePathName_filtSizes, 'rawDatafiltSizes','-v7.3');

%% Clear all
clear all; clc; close all

% NOTE: re-run "user inputs section" if run this clearing section

%% Step 5: Create Ellipses

% load filtered x,y data and filtSizes data
load(fullFilePathName)
load(fullFilePathName_filtSizes)

% strt and nd takes care of which exps #s to work with, strt:end, inclusive
% strt = 1; 
% nd = 10;   

rawDatafiltEllipses = createEllipses2(rawDatafilt, rawDatafiltSizes);
% rawDatafiltEllipses = createEllipses2(rawDatafilt, rawDatafiltSizes, strt, nd);
% MATLAB crashes with 10 exps, so need to do 5 at a time

% otherOrg = 'Dmel';z
% xyEllipsesFileName = ['xyDatafiltEllipses', otherOrg, '.mat'];

% % save the output
% save('rawDatafiltEllipsesMealworm910', 'rawDatafiltEllipses'); % removed '-v7.3' flag

% save the output, may take a while
tic
save (fullFilePathName_filtEllipses, 'rawDatafiltEllipses','-v7.3');
toc
% save (fullFilePathName_filtEllipses, 'rawDatafiltEllipses');

%% Clear all
clear all; clc; close all

% NOTE: re-run "user inputs section" if run this clearing section

%% Step 6: Get Interactions

% load filtEllipses data
tic
load(fullFilePathName_filtEllipses)
toc

tic
rawDatafiltCollisions = findCollision2(rawDatafiltEllipses, otherOrg);
toc

% save the output
save(fullFilePathName_filtCollisions, 'rawDatafiltCollisions', '-v7.3');

%% Clear all
clear all; clc; close all

% NOTE: re-run "user inputs section" if run this clearing section

%% Step 7: Plot interaction ethogram and frequency of interactions

%load filtCollisions data
load(fullFilePathName_filtCollisions)

% create interaction ethogram of data (manually save fig. if desired)
interactionEthogram

% plot frequency of interactions (note: this currently needs fixing, is
% specific to Dal wt vs. orco when interactin with ants)
% manually save fig. if desired
% interactionFreqPlot

%% Clear all
clear all; clc; close all

% NOTE: re-run "user inputs section" if run this clearing section

%% Get Velocity, Orientation, and Distance graphs for each insect in each expt

% load relevant data
load(fullFilePathName)

%outputPath = '/Volumes/jess/Jonayet/Jonayet2022PostAnalysis/velocities';
%outputPath = '/Volumes/jess/Jonayet/DalDmel-Jess-2022-04-12_postAnalysis/velocities';

[rawDatafiltVelocities, medianVelocities, otherVel] = velocities2(rawDatafilt, otherOrg);

% save the output
save('rawDatafiltVelocitiesMealybugDestroyer', 'rawDatafiltVelocities');


%% Classify interactions into different approach modes

%...
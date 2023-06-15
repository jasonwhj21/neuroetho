%% Concatinate data from all video csv files
% 20220526
% this function takes all files (expts) ending in desired string and combines data 
% from those files into a single cell array
%
% input: startPath (path location where csv files are stored) and str (file
% ending, incuding extension, for all csv files to analyze)
% ex:
% startPath = /Volumes/Parker_lab/JessK/Behavior/HungryHallway/DLC Analysis/DalAnt-JessDavid-2022-02-03/videos
% str = _filtered.csv
%
% output: cell array with contatinated rawData and struct with all files
% used
%


function [rawData, files] = concatinate(startPath, str)

%% Set path

% Get current directory
curr_dir = pwd;

% Ask user to confirm or change (GUI pops up)
topLevelFolder = uigetdir(startPath);
if topLevelFolder == 0
    return;
end

% Move to path with files in it
cd(startPath);

%% Create structure with name of all .csv files in folder

%load all files that end with input str
files = dir(fullfile(startPath, ['*',str]));

%% Import CSV file as .mat

rawData = cell(length(files),1);

for i = 1: length(files)
    %define data dir
    data_dir = [startPath, '/', files(i).name];
    
    %import csv file
    importOpts = detectImportOptions(data_dir);
    
    %set import options
    importOpts.VariableNamesLine = 2;
    importOpts.VariableUnitsLine = 3;
    importOpts.DataLine = 4;
    
    %add data into a a cell array of tables
    temp = readtable(data_dir, importOpts, 'ReadVariableNames', true);
    rawData{i,1} = temp;
    
    %go through all headers and add an "_" to end of each string (except first column)
    %then replace '_' --> _x', '_1_' --> '_y', '_2_' --> '_likelihood'
    %alter first col header from 'bodyparts' to Frame_Num'
    %this adjusts headers once they have been imported into Matlab
    rawData{i,1}.Properties.VariableNames = [rawData{i,1}.Properties.VariableNames(1),strcat(rawData{i,1}.Properties.VariableNames(2:end), '_0')];
    rawData{i,1}.Properties.VariableNames = regexprep(rawData{i,1}.Properties.VariableNames, '_1_0', '_y');
    rawData{i,1}.Properties.VariableNames = regexprep(rawData{i,1}.Properties.VariableNames, '_2_0', '_likelihood');
    rawData{i,1}.Properties.VariableNames = regexprep(rawData{i,1}.Properties.VariableNames, '_0', '_x');
    rawData{i,1}.Properties.VariableNames(1) = {'Frame_Num'}; 
    clear temp
    
    display([num2str(i), '/', num2str(length(files)), ' : ', files(i).name]);
end


%% Return to original dir 
 cd(curr_dir)
 

end



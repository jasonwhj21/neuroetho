str = '_filtered.csv';
path = '/Users/jasonwong/Projects/Beetle_Learning_MATLAB/Organism_CSVs'
folders = dir([path,'/','Dal_*']);
% load('/Users/jasonwong/Projects/Beetle_Learning_BENTO/Annotations_to_match_with_Jess/Dal_Solenopsis_2/Solenopsis_2Filt.mat');
% curves = curvature_circles(rawDatafilt);
% distances = distance(rawDatafilt);
% velocity = velocities2(rawDatafilt);
% interactions = readmatrix([path, '/Dal_Solepnosis/Test_Experiment_DalFormica2.annot'], 'FileType','text');
% save(outputpath,'curves','distances','velocity','-v7.3')
num_folders = size(folders,1);
for i = 1:num_folders
    organism = folders(i).name
    org_folder = [folders(i).folder,'/',organism];
    load([path,'/',organism,'/',organism,'XY']);
     [rawData,files] = concatinate(org_folder, str);
     [rawDatafilt, rawDatafiltlin] = filtInterp(rawDatafilt, files, 0.7);
     velocitylin = velocities2(rawDatafilt);
     curvaturelin = curvature_circles(rawDatafilt);
    [distanceslin,interactionslin] = distance(rawDatafiltlin,0,75);
    [distanceslin,before_interactionslin] = distance(rawDatafiltlin,75,250);
    [distanceslin,long_dist_interactionslin] = distance(rawDatafiltlin,0,250);
     flexlin = flexion(rawDatafiltlin);

    outputpath = [path,'/',organism,'/',organism,'XYLin'];
    save(outputpath,'rawDatafiltlin','-v7.3');
    outputpath2 = [path,'/',organism,'/',organism,'statisticslin'];
    save(outputpath2,'distanceslin','velocitylin','curvaturelin','flexlin','interactionslin','before_interactionslin','long_dist_interactionslin','-v7.3');
end

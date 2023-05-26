str = '_filtered.csv';
path = '/Users/jasonwong/Projects/Beetle_Learning_MATLAB/Organism_CSVs'
folders = dir([path,'/','Dal_*']);
% load('/Users/jasonwong/Projects/Beetle_Learning_BENTO/Annotations_to_match_with_Jess/Dal_Solenopsis_2/Solenopsis_2Filt.mat');
% curves = curvature_circles(rawDatafilt);
% distances = distance(rawDatafilt);
% velocity = velocities2(rawDatafilt);
% interactions = readmatrix([path, '/Dal_Solepnosis/Test_Experiment_DalFormica2.annot'], 'FileType','text');
% save(outputpath,'curves','distances','velocity','-v7.3')
% which = [1];
num_folders = size(folders,1);
for i = 1:num_folders
    
     organism = folders(i).name
     org_folder = [folders(i).folder,'/',organism];
    
%       [rawData,files] = concatinate(org_folder, str);
     load([org_folder,'/',organism,'XY'])
     load([org_folder,'/',organism,'XYLin'])
%          [rawDatafilt, rawDatafiltlin] = filtInterp(rawData, files, 0.7);
     velocity = velocities2(rawDatafilt);
     curvature = curvature_circles(rawDatafilt);
    [distances,interactions] = distance(rawDatafilt,0,50);
    [distances,before_interactions] = distance(rawDatafilt,50,125);
    [distances,long_dist_interactions] = distance(rawDatafilt,0,125);
     flex = flexion(rawDatafilt);

     velocitylin = velocities2(rawDatafiltlin);
     curvaturelin = curvature_circles(rawDatafiltlin);
    [distanceslin,interactionslin] = distance(rawDatafiltlin,0,50);
    [distanceslin,before_interactionslin] = distance(rawDatafiltlin,50,125);
    [distanceslin,long_dist_interactionslin] = distance(rawDatafiltlin,0,125);
     flexlin = flexion(rawDatafiltlin);

%     outputpath = [path,'/',organism,'/',organism,'XY'];
%     save(outputpath,'rawDatafilt','-v7.3');
%     outputpath1 = [path,'/',organism,'/',organism,'XYLin'];
%     save(outputpath1,'rawDatafiltlin','-v7.3');
    outputpath2 = [path,'/',organism,'/',organism,'statistics'];
    save(outputpath2,'distances','velocity','curvature','flex','interactions','before_interactions','long_dist_interactions','-v7.3');
    outputpath3 = [path,'/',organism,'/',organism,'statisticslin'];
    save(outputpath3,'distanceslin','velocitylin','curvaturelin','flexlin','interactionslin','before_interactionslin','long_dist_interactionslin','-v7.3');
end

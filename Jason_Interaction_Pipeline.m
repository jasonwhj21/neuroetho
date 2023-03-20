startPath = ''; %path in which the annotaions, DLC data, and other functions are stored
outputpath = ''; %can be same as startpath

for i = 1:num_orgs
    org_folder = "Annotations"+"/"+files(i).name;
    num_files = size(org_folder);
    for file = 1:num_files
        annotatFile = dir(org_folder + "*.annot");
        dlcFile = dir(org_folder + "*.csv");
        %read the files in and manipulate
    end
end
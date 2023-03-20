function annotations = readBento(filepath)
    annotation = readmatrix('filepath', 'FileType','text');
    behaviors = ['Dal_Approach', 'Other_Approach','Mutual_Approach'];
    [rows,columns] = find(isnan(annotation));
    starts = unique(rows);
    annotations = struct;
    annotations.dal_approach = annotation(1:starts(1)-1,1:2);
    annotations.other_approach = annotation(starts(2)+1:starts(3)-1,1:2);
    annotations.mutual_approach = annotation(starts(4)+1:end, 1:2);
end
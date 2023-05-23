dalAbd1T = [rawDatafilt{1,1}.DalotiaAbdomen1_x, rawDatafilt{1,1}.DalotiaAbdomen1_y, rawDatafilt{1+1,1}.DalotiaAbdomen1_x];
    dalHead = [rawDatafilt{1,1}.DalotiaHead_x, rawDatafilt{1,1}.DalotiaHead_y, rawDatafilt{1+1,1}.DalotiaHead_x];
    otherMidT = [rawDatafilt{1,1}.AntThorax_x, rawDatafilt{1,1}.AntThorax_y, rawDatafilt{+1,1}.AntThorax_x];
    otherHeadT = [rawDatafilt{1,1}.AntHead_x, rawDatafilt{1,1}.AntHead_y, rawDatafilt{1+1,1}.AntHead_x];
    midDist = vecnorm(dalAbd1T' - otherMidT')';
    headDist = vecnorm(dalHead' - otherMidT')';
    midHead = vecnorm(dalAbd1T' - otherHeadT')';
    headHead = vecnorm(dalHead' - otherHeadT')';

    collision = [min([midDist,headDist,midHead,headHead,midHead],[],2)<maxDist & min([midDist,headDist,headHead,midHead],[],2)>minDist];
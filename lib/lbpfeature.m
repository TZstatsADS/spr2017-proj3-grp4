function lbpfeature()
conf.calDir = './' ; % calculating directory
conf.dataDir = './images/' ; % data (image) directory 
conf.outDir = './output4/'; % output directory
conf.prefix = 'lbp_' ;
conf.lbpPath = fullfile(conf.outDir, [conf.prefix 'feature.mat']);

imname = dir(strcat(conf.dataDir,'*.jpg'));    
im_num = length(imname);
lbp = zeros(im_num, 59);

for a = 1:length(imname)
    img = imread(fullfile(conf.dataDir,imname(a).name));
    lbp(a,:) = extractLBPFeatures(img);
    sprintf('%s%d','image',a,'completed')
end

save(conf.lbpPath, 'lbp');
csvwrite('./output/lbp.csv',lbp);
end


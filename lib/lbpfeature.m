function lbpfeature()
imname = dir('C:\Users\qn_li\Columbia\Applied data science\wk7-Image Analysis\MATLAB_sift\images\*.jpg');
im_num = length(imname);
im_temp = imread(imname(1).name);
lbp = zeros(im_num, 59);

for a = 1:length(imname)
    img = imread(imname(a).name);
    lbp(a,:) = extractLBPFeatures(img);
    sprintf('%s%d','image',a,'completed')
end
end


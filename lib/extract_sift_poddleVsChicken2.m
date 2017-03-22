% Extract SIFT features for poddle vs. fried chicken image set
function extract_sift_poddleVsChicken2()

conf.calDir = './' ; % calculating directory
conf.dataDir = './images/' ; % data (image) directory 
conf.outDir = './output3/'; % output directory
conf.numWords = 10000 ; % vocabulary size
conf.numSpatialX = 1 ; % spatial histogram configuration
conf.numSpatialY = 1 ;
conf.quantizer = 'kdtree' ; % search structure

conf.prefix = 'sift_pf7' ;
conf.randSeed = 1 ;

conf.framePath = fullfile(conf.outDir, [conf.prefix '-framesall.mat']);
conf.descrPath = fullfile(conf.outDir, [conf.prefix '-descrall.mat']);
conf.histPath = fullfile(conf.outDir, [conf.prefix '-hists.mat']) ;
conf.vocabPath = fullfile(conf.outDir, [conf.prefix '-vocab.mat']);
conf.resultPath = fullfile(conf.outDir, [conf.prefix '-result']) ;

randn('state',conf.randSeed) ;
rand('state',conf.randSeed) ;
vl_twister('state',conf.randSeed) ;

model.numSpatialX = conf.numSpatialX ;
model.numSpatialY = conf.numSpatialY ;
model.quantizer = conf.quantizer ;
model.vocab = [] ;

% --------------------------------------------------------------------
%                                                     Train vocabulary
% --------------------------------------------------------------------

if ~exist(conf.vocabPath)
    file = fopen('train_img_names.csv');
    imagenames = textscan(file, '%s %*[^\n]');
    fclose(file);
    imagenames = imagenames{:};
    imagenames = imagenames(2:end);
    [nfiles, s] = size(imagenames);

% Get some SIFT descriptors to train the dictionary
    descrsall = {} ;
    frameall = {};
    for ii = 1:nfiles
        fprintf('Processing dictionary %s (%.2f %%)\n', imagenames{ii}, 100 * ii /nfiles) ;
        currentFileName = imagenames{ii};
        imm = imread(fullfile(conf.dataDir,currentFileName));
            if length(size(imm)) == 3
                im = single(rgb2gray(imm));
            else
                im = single(imm);
            end
            if size(im,1) > 480
                im = imresize(im, [480 NaN]);
            fprintf('\tResize.\n');
            end
    [frameall{ii}, descrsall{ii}] = vl_sift(im, 'PeakThresh', 10,'EdgeThresh',10);
    [m1, m2] = size(frameall{ii});
    img_names{ii} = repmat(ii, m2, 1);
    end


  % save the corresponding descriptors for all feature visualization
  descrsAll = horzcat(descrsall{:});
  descrsAll = single(descrsAll);
  save(conf.descrPath, 'descrsAll');
  % save the corresponding frames for all feature visualization
  framesAll = horzcat(frameall{:});
  save(conf.framePath,'framesAll');
  % save the image index for feature visualization
  imgAll = cat(1, img_names{:});
  csvwrite('./output3/descrsAll.csv', descrsAll);
  csvwrite('./output3/frameAll.csv', framesAll);
  csvwrite('./output3/imageAll.csv', imgAll);
  % Quantize the descriptors to get the visual words
  [vocab, assign] = vl_kmeans(descrsAll, conf.numWords, 'verbose', 'algorithm', 'elkan', 'MaxNumIterations', 100) ;
  save(conf.vocabPath, 'vocab');
  
  assign_tr = assign.';
  csvwrite('./output3/sift_feature_assign.csv', assign_tr);
  else
  load(conf.vocabPath) ;
end

model.vocab = vocab ;

if strcmp(model.quantizer, 'kdtree')
  model.kdtree = vl_kdtreebuild(vocab) ;
end

% --------------------------------------------------------------------
%                                           Compute spatial histograms
% --------------------------------------------------------------------

imagefilesAll = dir(strcat(conf.dataDir,'*.jpg'));      
nfilesALL = length(imagefilesAll);

if ~exist(conf.histPath)
  fprintf('Compute spatial histogram\n');
  hists = {} ;
  % parfor ii = 1:nfilesALL
  for ii = 1:nfilesALL
    fprintf('Processing dictionary %s (%.2f %%)\n', imagefilesAll(ii).name, 100 * ii /nfilesALL) ;
    %im = imread(fullfile(conf.calDir, images{ii})) ;
    currentFileName = imagefilesAll(ii).name;
    imm = imread(fullfile(conf.dataDir,currentFileName));
    hists{ii} = getImageDescriptor(model, imm);
  end

  hists = cat(2, hists{:}) ;
  save(conf.histPath, 'hists');
  csvwrite('./output3/histsall.csv',hists);
  % Save the sparse matrix for the use of R
  [row,col,v] = find(hists);
  hists_sparse = [row, col, v];
  csvwrite('./output3/hists_sparse_full.csv',hists_sparse);

else
  load(conf.histPath);
end

function hist = getImageDescriptor(model, imm)
% -------------------------------------------------------------------------
if length(size(imm)) == 3
        im = single(rgb2gray(imm));
else
    im = single(imm);
end

if size(im,1) > 480
    im = imresize(im, [480 NaN]);
    fprintf('\tResize.\n');
end
% im = standarizeImage(im) ;
width = size(im,2) ;
height = size(im,1) ;
numWords = size(model.vocab, 2) ;

% get sift features
[frames, descrs] = vl_sift(im) ;

% quantize local descriptors into visual words
switch model.quantizer
  case 'vq'
    [drop, binsa] = min(vl_alldist(model.vocab, single(descrs)), [], 1) ;
  case 'kdtree'
    binsa = double(vl_kdtreequery(model.kdtree, model.vocab, ...
                                  single(descrs), ...
                                  'MaxComparisons', 50)) ;
end

for i = 1:length(model.numSpatialX)
  binsx = vl_binsearch(linspace(1,width,model.numSpatialX(i)+1), frames(1,:)) ;
  binsy = vl_binsearch(linspace(1,height,model.numSpatialY(i)+1), frames(2,:)) ;

  % combined quantization
  bins = sub2ind([model.numSpatialY(i), model.numSpatialX(i), numWords], ...
                 binsy,binsx,binsa) ;
  hist = zeros(model.numSpatialY(i) * model.numSpatialX(i) * numWords, 1) ;
  hist = vl_binsum(hist, ones(size(bins)), bins) ;
  hists{i} = single(hist / sum(hist)) ;
end
hist = cat(1,hists{:}) ;
hist = hist / sum(hist) ;

function im = standarizeImage(im)
% -------------------------------------------------------------------------

im = im2single(im) ;
if size(im,1) > 480, im = imresize(im, [480 NaN]) ; end

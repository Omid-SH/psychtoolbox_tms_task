% Input i index and you will get 4*2*2 subjects
% i j k (data set reverse D1 <-> D4 D2 <-> D3) (hemifield TMS : 1 -> left, 2-> right)
% TMS left :
% S_i_1_1_1_1 , S_i_2_1_1_1 , S_i_1_2_1_1 , S_i_2_2_1_1
% S_i_1_1_2_1 , S_i_2_1_2_1 , S_i_1_2_2_1 , S_i_2_2_2_1

% TMS right :
% S_i_1_1_1_2 , S_i_2_1_1_2 , S_i_1_2_1_2 , S_i_2_2_1_2
% S_i_1_1_2_2 , S_i_2_1_2_2 , S_i_1_2_2_2 , S_i_2_2_2_2

clear; clc

id = input('Subject main index? ');

% Load images from Fraktals dataset
location = '../assets/Thesis Shapes/Fraktals/';       %  folder in which your images exists
imgs = zeros(32,200,200,3);      % store all images

for i = 1:32
    ds = imageDatastore([location, 'F', num2str(i), '.jpeg']);
    img = read(ds);
    imgs(i,:,:,:) = img;
end


% Load Fake Fraktals
location = '../assets/Thesis Shapes/Fake Fraktals/';       %  folder in which your images exists
fimgs = zeros(16,200,200,3);      % store all fake images

for i = 1:16
    ds = imageDatastore([location, 'Fake', num2str(i), '.jpeg']);
    img = read(ds);
    fimgs(i,:,:,:) = img;
end

% Main matrix
M = 1:32;

save(['../subjects','/M_', num2str(id)], 'M');

% Generate subject folders
for j = 1:2
    for k = 1:2
        for p = 1:2
            for l = 1:2         
                mkdir('../subjects',['S_', num2str(id), '_', num2str(j), '_', num2str(k), '_', num2str(p), '_', num2str(l)]);
                mkdir(['../subjects','/S_', num2str(id), '_', num2str(j), '_', num2str(k), '_', num2str(p), '_', num2str(l)], 'D_0');
                mkdir(['../subjects','/S_', num2str(id), '_', num2str(j), '_', num2str(k), '_', num2str(p), '_', num2str(l)], 'D_1');
                mkdir(['../subjects','/S_', num2str(id), '_', num2str(j), '_', num2str(k), '_', num2str(p), '_', num2str(l)], 'D_2');
                mkdir(['../subjects','/S_', num2str(id), '_', num2str(j), '_', num2str(k), '_', num2str(p), '_', num2str(l)], 'D_3');
                mkdir(['../subjects','/S_', num2str(id), '_', num2str(j), '_', num2str(k), '_', num2str(p), '_', num2str(l)], 'D_4');
            end
        end
    end
end

% Store Fraktals in folders
for d=1:4
    
    for k=1:4
        imwrite(uint8(squeeze(imgs(M(d*8-8+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_1_1', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-7-k+4),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_1', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-4+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_1', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+1-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_1_1', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        
        imwrite(uint8(squeeze(imgs(M(d*8-8+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_1_2', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-7-k+4),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_2', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-4+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_2', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+1-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_1_2', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        
        imwrite(uint8(squeeze(imgs(M(d*8-8+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_2_1', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-7-k+4),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_1', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-4+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_1', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+1-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_2_1', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        
        imwrite(uint8(squeeze(imgs(M(d*8-8+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_2_2', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-7-k+4),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_2', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-4+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_2', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+1-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_2_2', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
    end
    for k=5:8
        imwrite(uint8(squeeze(imgs(M(d*8-8+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_1_1', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+5-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_1', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-12+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_1', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+1-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_1_1', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        
        imwrite(uint8(squeeze(imgs(M(d*8-8+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_1_2', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+5-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_2', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-12+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_2', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+1-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_1_2', '/D_', num2str(d)],['F' num2str(k) '.jpeg']));
        
        imwrite(uint8(squeeze(imgs(M(d*8-8+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_2_1', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+5-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_1', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-12+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_1', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+1-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_2_1', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        
        imwrite(uint8(squeeze(imgs(M(d*8-8+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_2_2', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+5-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_2', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8-12+k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_2', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
        imwrite(uint8(squeeze(imgs(M(d*8+1-k),:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_2_2', '/D_', num2str(5-d)],['F' num2str(k) '.jpeg']));
    end
    
    % Import fake images (4 in each dataset)
    for f=1:4
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_1_1', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_1', '/D_', num2str(d)],['F' num2str(13-f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_1', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_1_1', '/D_', num2str(d)],['F' num2str(13-f) '.jpeg']));
        
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_1_2', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_2', '/D_', num2str(d)],['F' num2str(13-f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_2', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_1_2', '/D_', num2str(d)],['F' num2str(13-f) '.jpeg']));
                
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_2_1', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_1', '/D_', num2str(5-d)],['F' num2str(13-f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_1', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_2_1', '/D_', num2str(5-d)],['F' num2str(13-f) '.jpeg']));
        
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_2_2', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_2', '/D_', num2str(5-d)],['F' num2str(13-f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_2', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_2_2', '/D_', num2str(5-d)],['F' num2str(13-f) '.jpeg']));
    end
end


% Add training fracktals

% Load images from Training Fraktals dataset
location = '../assets/Thesis Shapes/Training Shapes/';       %  folder in which your images exists
imgs = zeros(12,200,200,3);      % store all images

for i = 1:12
    ds = imageDatastore([location, 'F', num2str(i), '.jpeg']);
    img = read(ds);
    imgs(i,:,:,:) = img;
end

% Training Fracktals on D0
for j=1:2
for k=1:2
for l=1:2
for p=1:2
    for f=1:12
        imwrite(uint8(squeeze(imgs(f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_', num2str(j), '_', num2str(k), '_', num2str(l), '_', num2str(p), '/D_', num2str(0)],['F' num2str(f) '.jpeg']));
    end
end
end
end
end
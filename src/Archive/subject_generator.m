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
location = '../assets/Fraktals/';       %  folder in which your images exists
imgs = zeros(32,200,200,3);      % store all images

for i = 1:32
    ds = imageDatastore([location, 'F', num2str(i), '.jpeg']);
    img = read(ds);
    imgs(i,:,:,:) = img;
end


% Load Fake Fraktals
location = '../assets/Fake Fraktals/';       %  folder in which your images exists
fimgs = zeros(16,200,200,3);      % store all fake images

for i = 1:16
    ds = imageDatastore([location, 'Fake', num2str(i), '.jpeg']);
    img = read(ds);
    fimgs(i,:,:,:) = img;
end

% Make main random matrix
M = zeros(1, 32);
for i = 1:8
    index = randperm(4) + 4*(i-1);
    for j = 1:4
        M(i+(j-1)*8) = index(j);
    end
end

for i = 1:4
    M(8*i-7:8*i) = M(randperm(8) + 8*(i-1));
end

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
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_1', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_1', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_1_1', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
        
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_1_2', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_2', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_2', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_1_2', '/D_', num2str(d)],['F' num2str(8+f) '.jpeg']));
                
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_2_1', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_1', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_1', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_2_1', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_2_2', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_2', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_2', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
        imwrite(uint8(squeeze(fimgs((d-1)*4+f,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_2_2', '/D_', num2str(5-d)],['F' num2str(8+f) '.jpeg']));
    end
end


% Add training fracktals

% Load images from Training Fraktals dataset
location = './Training Shapes/';       %  folder in which your images exists
imgs = zeros(8,200,200,3);      % store all images

for i = 1:8
    ds = imageDatastore([location, 'F', num2str(i), '.jpeg']);
    img = read(ds);
    imgs(i,:,:,:) = img;
end

for d=1:4
    % Training Fracktals on D0
    for p=1:8
        if( d == 1 )
            imwrite(uint8(squeeze(imgs(p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_1_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
            imwrite(uint8(squeeze(imgs(p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_1_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
            imwrite(uint8(squeeze(imgs(p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_2_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
            imwrite(uint8(squeeze(imgs(p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_1_2_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
        elseif( d == 2 )
            if(p<5)
                imwrite(uint8(squeeze(imgs(5-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(5-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(5-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(5-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
            else
                imwrite(uint8(squeeze(imgs(13-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(13-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_1_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(13-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(13-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_1_2_2_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
            end
        elseif( d == 3 )
            if(p<5)
                imwrite(uint8(squeeze(imgs(4+p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(4+p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(4+p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(4+p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
            else
                imwrite(uint8(squeeze(imgs(p-4,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(p-4,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_1_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(p-4,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
                imwrite(uint8(squeeze(imgs(p-4,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_1_2_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));

            end
        else
            imwrite(uint8(squeeze(imgs(9-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_1_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
            imwrite(uint8(squeeze(imgs(9-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_1_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
            imwrite(uint8(squeeze(imgs(9-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_2_1', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));
            imwrite(uint8(squeeze(imgs(9-p,:,:,:))),fullfile(['../subjects','/S_', num2str(id),'_2_2_2_2', '/D_', num2str(0)],['F' num2str(p) '.jpeg']));

        end
    end
end
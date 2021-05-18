close all
clear
clc
chps = 4;
skip_new = 0;
time_delay = 0;
rotation = 0;
%load ('im_corr_matrix.mat');

%settings for array spot identification
global int_corr
int_corr = 0.2;
global raduis_range
raduis_range = [30 50];
global el
el = 80;
global rnd
rnd = -2; % -2 giraffe; -1 Opticos


list=dir('S*.jpg');
num_img = floor(length(list)/chps)*chps;


%transform all amiges into the cell array
IMAGES = cell (num_img/chps,chps);
for i = 1:chps
    q=1;
    for k = i:chps:num_img
    im_rot = imrotate(imread(list(k).name),rotation,'bilinear','crop');    
    %IMAGES{q,i}=im2double(im_rot)./corr_m*100;
    IMAGES{q,i}=(im_rot);
    %IMAGES{q,i}=imread(list(k).name);
    q=q+1;
    end
end
%end
save('Images.mat','IMAGES');


%make array's masks
q=floor(length(list)/chps)*chps-3;
new_masks = menu('overwrite previous masks?', 'yes','no');
if new_masks == 1
    for k = 1 : chps
        im_rot = imrotate(imread(list(q).name),rotation,'bilinear','crop'); 
        rgb1 = im_rot;
        masks_temp = find_masks(rgb1,k);
        [a,~] = size (masks_temp);
        MASKS([1:a],k) = masks_temp;
        target_number(k,1) = a-1;
        q=q+1;
        close all
    end
    save('Masks.mat','MASKS');
    save('target_number.mat','target_number');
    close all
else 
    load('target_number.mat');
    load('Masks.mat');
end
fprintf('wait...\n');

%calculate spot's raw intensity
[u1, u2] = size (IMAGES);
DATA = cell(chps,1);

for k=1 : chps    
    %background intensity
    for i = 1: num_img/chps
        IMAGE = IMAGES{i,k};
        MASK = MASKS{1,k};
        DATA{k,1}(i,1) = image_x_mask(IMAGE, MASK);
    end 
    
    %targets intetsity
    for i = 1: num_img/chps
        for ii = 1: target_number(k,1)
            IMAGE = IMAGES{i,k};
            MASK = MASKS{ii+1,k};
            DATA{k,1}(i,ii+1) = image_x_mask(IMAGE, MASK);
        end
    end

end

%time scale calculation
%inital time point = time the very first image taken
name = list(1).name;
  h = name(6:7); m = name(8:9); ss = name(10:11);
  hrs= str2double(h); mn= str2double(m);sec= str2double(ss);
  time_abs_1= hrs*60*60+mn*60+sec;
  
for k=1 : chps    
    l=1;
    for i = k :chps: num_img
        name = list(i).name;
        h = name(6:7); m = name(8:9); ss = name(10:11);
        hrs= str2double(h); mn= str2double(m); sec= str2double(ss);
        time_abs = hrs*60*60+mn*60+sec;
        time_rel = time_delay + time_abs - time_abs_1;
        TIME{k,1}(l,1)= time_rel;
        l=l+1;
    end
end
save ('raw_DATA.mat','DATA');
save ('TIME.mat','TIME');
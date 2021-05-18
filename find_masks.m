function [ masks_temp ] = find_masks( rgb1,k )
global int_corr
global raduis_range
global el
global rnd

while 1
    figure (1);imshow(rgb1);
    K = imadjust(rgb1,[0 int_corr],[]);
    d = imdistline;delete(d);

    se(1) = 0.96; se(2) = 0.01;
    [centers, radii] = imfindcircles(K,raduis_range,'ObjectPolarity','bright', 'Sensitivity',se(1), 'EdgeThreshold', se(2));
    imshow(K)

    h = viscircles(centers,radii, 'EdgeColor','w', 'LineWidth', 5);
    centers(:,3) = radii(:,1);
    centers(:,1) = centers(:,1)-radii(:,1);
    centers(:,2) = centers(:,2)-radii(:,1);
    [a, ~] = size (centers);

    sat = menu('satisfied?', 'Yes', 'No' );
    if sat == 1
        break
    end
        
    
    while 1
    yy = inputdlg('Enter sensitivity and edge treshhold values. Initial values are 0.96 and 0.01','Sample', [1 50]);
    se = str2num(yy{:});
    [centers, radii] = imfindcircles(K,raduis_range,'ObjectPolarity','bright', 'Sensitivity',se(1), 'EdgeThreshold', se(2));
    imshow(K)

    h = viscircles(centers,radii);
    centers(:,3) = radii(:,1);
    centers(:,1) = centers(:,1)-radii(:,1);
    centers(:,2) = centers(:,2)-radii(:,1);
    [a, ~] = size (centers);

    sat = menu('satisfied?', 'Yes', 'No' );
    if sat == 1
        break
    end
    end
    break
end

% add missing targets
mis = menu('Missing any targets?', 'No', 'Yes' );
if mis == 2
    extra_targtes = menu('how many targets to add?', '1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20',...
                                                    '21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40',...
                                                    '41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60');
    new_targets = extra_targtes;
    pos = zeros (new_targets,4);
            for i = 1 : new_targets
                fprintf('Select taret #%d\n',i);
                h = imellipse(gca, [50 50 el el]);
                position = wait(h);
                pos(i,:) = getPosition(h);
                centers (a+i, 1) = pos(i, 1);
                centers (a+i, 2) = pos(i, 2);
                centers (a+i, 3) = pos(i,3)/2;
            end
    else
end
% end add missing targets



%sorting spots
[a,~] = size (centers);
c = centers;
n = 2;
%n = 15;

while 1
c (:,4) = round((c(:,2)+n),rnd);
cc = sortrows(c, [4 1]);
cen = (cc);

figure(1)
imshow(K)
hold on 

plot (cen(:,1),cen(:,2),'-','color', 'r', 'linewidth', 2.5)
for i =1:a
    x = cen(i,1);
    y = cen(i,2);
    text(x, y ,num2str(i), 'color', 'b', 'fontsize', 14);   
end

correct_order = menu('correct order?', 'YES', 'NO');
if correct_order == 1
    break
end

n = n + 5.5;
close (figure(1));
end


%end sorting spots

% delete bad targtes
xx = inputdlg('Enter space-separated numbers of the targets to be deleted:',...
             'Sample', [1 50]);
data = str2num(xx{:});
cen(data,:) = [];
% end delete bad targets

% final check of the spots and making masks
[a,~] = size (cen);
figure(2)
hold on
imshow (K)
for i = 1 : a
    text(cen(i,1), cen(i,2) ,num2str(i), 'color', 'b', 'fontsize', 1); 
    h = imellipse(gca, [cen(i,1),cen(i,2), cen(i,3)*2, cen(i,3)*2]);
    setColor(h,'g');
    position = wait(h);
    text(cen(i,1)-20, cen(i,2)-5 ,num2str(i), 'color', 'w', 'fontsize', 36); 
    pos(i,:) = getPosition(h);
    masks_temp{i,1}=createMask(h); 
end

saveas(gcf, ['Chip-' num2str(k) '-mask'] , 'pdf');
% end checking
end


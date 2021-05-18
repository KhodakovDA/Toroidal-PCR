close all
clear all

load ('raw_DATA.mat');
load ('TIME.mat');
load ('target_number.mat');
skip_new = 6;
sm_cycle = 4;
chps = 4;
threshold = 10; %10 of the range
range_start = 1;
range_stop = 30;
[a ~] = size (DATA{1,1}); 
num_img = a*chps;

for i = 1:chps
    q = 2;
    DATA_aver{i,1}(:,1) = DATA{i,1}(:,1);
    for ii = 2:2:49
       DATA_aver{i,1}(:,q)= (DATA{i,1}(:,ii)+DATA{i,1}(:,ii+1))/2;
    q = q+1;
    end
    end

%DATA
DATA = DATA_aver;
target_number = target_number/2;
% backgroond substraction for all data in DATA(:,2)
for i = 1 :chps
    for k = 1 : target_number(i,1)
    DATA{i,2}(:,k)=DATA{i,1}(:,k+1)-DATA{i,1}(:,1);
    end   
end


% normalization starting from cycle=skip_new. skip_new accounts for number
% of 'cycles' required for the flow to settle and the array to stabilize at
% the assay's temperature
for i = 1 :chps
    for k = 1 : target_number(i,1)
    DATA{i,3}([(skip_new+1):num_img/chps],k)=DATA{i,2}([(skip_new+1):num_img/chps],k)-DATA{i,2}((skip_new+1),k);
    end   
end

% control substraction
for i = 1 :chps
    for k = 1 : target_number(i,1)
        %norm by PCs
        %DATA{i,4}(:,k)=DATA{i,3}(:,k)-(((DATA{i,3}(:,1))+(DATA{i,3}(:,1))+(DATA{i,3}(:,1)))/3);
        
        %norm by NCs
        DATA{i,4}(:,k)=DATA{i,3}(:,k)-(((DATA{i,3}(:,target_number(i,1)-2))+(DATA{i,3}(:,target_number(i,1)-1)))/2);
        
    end   
end

for i = 1 :chps
             
        %norm by NCs
        DATA{i,4}(:,1)=DATA{i,4}(:,1)+7;
        DATA{i,4}(:,24)=DATA{i,4}(:,24)+7;
%         
%       
end

save ('DATA.mat','DATA');
save ('TIME.mat','TIME');

%  clear
global DATA
global TIME
load ('DATA.mat');
load ('TIME.mat')

fprintf('Done.\n');

tar_names = cell(24,1);
tar_names{1,1} = 'Pos.Control';
tar_names{2,1} = 'rs10917079'; %_1
tar_names{3,1} = 'rs4233039';%_2
tar_names{4,1} = 'rs11210795';%_1_3
tar_names{5,1} = 'rs596062';%_1_4
tar_names{6,1} = 'rs12030495';%_1_6
tar_names{7,1} = 'rs2483693';%_1_7
tar_names{8,1} = 'rs965949';%_1_8
tar_names{9,1} = 'rs12563071';%_1_9
tar_names{10,1} = 'rs10753501';%_2_1
tar_names{11,1} = 'rs3122037';%_2_2
tar_names{12,1} = 'rs517542';%_2_7
tar_names{13,1} = 'rs12119583';%_3_1
tar_names{14,1} = 'rs1112687';%_4_0
tar_names{15,1} = 'rs12031946';%_2_4
tar_names{16,1} = 'rs1335857';%_2_8
tar_names{17,1} = 'rs3789806';%_B
tar_names{18,1} = 'rs7519586';%_2_5
tar_names{19,1} = 'rs1934287';%_2_6
tar_names{20,1} = 'rs6702475';%_3_0
tar_names{21,1} = 'rs3116387';%_3_4
tar_names{22,1} = 'Neg.Control 1';%
tar_names{23,1} = 'Neg.Control 2';%
tar_names{24,1} = 'Pos.Control';%



% subplot the data
nCol = 4;
nRow = 6;
Rect = [0.07, 0.07, 0.90, 0.88];
space_x = 0.0001;
space_y = 0.001;
AxisPos = moPlotPos(nCol, nRow, Rect, space_x, space_y);

kkk = 600;
set(gcf, 'Position', [100, 100, kkk, kkk*3/3.5]);

plot_pos = [100,500;...
            500,500;...
            100,50;...
            500,50];

        
load ('target_number.mat');
target_number = target_number/2;

for chip = 1:4
figure (chip);

set(gcf, 'Position', [plot_pos(chip,:), kkk, kkk*3/3.5]);
    for i = 1 : target_number(1,1)
        
if chip == 1
  yy1 = smooth(TIME{1,1}/60,DATA{1,4}(:,i),0.25,'loess');
  axes('Position', AxisPos(i, :)); 
  plot(TIME{1,1}/60,yy1,'r', 'linewidth', 2); hold on
  set(gca, 'Color', 'None');
      if i > 1
          if i < 22
      y_max = max(DATA {1,4}(range_start:range_stop, i));
      time_ct = TIME{1,1};
      Data_ct = yy1;
      [Tt(i), treshold_val(i)] = find_Tt (skip_new, sm_cycle, Data_ct, time_ct, y_max, threshold);
      treshold_times(i,chip) = Tt(i);
      if isnan(Tt(i))
      else 
         line ([range_start range_stop], [treshold_val(i) treshold_val(i)],'Color',[0.2 0.2 0.2]);
      end    
      end
      end
end
% 

if chip == 2
yy1 = smooth(TIME{2,1}/60,DATA{2,4}(:,i),0.25,'loess');
axes('Position', AxisPos(i, :)); 
plot(TIME{2,1}/60,yy1,'g', 'linewidth', 2);hold on
set(gca, 'Color', 'None');
      if i > 1
          if i < 22
      y_max = max(DATA {2,4}(range_start:range_stop, i));
      time_ct = TIME{2,1};
      Data_ct = yy1;
      [Tt(i) treshold_val(i)] = find_Tt (skip_new, sm_cycle, Data_ct, time_ct, y_max, threshold);
     treshold_times(i,chip) = Tt(i);
     if isnan(Tt(i))
      else  
     line ([range_start range_stop], [treshold_val(i) treshold_val(i)],'Color',[0.2 0.2 0.2])
     end
     end
     end

end

if chip == 3
yy1 = smooth(TIME{3,1}/60,DATA{3,4}(:,i),0.25,'loess');
axes('Position', AxisPos(i, :));
plot(TIME{3,1}/60,yy1,'b', 'linewidth', 2);hold on
set(gca, 'Color', 'None');
      if i > 1
          if i < 22
      y_max = max(DATA {3,4}(range_start:range_stop, i));
      time_ct = TIME{3,1};
      Data_ct = yy1;
      [Tt(i) treshold_val(i)] = find_Tt (skip_new, sm_cycle, Data_ct, time_ct, y_max, threshold);
      treshold_times(i,chip) = Tt(i);
      if isnan(Tt(i))
      else 
      line ([range_start range_stop], [treshold_val(i) treshold_val(i)],'Color',[0.2 0.2 0.2])
      end
      end
      end
end

if chip == 4 
 yy1 = smooth(TIME{4,1}/60,DATA{4,4}(:,i),0.25,'loess');
 axes('Position', AxisPos(i, :));
 plot(TIME{4,1}/60,yy1,'m', 'linewidth', 2);hold on
 set(gca, 'Color', 'None');
       if i > 1
          if i < 22
      y_max = max(DATA {4,4}(range_start:range_stop, i));
      time_ct = TIME{4,1};
      Data_ct = yy1;
      [Tt(i) treshold_val(i)] = find_Tt (skip_new, sm_cycle, Data_ct, time_ct, y_max, threshold);
      treshold_times(i,chip) = Tt(i);
      if isnan(Tt(i))
      else 
      line ([range_start range_stop], [treshold_val(i) treshold_val(i)],'Color',[0.2 0.2 0.2])
      end
      end
      end
end

range_start = 1;
range_stop = 30; 
[a ~] = size(DATA{1,1});
if a < 30
    range_stop = a;
end
 
set(gca, 'xlim',([-0.5 30]));
set(gca, 'XTick',[0 10 20 30])

% Y scale opt
y_range_1 = max( DATA {1,4}(range_start:range_stop, i));
Y11 = -(y_range_1 *0.1);
Y12 = y_range_1 *1.1;

y_range_2 = max( DATA {2,4}(range_start:range_stop, i));
Y21 = -(y_range_2 *0.1);
Y22 = y_range_2 *1.1;

y_range_3 = max (DATA {3,4}(range_start:range_stop, i));
Y31 = -(y_range_3 *0.1);
Y32 = y_range_3 *1.1;

y_range_4 = max (DATA {4,4}(range_start:range_stop, i));
Y41 = -(y_range_4 *0.1);
Y42 = y_range_4 *1.1;

if y_range_1 > y_range_2
    y_lim_up = Y12;
    y_lim_low = Y11;
    else 
    y_lim_up = Y22;
    y_lim_low = Y21;
end

if y_lim_up > y_range_3
    y_lim_up = y_lim_up;
    y_lim_low = y_lim_low;
    else 
    y_lim_up = Y32;
    y_lim_low = Y31;
end

if y_lim_up > y_range_4
    y_lim_up = y_lim_up;
    y_lim_low = y_lim_low;
    else 
    y_lim_up = Y42;
    y_lim_low = Y41;
end

if y_lim_up == y_lim_low
    y_lim_up = 1;
    y_lim_low = -0.10;
end



if chip == 1
    y_lim_up = Y12;
    y_lim_low = Y11;
end

if chip == 2
    y_lim_up = Y22;
    y_lim_low = Y21;
end

if chip == 3
    y_lim_up = Y32;
    y_lim_low = Y31;
end

if chip == 4
    y_lim_up = Y42;
    y_lim_low = Y41;
end 
    
if y_lim_up == y_lim_low
    y_lim_up = 7;
    y_lim_low = -0.5;
    set(gca, 'ylim',([y_lim_low y_lim_up]));
end    
    
set(gca, 'ylim',([y_lim_low y_lim_up]));


if y_lim_up - y_lim_low < 3.2
    y_lim_up = 7;
    y_lim_low = -0.5;
    set(gca, 'ylim',([y_lim_low y_lim_up]));
end

Pos_control_spots = [1 24];
if ismember(i,Pos_control_spots) == 1
    text(2,y_lim_up/8,tar_names{i,1}, 'fontname', 'Courier', 'fontsize',12); 
end

Neg_control_spots = [22 23];
if ismember(i,Neg_control_spots) == 1
    text(2,y_lim_up/6*5,tar_names{i,1}, 'fontname', 'Courier', 'fontsize',12); 
end

 if i>1
        if i<22
                text(2,y_lim_up/3*2,[tar_names{i,1} char(10) '{\it T_t} = ' num2str(Tt(i))], 'fontname', 'Courier', 'fontsize',12);                      
        end
 end

     set(gca, 'YTick',[0 0.5*y_lim_up y_lim_up])

% plot y values only on specific sublots 
x_array = [21 22 23 24];
if ismember(i,x_array) == 1
    set(gca,'XTickLabel',[0 10 20 30],'FontSize',14);
    xlabel('Time (min)','FontSize',14)
    else set(gca,'XTickLabel',[]);
end

% plot y values only on specific sublots 
y_array = [1 5 9 13 17 21];
if ismember(i,y_array) == 1
    set(gca,'YTickLabel',[{0.0} {0.5} {1.0}],'FontSize',14);
    ylabel('RFU','FontSize',14)
    else set(gca,'YTickLabel',[])
end
%

set(gca,'xcolor','k');
set(gca,'ycolor','k');

    end
    
    chip_name = ['chip-' num2str(chip) ' qPCR Data'];

% saveas(gcf, chip_name, 'fig');
 saveas(gcf, chip_name, 'pdf')
end

%plot Tt for each chip
figure (5);

tick_label = ...
{'rs10917079',...
'rs4233039',...
'rs11210795',...
'rs596062',...
'rs12030495',...
'rs2483693',...
'rs965949',...
'rs12563071',...
'rs10753501',...
'rs3122037',...
'rs517542',...
'rs12119583',...
'rs1112687',...
'rs12031946',...
'rs1335857',...
'rs3789806',...
'rs7519586',...
'rs1934287',...
'rs6702475',...
'rs3116387'};

nCol = 1;
nRow = 4;
Rect = [0.07, 0.07, 0.90, 0.90];
Rect = [0.07, 0.13, 0.9, 0.85];
%       left bottom right top
space_x = 0.0001;
space_y = 0.0005;
AxisPos = moPlotPos(nCol, nRow, Rect, space_x, space_y);

kkk = 700;
set(gcf, 'Position', [100, 100, kkk, kkk*3/3.5]);

for i = 1:20
x_axis(i,1) = i;
end

for i = 1 : 4
    axes('Position', AxisPos(i, :));
    bar (x_axis,treshold_times((2:21),i), 'FaceColor',[0 .7 .7]); hold on
    set(gca, 'xlim',([0 21]));
    set(gca, 'ylim',([0 25]));
    set(gca,'XTickLabel',[]);
    set(gca, 'XTick',[1:1:20],'fontname', 'Arial', 'fontsize',12)
    set(gca, 'YTick',[0, 5, 15, 25],'fontname', 'Arial', 'fontsize',12)
    ylabel('{\it T_t } (min)','FontSize',12)
    legend (['Chip ' num2str(i)])
end

set(gca,'XTickLabel',tick_label,'fontname', 'Arial', 'fontsize',12);
set(gca,'XTickLabelRotation',45);
saveas(gcf, 'Data_combined', 'pdf')
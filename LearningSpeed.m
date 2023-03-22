clearvars
close all

startPath = 'Z:\Filippo\Animals';
try
    load(fullfile(startPath,'animalData.mat'))
catch
    fprintf(2,'\nThe variable "animalData.mat" doesn''t exist.')
    fprintf(2,'\nYou have to create it first.\n\n')
    return
end

% load Cohort Data
cohort_Data11 = animalData.cohort(11).animal;
cohort_Data14 = animalData.cohort(14).animal;
cohort_Data15 = animalData.cohort(15).animal;
cohort_Data16 = animalData.cohort(16).animal;
cohort_Data17 = animalData.cohort(17).animal;
cohort_Data18 = animalData.cohort(18).animal;

%% Cohort 11 + 14 + 17 (contrast = 20)
Speed20_initial = horzcat(cohort_Data11.intersec_initial,cohort_Data14.intersec_initial,cohort_Data17.intersec_initial);
Speed20_second = horzcat(cohort_Data11.intersec_second);

Speed20_initial_std = std(Speed20_initial,0,2,'omitnan');
Speed20_initial_mean = mean(Speed20_initial,2,'omitnan');

Speed20_second_std = std(Speed20_second,0,2,'omitnan');
Speed20_second_mean = mean(Speed20_second,2,'omitnan');

%% Cohort 15 (contrast = 12)
Speed12_initial = horzcat(cohort_Data15.intersec_initial);
Speed12_second = horzcat(cohort_Data15(1).intersec_second);

Speed12_initial_std = std(Speed12_initial,0,2,'omitnan');
Speed12_initial_mean = mean(Speed12_initial,2,'omitnan');

Speed12_second_std = std(Speed12_second,0,2,'omitnan');
Speed12_second_mean = mean(Speed12_second,2,'omitnan');

%% Cohort 16 (contrast = 14 or 16)
% STD & Mean for deltaA = 14
Speed14_initial = nan(1,3);
for i = 1:3
    Speed14_initial(1,i) = cohort_Data16(i).intersec_initial;
end
Speed14_second = nan(1,2);
for i = 1:2
    Speed14_second(1,i) = cohort_Data16(i).intersec_second;
end

Speed14_initial_std = std(Speed14_initial,0,2,'omitnan');
Speed14_initial_mean = mean(Speed14_initial,2,'omitnan');

Speed14_second_std = std(Speed14_second,0,2,'omitnan');
Speed14_second_mean = mean(Speed14_second,2,'omitnan');

% STD & Mean for deltaA = 16
Speed16_initial = nan(1,3);
for i = 4:6
    Speed16_initial(1,i-3) = cohort_Data16(i).intersec_initial;
end
Speed16_second = nan(1,3);
for i = 4:6
    Speed16_second(1,i-3) = cohort_Data16(i).intersec_second;
end

Speed16_initial_std = std(Speed16_initial,0,2,'omitnan');
Speed16_initial_mean = mean(Speed16_initial,2,'omitnan');

Speed16_second_std = std(Speed16_second,0,2,'omitnan');
Speed16_second_mean = mean(Speed16_second,2,'omitnan');

%% Cohort 18 - DREADD-Cohort
%Speed Saline
SpeedSa_initial = [cohort_Data18(1).intersec_initial,cohort_Data18(3).intersec_initial,cohort_Data18(5).intersec_initial,cohort_Data18(7).intersec_initial];
SpeedSa_second = [cohort_Data18(1).intersec_second,cohort_Data18(3).intersec_second,cohort_Data18(5).intersec_second,cohort_Data18(7).intersec_second];

SpeedSa_initial_std = std(SpeedSa_initial,0,2,'omitnan');
SpeedSa_initial_mean = mean(SpeedSa_initial,2,'omitnan');

SpeedSa_second_std = std(SpeedSa_second,0,2,'omitnan');
SpeedSa_second_mean = mean(SpeedSa_second,2,'omitnan');

%Speed CNO
SpeedCNO_initial = [cohort_Data18(2).intersec_initial,cohort_Data18(4).intersec_initial,cohort_Data18(6).intersec_initial,cohort_Data18(8).intersec_initial];
SpeedCNO_second = [cohort_Data18(2).intersec_second,cohort_Data18(4).intersec_second,cohort_Data18(6).intersec_second,cohort_Data18(8).intersec_second];

SpeedCNO_initial_std = std(SpeedCNO_initial,0,2,'omitnan');
SpeedCNO_initial_mean = mean(SpeedCNO_initial,2,'omitnan');

SpeedCNO_second_std = std(SpeedCNO_second,0,2,'omitnan');
SpeedCNO_second_mean = mean(SpeedCNO_second,2,'omitnan');

%% Some Statistics
[p0,h0] = ranksum(Speed20_initial,SpeedCNO_initial);
[p1,h1] = ranksum(SpeedSa_initial,SpeedCNO_initial);
[p2,h2] = ranksum(Speed20_second,SpeedCNO_second);
[p3,h3] = ranksum(SpeedSa_second,SpeedCNO_second);

%% Plot Data (deltaA comparison initial rules)
deltaA = [12,14,16,20];
speed_initial_mean = [Speed12_initial_mean, Speed14_initial_mean, Speed16_initial_mean, Speed20_initial_mean];
speed_initial_std = [Speed12_initial_std, Speed14_initial_std, Speed16_initial_std, Speed20_initial_std];
speed_all_initial = [[12*ones(size(Speed12_initial))';14*ones(size(Speed14_initial))';16*ones(size(Speed16_initial))';20*ones(size(Speed20_initial))'],...
    [Speed12_initial';Speed14_initial';Speed16_initial';Speed20_initial']];

f1 = figure; errorbar(deltaA,speed_initial_mean,speed_initial_std,'LineStyle','none','Color','k','Marker','o','MarkerFaceColor','k')
hold on; plot(speed_all_initial(:,1),speed_all_initial(:,2),'LineStyle','none','Marker','.')
xlabel('contrast [mm]')
ylabel('Trials to expert')
title('Learning Speed over contrast - initial Rules')
xline(6,'--','Performance cutoff','LabelHorizontalAlignment','center','LabelVerticalAlignment','middle')
xlim([5 22])

speed_max_initial = arrayfun(@(c) max(speed_all_initial(speed_all_initial(:,1) == c, 2)), deltaA);
text(12,speed_max_initial(1)+100,sprintf('n=%d',sum(speed_all_initial(:,1) == 12)),'HorizontalAlignment','center')
text(14,speed_max_initial(2)+100,sprintf('n=%d',sum(speed_all_initial(:,1) == 14)),'HorizontalAlignment','center')
text(16,speed_max_initial(3)+100,sprintf('n=%d',sum(speed_all_initial(:,1) == 16)),'HorizontalAlignment','center')
text(20,speed_max_initial(4)+100,sprintf('n=%d',sum(speed_all_initial(:,1) == 20)),'HorizontalAlignment','center')
ylim([200 1800])

%% Plot Data (deltaA comparison ruleswitch)
speed_second_mean = [Speed12_second_mean, Speed14_second_mean, Speed16_second_mean, Speed20_second_mean];
speed_second_std = [Speed12_second_std, Speed14_second_std, Speed16_second_std, Speed20_second_std];
speed_all_second = [[12*ones(size(Speed12_second))';14*ones(size(Speed14_second))';16*ones(size(Speed16_second))';20*ones(size(Speed20_second))'],...
    [Speed12_second';Speed14_second';Speed16_second';Speed20_second']];

f2 = figure; errorbar(deltaA,speed_second_mean,speed_second_std,'LineStyle','none','Color','k','Marker','o','MarkerFaceColor','k')
hold on; plot(speed_all_second(:,1),speed_all_second(:,2),'LineStyle','none','Marker','.')
xlabel('contrast [mm]')
ylabel('Trials to expert')
title('Learning Speed over contrast - second Rules')
xline(6,'--','Performance cutoff','LabelHorizontalAlignment','center','LabelVerticalAlignment','middle')
xlim([5 22])

speed_max_second = arrayfun(@(c) max(speed_all_second(speed_all_second(:,1) == c, 2)), deltaA);
text(12,speed_max_second(1)+100,sprintf('n=%d',sum(speed_all_second(:,1) == 12)),'HorizontalAlignment','center')
text(14,2615,sprintf('n=%d',sum(speed_all_second(:,1) == 14)),'HorizontalAlignment','center')
text(16,speed_max_second(3)+100,sprintf('n=%d',sum(speed_all_second(:,1) == 16)),'HorizontalAlignment','center')
text(20,speed_max_second(4)+100,sprintf('n=%d',sum(speed_all_second(:,1) == 20)),'HorizontalAlignment','center')
ylim([800 3000])

%% Plot Data (deltaA comparison - Boxchart)
f3 = figure; boxchart(speed_all_initial(:,1), speed_all_initial(:,2), 'BoxFaceColor', 'k')
hold on; boxchart(speed_all_second(:,1), speed_all_second(:,2))
xlabel('contrast [mm]')
ylabel('Trials to expert')
title('Learning Speed over contrast')
xline(6,'--','Performance cutoff','LabelHorizontalAlignment','center','LabelVerticalAlignment','middle')
xlim([5 22])
legend('initial Rules','second Rules','Location','southwest')

%% Plot Data (native-saline-CNO)
x = [1,2,3,5,6,7];
speed_mean = [Speed20_initial_mean, SpeedSa_initial_mean, SpeedCNO_initial_mean, Speed20_second_mean, SpeedSa_second_mean, SpeedCNO_second_mean];
speed_std = [Speed20_initial_std, SpeedSa_initial_std, SpeedCNO_initial_std, Speed20_second_std, SpeedSa_second_std, SpeedCNO_second_std];
speed_all = [[1*ones(size(Speed20_initial))';2*ones(size(SpeedSa_initial))';3*ones(size(SpeedCNO_initial))';...
    5*ones(size(Speed20_second))';6*ones(size(SpeedSa_second))';7*ones(size(SpeedCNO_second))'],...
    [Speed20_initial';SpeedSa_initial';SpeedCNO_initial';Speed20_second';SpeedSa_second';SpeedCNO_second']];

f4 = figure; errorbar(x,speed_mean,speed_std,'LineStyle','none','Color','k','Marker','o','MarkerFaceColor','k')
hold on; plot(speed_all(:,1),speed_all(:,2),'LineStyle','none','Marker','.')
xticks([1:3,5:7]); xticklabels({'native', 'saline', 'CNO','native', 'saline', 'CNO'});
ax = gca;
ax.XAxis.TickLabelRotation = 30;
text(2, 2e3, 'initial Rules', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold')
text(6, 2e3, 'second Rules', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold')
ylabel('Trials to expert')
xlim([0,8])
ylim([150, 2000])

speed_max = arrayfun(@(c) max(speed_all(speed_all(:,1) == c, 2)), x);

plot([1 3],[speed_max(3)+150 speed_max(3)+150], 'k')
if p0 < 0.05 && p0 > 0.01
    text(2, speed_max(3)+200,'*','HorizontalAlignment','center')
elseif p0 < 0.01 && p0 > 0.001
    text(2, speed_max(3)+200,'**','HorizontalAlignment','center')
elseif p0 < 0.001
    text(2, speed_max(3)+200,'***','HorizontalAlignment','center')
else
    text(2, speed_max(3)+200,'ns','HorizontalAlignment','center')
end

plot([2 3],[speed_max(3)+50 speed_max(3)+50], 'k')
if p1 < 0.05 && p1 > 0.01
    text(2.5, speed_max(3)+100,'*','HorizontalAlignment','center')
elseif p1 < 0.01 && p1 > 0.001
    text(2.5, speed_max(3)+100,'**','HorizontalAlignment','center')
elseif p1 < 0.001
    text(2.5, speed_max(3)+100,'***','HorizontalAlignment','center')
else
    text(2.5, speed_max(3)+100,'ns','HorizontalAlignment','center')
end

plot([5 7],[speed_max(6)+150 speed_max(6)+150], 'k')
if p2 < 0.05 && p2 > 0.01
    text(6, speed_max(6)+200,'*','HorizontalAlignment','center')
elseif p2 < 0.01 && p2 > 0.001
    text(6, speed_max(6)+200,'**','HorizontalAlignment','center')
elseif p2 < 0.001
    text(6, speed_max(6)+200,'***','HorizontalAlignment','center')
else
    text(6, speed_max(6)+200,'ns','HorizontalAlignment','center')
end

plot([6 7],[speed_max(6)+50 speed_max(6)+50], 'k')
if p3 < 0.05 && p3 > 0.01
    text(6.5, speed_max(6)+100,'*','HorizontalAlignment','center')
elseif p3 < 0.01 && p3 > 0.001
    text(6.5, speed_max(6)+100,'**','HorizontalAlignment','center')
elseif p3 < 0.001
    text(6.5, speed_max(6)+100,'***','HorizontalAlignment','center')
else
    text(6.5, speed_max(6)+100,'ns','HorizontalAlignment','center')
end

%% Plot Data (native-saline-CNO - Boxchart)
speed_all_native = [[1*ones(size(Speed20_initial))';5*ones(size(Speed20_second))'],...
    [Speed20_initial';Speed20_second']];
speed_all_saline = [[2*ones(size(SpeedSa_initial))';6*ones(size(SpeedSa_second))'],...
    [SpeedSa_initial';SpeedSa_second']];
speed_all_CNO = [[3*ones(size(SpeedCNO_initial))';7*ones(size(SpeedCNO_second))'],...
    [SpeedCNO_initial';SpeedCNO_second']];

f5 = figure; boxchart(speed_all_native(:,1), speed_all_native(:,2), 'BoxFaceColor', '#0072BD')
hold on; boxchart(speed_all_saline(:,1), speed_all_saline(:,2))
boxchart(speed_all_CNO(:,1), speed_all_CNO(:,2), 'BoxFaceColor', 'k')
%scatter(speed_all(:,1),speed_all(:,2),'Marker','.','MarkerEdgeColor','k','Jitter','on')
ylabel('Trials to expert'); ylim([200 1900])
xticks([]), xticklabels({})
text(2, 100, 'initial Rules', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold')
text(6, 100, 'second Rules', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold')

plot([1 3],[speed_max(3)+150 speed_max(3)+150], 'k')
if p0 < 0.05 && p0 > 0.01
    text(2, speed_max(3)+200,'*','HorizontalAlignment','center')
elseif p0 < 0.01 && p0 > 0.001
    text(2, speed_max(3)+200,'**','HorizontalAlignment','center')
elseif p0 < 0.001
    text(2, speed_max(3)+200,'***','HorizontalAlignment','center')
else
    text(2, speed_max(3)+200,'ns','HorizontalAlignment','center')
end

plot([2 3],[speed_max(3)+50 speed_max(3)+50], 'k')
if p1 < 0.05 && p1 > 0.01
    text(2.5, speed_max(3)+100,'*','HorizontalAlignment','center')
elseif p1 < 0.01 && p1 > 0.001
    text(2.5, speed_max(3)+100,'**','HorizontalAlignment','center')
elseif p1 < 0.001
    text(2.5, speed_max(3)+100,'***','HorizontalAlignment','center')
else
    text(2.5, speed_max(3)+100,'ns','HorizontalAlignment','center')
end

plot([5 7],[speed_max(6)+150 speed_max(6)+150], 'k')
if p2 < 0.05 && p2 > 0.01
    text(6, speed_max(6)+200,'*','HorizontalAlignment','center')
elseif p2 < 0.01 && p2 > 0.001
    text(6, speed_max(6)+200,'**','HorizontalAlignment','center')
elseif p2 < 0.001
    text(6, speed_max(6)+200,'***','HorizontalAlignment','center')
else
    text(6, speed_max(6)+200,'ns','HorizontalAlignment','center')
end

plot([6 7],[speed_max(6)+50 speed_max(6)+50], 'k')
if p3 < 0.05 && p3 > 0.01
    text(6.5, speed_max(6)+100,'*','HorizontalAlignment','center')
elseif p3 < 0.01 && p3 > 0.001
    text(6.5, speed_max(6)+100,'**','HorizontalAlignment','center')
elseif p3 < 0.001
    text(6.5, speed_max(6)+100,'***','HorizontalAlignment','center')
else
    text(6.5, speed_max(6)+100,'ns','HorizontalAlignment','center')
end

legend('native','saline','CNO','Location','southeast'); legend('boxoff')

%% Save all Plots
savefig(f1, fullfile('Z:\Josephine\Master-Thesis_Figures','LearningSpeed_initial.fig'))
savefig(f2, fullfile('Z:\Josephine\Master-Thesis_Figures','LearningSpeed_second.fig'))
savefig(f3, fullfile('Z:\Josephine\Master-Thesis_Figures','LearningSpeed_Boxcharts.fig'))
savefig(f4, fullfile('Z:\Josephine\Master-Thesis_Figures','LearningSpeed_CNO.fig'))
savefig(f5, fullfile('Z:\Josephine\Master-Thesis_Figures','LearningSpeed_CNO_Boxcharts.fig'))
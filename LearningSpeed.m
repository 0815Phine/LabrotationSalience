clearvars

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
    Speed14_temp = cohort_Data16(i).intersec_initial;
    Speed14_initial(1,i) = Speed14_temp;
end
Speed14_second = nan(1,2);
for i = 1:2
    Speed14_temp = cohort_Data16(i).intersec_second;
    Speed14_second(1,i) = Speed14_temp;
end

Speed14_initial_std = std(Speed14_initial,0,2,'omitnan');
Speed14_initial_mean = mean(Speed14_initial,2,'omitnan');

Speed14_second_std = std(Speed14_second,0,2,'omitnan');
Speed14_second_mean = mean(Speed14_second,2,'omitnan');

% STD & Mean for deltaA = 16
Speed16_initial = nan(1,3);
for i = 4:6
    Speed16_temp = cohort_Data16(i).intersec_initial;
    Speed16_initial(1,i-3) = Speed16_temp;
end
Speed16_second = nan(1,3);
for i = 4:6
    Speed16_temp = cohort_Data16(i).intersec_second;
    Speed16_second(1,i-3) = Speed16_temp;
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
Speed_initial_mean = [Speed12_initial_mean, Speed14_initial_mean, Speed16_initial_mean, Speed20_initial_mean];
Speed_initial_std = [Speed12_initial_std, Speed14_initial_std, Speed16_initial_std, Speed20_initial_std];
speed_all_initial = [[12*ones(size(Speed12_initial))';14*ones(size(Speed14_initial))';16*ones(size(Speed16_initial))';20*ones(size(Speed20_initial))'],...
    [Speed12_initial';Speed14_initial';Speed16_initial';Speed20_initial']];

figure; errorbar(deltaA,Speed_initial_mean,Speed_initial_std,'LineStyle','none','Marker','o')
hold on
plot(speed_all_initial(:,1),speed_all_initial(:,2),'LineStyle','none','Marker','.')
xlabel('deltaA [mm]')
ylabel('Learning Speed [Trials]')
title('Learning Speed per deltaA - initial Rules')
xlim([10 22])

%% Plot Data (deltaA comparison ruleswitch)
Speed_second_mean = [Speed12_second_mean, Speed14_second_mean, Speed16_second_mean, Speed20_second_mean];
Speed_second_std = [Speed12_second_std, Speed14_second_std, Speed16_second_std, Speed20_second_std];
speed_all_second = [[12*ones(size(Speed12_second))';14*ones(size(Speed14_second))';16*ones(size(Speed16_second))';20*ones(size(Speed20_second))'],...
    [Speed12_second';Speed14_second';Speed16_second';Speed20_second']];

figure; errorbar(deltaA,Speed_second_mean,Speed_second_std,'LineStyle','none','Marker','o')
hold on
plot(speed_all_second(:,1),speed_all_second(:,2),'LineStyle','none','Marker','.')
xlabel('deltaA [mm]')
ylabel('Learning Speed [Trials]')
title('Learning Speed per deltaA - second Rules')
xlim([10 22])

%% Plot Data (native-saline-CNO)
x = [1,2,3,5,6,7];
Speed_mean = [Speed20_initial_mean, SpeedSa_initial_mean, SpeedCNO_initial_mean, Speed20_second_mean, SpeedSa_second_mean, SpeedCNO_second_mean];
Speed_std = [Speed20_initial_std, SpeedSa_initial_std, SpeedCNO_initial_std, Speed20_second_std, SpeedSa_second_std, SpeedCNO_second_std];
speed_all = [[1*ones(size(Speed20_initial))';2*ones(size(SpeedSa_initial))';3*ones(size(SpeedCNO_initial))';...
    5*ones(size(Speed20_second))';6*ones(size(SpeedSa_second))';7*ones(size(SpeedCNO_second))'],...
    [Speed20_initial';SpeedSa_initial';SpeedCNO_initial';Speed20_second';SpeedSa_second';SpeedCNO_second']];

figure; errorbar(x,Speed_mean,Speed_std,'LineStyle','none','Color','k','Marker','o','MarkerFaceColor','k')
hold on
plot(speed_all(:,1),speed_all(:,2),'LineStyle','none','Marker','.')
xticks([1:3,5:7]); xticklabels({'native', 'saline', 'CNO','native', 'saline', 'CNO'});
ax = gca;
ax.XAxis.TickLabelRotation = 30;
text(2, 2e3, 'initial rules', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold')
text(6, 2e3, 'second rules', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold')
ylabel('Learning Speed [Trials]')
xlim([0,8])
ylim([150, 2000])

plot([1 3],[900 900], 'k')
if p0 < 0.05 && p0 > 0.01
    text(2, 950,'*','HorizontalAlignment','center')
elseif p0 < 0.01 && p0 > 0.001
    text(2, 950,'**','HorizontalAlignment','center')
elseif p0 < 0.001
    text(2, 950,'***','HorizontalAlignment','center')
else
    text(2, 950,'ns','HorizontalAlignment','center')
end

plot([2 3],[800 800], 'k')
if p1 < 0.05 && p1 > 0.01
    text(2.5, 850,'*','HorizontalAlignment','center')
elseif p1 < 0.01 && p1 > 0.001
    text(2.5, 850,'**','HorizontalAlignment','center')
elseif p1 < 0.001
    text(2.5, 850,'***','HorizontalAlignment','center')
else
    text(2.5, 850,'ns','HorizontalAlignment','center')
end

plot([5 7],[1800 1800], 'k')
if p2 < 0.05 && p2 > 0.01
    text(6, 1850,'*','HorizontalAlignment','center')
elseif p2 < 0.01 && p2 > 0.001
    text(6, 1850,'**','HorizontalAlignment','center')
elseif p2 < 0.001
    text(6, 1850,'***','HorizontalAlignment','center')
else
    text(6, 1850,'ns','HorizontalAlignment','center')
end

plot([6 7],[1700 1700], 'k')
if p3 < 0.05 && p3 > 0.01
    text(6.5, 1750,'*','HorizontalAlignment','center')
elseif p3 < 0.01 && p3 > 0.001
    text(6.5, 1750,'**','HorizontalAlignment','center')
elseif p3 < 0.001
    text(6.5, 1750,'***','HorizontalAlignment','center')
else
    text(6.5, 1750,'ns','HorizontalAlignment','center')
end

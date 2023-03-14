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
cohort_Data17 = animalData.cohort(17).animal;
cohort_Data18 = animalData.cohort(18).animal;

%% Get Learning Speed native animals
Speed_initial = horzcat(cohort_Data11.intersec_initial,cohort_Data14.intersec_initial,cohort_Data17.intersec_initial);
Speed_second = horzcat(cohort_Data11.intersec_second);

Speed_initial_std = std(Speed_initial,0,2,'omitnan');
Speed_initial_mean = mean(Speed_initial,2,'omitnan');

Speed_second_std = std(Speed_second,0,2,'omitnan');
Speed_second_mean = mean(Speed_second,2,'omitnan');

%% Get Learning Speed (Cohort 18 - DREADD-Cohort)
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
[p0,h0] = ranksum(Speed_initial,SpeedCNO_initial);
[p1,h1] = ranksum(SpeedSa_initial,SpeedCNO_initial);
[p2,h2] = ranksum(Speed_second,SpeedCNO_second);
[p3,h3] = ranksum(SpeedSa_second,SpeedCNO_second);

%% Plot Data
x = [1,2,3,5,6,7];
Speed_mean = [Speed_initial_mean, SpeedSa_initial_mean, SpeedCNO_initial_mean, Speed_second_mean, SpeedSa_second_mean, SpeedCNO_second_mean];
Speed_std = [Speed_initial_std, SpeedSa_initial_std, SpeedCNO_initial_std, Speed_second_std, SpeedSa_second_std, SpeedCNO_second_std];
speed_all = [[1*ones(size(Speed_initial))';2*ones(size(SpeedSa_initial))';3*ones(size(SpeedCNO_initial))';...
    5*ones(size(Speed_second))';6*ones(size(SpeedSa_second))';7*ones(size(SpeedCNO_second))'],...
    [Speed_initial';SpeedSa_initial';SpeedCNO_initial';Speed_second';SpeedSa_second';SpeedCNO_second']];

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

%% original Code (still should work, just uncomment)
cohort_Data11 = animalData.cohort(11).animal;
cohort_Data14 = animalData.cohort(14).animal;
cohort_Data17 = animalData.cohort(17).animal;
cohort_Data18 = animalData.cohort(18).animal;
cohort_Data19 = animalData.cohort(19).animal;

%%Cohort 11 + 14 + 17 (contrast = 20)
Speed20_initial = horzcat(cohort_Data11.intersec_initial,cohort_Data14.intersec_initial,cohort_Data17.intersec_initial);
Speed20_second = horzcat(cohort_Data11.intersec_second);

Speed20_initial_std = std(Speed20_initial,0,2,'omitnan');
Speed20_initial_mean = mean(Speed20_initial,2,'omitnan');

Speed20_second_std = std(Speed20_second,0,2,'omitnan');
Speed20_second_mean = mean(Speed20_second,2,'omitnan');

%%Cohort 18 + 19 - DREADD-Cohort
%Speed Saline
SpeedSa_initial = [cohort_Data18(1).intersec_initial,cohort_Data18(3).intersec_initial,cohort_Data18(5).intersec_initial,cohort_Data18(7).intersec_initial,...
    cohort_Data19(1).intersec_initial,cohort_Data19(5).intersec_initial];
SpeedSa_second = [cohort_Data18(1).intersec_second,cohort_Data18(3).intersec_second,cohort_Data18(5).intersec_second,cohort_Data18(7).intersec_second,...
    cohort_Data19(1).intersec_second,cohort_Data19(5).intersec_second];

SpeedSa_initial_std = std(SpeedSa_initial,0,2,'omitnan');
SpeedSa_initial_mean = mean(SpeedSa_initial,2,'omitnan');

SpeedSa_second_std = std(SpeedSa_second,0,2,'omitnan');
SpeedSa_second_mean = mean(SpeedSa_second,2,'omitnan');

%Speed CNO
SpeedCNO_initial = [cohort_Data18(2).intersec_initial,cohort_Data18(4).intersec_initial,cohort_Data18(6).intersec_initial,cohort_Data18(8).intersec_initial,...
    cohort_Data19(2).intersec_initial,cohort_Data19(3).intersec_initial,cohort_Data19(6).intersec_initial];
SpeedCNO_second = [cohort_Data18(2).intersec_second,cohort_Data18(4).intersec_second,cohort_Data18(6).intersec_second,cohort_Data18(8).intersec_second,...
    cohort_Data19(2).intersec_second,cohort_Data19(3).intersec_second,cohort_Data19(6).intersec_second];

SpeedCNO_initial_std = std(SpeedCNO_initial,0,2,'omitnan');
SpeedCNO_initial_mean = mean(SpeedCNO_initial,2,'omitnan');

SpeedCNO_second_std = std(SpeedCNO_second,0,2,'omitnan');
SpeedCNO_second_mean = mean(SpeedCNO_second,2,'omitnan');

%Speed mCherry (CNO-Controls)
SpeedCNO_control_initial = [cohort_Data19(4).intersec_initial,cohort_Data19(8).intersec_initial];
SpeedCNO_control_second = [cohort_Data19(4).intersec_second,cohort_Data19(8).intersec_second];

SpeedCNO_control_initial_std = std(SpeedCNO_control_initial,0,2,'omitnan');
SpeedCNO_control_initial_mean = mean(SpeedCNO_control_initial,2,'omitnan');

SpeedCNO_control_second_std = std(SpeedCNO_control_second,0,2,'omitnan');
SpeedCNO_control_second_mean = mean(SpeedCNO_control_second,2,'omitnan');

% the following sections are still only working with the original code
%% Some Statistics
[p0,~] = ranksum(Speed20_initial,SpeedCNO_initial,'tail','left');
[p1,~] = ranksum(SpeedSa_initial,SpeedCNO_initial,'tail','left');
[p2,~] = ranksum(Speed20_second,SpeedCNO_second,'tail','left');
[p3,~] = ranksum(SpeedSa_second,SpeedCNO_second,'tail','left');
[p4,~] = ranksum(Speed20_initial,SpeedSa_initial);
[p5,~] = ranksum(Speed20_second,SpeedSa_second);
[p6,~] = ranksum(SpeedCNO_initial,SpeedCNO_control_initial,'tail','right');
[p7,~] = ranksum(SpeedCNO_second,SpeedCNO_control_second,'tail','right');

%% Comparison of DREADD-Cohorts (native-saline-CNO-mCherry)
% Plot Data (native-saline-CNO)
x = [1,2,3,5,6,7];
speed_mean = [Speed20_initial_mean, SpeedSa_initial_mean, SpeedCNO_initial_mean, Speed20_second_mean, SpeedSa_second_mean, SpeedCNO_second_mean];
speed_std = [Speed20_initial_std, SpeedSa_initial_std, SpeedCNO_initial_std, Speed20_second_std, SpeedSa_second_std, SpeedCNO_second_std];
speed_all = [[1*ones(size(Speed20_initial))';2*ones(size(SpeedSa_initial))';3*ones(size(SpeedCNO_initial))';...
    5*ones(size(Speed20_second))';6*ones(size(SpeedSa_second))';7*ones(size(SpeedCNO_second))'],...
    [Speed20_initial';SpeedSa_initial';SpeedCNO_initial';Speed20_second';SpeedSa_second';SpeedCNO_second']];

f5 = figure; errorbar(x,speed_mean,speed_std,'LineStyle','none','Color','k','Marker','o','MarkerFaceColor','k')
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

plotStatistics(p0, speed_max(3)+100, 1, 3)
plotStatistics(p1, speed_max(3), 2, 3)
plotStatistics(p2, speed_max(6)+100, 5, 7)
plotStatistics(p3, speed_max(6), 6, 7)

% Plot Data (native-saline-CNO - Boxchart)
speed_all_native = [[1*ones(size(Speed20_initial))';5*ones(size(Speed20_second))'],...
    [Speed20_initial';Speed20_second']];
speed_all_saline = [[2*ones(size(SpeedSa_initial))';6*ones(size(SpeedSa_second))'],...
    [SpeedSa_initial';SpeedSa_second']];
speed_all_CNO = [[3*ones(size(SpeedCNO_initial))';7*ones(size(SpeedCNO_second))'],...
    [SpeedCNO_initial';SpeedCNO_second']];
speed_all_CNO_control = [[4*ones(size(SpeedCNO_control_initial))';8*ones(size(SpeedCNO_control_second))'],...
    [SpeedCNO_control_initial';SpeedCNO_control_second']];

f6 = figure; boxchart(speed_all_native(:,1), speed_all_native(:,2), 'BoxFaceColor', 'k', 'MarkerColor', 'k')
hold on; boxchart(speed_all_saline(:,1), speed_all_saline(:,2), 'BoxFaceColor', '#0072BD')
boxchart(speed_all_CNO(:,1), speed_all_CNO(:,2), 'BoxFaceColor', [1.0000, 0.3216, 0.3020])
boxchart(speed_all_CNO_control(:,1), speed_all_CNO_control(:,2), 'BoxFaceColor', '#A2142F')
%scatter(speed_all(:,1),speed_all(:,2),'Marker','.','MarkerEdgeColor','k','Jitter','on')
ylabel('Trials to expert'); ylim([200 1900])
xticks([2 6]), xticklabels({'Initial rules', 'Second rules'})
% text(2, 100, 'initial rules', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold')
% text(7, 100, 'second rules', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold')

plotStatistics(p0, speed_max(3)+100, 1, 3)
plotStatistics(p1, speed_max(3), 2, 3)
plotStatistics(p2, speed_max(6)+100, 5, 7)
plotStatistics(p3, speed_max(6), 6, 7)

legend('native','saline','CNO','CNO-control','Location','southeast'); legend('boxoff')

%% calculate factor between initial and switched rule learning
factor_CNO = SpeedCNO_second./SpeedCNO_initial;
factor_saline = SpeedSa_second./SpeedSa_initial;
% for native animals all animals not trained on 20mm contrast are removed
speed_ini_adjust = speed_all_initial;
speed_ini_adjust(19:30,:) = []; speed_ini_adjust(2:6,:) = []; speed_ini_adjust(4,:) = [];
factor_native = speed_all_second(:,2)./speed_ini_adjust(:,2);

% calculate if there is a difference between CNO, native and saline animals
[p,~] = ranksum(factor_CNO,factor_saline,'tail','right');
if p <= 0.05
    fprintf('The factor between CNO and saline animals is significantly different (p=%d).\n', p)
else
    fprintf('The factor between CNO and saline animals is not significantly different.\n')
end
[p,~] = ranksum(factor_CNO,factor_native,'tail','right');
if p <= 0.05
    fprintf('The factor between CNO and native animals is significantly different (p=%d).\n', p)
else
    fprintf('The factor between CNO and native animals is not significantly different.\n')
end

% figure, hold on
% boxchart(ones(size(factor_native)),factor_native, 'BoxFaceColor', 'k', 'MarkerColor', 'k')
% boxchart(1+ones(size(factor_saline)),factor_saline, 'BoxFaceColor', [0 0.45 0.74], 'MarkerColor', [0 0.45 0.74])
% boxchart(2+ones(size(factor_CNO)),factor_CNO, 'BoxFaceColor', [1 0.32 0.30], 'MarkerColor', [1 0.32 0.30])
% title('Second Rule/Initial Rule')
% ylabel('Factor'); xticks([1 2 3]); xticklabels({'Native' 'Saline' 'CNO'})
% xlim([0.5 3.5]); ylim([0.5 5.5])

%% Save all Plots
%savefig(f1, fullfile('Z:\Josephine\Master-Thesis_Figures\Learning_Speed','LearningSpeed_initial.fig'))
%savefig(f2, fullfile('Z:\Josephine\Master-Thesis_Figures\Learning_Speed','LearningSpeed_second.fig'))
%savefig(f3, fullfile('Z:\Josephine\Master-Thesis_Figures\Learning_Speed','LearningSpeed_Boxcharts.fig'))
%savefig(f5, fullfile('Z:\Josephine\Master-Thesis_Figures\Learning_Speed','LearningSpeed_CNO.fig'))
%savefig(f6, fullfile('Z:\Josephine\Master-Thesis_Figures\Learning_Speed','LearningSpeed_CNO_Boxcharts.fig'))
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

%% create Speed-cell for each cohort (ATTENTION: for contrast=20mm and CNO analysis cohorts have to be pooled later on)
% add cohorts you want to analyze
cohorts = [11, 14, 15, 16, 17, 18, 19];
FieldofChoice = {'intersec_initial', 'intersec_second'};

Speed_initial = cell(1, length(cohorts));
Speed_switched = cell(1, length(cohorts));
Speed_initial_std = zeros(1, length(cohorts));
Speed_initial_mean = zeros(1, length(cohorts));
Speed_switched_std = zeros(1, length(cohorts));
Speed_switched_mean = zeros(1, length(cohorts));
for cohortIDX = 1:length(cohorts)
    cohort_Data = animalData.cohort(cohorts(cohortIDX)).animal;

    % cohort 16 was trained on two different contrasts therefore animals have to be split
    if cohorts(cohortIDX) == 16
        Speed_initial{cohortIDX} = cell(1,2);
        Speed_switched{cohortIDX} = cell(1,2);
        for mouseIDX = 1:length(cohort_Data)
            session_names{mouseIDX} = cohort_Data(mouseIDX).session_names;
            Flag_14mm(mouseIDX,1) = sum(contains(session_names{1,mouseIDX}, '14mm')) > 0;
            Flag_16mm(mouseIDX,1) = sum(contains(session_names{1,mouseIDX}, '16mm')) > 0;
        end
        Speed_initial{cohortIDX}{1} = horzcat(cohort_Data(Flag_14mm).(FieldofChoice{1}));
        Speed_initial{cohortIDX}{2}  = horzcat(cohort_Data(Flag_16mm).(FieldofChoice{1}));
        Speed_switched{cohortIDX}{1} = horzcat(cohort_Data(Flag_14mm).(FieldofChoice{2}));
        Speed_switched{cohortIDX}{2}  = horzcat(cohort_Data(Flag_16mm).(FieldofChoice{2}));

    % cohort 18 retreived different intervention and therefore has to be split
    elseif cohorts(cohortIDX) == 18
        Speed_initial{cohortIDX} = cell(1,2);
        Speed_switched{cohortIDX} = cell(1,2);
        for mouseIDX = 1:length(cohort_Data)
            session_names{mouseIDX} = cohort_Data(mouseIDX).session_names;
            % counterintuively Saline-animals are the only ones that have CNO written in any session name
            Flag_Saline(mouseIDX,1) = sum(contains(session_names{1,mouseIDX}, 'CNO')) > 0;
            Flag_CNO(mouseIDX,1) = sum(contains(session_names{1,mouseIDX}, 'CNO')) == 0;
        end
        Speed_initial{cohortIDX}{1} = horzcat(cohort_Data(Flag_Saline).(FieldofChoice{1}));
        Speed_initial{cohortIDX}{2}  = horzcat(cohort_Data(Flag_CNO).(FieldofChoice{1}));
        Speed_switched{cohortIDX}{1} = horzcat(cohort_Data(Flag_Saline).(FieldofChoice{2}));
        Speed_switched{cohortIDX}{2}  = horzcat(cohort_Data(Flag_CNO).(FieldofChoice{2}));

    % cohort 19 retreived different intervention and therefore has to be split
    elseif cohorts(cohortIDX) == 19
        Speed_initial{cohortIDX} = cell(1,3);
        Speed_switched{cohortIDX} = cell(1,3);
        for mouseIDX = 1:length(cohort_Data)
            session_names{mouseIDX} = cohort_Data(mouseIDX).session_names;
            % mCherry and CNO animals can only be seperated manually
            if mouseIDX == 4 || mouseIDX == 8
                Flag_mCherry(mouseIDX,1) = true;
            else
                % counterintuively Saline-animals are the only ones that have CNO written in any session name
                Flag_Saline(mouseIDX,1) = sum(contains(session_names{1,mouseIDX}, 'CNO')) > 0;
                Flag_CNO(mouseIDX,1) = sum(contains(session_names{1,mouseIDX}, 'CNO')) == 0;
            end
        end
        Speed_initial{cohortIDX}{1} = horzcat(cohort_Data(Flag_Saline).(FieldofChoice{1}));
        Speed_initial{cohortIDX}{2}  = horzcat(cohort_Data(Flag_CNO).(FieldofChoice{1}));
        Speed_initial{cohortIDX}{3}  = horzcat(cohort_Data(Flag_mCherry).(FieldofChoice{1}));
        Speed_switched{cohortIDX}{1} = horzcat(cohort_Data(Flag_Saline).(FieldofChoice{2}));
        Speed_switched{cohortIDX}{2}  = horzcat(cohort_Data(Flag_CNO).(FieldofChoice{2}));
        Speed_switched{cohortIDX}{3}  = horzcat(cohort_Data(Flag_mCherry).(FieldofChoice{2}));

    else
        Speed_initial{cohortIDX} = horzcat(cohort_Data.(FieldofChoice{1}));
        Speed_switched{cohortIDX} = horzcat(cohort_Data.(FieldofChoice{2}));

        Speed_initial_std(cohortIDX) = std(Speed_initial{cohortIDX}, 0, 2, 'omitnan');
        Speed_initial_mean(cohortIDX) = mean(Speed_initial{cohortIDX}, 2, 'omitnan');

        Speed_switched_std(cohortIDX) = std(Speed_switched{cohortIDX}, 0, 2, 'omitnan');
        Speed_switched_mean(cohortIDX) = mean(Speed_switched{cohortIDX}, 2, 'omitnan');
    end
end

%% original Code (still should work, just uncomment)
% cohort_Data11 = animalData.cohort(11).animal;
% cohort_Data14 = animalData.cohort(14).animal;
% cohort_Data15 = animalData.cohort(15).animal;
% cohort_Data16 = animalData.cohort(16).animal;
% cohort_Data17 = animalData.cohort(17).animal;
% cohort_Data18 = animalData.cohort(18).animal;
% cohort_Data19 = animalData.cohort(19).animal;
% 
% %%Cohort 11 + 14 + 17 (contrast = 20)
% Speed20_initial = horzcat(cohort_Data11.intersec_initial,cohort_Data14.intersec_initial,cohort_Data17.intersec_initial);
% Speed20_second = horzcat(cohort_Data11.intersec_second);
% 
% Speed20_initial_std = std(Speed20_initial,0,2,'omitnan');
% Speed20_initial_mean = mean(Speed20_initial,2,'omitnan');
% 
% Speed20_second_std = std(Speed20_second,0,2,'omitnan');
% Speed20_second_mean = mean(Speed20_second,2,'omitnan');
% 
% %%Cohort 15 (contrast = 12)
% Speed12_initial = horzcat(cohort_Data15.intersec_initial);
% Speed12_second = horzcat(cohort_Data15(1).intersec_second);
% 
% Speed12_initial_std = std(Speed12_initial,0,2,'omitnan');
% Speed12_initial_mean = mean(Speed12_initial,2,'omitnan');
% 
% Speed12_second_std = std(Speed12_second,0,2,'omitnan');
% Speed12_second_mean = mean(Speed12_second,2,'omitnan');
% 
% %%Cohort 16 (contrast = 14 or 16)
% % STD & Mean for deltaA = 14
% Speed14_initial = nan(1,3);
% for i = 1:3
%     Speed14_initial(1,i) = cohort_Data16(i).intersec_initial;
% end
% Speed14_second = nan(1,2);
% for i = 1:2
%     Speed14_second(1,i) = cohort_Data16(i).intersec_second;
% end
% 
% Speed14_initial_std = std(Speed14_initial,0,2,'omitnan');
% Speed14_initial_mean = mean(Speed14_initial,2,'omitnan');
% 
% Speed14_second_std = std(Speed14_second,0,2,'omitnan');
% Speed14_second_mean = mean(Speed14_second,2,'omitnan');
% 
% % STD & Mean for deltaA = 16
% Speed16_initial = nan(1,3);
% for i = 4:6
%     Speed16_initial(1,i-3) = cohort_Data16(i).intersec_initial;
% end
% Speed16_second = nan(1,3);
% for i = 4:6
%     Speed16_second(1,i-3) = cohort_Data16(i).intersec_second;
% end
% 
% Speed16_initial_std = std(Speed16_initial,0,2,'omitnan');
% Speed16_initial_mean = mean(Speed16_initial,2,'omitnan');
% 
% Speed16_second_std = std(Speed16_second,0,2,'omitnan');
% Speed16_second_mean = mean(Speed16_second,2,'omitnan');
% 
% %%Cohort 18 + 19 - DREADD-Cohort
% %Speed Saline
% SpeedSa_initial = [cohort_Data18(1).intersec_initial,cohort_Data18(3).intersec_initial,cohort_Data18(5).intersec_initial,cohort_Data18(7).intersec_initial,...
%     cohort_Data19(1).intersec_initial,cohort_Data19(5).intersec_initial];
% SpeedSa_second = [cohort_Data18(1).intersec_second,cohort_Data18(3).intersec_second,cohort_Data18(5).intersec_second,cohort_Data18(7).intersec_second,...
%     cohort_Data19(1).intersec_second,cohort_Data19(5).intersec_second];
% 
% SpeedSa_initial_std = std(SpeedSa_initial,0,2,'omitnan');
% SpeedSa_initial_mean = mean(SpeedSa_initial,2,'omitnan');
% 
% SpeedSa_second_std = std(SpeedSa_second,0,2,'omitnan');
% SpeedSa_second_mean = mean(SpeedSa_second,2,'omitnan');
% 
% %Speed CNO
% SpeedCNO_initial = [cohort_Data18(2).intersec_initial,cohort_Data18(4).intersec_initial,cohort_Data18(6).intersec_initial,cohort_Data18(8).intersec_initial,...
%     cohort_Data19(2).intersec_initial,cohort_Data19(3).intersec_initial,cohort_Data19(6).intersec_initial];
% SpeedCNO_second = [cohort_Data18(2).intersec_second,cohort_Data18(4).intersec_second,cohort_Data18(6).intersec_second,cohort_Data18(8).intersec_second,...
%     cohort_Data19(2).intersec_second,cohort_Data19(3).intersec_second,cohort_Data19(6).intersec_second];
% 
% SpeedCNO_initial_std = std(SpeedCNO_initial,0,2,'omitnan');
% SpeedCNO_initial_mean = mean(SpeedCNO_initial,2,'omitnan');
% 
% SpeedCNO_second_std = std(SpeedCNO_second,0,2,'omitnan');
% SpeedCNO_second_mean = mean(SpeedCNO_second,2,'omitnan');
% 
% %Speed mCherry (CNO-Controls)
% SpeedCNO_control_initial = [cohort_Data19(4).intersec_initial,cohort_Data19(8).intersec_initial];
% SpeedCNO_control_second = [cohort_Data19(4).intersec_second,cohort_Data19(8).intersec_second];
% 
% SpeedCNO_control_initial_std = std(SpeedCNO_control_initial,0,2,'omitnan');
% SpeedCNO_control_initial_mean = mean(SpeedCNO_control_initial,2,'omitnan');
% 
% SpeedCNO_control_second_std = std(SpeedCNO_control_second,0,2,'omitnan');
% SpeedCNO_control_second_mean = mean(SpeedCNO_control_second,2,'omitnan');

% the following sections are still only working with the original code (work in progress)
%% Some Statistics
[p0,~] = ranksum(Speed20_initial,SpeedCNO_initial,'tail','left');
[p1,~] = ranksum(SpeedSa_initial,SpeedCNO_initial,'tail','left');
[p2,~] = ranksum(Speed20_second,SpeedCNO_second,'tail','left');
[p3,~] = ranksum(SpeedSa_second,SpeedCNO_second,'tail','left');
[p4,~] = ranksum(Speed20_initial,SpeedSa_initial);
[p5,~] = ranksum(Speed20_second,SpeedSa_second);
[p6,~] = ranksum(SpeedCNO_initial,SpeedCNO_control_initial,'tail','right');
[p7,~] = ranksum(SpeedCNO_second,SpeedCNO_control_second,'tail','right');

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
%xline(6,'--','Performance cutoff','LabelHorizontalAlignment','center','LabelVerticalAlignment','middle')
xlim([10 22])
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

plotStatistics(p0, speed_max(3)+100, 1, 3)
plotStatistics(p1, speed_max(3), 2, 3)
plotStatistics(p2, speed_max(6)+100, 5, 7)
plotStatistics(p3, speed_max(6), 6, 7)

%% Plot Data (native-saline-CNO - Boxchart)
speed_all_native = [[1*ones(size(Speed20_initial))';5*ones(size(Speed20_second))'],...
    [Speed20_initial';Speed20_second']];
speed_all_saline = [[2*ones(size(SpeedSa_initial))';6*ones(size(SpeedSa_second))'],...
    [SpeedSa_initial';SpeedSa_second']];
speed_all_CNO = [[3*ones(size(SpeedCNO_initial))';7*ones(size(SpeedCNO_second))'],...
    [SpeedCNO_initial';SpeedCNO_second']];
speed_all_CNO_control = [[4*ones(size(SpeedCNO_control_initial))';8*ones(size(SpeedCNO_control_second))'],...
    [SpeedCNO_control_initial';SpeedCNO_control_second']];

f5 = figure; boxchart(speed_all_native(:,1), speed_all_native(:,2), 'BoxFaceColor', 'k', 'MarkerColor', 'k')
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
speed_all_initial_adjust = speed_all_initial;
speed_all_initial_adjust(19:30,:) = []; speed_all_initial_adjust(2:6,:) = []; speed_all_initial_adjust(4,:) = [];
factor_native = speed_all_second(:,2)./speed_all_initial_adjust(:,2);

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

%% line plot (contrast 20mm) initial vs. switched
figure, hold on

xvalues = ones(1,length(Speed20_initial)); scatter(xvalues,Speed20_initial, 'k','filled')
xvalues = ones(1,length(Speed20_second)); scatter(xvalues+1,Speed20_second, 'k','filled'),

for i = 1:length(Speed20_second)
    plot([1,2],[Speed20_initial(i),Speed20_second(i)],'Color','k')
end

plot([1,2],[Speed20_initial_mean, Speed20_second_mean],'LineWidth', 1.5)

[p8,~] = ranksum(Speed20_initial, Speed20_second);
plotStatistics(p8, speed_max(4), 1, 2)

title('trials to expert per animal')
xticks([1,2]), xticklabels({'initial rule','switched rule'})
ylabel('Trials to expert')

%% Save all Plots
%savefig(f1, fullfile('Z:\Josephine\Master-Thesis_Figures\Learning_Speed','LearningSpeed_initial.fig'))
%savefig(f2, fullfile('Z:\Josephine\Master-Thesis_Figures\Learning_Speed','LearningSpeed_second.fig'))
%savefig(f3, fullfile('Z:\Josephine\Master-Thesis_Figures\Learning_Speed','LearningSpeed_Boxcharts.fig'))
%savefig(f4, fullfile('Z:\Josephine\Master-Thesis_Figures\Learning_Speed','LearningSpeed_CNO.fig'))
%savefig(f5, fullfile('Z:\Josephine\Master-Thesis_Figures\Learning_Speed','LearningSpeed_CNO_Boxcharts.fig'))
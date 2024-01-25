% clearvars
% close all
% 
% startPath = 'Z:\Filippo\Animals';
% try
%     load(fullfile(startPath,'animalData.mat'))
% catch
%     fprintf(2,'\nThe variable "animalData.mat" doesn''t exist.')
%     fprintf(2,'\nYou have to create it first.\n\n')
%     return
% end

%% create Speed-cell with speed per animal for each cohort
% ATTENTION: to run this script animalData.mat has do be loaded into the workspace
% for contrast=20mm and CNO analysis cohorts have to be pooled later on
% -> this means std and mean have to be calculated with pooled cohorts (see later sections)

% add cohorts you want to analyze
cohorts = [11, 14, 15, 16, 17, 18, 19];
FieldofChoice = {'intersec_initial', 'intersec_second'};

% we will create two cells for each rule set
Speed_ini_co = cell(2, length(cohorts));
Speed_swi_co = cell(2, length(cohorts));
for cohortIDX = 1:length(cohorts)
    cohort_Data = animalData.cohort(cohorts(cohortIDX)).animal;

    % cohort 16 was trained on two different contrasts therefore animals have to be split
    if cohorts(cohortIDX) == 16
        Speed_ini_co{1,cohortIDX} = cell(1,2);
        Speed_swi_co{1,cohortIDX} = cell(1,2);
        % create a flag for the different contrast
        for mouseIDX = 1:length(cohort_Data)
            session_names{mouseIDX} = cohort_Data(mouseIDX).session_names;
            Flag_14mm(mouseIDX,1) = sum(contains(session_names{1,mouseIDX}, '14mm')) > 0;
            Flag_16mm(mouseIDX,1) = sum(contains(session_names{1,mouseIDX}, '16mm')) > 0;
        end
        Speed_ini_co{1,cohortIDX}{1} = horzcat(cohort_Data(Flag_14mm).(FieldofChoice{1}));
        Speed_ini_co{1,cohortIDX}{2}  = horzcat(cohort_Data(Flag_16mm).(FieldofChoice{1}));
        Speed_swi_co{1,cohortIDX}{1} = horzcat(cohort_Data(Flag_14mm).(FieldofChoice{2}));
        Speed_swi_co{1,cohortIDX}{2}  = horzcat(cohort_Data(Flag_16mm).(FieldofChoice{2}));

    % cohort 18 retreived different intervention and therefore has to be split
    elseif cohorts(cohortIDX) == 18
        Speed_ini_co{1,cohortIDX} = cell(1,2);
        Speed_swi_co{1,cohortIDX} = cell(1,2);
        % create a flag for the different interventions
        for mouseIDX = 1:length(cohort_Data)
            session_names{mouseIDX} = cohort_Data(mouseIDX).session_names;
            % counterintuively Saline-animals are the only ones that have CNO written in any session name
            Flag_Saline(mouseIDX,1) = sum(contains(session_names{1,mouseIDX}, 'CNO')) > 0;
            Flag_CNO(mouseIDX,1) = sum(contains(session_names{1,mouseIDX}, 'CNO')) == 0;
        end
        Speed_ini_co{1,cohortIDX}{1} = horzcat(cohort_Data(Flag_Saline).(FieldofChoice{1}));
        Speed_ini_co{1,cohortIDX}{2}  = horzcat(cohort_Data(Flag_CNO).(FieldofChoice{1}));
        Speed_swi_co{1,cohortIDX}{1} = horzcat(cohort_Data(Flag_Saline).(FieldofChoice{2}));
        Speed_swi_co{1,cohortIDX}{2}  = horzcat(cohort_Data(Flag_CNO).(FieldofChoice{2}));

    % cohort 19 retreived different intervention and therefore has to be split
    elseif cohorts(cohortIDX) == 19
        Speed_ini_co{1,cohortIDX} = cell(1,3);
        Speed_swi_co{1,cohortIDX} = cell(1,3);
        % create a flag for the different interventions
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
        Speed_ini_co{1,cohortIDX}{1} = horzcat(cohort_Data(Flag_Saline).(FieldofChoice{1}));
        Speed_ini_co{1,cohortIDX}{2}  = horzcat(cohort_Data(Flag_CNO).(FieldofChoice{1}));
        Speed_ini_co{1,cohortIDX}{3}  = horzcat(cohort_Data(Flag_mCherry).(FieldofChoice{1}));
        Speed_swi_co{1,cohortIDX}{1} = horzcat(cohort_Data(Flag_Saline).(FieldofChoice{2}));
        Speed_swi_co{1,cohortIDX}{2}  = horzcat(cohort_Data(Flag_CNO).(FieldofChoice{2}));
        Speed_swi_co{1,cohortIDX}{3}  = horzcat(cohort_Data(Flag_mCherry).(FieldofChoice{2}));

    % the rest can be directly assigned without further preperation
    else
        Speed_ini_co{1,cohortIDX} = horzcat(cohort_Data.(FieldofChoice{1}));
        Speed_swi_co{1,cohortIDX} = horzcat(cohort_Data.(FieldofChoice{2}));
    end
end

%% Reshape Speed-cell according to contrast
% add the contrast used for each cohort, keep the same shape as used for the cohorts variable
contrast16 = [14,16];
contrastOrder = [20,20,12,NaN,20,NaN,NaN];

% this part adds the contrast value to the cell array
for contrastIDX = 1:length(contrastOrder)
    % cohort 16 was trained on two different contrasts
    if isnan(contrastOrder(contrastIDX)) && cohorts(contrastIDX) == 16
        Speed_ini_co{2,contrastIDX}{1} = contrast16(1)*ones(size(Speed_ini_co{1,contrastIDX}{1}));
        Speed_ini_co{2,contrastIDX}{2} = contrast16(2)*ones(size(Speed_ini_co{1,contrastIDX}{2}));
        Speed_swi_co{2,contrastIDX}{1} = contrast16(1)*ones(size(Speed_swi_co{1,contrastIDX}{1}));
        Speed_swi_co{2,contrastIDX}{2} = contrast16(2)*ones(size(Speed_swi_co{1,contrastIDX}{2}));
    else
        Speed_ini_co{2,contrastIDX} = contrastOrder(contrastIDX)*ones(size(Speed_ini_co{1,contrastIDX}));
        Speed_swi_co{2,contrastIDX} = contrastOrder(contrastIDX)*ones(size(Speed_swi_co{1,contrastIDX}));
    end
end

% now we prepare the cell so we can use it for plotting
Speed_ini_contrast = Speed_ini_co;
Speed_swi_contrast = Speed_swi_co;
% first we break down cohort 16
for rowIDX = 1:height(Speed_ini_contrast)
    Speed_co16 = horzcat(Speed_ini_contrast{rowIDX,4});
    Speed_ini_contrast{rowIDX,4} = horzcat(Speed_co16{1},Speed_co16{2});
    Speed_co16 = horzcat(Speed_swi_contrast{rowIDX,4});
    Speed_swi_contrast{rowIDX,4} = horzcat(Speed_co16{1},Speed_co16{2});
end
% then we remove cohort 18 and 19 (only important for later analysis)
Speed_ini_contrast(:,6:7) = [];
Speed_swi_contrast(:,6:7) = [];
% change the format
Speed_ini_contrast = cell2mat(Speed_ini_contrast);
Speed_swi_contrast = cell2mat(Speed_swi_contrast);
% remove animals where learning speed is 0 or NaN(might result from other learning stages used)
Speed_swi_contrast(:,Speed_swi_contrast(1,:) == 0) = [];
Speed_swi_contrast(:,isnan(Speed_swi_contrast(1,:))) = [];

%% Calculating mean and std for each contrast
% we call the contrast deltaA to not run into errors with the contrast function
deltaA = unique(Speed_ini_contrast(2,:));
speed_mean = arrayfun(@(c) mean(Speed_ini_contrast(1,Speed_ini_contrast(2,:)==c)), deltaA);
speed_mean(2,:) = arrayfun(@(c) mean(Speed_swi_contrast(1,Speed_swi_contrast(2,:)==c)), deltaA);
speed_std = arrayfun(@(c) std(Speed_ini_contrast(1,Speed_ini_contrast(2,:)==c),0,2,'omitnan'), deltaA);
speed_std(2,:) = arrayfun(@(c) std(Speed_swi_contrast(1,Speed_swi_contrast(2,:)==c),0,2,'omitnan'), deltaA);

%% Comparison between contrasts
% plot data initial rule
f1 = figure; errorbar(deltaA,speed_mean(1,:),speed_std(1,:),'LineStyle','none','Color','k','Marker','o','MarkerFaceColor','k')
hold on; plot(Speed_ini_contrast(2,:),Speed_ini_contrast(1,:),'LineStyle','none','Marker','.')
xlabel('contrast [mm]'); ylabel('Trials to expert')
title('Learning time over contrast - initial rule')
% counting the number of animals for each contrast
speed_max = arrayfun(@(c) max(Speed_ini_contrast(1, Speed_ini_contrast(2,:) == c)),deltaA);
arrayfun(@(c, maxVal)...
    text(c, maxVal+100, sprintf('n=%d', sum(Speed_ini_contrast(2,:) == c)), 'HorizontalAlignment', 'center'), deltaA, speed_max);
%xlim([5 22]); ylim([200 1800])
%xline(6,'--','Performance cutoff','LabelHorizontalAlignment','center','LabelVerticalAlignment','middle')

% plot data switched rule
f2 = figure; errorbar(deltaA,speed_mean(2,:),speed_std(2,:),'LineStyle','none','Color','k','Marker','o','MarkerFaceColor','k')
hold on; plot(Speed_swi_contrast(2,:),Speed_swi_contrast(1,:),'LineStyle','none','Marker','.')
xlabel('contrast [mm]'); ylabel('Trials to expert')
title('Learning time over contrast - switched rule')
% counting the number of animals for each contrast
speed_max = arrayfun(@(c) max(Speed_swi_contrast(1, Speed_swi_contrast(2,:) == c)),deltaA);
arrayfun(@(c, maxVal)...
    text(c, maxVal+100, sprintf('n=%d', sum(Speed_swi_contrast(2,:) == c)), 'HorizontalAlignment', 'center'), deltaA, speed_max);
%xlim([5 22]); ylim([800 3000])
%xline(6,'--','Performance cutoff','LabelHorizontalAlignment','center','LabelVerticalAlignment','middle')

% Boxcharts (initial and switched rule)
f3 = figure; boxchart(Speed_ini_contrast(2,:), Speed_ini_contrast(1,:), 'BoxFaceColor', 'k')
hold on; boxchart(Speed_swi_contrast(2,:), Speed_swi_contrast(1,:))
xlabel('contrast [mm]')
ylabel('Trials to expert')
title('Learning time over contrast')
%xline(6,'--','Performance cutoff','LabelHorizontalAlignment','center','LabelVerticalAlignment','middle')
xlim([10 22])
legend('Initial rule','Switched rule','Location','southwest')

%% Comparison between initial and switched rule
% compare the learning time as a factor between the switched and initial rule
% first adjust the speed_ini_contrast array so it only contains animals trained on both rules
% -> for now this is hard-coded
speed_ini_adjust = Speed_ini_contrast;
speed_ini_adjust(:,27:end) = []; speed_ini_adjust(:,23) = []; speed_ini_adjust(:,16:20) = []; speed_ini_adjust(:,7:14) = [];
% now we calculate the factor for each contrast and compare them to contrast 20mm
factor = arrayfun(@(c) Speed_swi_contrast(1,Speed_swi_contrast(2,:)==c)./speed_ini_adjust(1,speed_ini_adjust(2,:)==c), deltaA, 'UniformOutput', false);
factor_mean = mean([factor{:}]);
for i = 1:length(factor)-1
    [p,~] = ranksum(factor{1,4},factor{1,i},'tail','right');
    if p <= 0.05
        fprintf('The factor between contrast 20mm and contrast %dmm is significantly different (p=%.2f).\n', deltaA(i), p)
    else
        fprintf('The factor between contrast 20mm and contrast %dmm is not significantly different (p=%.2f).\n', deltaA(i), p)
    end
end

% line plot (contrast 20mm)
f4 = figure; hold on
Speed_ini_20 = Speed_ini_contrast(1,Speed_ini_contrast(2,:)==20);
Speed_swi_20 = Speed_swi_contrast(1,Speed_swi_contrast(2,:)==20);
% plot all individual animals
xvalues = ones(1,length(Speed_ini_20)); scatter(xvalues,Speed_ini_20, 'k','filled')
xvalues = ones(1,length(Speed_swi_20)); scatter(xvalues+1,Speed_swi_20, 'k','filled')
% connect the pairs
% -> the logic of the Speed-array guarantes that animal 1 in the initial array is he same animal 1 in the switched array
% -> this might not be true if the input data is changes!!
for i = 1:length(Speed_swi_20)
    plot([1,2],[Speed_ini_20(i),Speed_swi_20(i)],'Color','k')
end
% plot the mean and statistics
plot([1,2],[speed_mean(1,4), speed_mean(2,4)],'LineWidth', 1.5)
%[p,~] = ranksum(Speed_ini_20, Speed_swi_20);
p_paired = signrank(Speed_ini_20(1,1:length(Speed_swi_20)), Speed_swi_20);
plotStatistics(p_paired, speed_max_swi(4), 1, 2)
% add labels and title
title('trials to expert per animal')
xticks([1,2]), xticklabels({'initial rule','switched rule'})
ylabel('Trials to expert')

%% Reshape Speed-cell for DREADD-analysis
% add the intervention names

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
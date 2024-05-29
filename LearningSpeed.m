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

%% Gather information
% ATTENTION: to run this script animalData.mat has do be loaded into the workspace
% for contrast=20mm cohorts have to be pooled later on
% -> this means std and mean have to be calculated with pooled cohorts (see later sections)

% add cohorts you want to analyze
cohorts = arrayfun(@(x) num2str(x), 1:numel(animalData.cohort), 'UniformOutput', false);
answer = listdlg('ListString',cohorts,'PromptString','Choose your cohort (11, 12, 15, 16 for Manuscript-Plots).');
cohorts = cellfun(@str2double, cohorts(answer));
FieldofChoice = {'intersec_initial', 'intersec_second'};

if sum(ismember([18, 19], cohorts))
    error('This code does not work with Cohort 18 or 19, use LearningSpeed_DREADDs.m')
end

% add the contrast used for each cohort, keep the same shape as used for the cohorts variable
contrast16 = [14,16];
contrastOrder = [20,20,12,NaN];

%% create Speed-cell with speed per animal for each cohort
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

    % the rest can be directly assigned without further preperation
    else
        Speed_ini_co{1,cohortIDX} = horzcat(cohort_Data.(FieldofChoice{1}));
        Speed_swi_co{1,cohortIDX} = horzcat(cohort_Data.(FieldofChoice{2}));
    end
end

%% Reshape Speed-cell according to contrast
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
speed_max_ini = arrayfun(@(c) max(Speed_ini_contrast(1, Speed_ini_contrast(2,:) == c)),deltaA);
arrayfun(@(c, maxVal)...
    text(c, maxVal+100, sprintf('n=%d', sum(Speed_ini_contrast(2,:) == c)), 'HorizontalAlignment', 'center'), deltaA, speed_max_ini);
%xlim([5 22]); ylim([200 1800])
%xline(6,'--','Performance cutoff','LabelHorizontalAlignment','center','LabelVerticalAlignment','middle')

% plot data switched rule
f2 = figure; errorbar(deltaA,speed_mean(2,:),speed_std(2,:),'LineStyle','none','Color','k','Marker','o','MarkerFaceColor','k')
hold on; plot(Speed_swi_contrast(2,:),Speed_swi_contrast(1,:),'LineStyle','none','Marker','.')
xlabel('contrast [mm]'); ylabel('Trials to expert')
title('Learning time over contrast - switched rule')
% counting the number of animals for each contrast
speed_max_swi = arrayfun(@(c) max(Speed_swi_contrast(1, Speed_swi_contrast(2,:) == c)),deltaA);
arrayfun(@(c, maxVal)...
    text(c, maxVal+100, sprintf('n=%d', sum(Speed_swi_contrast(2,:) == c)), 'HorizontalAlignment', 'center'), deltaA, speed_max_swi);
%xlim([5 22]); ylim([800 3000])
%xline(6,'--','Performance cutoff','LabelHorizontalAlignment','center','LabelVerticalAlignment','middle')

% Boxcharts (initial and switched rule)
f3 = figure; boxchart(Speed_ini_contrast(2,:), Speed_ini_contrast(1,:), 'BoxFaceColor', 'k', 'MarkerStyle', 'none')
hold on; boxchart(Speed_swi_contrast(2,:), Speed_swi_contrast(1,:), 'BoxFaceColor', [0.5,0.5,0.5], 'MarkerStyle', 'none')
%scatter(Speed_ini_contrast(2,:), Speed_ini_contrast(1,:),'k','.')
%scatter(Speed_swi_contrast(2,:), Speed_swi_contrast(1,:),'MarkerEdgeColor', [0.5,0.5,0.5],'Marker','.')
xlabel('Contrast [mm]')
ylabel('Trials to expert')
title('Learning time over contrast')
%xline(6,'--','Performance cutoff','LabelHorizontalAlignment','center','LabelVerticalAlignment','middle')
xlim([10 22]); set ( gca, 'xdir', 'reverse')
legend('Initial rule','Reversed rule','Location','southeast','Box','off')

%% Comparison between initial and switched rule
% compare the learning time as a factor between the switched and initial rule
% first adjust the speed_ini_contrast array so it only contains animals trained on both rules
% -> for now this is hard-coded !!!!
speed_ini_adjust = Speed_ini_contrast;
speed_ini_adjust(:,21) = []; speed_ini_adjust(:,14:18) = [];
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
%xvalues = ones(1,length(Speed_ini_20)); scatter(xvalues,Speed_ini_20, 'k','filled')
%xvalues = ones(1,length(Speed_swi_20)); scatter(xvalues+1,Speed_swi_20, 'k','filled')
% connect the pairs
% -> the logic of the Speed-array guarantes that animal 1 in the initial array is he same animal 1 in the switched array
% -> this might not be true if the input data is changes!!
for i = 1:length(Speed_swi_20)
    plot([1,2],[Speed_ini_20(i),Speed_swi_20(i)],'Color','k','LineStyle',':')
end
% plot the mean and statistics
plot([1,2],[mean(Speed_ini_20(1:length(Speed_swi_20))), speed_mean(2,4)], 'Color', 'k', 'LineWidth', 1.5)
%[p,~] = ranksum(Speed_ini_20, Speed_swi_20);
%p_paired = signrank(Speed_ini_20(1,1:length(Speed_swi_20)), Speed_swi_20);
[~,p_paired] = ttest(Speed_ini_20(1,1:length(Speed_swi_20)), Speed_swi_20);
plotStatistics(p_paired, speed_max_swi(4), 1, 2)
errorbar(0.9,mean(Speed_ini_20(1:length(Speed_swi_20))),speed_std(1,4), 'o', 'MarkerFaceColor', [0.1294 0.4 0.6745], 'Color', [0.1294 0.4 0.6745])
errorbar(2.1,mean(Speed_swi_20),speed_std(2,4), 'o', 'MarkerFaceColor', [0.9373 0.5412 0.3843], 'Color', [0.9373 0.5412 0.3843])
% add labels and title
title('Learning time per animal')
xticks([1,2]), xticklabels({'Initial rule','Reversed rule'})
ylabel('Trials to expert')

%% Save all Plots
%savefig(f1, fullfile('',''))
%savefig(f2, fullfile('',''))
%savefig(f3, fullfile('',''))
%savefig(f4, fullfile('',''))

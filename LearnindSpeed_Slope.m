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

%% create slope arrays
% ATTENTION: to run this script animalData.mat has do be loaded into the workspace
% load cohort-data for 20mm contrast
cohorts = [11, 12];
FieldofChoice = {'slope_initial', 'slope_second'};

Slope20_ini = [];
Slope20_swi = [];
for cohortIDX = 1:length(cohorts)
    cohort_Data = animalData.cohort(cohorts(cohortIDX)).animal;
    Slope20_ini = horzcat(Slope20_ini, cohort_Data.(FieldofChoice{1}));
    Slope20_swi = horzcat(Slope20_swi, cohort_Data.(FieldofChoice{2}));
end

Slope20_ini_std = std(Slope20_ini,0,2,'omitnan');
Slope20_ini_mean = mean(Slope20_ini,2,'omitnan');

Slope20_sec_std = std(Slope20_swi,0,2,'omitnan');
Slope20_swi_mean = mean(Slope20_swi,2,'omitnan');

%[p,~] = ranksum(Slope20_ini,Slope20_swi);
%p_paired = signrank(Slope20_ini(1,1:length(Slope20_swi)), Slope20_swi);
[~,p_paired] = ttest(Slope20_ini, Slope20_swi);

%% line plot
figure, hold on

%xvalues = ones(1,length(Slope20_ini)); scatter(xvalues,Slope20_ini, 'k','filled')
%xvalues = ones(1,length(Slope20_swi)); scatter(xvalues+1,Slope20_swi, 'k','filled'),

for i = 1:length(Slope20_swi)
    plot([1,2],[Slope20_ini(i),Slope20_swi(i)],'Color','k', 'LineStyle', ':')
end

plot([1,2],[mean(Slope20_ini(1:length(Slope20_swi))), Slope20_swi_mean], 'Color', 'k', 'LineWidth', 1.5)

slope_all = horzcat(Slope20_ini,Slope20_swi);
slope_max = max(slope_all);
plotStatistics(p_paired,slope_max,1,2)
errorbar(0.9,mean(Slope20_ini(1:length(Slope20_swi))),Slope20_ini_std, 'o', 'MarkerFaceColor', [0.1294 0.4 0.6745], 'Color', [0.1294 0.4 0.6745])
errorbar(2.1,Slope20_swi_mean,Slope20_sec_std, 'o', 'MarkerFaceColor', [0.9373 0.5412 0.3843], 'Color', [0.9373 0.5412 0.3843])

title('Learning speed per animal')
xticks([1,2]), xticklabels({'Initial rule','Reversed rule'})
ylabel('Slope of logistic fit')
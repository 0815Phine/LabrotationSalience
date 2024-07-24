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

%% choose cohorts
cohorts = arrayfun(@(x) num2str(x), 1:numel(animalData.cohort), 'UniformOutput', false);
answer = listdlg('ListString',cohorts,'PromptString','Choose your cohort.');
cohorts = cellfun(@str2double, cohorts(answer));
cohortData = horzcat(animalData.cohort(cohorts).animal);

%% choose stages
stages = getstagenames(cohortData);
answer = listdlg('ListString',stages,'PromptString','Choose stages.');
stages = stages(answer);

%% count sessions
for stageIDX = 1:length(stages)
    for mouseIDX = 1:length(cohortData)
        isStage = contains(cohortData(mouseIDX).session_names, stages(stageIDX));
        numSes = sum(isStage);

        if strcmp(stages{stageIDX}, 'P3.2')
            SesCountini(mouseIDX) = numSes;
        elseif strcmp(stages{stageIDX}, 'P3.4')
            SesCountsec(mouseIDX) = numSes;
        end
    end
end

% Statistics
[~,p1] = ttest(SesCountini, SesCountsec);

%% line plot with errorbars
figure, hold on

%xvalues = ones(1,length(SesCountini)); scatter(xvalues,SesCountini, 'k','filled')
%xvalues = ones(1,length(SesCountsec)); scatter(xvalues+1,SesCountsec, 'k','filled')

for i = 1:length(SesCountsec)
    plot([1,2],[SesCountini(i),SesCountsec(i)],'Color','k')
end

plot([1,2],[mean(SesCountini),mean(SesCountsec)], 'Color', 'r','LineWidth', 1.5)
plotStatistics(p1,max(horzcat(SesCountini,SesCountsec)),1,2)

errorbar(0.9,mean(SesCountini),std(SesCountini),'o','Color','k')
errorbar(2.1,mean(SesCountsec),std(SesCountsec),'o','Color','k')

title('Number of sessions per animal')
xticks([1,2]), xticklabels({'Initial rule','Reversed rule'})
ylabel('Number of sessions')
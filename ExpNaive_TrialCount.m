% clearvars
% close all
% 
% % load animalData.mat
% startPath = 'Z:\Filippo\Animals';
% try
%     load(fullfile(startPath,'animalData.mat'))
% catch
%     fprintf(2,'\nThe variable "animalData.mat" doesn''t exist.')
%     fprintf(2,'\nYou have to create it first.\n\n')
%     return
% end

%% trials per session initial rule (should be called P3.2) expert vs. naive
% choose cohorts
cohorts = arrayfun(@(x) num2str(x), 1:numel(animalData.cohort), 'UniformOutput', false);
answer = listdlg('ListString',cohorts,'PromptString','Choose your cohort.');
cohorts = cellfun(@str2double, cohorts(answer));
%cohortData = horzcat(animalData.cohort(cohorts).animal);

% add the cohorts you want to analyze
%cohortFlag = [11, 12];
%numCohorts = length(cohortFlag);
numMice = arrayfun(@(x) length(animalData.cohort(x).animal), cohorts);

% specify the number of sessions you want to analyze for each condition
numSes = 4;

alltrials_ini = NaN (sum(numMice),numSes*2);
for cohortIdx = 1:length(cohorts)
    cohortData = animalData.cohort(cohorts(cohortIdx)).animal;
    mouseFlag = length(cohortData);

    for mouseIdx = 1:mouseFlag
        isP2 = contains(cohortData(mouseIdx).session_names,'P3.2');
        sesFlag_first = find(isP2, 1, 'first');
        sesFlag_last = find(isP2, 1, 'last');

        % count trials
        trialcountnaive = cellfun(@numel, cohortData(mouseIdx).Lick_Events(sesFlag_first:sesFlag_first+(numSes-1)));
        trialcountexp = cellfun(@numel, cohortData(mouseIdx).Lick_Events(sesFlag_last-(numSes-1):sesFlag_last));
        
        rowIdx = sum(numMice(1:cohortIdx-1)) + mouseIdx;
        alltrials_ini(rowIdx, 1:numSes) = trialcountnaive;
        alltrials_ini(rowIdx, numSes+1:numSes*2) = trialcountexp;
    end
end

% this removes the the 17th row as the animal did not completed the stage (optional)
%alltrials_ini(17,:) = [];

% calculate mean trials for both conditions
naivetrials_ini = mean(alltrials_ini(:,1:numSes), 2);
experttrials_ini = mean(alltrials_ini(:,numSes+1:numSes*2), 2);

% Statistics and normalization
%[p1,~] = signrank(naivetrials_ini, experttrials_ini);
[~,p1] = ttest(naivetrials_ini, experttrials_ini);
ztrials_ini = zscore(alltrials_ini,0,2);

%% trials per session second rule (should be called P3.4) expert vs. naive
% add the cohorts you want to analyze
%cohortFlag = 11;
%numCohorts = length(cohortFlag);
%numMice = arrayfun(@(x) length(animalData.cohort(x).animal), cohortFlag);

% specify the number of sessions you want to analyze for each condition
%numSes = 4;

alltrials_swi = NaN (sum(numMice),numSes*2);
for cohortIdx = 1:length(cohorts)
    cohortData = animalData.cohort(cohorts(cohortIdx)).animal;
    mouseFlag = length(cohortData);

    for mouseIdx = 1:length(cohortData)
        isP4 = contains(cohortData(mouseIdx).session_names,'P3.4');
        sesFlag_first = find(isP4, 1, 'first');
        sesFlag_last = find(isP4, 1, 'last');
        
        % count Trials
        trialcountnaive = cellfun(@numel, cohortData(mouseIdx).Lick_Events(sesFlag_first:sesFlag_first+(numSes-1)));
        trialcountexp = cellfun(@numel, cohortData(mouseIdx).Lick_Events(sesFlag_last-(numSes-1):sesFlag_last));
        
        rowIdx = sum(numMice(1:cohortIdx-1)) + mouseIdx;
        alltrials_swi(rowIdx, 1:numSes) = trialcountnaive;
        alltrials_swi(rowIdx, numSes+1:numSes*2) = trialcountexp;      
    end
end

% calculate mean trials for both conditions
naivetrials_swi = mean(alltrials_swi(:,1:numSes), 2);
experttrials_swi = mean(alltrials_swi(:,numSes+1:numSes*2), 2);

% Statistics and normalization
[p2,~] = signrank(naivetrials_swi, experttrials_swi);
ztrials_swi = zscore(alltrials_swi,0,2);

%% plot data initial rule
% 3d bar plot
%f1 = figure; trialbars = bar3(ztrials_ini);
%numBars = size(ztrials_ini,1);
%numSets = size(ztrials_ini,2);
%for i = 1:numSets
%    zdata = ones(6*numBars,4);
%    k = 1;
%    for j = 0:6:(6*numBars-6)
%      zdata(j+1:j+6,:) = ztrials_ini(k,i);
%      k = k+1;
%    end
%    set(trialbars(i),'Cdata',zdata)
%end
%colorbar
%xlabel('Sessions'); xticks([]); xticklabels([])
%ylabel('Animals'); yticks([]); yticklabels([])
%title('Trialcount initial rule', 'Conditioning')

% histogram
f2 = figure; edges = 0:10:150;
histogram(alltrials_ini(:,1:4),edges); hold on
histogram(alltrials_ini(:,5:8),edges)
title('Trial-Histogram', 'Conditioning')
xlabel('Trials')
legend('naive','expert'); legend('boxoff')

% line plot
f3 = figure; hold on
%boxchart(ones(1,length(naivetrials_ini)),naivetrials_ini,'BoxFaceColor','k','MarkerStyle','none','BoxWidth',0.2)
%boxchart(ones(1,length(experttrials_ini))+1,experttrials_ini,'BoxFaceColor','k','MarkerStyle','none','BoxWidth',0.2)
errorbar(0.9,mean(naivetrials_ini),std(naivetrials_ini),'o','Color','k')
errorbar(2.1,mean(experttrials_ini),std(naivetrials_ini),'o','Color','k')
for i = 1:length(experttrials_ini)
    plot([1,2],[naivetrials_ini(i),experttrials_ini(i)],'Color','k')
end
plot([1,2],[mean(naivetrials_ini),mean(experttrials_ini)],'LineWidth',1.5)
maxexpert = max(experttrials_ini);
plotStatistics(p1,maxexpert,1,2)
title('Trials per session', 'Conditioning')
xticks([1 2]); xticklabels({'Naive','Expert'})
ylabel('Trials')

%% plot data switched rule
% 3d bar plot
%f4 = figure; trialbars = bar3(ztrials_swi);
%numBars = size(ztrials_swi,1);
%numSets = size(ztrials_swi,2);
%for i = 1:numSets
%    zdata = ones(6*numBars,4);
%    k = 1;
%    for j = 0:6:(6*numBars-6)
%      zdata(j+1:j+6,:) = ztrials_swi(k,i);
%      k = k+1;
%    end
%    set(trialbars(i),'Cdata',zdata)
%end
%colorbar
%xlabel('Sessions'); xticks([]); xticklabels([])
%ylabel('Animals'); yticks([]); yticklabels([])
%title('Trialcount switched rule', 'Reversal')

% histogram
f5 = figure; histogram(alltrials_swi(:,1:4),edges); hold on
histogram(alltrials_swi(:,5:8),edges)
title('Trial-Histogram', 'Reversal')
xlabel('Trials')
legend('naive','expert'); legend('boxoff')

% line plot
f6 = figure; hold on
errorbar(0.9,mean(naivetrials_swi),std(naivetrials_swi),'o','Color','k')
errorbar(2.1,mean(experttrials_swi),std(naivetrials_swi),'o','Color','k')
for i = 1:length(experttrials_swi)
    plot([1,2],[naivetrials_swi(i),experttrials_swi(i)],'Color','k')
end
plot([1,2],[mean(naivetrials_swi),mean(experttrials_swi)],'LineWidth',1.5)
maxexpert = max(experttrials_swi);
plotStatistics(p2,maxexpert,1,2)
title('Trials per animal', 'Reversal')
xticks([1 2]); xticklabels({'Naive','Expert'})
ylabel('Trials')
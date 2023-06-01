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

%% Population trial d'prime initial rules (contrast: 20mm)
figure

alldvalues = NaN(787,19);
cohortFlag = [11, 14, 17];
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP2 = contains(cohortData(i).session_names,'P3.2');
        trialFlag_first = find(isP2, 1, 'first');
        trialFlag_last = find(isP2, 1, 'last');
        trialFlag = sum(cohortData(i).trial_num(trialFlag_first:trialFlag_last));

        dvalues = cohortData(i).dvalues_trials;
        dvalues(trialFlag+1:end) = [];
        dvalues(1:200) = [];

        xvalues = (201:length(dvalues)+200)';
        plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on

        alldvalues(1:length(dvalues),i) = dvalues;
    end
end

trials_dprime_mean = mean(alldvalues,2,'omitnan');
trials_dprime_std = std(alldvalues,0,2,'omitnan');
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
plot(201:length(curve1)+200, curve1,'Color','#4d4d4d');
plot(201:length(curve2)+200, curve2,'Color','#4d4d4d');
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],'FaceColor','#e6e6e6', 'EdgeColor','none');
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')

xlabel('trials')
ylabel('d prime')
title ('Population Performance over trials (initial rules; contrast 20mm)')

%% Population trial d'prime initial rules
cohortFlag = [15, 16];
for ii = cohortFlag
    figure
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP2 = contains(cohortData(i).session_names,'P3.2');
        trialFlag_first = find(isP2, 1, 'first');
        trialFlag_last = find(isP2, 1, 'last');
        trialFlag = sum(cohortData(i).trial_num(trialFlag_first:trialFlag_last));

        dvalues = cohortData(i).dvalues_trials;
        dvalues(trialFlag+1:end) = [];
        dvalues(1:200) = [];

        xvalues = (201:length(dvalues)+200)';
        contrastFlag = contains(cohortData(i).session_names,'16mm');
        if contrastFlag(1)==0
            plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
        else
            plot(xvalues, dvalues, 'Color', 'k'), hold on
        end
    end

    xlabel('trials')
    ylabel('d prime')
    title (sprintf('Population Performance over trials (initial rules; Cohort %d)', ii))
end

%% Population trial d'prime second rules
cohortFlag = [11, 15, 16];
for ii = cohortFlag
    figure
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP4 = contains(cohortData(i).session_names,'P3.4');
        trialFlag_first = find(isP4, 1, 'first');
        trialFlag_last = find(isP4, 1, 'last');

        dvalues = cohortData(i).dvalues_trials;
        trialFlag = sum(cohortData(i).trial_num(1:trialFlag_first-1));
        dvalues(1:trialFlag) = [];
        trialFlag = sum(cohortData(i).trial_num(trialFlag_first:trialFlag_last));
        dvalues(trialFlag+1:end) = [];

        trialFlag = sum(cohortData(i).trial_num(1:trialFlag_first-1));
        xvalues = (1:length(dvalues))';
        contrastFlag = contains(cohortData(i).session_names,'16mm');
        if contrastFlag(1)==0
            plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
        else
            plot(xvalues, dvalues, 'Color', 'k'), hold on
        end
    end

    xlabel('trials')
    ylabel('d prime')
    title (sprintf('Population Performance over trials (second rules; Cohort %d)', ii))
end
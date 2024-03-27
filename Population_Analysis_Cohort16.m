%% Population trial d'prime initial rules cohort 16
% FOR THE FOLLOWING SECTIONS THERE IS STILL THE ERROR FOR THE SWITCHED RULE
% (REMOVING TOO MANY DVALUES FROM THE START)

cohortNum = 16;
cohortData = animalData.cohort(cohortNum).animal;
alldvalues14 = NaN(1526,3);
alldvalues16 = NaN(885,6);
for mouseIDX = 1:length(cohortData)
    isP2 = contains(cohortData(mouseIDX).session_names,'P3.2');
    sesFlag_first = find(isP2, 1, 'first');
    sesFlag_last = find(isP2, 1, 'last');
    trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));

    dvalues = cohortData(mouseIDX).dvalues_trials;
    dvalues(trialFlag+1:end) = [];
    dvalues(1:200) = [];

    %xvalues = (201:length(dvalues)+200)';
    contrastFlag14 = contains(cohortData(mouseIDX).session_names,'14mm');
    contrastFlag16 = contains(cohortData(mouseIDX).session_names,'16mm');
    if contrastFlag14(1)==1
        %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
        alldvalues14(1:length(dvalues),mouseIDX) = dvalues;
    elseif contrastFlag16(1)==1
        %plot(xvalues, dvalues, 'Color', 'k'), hold on
        alldvalues16(1:length(dvalues),mouseIDX) = dvalues;
    end
end

figure
trials_dprime_mean = mean(alldvalues14,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvalues14,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')
xlabel('trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title (sprintf('Population Performance over trials (initial rules; Cohort %d; contrast 14mm)', cohortNum))

figure
trials_dprime_mean = mean(alldvalues16,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvalues16,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')
xlabel('Trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title (sprintf('Population Performance over trials (initial rules; Cohort %d; contrast 16mm', cohortNum))

%% Population trial d'prime second rules cohort 16
cohortNum = 16;
cohortData = animalData.cohort(cohortNum).animal;
alldvalues14 = NaN(3055,3);
alldvalues16 = NaN(2555,6);
for mouseIDX = 1:length(cohortData)
    isP4 = contains(cohortData(mouseIDX).session_names,'P3.4');
    sesFlag_first = find(isP4, 1, 'first');
    sesFlag_last = find(isP4, 1, 'last');

    dvalues = cohortData(mouseIDX).dvalues_trials;
    trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(1:sesFlag_first-1)));
    dvalues(1:trialFlag) = [];
    trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));
    if trialFlag == 0
        continue
    else
        dvalues(trialFlag-199:end) = [];
        dvalues(1:200) = [];
    end

    contrastFlag14 = contains(cohortData(mouseIDX).session_names,'14mm');
    contrastFlag16 = contains(cohortData(mouseIDX).session_names,'16mm');

    if contrastFlag14(1)==1
        %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
        alldvalues14(1:length(dvalues),mouseIDX) = dvalues;
    elseif contrastFlag16(1)==1
        %plot(xvalues, dvalues, 'Color', '#k'), hold on
        alldvalues16(1:length(dvalues),mouseIDX) = dvalues;
    end
end

figure
trials_dprime_mean = mean(alldvalues14,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvalues14,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')
xlabel('Trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title (sprintf('Population Performance over trials (second rules; Cohort %d; contrast 14mm)', cohortNum))

figure
trials_dprime_mean = mean(alldvalues16,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvalues16,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')
xlabel('Trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title (sprintf('Population Performance over trials (second rules; Cohort %d)', cohortNum))
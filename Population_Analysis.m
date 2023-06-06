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

alldvalues = NaN(766,19);
cohortFlag = [11, 14, 17];
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP2 = contains(cohortData(i).session_names,'P3.2');
        sesFlag_first = find(isP2, 1, 'first');
        sesFlag_last = find(isP2, 1, 'last');
        trialFlag = sum(cellfun(@numel, cohortData(i).Lick_Events(sesFlag_first:sesFlag_last)));

        dvalues = cohortData(i).dvalues_trials;
        dvalues(trialFlag+1:end) = [];
        dvalues(1:200) = [];

        %xvalues = (201:length(dvalues)+200)';
        %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
        
        if ii == 11
            alldvalues(1:length(dvalues),i) = dvalues;
        elseif ii == 14
            alldvalues(1:length(dvalues),i+6) = dvalues;
        elseif ii == 17
            alldvalues(1:length(dvalues),i+14) = dvalues;
        end
    end
end

trials_dprime_mean = mean(alldvalues,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvalues,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'), hold on
plot(201:length(curve2)+200, curve2,'Color','#4d4d4d');
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],'FaceColor','#e6e6e6', 'EdgeColor','none');
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')

xlabel('trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Population Performance over trials (initial rules; contrast 20mm)')

%% Population trial d'prime initial rules
cohortFlag = [15, 16];
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    alldvalues = NaN(1616,6);
    alldvalues14 = NaN(1526,3);
    alldvalues16 = NaN(885,6);
    for i = 1:length(cohortData)
        isP2 = contains(cohortData(i).session_names,'P3.2');
        sesFlag_first = find(isP2, 1, 'first');
        sesFlag_last = find(isP2, 1, 'last');
        trialFlag = sum(cellfun(@numel, cohortData(i).Lick_Events(sesFlag_first:sesFlag_last)));

        dvalues = cohortData(i).dvalues_trials;
        dvalues(trialFlag+1:end) = [];
        dvalues(1:200) = [];

        %xvalues = (201:length(dvalues)+200)';
        contrastFlag14 = contains(cohortData(i).session_names,'14mm');
        contrastFlag16 = contains(cohortData(i).session_names,'16mm');
        if contrastFlag14(1)==1
            %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
            alldvalues14(1:length(dvalues),i) = dvalues;
        elseif contrastFlag16(1)==1
            %plot(xvalues, dvalues, 'Color', 'k'), hold on
            alldvalues16(1:length(dvalues),i) = dvalues;
        else
            alldvalues(1:length(dvalues),i) = dvalues;
        end
    end
    
    if ii == 16
        figure
        trials_dprime_mean = mean(alldvalues14,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
        trials_dprime_std = std(alldvalues14,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
        curve1 = trials_dprime_mean + trials_dprime_std;
        curve2 = trials_dprime_mean - trials_dprime_std;
        plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'), hold on
        plot(201:length(curve2)+200, curve2,'Color','#4d4d4d');
        fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],'FaceColor','#e6e6e6', 'EdgeColor','none');
        plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')

        xlabel('trials')
        ylabel('d prime')
        yline([1.65, 1.65],'Color','black','LineStyle','--')
        yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
        title (sprintf('Population Performance over trials (initial rules; Cohort %d; contrast 14mm)', ii))

        figure
        trials_dprime_mean = mean(alldvalues16,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
        trials_dprime_std = std(alldvalues16,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
        curve1 = trials_dprime_mean + trials_dprime_std;
        curve2 = trials_dprime_mean - trials_dprime_std;
        plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'), hold on
        plot(201:length(curve2)+200, curve2,'Color','#4d4d4d');
        fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],'FaceColor','#e6e6e6', 'EdgeColor','none');
        plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')
    else
        figure
        trials_dprime_mean = mean(alldvalues,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
        trials_dprime_std = std(alldvalues,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
        curve1 = trials_dprime_mean + trials_dprime_std;
        curve2 = trials_dprime_mean - trials_dprime_std;
        plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'), hold on
        plot(201:length(curve2)+200, curve2,'Color','#4d4d4d');
        fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],'FaceColor','#e6e6e6', 'EdgeColor','none');
        plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')
    end

    xlabel('trials')
    ylabel('d prime')
    yline([1.65, 1.65],'Color','black','LineStyle','--')
    yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
    title (sprintf('Population Performance over trials (initial rules; Cohort %d)', ii))
end

%% Population trial d'prime second rules
cohortFlag = [11, 15, 16];

for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    alldvalues = NaN(3180,6);
    alldvalues14 = NaN(3055,3);
    alldvalues16 = NaN(2555,6);
    for i = 1:length(cohortData)
        isP4 = contains(cohortData(i).session_names,'P3.4');
        sesFlag_first = find(isP4, 1, 'first');
        sesFlag_last = find(isP4, 1, 'last');

        dvalues = cohortData(i).dvalues_trials;
        trialFlag = sum(cellfun(@numel, cohortData(i).Lick_Events(1:sesFlag_first-1)));
        dvalues(1:trialFlag) = [];
        trialFlag = sum(cellfun(@numel, cohortData(i).Lick_Events(sesFlag_first:sesFlag_last)));
        if trialFlag == 0
            continue
        else
            dvalues(trialFlag-199:end) = [];
        end

        trialFlag = sum(cohortData(i).trial_num(1:sesFlag_first-1));
        %xvalues = (1:length(dvalues))';
        contrastFlag14 = contains(cohortData(i).session_names,'14mm');
        contrastFlag16 = contains(cohortData(i).session_names,'16mm');

        if contrastFlag14(1)==1
            %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
            alldvalues14(1:length(dvalues),i) = dvalues;
        elseif contrastFlag16(1)==1
            %plot(xvalues, dvalues, 'Color', '#k'), hold on
            alldvalues16(1:length(dvalues),i) = dvalues;
        else
            %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
            alldvalues(1:length(dvalues),i) = dvalues;
        end
    end

    if ii == 16
        figure
        trials_dprime_mean = mean(alldvalues14,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
        trials_dprime_std = std(alldvalues14,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
        curve1 = trials_dprime_mean + trials_dprime_std;
        curve2 = trials_dprime_mean - trials_dprime_std;
        plot(1:length(curve1), curve1,'Color','#4d4d4d'), hold on
        plot(1:length(curve2), curve2,'Color','#4d4d4d');
        fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],'FaceColor','#e6e6e6', 'EdgeColor','none');
        plot((1:length(trials_dprime_mean)),trials_dprime_mean, 'Color', 'k')
        xlabel('trials')
        ylabel('d prime')
        yline([1.65, 1.65],'Color','black','LineStyle','--')
        yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
        title (sprintf('Population Performance over trials (second rules; Cohort %d; contrast 14mm)', ii))

        figure
        trials_dprime_mean = mean(alldvalues16,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
        trials_dprime_std = std(alldvalues16,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
        curve1 = trials_dprime_mean + trials_dprime_std;
        curve2 = trials_dprime_mean - trials_dprime_std;
        plot(1:length(curve1), curve1,'Color','#4d4d4d'), hold on
        plot(1:length(curve2), curve2,'Color','#4d4d4d');
        fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],'FaceColor','#e6e6e6', 'EdgeColor','none');
        plot((1:length(trials_dprime_mean)),trials_dprime_mean, 'Color', 'k')
    else 
        figure
        trials_dprime_mean = mean(alldvalues,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
        trials_dprime_std = std(alldvalues,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
        curve1 = trials_dprime_mean + trials_dprime_std;
        curve2 = trials_dprime_mean - trials_dprime_std;

        plot(1:length(curve1), curve1,'Color','#4d4d4d'), hold on
        plot(1:length(curve2), curve2,'Color','#4d4d4d');
        fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],'FaceColor','#e6e6e6', 'EdgeColor','none');
        plot((1:length(trials_dprime_mean)),trials_dprime_mean, 'Color', 'k')
    end

    xlabel('trials')
    ylabel('d prime')
    yline([1.65, 1.65],'Color','black','LineStyle','--')
    yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
    title (sprintf('Population Performance over trials (second rules; Cohort %d)', ii))
end

%% Population trial d'prime CNO Cohort
figure

alldvalues = NaN(969,8);
cohortFlag = [18, 19];
mice = string({'#70','#72','#74','#76','#79','#80','#83','#84'});

for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        mouseflag = string(cohortData(i).animalName) == mice;
        if sum(mouseflag) == 1
            isP2 = contains(cohortData(i).session_names,'P3.2');
            sesFlag_first = find(isP2, 1, 'first');
            sesFlag_last = find(isP2, 1, 'last');
            trialFlag = sum(cellfun(@numel, cohortData(i).Lick_Events(sesFlag_first:sesFlag_last)));

            dvalues = cohortData(i).dvalues_trials;
            dvalues(trialFlag+1:end) = [];
            dvalues(1:200) = [];

            %xvalues = (201:length(dvalues)+200)';
            %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
            
            if ii == 18
                alldvalues(1:length(dvalues),i) = dvalues;
            elseif i == 2
                alldvalues(1:length(dvalues),i-1) = dvalues;
            elseif i == 6
                alldvalues(1:length(dvalues),i-1) = dvalues;
            else
                alldvalues(1:length(dvalues),i) = dvalues;
            end
        continue
        end
    end
end

trials_dprime_mean = mean(alldvalues,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvalues,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'), hold on
plot(201:length(curve2)+200, curve2,'Color','#4d4d4d');
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],'FaceColor','#e6e6e6', 'EdgeColor','none');
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')

xlabel('trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Population Performance over trials (initial rules; contrast 20mm; CNO)')

figure
alldvalues = NaN(1980,8);
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        mouseflag = string(cohortData(i).animalName) == mice;
        if sum(mouseflag) == 1
            isP3 = contains(cohortData(i).session_names,'P3.3');
            sesFlag_first = find(isP3, 1, 'first');
            sesFlag_last = find(isP3, 1, 'last');

            dvalues = cohortData(i).dvalues_trials;
            trialFlag = sum(cellfun(@numel, cohortData(i).Lick_Events(1:sesFlag_first-1)));
            dvalues(1:trialFlag) = [];
            trialFlag = sum(cellfun(@numel, cohortData(i).Lick_Events(sesFlag_first:sesFlag_last)));
            if trialFlag == 0
                continue
            else
                dvalues(trialFlag-199:end) = [];
            end

            if ii == 18
                alldvalues(1:length(dvalues),i) = dvalues;
            elseif i == 2
                alldvalues(1:length(dvalues),i-1) = dvalues;
            elseif i == 6
                alldvalues(1:length(dvalues),i-1) = dvalues;
            else
                alldvalues(1:length(dvalues),i) = dvalues;
            end
        continue
        end
    end
end

trials_dprime_mean = mean(alldvalues,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvalues,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;

plot(1:length(curve1), curve1,'Color','#4d4d4d'), hold on
plot(1:length(curve2), curve2,'Color','#4d4d4d');
fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],'FaceColor','#e6e6e6', 'EdgeColor','none');
plot((1:length(trials_dprime_mean)),trials_dprime_mean, 'Color', 'k')
xlabel('trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Population Performance over trials (second rules; contrast 20mm; CNO)')


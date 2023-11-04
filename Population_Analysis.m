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
alldvalues(:,17) = [];

trials_dprime_mean = mean(alldvalues,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvalues,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d');
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')

xlabel('Trials')
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
        % plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
        % plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
        fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
            'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
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
        % plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
        % plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
        fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
            'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
        plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')
    else
        figure
        trials_dprime_mean = mean(alldvalues,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
        trials_dprime_std = std(alldvalues,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
        curve1 = trials_dprime_mean + trials_dprime_std;
        curve2 = trials_dprime_mean - trials_dprime_std;
        % plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
        % plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
        fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
            'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
        plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')
    end

    xlabel('Trials')
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
            dvalues(1:200) = [];
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
        % plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
        % plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
        fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
            'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
        plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')
        xlabel('Trials')
        ylabel('d prime')
        yline([1.65, 1.65],'Color','black','LineStyle','--')
        yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
        title (sprintf('Population Performance over trials (second rules; Cohort %d; contrast 14mm)', ii))

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
    else 
        figure
        trials_dprime_mean = mean(alldvalues,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
        trials_dprime_std = std(alldvalues,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
        curve1 = trials_dprime_mean + trials_dprime_std;
        curve2 = trials_dprime_mean - trials_dprime_std;
        % plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
        % plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
        fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
            'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
        plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k')
    end

    xlabel('Trials')
    ylabel('d prime')
    yline([1.65, 1.65],'Color','black','LineStyle','--')
    yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
    title (sprintf('Population Performance over trials (second rules; Cohort %d)', ii))
end

%% Population trial d'prime CNO Cohort
fig_1 = figure;

alldvaluesCNO = NaN(969,8);
cohortFlag = [18, 19];
mice = string({'#70','#72','#74','#76','#79','#80','#83'});
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
                alldvaluesCNO(1:length(dvalues),i) = dvalues;
            elseif i == 2
                alldvaluesCNO(1:length(dvalues),i-1) = dvalues;
            elseif i == 6
                alldvaluesCNO(1:length(dvalues),i-1) = dvalues;
            else
                alldvaluesCNO(1:length(dvalues),i) = dvalues;
            end
        continue
        end
    end
end

trials_dprime_mean = mean(alldvaluesCNO,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvaluesCNO,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor',[1 0.8 0.8],'EdgeColor','none','FaceAlpha',0.5); hold on
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d')
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', [1 0.32 0.30])

% get d_values for Saline animals
alldvaluesSaline = NaN(1124,6);
mice = string({'#69','#71','#73','#75','#78','#82'});
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
            
            if i == 7
                alldvaluesSaline(1:length(dvalues),i-1) = dvalues;
            elseif ii == 18
                alldvaluesSaline(1:length(dvalues),i) = dvalues;
            elseif i == 1
                alldvaluesSaline(1:length(dvalues),i+1) = dvalues;
            elseif i == 5
                alldvaluesSaline(1:length(dvalues),i-1) = dvalues;
            end
        continue
        end
    end
end

trials_dprime_mean = mean(alldvaluesSaline,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvaluesSaline,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor',[0.8 0.92 1],'EdgeColor','none','FaceAlpha',0.5)
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d')
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d');
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', [0 0.45 0.74])

xlabel('Trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Initial rules')
plot([560.5 560.5], [-0.5 1.65], 'Color', [0 0.45 0.74], 'LineStyle', ':','LineWidth',1)
plot([559 559], [-0.5 1.65], 'Color', [1 0.32 0.30], 'LineStyle', ':','LineWidth',1)

% statistics on d'primes
endflag = size(alldvaluesCNO);
endflag = endflag(1);
[p0, h0] = ranksum(reshape(alldvaluesCNO(endflag-200:endflag,:),[],1), reshape(alldvaluesSaline(endflag-200:endflag,:), [], 1));
% plot([endflag endflag], [2.25 4.25], 'Color', [.7 .7 .7]); plot([endflag+200 endflag+200], [2.25 4.25], 'Color', [.7 .7 .7])
plot([endflag endflag+200], [4.25 4.25], 'k');
if p0 <= 0.05 && p0 > 0.01
    text(endflag+100, 4.3,'*','HorizontalAlignment','center')
elseif p0 <= 0.01 && p0 > 0.001
    text(endflag+100, 4.3,'**','HorizontalAlignment','center')
elseif p0 <= 0.001
    text(endflag+100, 4.3,'***','HorizontalAlignment','center')
else
    text(endflag+100, 4.3,'ns','HorizontalAlignment','center')
end

legend('','CNO','','Saline'); legend('boxoff'); legend('location','best')

fig_2 = figure; hold on
boxchart(ones(numel(alldvaluesCNO(endflag-200:endflag,:)),1), reshape(alldvaluesCNO(endflag-200:endflag,:),[],1),...
    'BoxFaceColor', [1 0.32 0.30],'Notch', 'on')
hold on; boxchart(1+ones(numel(alldvaluesSaline(endflag-200:endflag,:)),1), reshape(alldvaluesSaline(endflag-200:endflag,:), [], 1),...
    'BoxFaceColor', [0 0.45 0.74], 'Notch', 'on')
scatter(ones(numel(alldvaluesCNO(endflag-200:endflag,:)),1), reshape(alldvaluesCNO(endflag-200:endflag,:),[],1),...
    'MarkerEdgeColor', [1 0.32 0.30], 'Marker', '.', 'XJitter', 'randn', 'MarkerEdgeAlpha', 0.4)
scatter(1+ones(numel(alldvaluesSaline(endflag-200:endflag,:)),1), reshape(alldvaluesSaline(endflag-200:endflag,:),[],1),...
    'MarkerEdgeColor', [0 0.45 0.74], 'Marker', '.', 'XJitter', 'randn', 'MarkerEdgeAlpha', 0.4)

plot([1 2], [4.25 4.25], 'k');
if p0 <= 0.05 && p0 > 0.01
    text(1.5, 4.3,'*','HorizontalAlignment','center')
elseif p0 <= 0.01 && p0 > 0.001
    text(1.5, 4.3,'**','HorizontalAlignment','center')
elseif p0 <= 0.001
    text(1.5, 4.3,'***','HorizontalAlignment','center')
else
    text(1.5, 4.3,'ns','HorizontalAlignment','center')
end

title('Population performance in expert animals (initial rule)')
xticks([1 2]), xticklabels({'CNO' 'Saline'}), ylabel('d prime')

% second rules
fig_3 = figure;
alldvaluesCNO = NaN(1532,8);
mice = string({'#70','#72','#74','#76','#79','#80','#83'});
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
                dvalues(1:200) = [];
            end

            if i == 7
                alldvaluesCNO(1:length(dvalues),i-1) = dvalues;
            elseif ii == 18
                alldvaluesCNO(1:length(dvalues),i) = dvalues;
            elseif i == 1
                alldvaluesCNO(1:length(dvalues),i+1) = dvalues;
            elseif i == 5
                alldvaluesCNO(1:length(dvalues),i-1) = dvalues;
            end
        continue
        end
    end
end

trials_dprime_mean = mean(alldvaluesCNO,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvaluesCNO,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor',[1 0.8 0.8], 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color',  [1 0.32 0.30])

% Saline animals
alldvaluesSaline = NaN(2164,6);
mice = string({'#69','#71','#73','#75','#78','#82'});
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        mouseflag = string(cohortData(i).animalName) == mice;
        if sum(mouseflag) == 1
            isP3 = contains(cohortData(i).session_names,'P3.4');
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
                dvalues(1:200) = [];
            end

            if i == 7
                alldvaluesSaline(1:length(dvalues),i-1) = dvalues;
            elseif ii == 18
                alldvaluesSaline(1:length(dvalues),i) = dvalues;
            elseif i == 1
                alldvaluesSaline(1:length(dvalues),i+1) = dvalues;
            elseif i == 5
                alldvaluesSaline(1:length(dvalues),i-1) = dvalues;
            end
        continue
        end
    end
end

trials_dprime_mean = mean(alldvaluesSaline,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvaluesSaline,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor',[0.8 0.92 1], 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color',  [0 0.45 0.74])

xlabel('Trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Second rules')
plot([953 953], [-1.5 1.65], 'Color', [0 0.45 0.74], 'LineStyle', ':','LineWidth',1)
plot([1303 1303], [-1.5 1.65], 'Color', [1 0.32 0.30], 'LineStyle', ':','LineWidth',1)
xlim([200 2400]); ylim([-1.5 5])

% statistics on d'primes
endflag = size(alldvaluesCNO);
endflag = endflag(1);
[p1, h1] = ranksum(reshape(alldvaluesCNO(endflag-200:endflag,:),[],1), reshape(alldvaluesSaline(endflag-200:endflag,:), [], 1));
% plot([endflag endflag], [2.25 4.25], 'Color', [.7 .7 .7]); plot([endflag+200 endflag+200], [2.25 4.25], 'Color', [.7 .7 .7])
plot([endflag endflag+200], [4.25 4.25], 'k');
if p1 <= 0.05 && p1 > 0.01
    text(endflag+100, 4.3,'*','HorizontalAlignment','center')
elseif p1 <= 0.01 && p1 > 0.001
    text(endflag+100, 4.3,'**','HorizontalAlignment','center')
elseif p1 <= 0.001
    text(endflag+100, 4.3,'***','HorizontalAlignment','center')
else
    text(endflag+100, 4.3,'ns','HorizontalAlignment','center')
end

crossflag = 953;
[p2, h2] = ranksum(reshape(alldvaluesCNO(crossflag-200:crossflag,:),[],1), reshape(alldvaluesSaline(crossflag-200:crossflag,:), [], 1));
plot([crossflag-200 crossflag], [4.25 4.25], 'k');
if p2 <= 0.05 && p2 > 0.01
    text(crossflag-100, 4.3,'*','HorizontalAlignment','center')
elseif p2 <= 0.01 && p2 > 0.001
    text(crossflag-100, 4.3,'**','HorizontalAlignment','center')
elseif p2 <= 0.001
    text(crossflag-100, 4.3,'***','HorizontalAlignment','center')
else
    text(crossflag-100, 4.3,'ns','HorizontalAlignment','center')
end

legend('','CNO','','Saline'); legend('boxoff'); legend('location','best')

fig_4 = figure; hold on
boxchart(ones(numel(alldvaluesCNO(endflag-200:endflag,:)),1), reshape(alldvaluesCNO(endflag-200:endflag,:),[],1),...
    'BoxFaceColor', [1 0.32 0.30],'Notch', 'on')
hold on; boxchart(1+ones(numel(alldvaluesSaline(endflag-200:endflag,:)),1), reshape(alldvaluesSaline(endflag-200:endflag,:), [], 1),...
    'BoxFaceColor', [0 0.45 0.74], 'Notch', 'on')
scatter(ones(numel(alldvaluesCNO(endflag-200:endflag,:)),1), reshape(alldvaluesCNO(endflag-200:endflag,:),[],1),...
    'MarkerEdgeColor', [1 0.32 0.30], 'Marker', '.', 'XJitter', 'randn', 'MarkerEdgeAlpha', 0.4)
scatter(1+ones(numel(alldvaluesSaline(endflag-200:endflag,:)),1), reshape(alldvaluesSaline(endflag-200:endflag,:),[],1),...
    'MarkerEdgeColor', [0 0.45 0.74], 'Marker', '.', 'XJitter', 'randn', 'MarkerEdgeAlpha', 0.4)

plot([1 2], [4.25 4.25], 'k');
if p2 <= 0.05 && p2 > 0.01
    text(1.5, 4.3,'*','HorizontalAlignment','center')
elseif p2 <= 0.01 && p2 > 0.001
    text(1.5, 4.3,'**','HorizontalAlignment','center')
elseif p2 <= 0.001
    text(1.5, 4.3,'***','HorizontalAlignment','center')
else
    text(1.5, 4.3,'ns','HorizontalAlignment','center')
end

title('Population performance in expert animals (switched rule)')
xticks([1 2]), xticklabels({'CNO' 'Saline'}), ylabel('d prime')

%% Save Figures
%saveFigure(fig_1,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Trial-dprime_CNO_saline_initial'),true,true)
saveFigure(fig_2,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Peak_Performance_CNO_initial_rules'),true,true)
%saveFigure(fig_3,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Trial-dprime_CNO_saline_switched'),true,true)
saveFigure(fig_4,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Peak_Performance_CNO_switched_rules'),true,true)
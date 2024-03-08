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

%% Population trial d'prime
% only works if animalData.m is loaded
figure

cohorts = arrayfun(@(x) num2str(x), 1:numel(animalData.cohort), 'UniformOutput', false);
answer = listdlg('ListString',cohorts,'PromptString','Choose your cohort.');
cohorts = cellfun(@str2double, cohorts(answer));
stages = {'P3.2','P3.4'};
numMice = arrayfun(@(x) length(animalData.cohort(x).animal), cohorts);
cohortData = horzcat(animalData.cohort(cohorts).animal);
max_dvalue = max(arrayfun(@(m) length(cohortData(m).dvalues_trials), 1:sum(numMice)));

alldvalues = NaN(max_dvalue,sum(numMice));
for stageIDX = 1:length(stages)
    for mouseIDX = 1:length(cohortData)
        isStage = contains(cohortData(mouseIDX).session_names, stages(stageIDX));
        sesFlag_first = find(isStage, 1, 'first');
        sesFlag_last = find(isStage, 1, 'last');

        if strcmp(stages{stageIDX}, 'P3.2')
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));
            dvalues = cohortData(mouseIDX).dvalues_trials;
            dvalues(trialFlag+1:end) = [];
            dvalues(1:200) = [];
        elseif strcmp(stages{stageIDX}, 'P3.4')
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
        end

        %xvalues = (201:length(dvalues)+200)';
        %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on

        alldvalues(1:length(dvalues),mouseIDX) = dvalues;
    end
    
    color_map = [[0.2 0.2 0.2]; [0.8 0.8 0.8]];
    trials_dprime_mean = mean(alldvalues,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
    trials_dprime_std = std(alldvalues,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
    curve1 = trials_dprime_mean + trials_dprime_std;
    curve2 = trials_dprime_mean - trials_dprime_std;
    % plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
    % plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
    fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
        'FaceColor',color_map(stageIDX,:), 'EdgeColor','none','FaceAlpha',0.5); hold on
    plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', 'k', 'LineWidth', 2)
end

xlabel('Trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
%yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Population performance over trials')

% for cohort 11 & 12
%plot([471,471],[-1,1.65],'Color','r')
%plot([1103,1103],[-1,1.65],'Color','r')

%% Population trial d'prime initial rules cohort 16
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

%% Population trial d'prime CNO Cohort
fig_1 = figure;

alldvaluesCNO = NaN(969,8);
cohortFlag = [18, 19];
mice = string({'#70','#72','#74','#76','#79','#80','#83'});
for cohortNum = cohortFlag
    cohortData = animalData.cohort(cohortNum).animal;
    for mouseIDX = 1:length(cohortData)
        mouseflag = string(cohortData(mouseIDX).animalName) == mice;
        if sum(mouseflag) == 1
            isP2 = contains(cohortData(mouseIDX).session_names,'P3.2');
            sesFlag_first = find(isP2, 1, 'first');
            sesFlag_last = find(isP2, 1, 'last');
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));

            dvalues = cohortData(mouseIDX).dvalues_trials;
            dvalues(trialFlag+1:end) = [];
            dvalues(1:200) = [];

            %xvalues = (201:length(dvalues)+200)';
            %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
            
            if cohortNum == 18
                alldvaluesCNO(1:length(dvalues),mouseIDX) = dvalues;
            elseif mouseIDX == 2
                alldvaluesCNO(1:length(dvalues),mouseIDX-1) = dvalues;
            elseif mouseIDX == 6
                alldvaluesCNO(1:length(dvalues),mouseIDX-1) = dvalues;
            else
                alldvaluesCNO(1:length(dvalues),mouseIDX) = dvalues;
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
for cohortNum = cohortFlag
    cohortData = animalData.cohort(cohortNum).animal;
    for mouseIDX = 1:length(cohortData)
        mouseflag = string(cohortData(mouseIDX).animalName) == mice;
        if sum(mouseflag) == 1
            isP2 = contains(cohortData(mouseIDX).session_names,'P3.2');
            sesFlag_first = find(isP2, 1, 'first');
            sesFlag_last = find(isP2, 1, 'last');
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));

            dvalues = cohortData(mouseIDX).dvalues_trials;
            dvalues(trialFlag+1:end) = [];
            dvalues(1:200) = [];

            %xvalues = (201:length(dvalues)+200)';
            %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
            
            if mouseIDX == 7
                alldvaluesSaline(1:length(dvalues),mouseIDX-1) = dvalues;
            elseif cohortNum == 18
                alldvaluesSaline(1:length(dvalues),mouseIDX) = dvalues;
            elseif mouseIDX == 1
                alldvaluesSaline(1:length(dvalues),mouseIDX+1) = dvalues;
            elseif mouseIDX == 5
                alldvaluesSaline(1:length(dvalues),mouseIDX-1) = dvalues;
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

plotStatistics(p0,4.2,endflag,endflag+200)
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
plotStatistics(p0,4.2,1,2)
title('Population performance in expert animals (initial rule)')
xticks([1 2]), xticklabels({'CNO' 'Saline'}), ylabel('d prime')

% second rules
fig_3 = figure;
alldvaluesCNO = NaN(1532,8);
mice = string({'#70','#72','#74','#76','#79','#80','#83'});
for cohortNum = cohortFlag
    cohortData = animalData.cohort(cohortNum).animal;
    for mouseIDX = 1:length(cohortData)
        mouseflag = string(cohortData(mouseIDX).animalName) == mice;
        if sum(mouseflag) == 1
            isP3 = contains(cohortData(mouseIDX).session_names,'P3.3');
            sesFlag_first = find(isP3, 1, 'first');
            sesFlag_last = find(isP3, 1, 'last');

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

            if mouseIDX == 7
                alldvaluesCNO(1:length(dvalues),mouseIDX-1) = dvalues;
            elseif cohortNum == 18
                alldvaluesCNO(1:length(dvalues),mouseIDX) = dvalues;
            elseif mouseIDX == 1
                alldvaluesCNO(1:length(dvalues),mouseIDX+1) = dvalues;
            elseif mouseIDX == 5
                alldvaluesCNO(1:length(dvalues),mouseIDX-1) = dvalues;
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
for cohortNum = cohortFlag
    cohortData = animalData.cohort(cohortNum).animal;
    for mouseIDX = 1:length(cohortData)
        mouseflag = string(cohortData(mouseIDX).animalName) == mice;
        if sum(mouseflag) == 1
            isP3 = contains(cohortData(mouseIDX).session_names,'P3.4');
            sesFlag_first = find(isP3, 1, 'first');
            sesFlag_last = find(isP3, 1, 'last');

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

            if mouseIDX == 7
                alldvaluesSaline(1:length(dvalues),mouseIDX-1) = dvalues;
            elseif cohortNum == 18
                alldvaluesSaline(1:length(dvalues),mouseIDX) = dvalues;
            elseif mouseIDX == 1
                alldvaluesSaline(1:length(dvalues),mouseIDX+1) = dvalues;
            elseif mouseIDX == 5
                alldvaluesSaline(1:length(dvalues),mouseIDX-1) = dvalues;
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

plotStatistics(p1,4.2,endflag,endflag+200)
plot([endflag endflag+200], [4.25 4.25], 'k');
crossflag = 953;
[p2, h2] = ranksum(reshape(alldvaluesCNO(crossflag-200:crossflag,:),[],1), reshape(alldvaluesSaline(crossflag-200:crossflag,:), [], 1));
plotStatistics(p2,4.2,crossflag-200,crossflag)
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
plotStatistics(p2,4.2,1,2)
title('Population performance in expert animals (switched rule)')
xticks([1 2]), xticklabels({'CNO' 'Saline'}), ylabel('d prime')

%% Save Figures
%saveFigure(fig_1,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Trial-dprime_CNO_saline_initial'),true,true)
saveFigure(fig_2,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Peak_Performance_CNO_initial_rules'),true,true)
%saveFigure(fig_3,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Trial-dprime_CNO_saline_switched'),true,true)
saveFigure(fig_4,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Peak_Performance_CNO_switched_rules'),true,true)
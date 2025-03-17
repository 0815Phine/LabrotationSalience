%% Population trial d'prime
% only works if animalData.m is loaded
currentFolder = pwd;
load(fullfile(currentFolder,'/RawData/animalData'))

%% choose cohorts and animals
cohorts = [22, 23, 24];
cohortData = horzcat(animalData.cohort(cohorts).animal);

%% choose stages
stages = getstagenames(cohortData);
answer = listdlg('ListString',stages,'PromptString','Choose stages.');
stages = stages(answer);

%% plot learning curves
% for learning curves
ablatedAnimals = {'#28','#29','#32','#33'};
ablatedData = cohortData(:,ismember({cohortData.animalName}, ablatedAnimals));
shamAnimals = {'#20','#21','#22','#24'};
shamData = cohortData(:,ismember({cohortData.animalName}, shamAnimals));

close all; fig_trials = figure; fig_sessions = figure;
color_map = [[0.804 0.1216 0.1373]; [0 0 0]];

groupData = {ablatedData, shamData};
groupLabels = {'Ablated', 'Sham'};
numMice = arrayfun(@(x) length(animalData.cohort(x).animal), cohorts);
max_dvalue = max(arrayfun(@(m) length(cohortData(m).dvalues_trials), 1:sum(numMice)));

alldvalues_trials_ablated = NaN(max_dvalue,sum(numMice));
alldvalues_sessions_ablated = NaN(max_dvalue,sum(numMice));
alldvalues_trials_sham = NaN(max_dvalue,sum(numMice));
alldvalues_sessions_sham = NaN(max_dvalue,sum(numMice));
for groupIDX = 1:length(groupData)
    currentData = groupData{groupIDX};
    for mouseIDX = 1:length(currentData)
        % last session stage 1
        isStage1 = contains(currentData(mouseIDX).session_names, 'P3.1');
        sesFlag_last_stage1 = find(isStage1, 1, 'last');

        isStage = contains(currentData(mouseIDX).session_names, 'P3.2');
        sesFlag_first = find(isStage, 1, 'first');
        sesFlag_last = find(isStage, 1, 'last');
        if isempty(sesFlag_first)
            continue
        end

        % dprime over sessions
        dvalues = currentData(mouseIDX).dvalues_sessions(sesFlag_first:sesFlag_last);
        if strcmp(groupLabels{groupIDX}, 'Ablated')
            alldvalues_sessions_ablated(1:length(dvalues),mouseIDX) = dvalues;
        elseif strcmp(groupLabels{groupIDX}, 'Sham')
            alldvalues_sessions_sham(1:length(dvalues),mouseIDX) = dvalues;
        end
        clear dvalues

        % dprime over trials
        if strcmp(stages, 'P3.2')
            trialFlag = sum(cellfun(@numel, currentData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));
            if trialFlag == 0
                continue
            else
                dvalues = currentData(mouseIDX).dvalues_trials;
                dvalues(trialFlag+1:end) = [];
                dvalues(1:200) = [];
            end
        else
            dvalues = currentData(mouseIDX).dvalues_trials;
            % this part removes all dvalues from stage 2 to the analysed stage
            trialFlag = sum(cellfun(@numel, currentData(mouseIDX).Lick_Events(sesFlag_last_stage1+1:sesFlag_first-1)));
            dvalues(1:trialFlag) = [];
            % removing the dvalues after the analysed stage and the first 200 (because of 200 trial binning window)
            trialFlag = sum(cellfun(@numel, currentData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));
            if trialFlag == 0
                continue
            else
                dvalues(trialFlag+1:end) = [];
                dvalues(1:200) = [];
            end
        end

        if strcmp(groupLabels{groupIDX}, 'Ablated')
            alldvalues_trials_ablated(1:length(dvalues),mouseIDX) = dvalues;
        elseif strcmp(groupLabels{groupIDX}, 'Sham')
            alldvalues_trials_sham(1:length(dvalues),mouseIDX) = dvalues;
        end
        clear dvalues
    end
end

alldvalues.ablated.trials = alldvalues_trials_ablated;
alldvalues.ablated.sessions = alldvalues_sessions_ablated;
alldvalues.sham.trials = alldvalues_trials_sham;
alldvalues.sham.sessions = alldvalues_sessions_sham;

xfield= fieldnames(alldvalues.ablated);
for fieldIDX = 1:length(xfield)
    figure(fieldIDX);
    hold on;

    for groupIDX = 1:1:length(groupData)
        groupName = groupLabels{groupIDX};
        dvalues = alldvalues.(lower(groupName)).(xfield{fieldIDX});
        dprime_mean = mean(dvalues,2,'omitnan'); dprime_mean(isnan(dprime_mean)) =[];
        dprime_std = std(dvalues,0,2,'omitnan'); dprime_std(isnan(dprime_std)) =[];
        curve1 = dprime_mean + dprime_std;
        curve2 = dprime_mean - dprime_std;

        if strcmp(xfield{fieldIDX}, 'trials')
            fill([(1:length(curve1))+200 fliplr((1:length(curve1))+200)], [curve1' fliplr(curve2')],[0 0 .85],...
                'FaceColor',color_map(groupIDX,:), 'EdgeColor','none','FaceAlpha',0.5); hold on
            plot((1:length(dprime_mean))+200,dprime_mean, 'Color', color_map(groupIDX,:), 'LineWidth', 2)

            learntime = mean(vertcat(groupData{groupIDX}.intersec_initial));
            plot([learntime learntime], [-2 1.65], 'Color', color_map(groupIDX,:),  'LineWidth', 1.5, 'LineStyle', ':')

        elseif strcmp(xfield{fieldIDX}, 'sessions')
            fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],...
                'FaceColor',color_map(groupIDX,:), 'EdgeColor','none','FaceAlpha',0.5); hold on
            plot((1:length(dprime_mean)),dprime_mean, 'Color', color_map(groupIDX,:), 'LineWidth', 2)

            learntime = find(dprime_mean>1.65,1);
            plot([learntime learntime], [-3 1.65], 'Color', color_map(groupIDX,:),  'LineWidth', 1.5, 'LineStyle', ':')
        end
    end

    xlabel(sprintf('%s', xfield{fieldIDX})); ylabel('d prime')
    yline([1.65, 1.65],'Color','black','LineStyle','--')
    %yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
    title (sprintf('Population performance over %s', xfield{fieldIDX}))
    legend('','Ablated','','Sham','Location','southeast','Box','off')
end

%% plot boxplots
% gather data
ablatedAnimals = {'#26','#27','#30','#31'};
shamAnimals = {'#07','#08','#10','#13'};
ablatedData = cohortData(:,ismember({cohortData.animalName}, ablatedAnimals));
shamData = cohortData(:,ismember({cohortData.animalName}, shamAnimals));
groupData = {ablatedData, shamData};

boxtable = NaN(4,4);
for groupIDX = 1:length(groupData)
    currentData = groupData{groupIDX};
    for mouseIDX = 1:length(currentData)
        if strcmp(groupLabels(groupIDX),'Ablated')
            isStage = contains(currentData(mouseIDX).session_names, 'P3.3');
        elseif strcmp(groupLabels(groupIDX),'Sham')
            isStage = contains(currentData(mouseIDX).session_names, 'P3.5');
        end
        sesFlag_first = find(isStage, 1, 'first');

        boxtable(groupIDX,mouseIDX) = currentData(mouseIDX).dvalues_sessions(sesFlag_first-1);
        boxtable(groupIDX+2,mouseIDX) = currentData(mouseIDX).dvalues_sessions(sesFlag_first);
    end
end

figure, hold on

for groupIDX = 1:length(boxtable)
    if groupIDX == 1 || groupIDX == 3
        boxchart(ones(1,length(boxtable))*groupIDX, boxtable(groupIDX,:),'BoxFaceColor',color_map(1,:))
    elseif groupIDX == 2 || groupIDX == 4
        boxchart(ones(1,length(boxtable))*groupIDX, boxtable(groupIDX,:),'BoxFaceColor',color_map(2,:))
    end
end

d_max_all = max(boxtable');
for groupIDX = 1:length(groupData)
    [~,p_paired,ci,stats]  = ttest(boxtable(groupIDX,:),boxtable(groupIDX+2,:));
    d_max = max(d_max_all(groupIDX),d_max_all(groupIDX+2));
    plotStatistics(p_paired,d_max,groupIDX,groupIDX+2,[])
end

title('Performance before and after ablation/sham')
ylabel('d prime')
xticks([1.5, 3.5]), xticklabels({'before','after'})
yline([1.65, 1.65],'Color','black','LineStyle','--')
legend(groupLabels,'Location','best','Box','off')

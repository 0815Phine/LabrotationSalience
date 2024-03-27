%% Population trial d'prime
% only works if animalData.m is loaded

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

%% plotting
figure
numMice = arrayfun(@(x) length(animalData.cohort(x).animal), cohorts);
max_dvalue = max(arrayfun(@(m) length(cohortData(m).dvalues_trials), 1:sum(numMice)));

alldvalues = NaN(max_dvalue,sum(numMice));
for stageIDX = 1:length(stages)
    for mouseIDX = 1:length(cohortData)
        % last session stage 1
        isStage1 = contains(cohortData(mouseIDX).session_names, 'P3.1');
        sesFlag_last_stage1 = find(isStage1, 1, 'last');

        isStage = contains(cohortData(mouseIDX).session_names, stages(stageIDX));
        sesFlag_first = find(isStage, 1, 'first');
        sesFlag_last = find(isStage, 1, 'last');

        if strcmp(stages{stageIDX}, 'P3.2')
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));
            if trialFlag == 0
                continue
            else
                dvalues = cohortData(mouseIDX).dvalues_trials;
                dvalues(trialFlag+1:end) = [];
                dvalues(1:200) = [];
            end
        else
            dvalues = cohortData(mouseIDX).dvalues_trials;
            % this part removes all dvalues from stage 2 to the analysed stage
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_last_stage1+1:sesFlag_first-1)));
            dvalues(1:trialFlag) = [];
            % removing the dvalues after the analysed stage and the first 200 (because of 200 trial binning window)
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));
            if trialFlag == 0
                continue
            else
                dvalues(trialFlag:end) = [];
                dvalues(1:200) = [];
            end
        end

        %xvalues = (201:length(dvalues)+200)';
        %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on

        alldvalues(1:length(dvalues),mouseIDX) = dvalues;
        clear dvalues
    end
    
    color_map = [[0.2 0.2 0.2]; [0.8 0.8 0.8]];
    trials_dprime_mean = mean(alldvalues,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
    trials_dprime_std = std(alldvalues,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
    curve1 = trials_dprime_mean + trials_dprime_std;
    curve2 = trials_dprime_mean - trials_dprime_std;
    % plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
    % plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
    fill([(1:length(curve1))+200 fliplr((1:length(curve1))+200)], [curve1' fliplr(curve2')],[0 0 .85],...
        'FaceColor',color_map(stageIDX,:), 'EdgeColor','none','FaceAlpha',0.5); hold on
    plot((1:length(trials_dprime_mean))+200,trials_dprime_mean, 'Color', 'k', 'LineWidth', 2)

    alldvalues = NaN(max_dvalue,sum(numMice));
end

xlabel('Trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
%yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Population performance over trials')

% for cohort 11 & 12
%plot([471,471],[-1,1.65],'Color','r')
%plot([1103,1103],[-1,1.65],'Color','r')

%% Population sessio d'prime
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
        isStage = contains(cohortData(mouseIDX).session_names, stages(stageIDX));
        sesFlag_first = find(isStage, 1, 'first');
        sesFlag_last = find(isStage, 1, 'last');

        dvalues = cohortData(mouseIDX).dvalues_sessions(sesFlag_first:sesFlag_last);
        alldvalues(1:length(dvalues),mouseIDX) = dvalues;
        clear dvalues
    end

    color_map = [[0.1294 0.4 0.6745]; [0.9373 0.5412 0.3843]];
    session_dprime_mean = mean(alldvalues,2,'omitnan'); session_dprime_mean(isnan(session_dprime_mean)) =[];
    session_dprime_std = std(alldvalues,0,2,'omitnan'); session_dprime_std(isnan(session_dprime_std)) =[];
    curve1 = session_dprime_mean + session_dprime_std;
    curve2 = session_dprime_mean - session_dprime_std;

    speed = find(session_dprime_mean>1.65,1);

    fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],...
        'FaceColor',color_map(stageIDX,:), 'EdgeColor','none','FaceAlpha',0.5); hold on
    plot((1:length(session_dprime_mean)),session_dprime_mean, 'Color', color_map(stageIDX,:), 'LineWidth', 2)
    plot([speed speed], [-3 1.65], 'Color', 'r',  'LineWidth', 1.5)

    alldvalues = NaN(max_dvalue,sum(numMice));
end

xlabel('Sessions')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
%yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Population performance over sessions')
%xlim([1 54])

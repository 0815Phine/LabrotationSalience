%% Success Rates
% only works if animalData.m is loaded
currentFolder = pwd;
load(fullfile(currentFolder,'/RawData/animalData'))

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
close all; fig_initial = figure; fig_reversed = figure; fig_overall = figure;
fig_ini_n = figure; fig_rev_n = figure; fig_ove_n = figure;
numMice = arrayfun(@(x) length(animalData.cohort(x).animal), cohorts);
max_sessions = max(arrayfun(@(m) length(cohortData(m).gogo_suc), 1:sum(numMice)));
color_map = [[0 1 0]; [1 0 0]];
stage_color_map = [[0.1294 0.4 0.6745]; [0.9373 0.5412 0.3843]];

% Create cell arrays to store axes for interpolation later
axis_go = cell(1, sum(numMice));
axis_nogo = cell(1, sum(numMice));
axis_overall = cell(1, sum(numMice));

allgo_suc = NaN(max_sessions,sum(numMice));
allnogo_suc = NaN(max_sessions,sum(numMice));
alloverall_suc = NaN(max_sessions,sum(numMice));
for stageIDX = 1:length(stages)
    for mouseIDX = 1:length(cohortData)

        isStage = contains(cohortData(mouseIDX).session_names, stages(stageIDX));
        sesFlag_first = find(isStage, 1, 'first');
        sesFlag_last = find(isStage, 1, 'last');
        if isempty(sesFlag_first)
            continue
        end

        % success rate go
        go_suc = cohortData(mouseIDX).gogo_suc(sesFlag_first:sesFlag_last);
        allgo_suc(1:length(go_suc),mouseIDX) = go_suc;
        axis_go{mouseIDX} = linspace(0, 1, length(go_suc));
        clear go_suc

        % success rate nogo
        nogo_suc = cohortData(mouseIDX).nogo_suc(sesFlag_first:sesFlag_last);
        allnogo_suc(1:length(nogo_suc),mouseIDX) = nogo_suc;
        axis_nogo{mouseIDX} = linspace(0, 1, length(nogo_suc));
        clear nogo_suc

        % overall success
        overall_suc = cohortData(mouseIDX).overall_suc(sesFlag_first:sesFlag_last);
        alloverall_suc(1:length(overall_suc),mouseIDX) = overall_suc;
        axis_overall{mouseIDX} = linspace(0, 1, length(overall_suc));
        clear overall_suc
    end

    sucrate.go = allgo_suc;
    sucrate.nogo =  allnogo_suc;
    sucrate.overall =  alloverall_suc;
    xfield = fieldnames(sucrate);
    for fieldIDX = 1:length(xfield)
        sucrate_mean = mean(sucrate.(xfield{fieldIDX}),2,'omitnan');  sucrate_mean(isnan(sucrate_mean)) =[];
        sucrate_std = std(sucrate.(xfield{fieldIDX}),0,2,'omitnan'); sucrate_std(isnan(sucrate_std)) =[];
        curve1 = sucrate_mean + sucrate_std;
        curve2 = sucrate_mean - sucrate_std;

        % select correct figure
        if strcmp(xfield{fieldIDX}, 'overall')
            plot_patch(alloverall_suc, axis_overall, stage_color_map(stageIDX,:), 30, fig_ove_n);
            figure(fieldIDX)
        elseif strcmp(stages{stageIDX}, 'P3.2')
            if strcmp(xfield{fieldIDX}, 'go')
                plot_patch(allgo_suc, axis_go, color_map(fieldIDX,:), 30, fig_ini_n);
            elseif strcmp(xfield{fieldIDX}, 'nogo')
                plot_patch(allnogo_suc, axis_nogo, color_map(fieldIDX,:), 30, fig_ini_n);
            end
            figure(stageIDX)
        elseif strcmp(stages{stageIDX}, 'P3.4')
            if strcmp(xfield{fieldIDX}, 'go')
                plot_patch(allgo_suc, axis_go, color_map(fieldIDX,:), 100, fig_rev_n);
            elseif strcmp(xfield{fieldIDX}, 'nogo')
                plot_patch(allnogo_suc, axis_nogo, color_map(fieldIDX,:), 100, fig_rev_n);
            end
            figure(stageIDX)
        else
            continue
        end

        if strcmp(xfield{fieldIDX}, 'overall')
            fill([(1:length(curve1)) fliplr((1:length(curve1)))], [curve1' fliplr(curve2')],[0 0 .85],...
                'FaceColor',stage_color_map(stageIDX,:), 'EdgeColor','none','FaceAlpha',0.5); hold on
            plot((1:length(sucrate_mean)),sucrate_mean, 'Color', stage_color_map(stageIDX,:), 'LineWidth', 2)

            xlabel('Sessions'); ylabel('Success rate')
            title ('Population success rate')
            legend('','Initial rule','','Reversed rule','Location','southeast','Box','off')
        else
            fill([(1:length(curve1)) fliplr((1:length(curve1)))], [curve1' fliplr(curve2')],[0 0 .85],...
                'FaceColor',color_map(fieldIDX,:), 'EdgeColor','none','FaceAlpha',0.5); hold on
            plot((1:length(sucrate_mean)),sucrate_mean, 'Color', color_map(fieldIDX,:), 'LineWidth', 2)

            xlabel('Sessions'); ylabel('Success rate')
            title (sprintf('Population success rates, %s', stages{stageIDX}))
            legend('','Go trials','','NoGo trials','Location','southeast','Box','off')
            %ylim([0 1])
        end
    end

    allgo_suc = NaN(max_sessions,sum(numMice));
    allnogo_suc = NaN(max_sessions,sum(numMice));
    alloverall_suc = NaN(max_sessions,sum(numMice));
end

%% Population performance on common axis
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

%%
fig_trials = figure; fig_sessions = figure;
color_map = [[0.1294 0.4 0.6745]; [0.9373 0.5412 0.3843]];
numMice = length(cohortData);

for stageIDX = 1:length(stages)
    SesFlag = arrayfun(@(m) contains(cohortData(m).session_names,stages(stageIDX)), 1:numMice, 'UniformOutput', false);

    all_dt = NaN(100,numMice); %maximum number of bins set high to ensure no 0 values will be included accidently
    all_ds = NaN(100,numMice); %maximum number of sessions set high to ensure no 0 values will be included accidently
    % cell arrays to store axis per mouse
    axis_trials = cell(1, numMice);
    axis_sessions = cell(1, numMice);
    for mouseIDX = 1:length(cohortData)
        sesFlag_first = find(SesFlag{mouseIDX}, 1, 'first');
        if isempty(sesFlag_first)
            continue
        end

        % dprime over sessions
        ds = cohortData(mouseIDX).dvalues_sessions(SesFlag{mouseIDX});
        all_ds(1:length(ds),mouseIDX) = ds;
        axis_sessions{mouseIDX} = linspace(0, 1, length(ds));
        clear ds

        %load lick events for relevent sessions
        LickEvents = cohortData(mouseIDX).Lick_Events(SesFlag{mouseIDX});
        LickEvents = vertcat(LickEvents{:});

        %divide Events into bins (fixed windows)
        bin_size = 100;
        num_bins = floor(length(LickEvents) / bin_size); %num_bins = ceil(length(LickEvents)/bin_size); 
        for binIDX = 1:num_bins
            start_trial = (binIDX-1)*bin_size + 1;
            end_trial = min(binIDX*bin_size, length(LickEvents));
            binned_data = LickEvents(start_trial:end_trial);

            % calculate go and no-go succes rate for binend data
            go_suc = sum(strncmpi(binned_data,"Go Success",8));
            go_fail = sum(strncmpi(binned_data,"Go Failure",8));
            nogo_suc = sum(strncmpi(binned_data,"No-Go Success",8));
            nogo_fail = sum(strncmpi(binned_data,"No-Go Failure",8));
            go_suc_rate = go_suc/(go_suc+go_fail);
            nogo_suc_rate = nogo_suc/(nogo_suc+nogo_fail);

            % calculate dprime
            [db, ~] = dprime(go_suc_rate, 1-nogo_suc_rate,...
                go_suc+go_fail, nogo_suc+nogo_fail);
            binned_dprime(binIDX) = db;
            clear db
        end
        % plot((1:length(binned_dprime))*bin_size,binned_dprime, 'Color', color_map(stageIDX,:)), hold on
        all_dt(1:length(binned_dprime),mouseIDX) = binned_dprime';
        axis_trials{mouseIDX} = linspace(0, 1, num_bins);  %Rescaled trial axis (normalized to 0-1)
        clear binned_dprime
    end
    
    plot_patch(all_dt, axis_trials,color_map(stageIDX,:),100, fig_trials);
    plot_patch(all_ds, axis_sessions,color_map(stageIDX,:),20, fig_sessions);

    % calculate mean and std
    % dprime_mean = mean(all_dt,2,'omitnan'); dprime_mean(isnan(dprime_mean)) =[];
    % dprime_std = std(all_dt,0,2,'omitnan'); dprime_std(isnan(dprime_std)) =[];
    % curve1 = dprime_mean + dprime_std;
    % curve2 = dprime_mean - dprime_std;
    % 
    % % plot data
    % fill([(1:length(curve1))*bin_size fliplr((1:length(curve1))*bin_size)], [curve1' fliplr(curve2')],[0 0 .85],...
    %     'FaceColor',color_map(stageIDX,:), 'EdgeColor','none','FaceAlpha',0.5), hold on
    % plot((1:length(dprime_mean))*bin_size,dprime_mean, 'Color', color_map(stageIDX,:), 'LineWidth', 2)
end

figure(fig_sessions)
title('Population performance over sessions')
xlabel('Session progression'), ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
legend('Initial rule','','Reversed rule','Location','southeast','Box','off')

figure(fig_trials)
title('Population performance over binned trials')
xlabel('Trial progression'), ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
legend('Initial rule','','Reversed rule','Location','southeast','Box','off')

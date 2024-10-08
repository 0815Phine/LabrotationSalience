%% Population trial d'prime fixed window
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
figure, color_map = [[0.1294 0.4 0.6745]; [0.9373 0.5412 0.3843]];
numMice = length(cohortData);

all_dprime = NaN(10,numMice);
for stageIDX = 1:length(stages)
    SesFlag = arrayfun(@(m) contains(cohortData(m).session_names,stages(stageIDX)), 1:numMice, 'UniformOutput', false);
    for mouseIDX = 1:length(cohortData)
        sesFlag_first = find(SesFlag{mouseIDX}, 1, 'first');
        if isempty(sesFlag_first)
            continue
        end

        %load lick events for relevent sessions
        LickEvents = cohortData(mouseIDX).Lick_Events(SesFlag{mouseIDX});
        LickEvents = vertcat(LickEvents{:});

        %divide Events into bins
        bin_size = 100;
        num_bins = ceil(length(LickEvents)/bin_size);
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
        plot((1:length(binned_dprime))*bin_size,binned_dprime, 'Color', color_map(stageIDX,:)), hold on
        all_dprime(1:length(binned_dprime),mouseIDX) = binned_dprime';
        clear binned_dprime
    end

    % calculate mean and std
    dprime_mean = mean(all_dprime,2,'omitnan'); dprime_mean(isnan(dprime_mean)) =[];
    dprime_std = std(all_dprime,0,2,'omitnan'); dprime_std(isnan(dprime_std)) =[];
    curve1 = dprime_mean + dprime_std;
    curve2 = dprime_mean - dprime_std;

    % plot data
    fill([(1:length(curve1))*bin_size fliplr((1:length(curve1))*bin_size)], [curve1' fliplr(curve2')],[0 0 .85],...
        'FaceColor',color_map(stageIDX,:), 'EdgeColor','none','FaceAlpha',0.5)
    plot((1:length(dprime_mean))*bin_size,dprime_mean, 'Color', color_map(stageIDX,:), 'LineWidth', 2)

    all_dprime = NaN(20,numMice);
end

title('Population performance over binned trials')
xlabel('Trials'), ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
legend('','Initial rule','','Reversed rule','Location','southeast','Box','off')

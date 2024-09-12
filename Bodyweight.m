%% choose cohorts
cohorts = arrayfun(@(x) num2str(x), 1:numel(animalData.cohort), 'UniformOutput', false);
answer = listdlg('ListString',cohorts,'PromptString','Choose your cohort.');
cohorts = cellfun(@str2double, cohorts(answer));
cohortData = horzcat(animalData.cohort(cohorts).animal);

%% get bodyweight

for mouseIDX = 1:length(cohortData)
    BW(mouseIDX) = (cohortData(mouseIDX).bodyweight(1,1)/cohortData(mouseIDX).bodyweight(1,2))*100;
end

%% calculate mean and std

meanBW = mean(BW);
stdBW = std(BW);
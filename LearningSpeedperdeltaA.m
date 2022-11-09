clearvars

startPath = 'Z:\Filippo\Animals';
try
    load(fullfile(startPath,'animalData.mat'))
catch
    fprintf(2,'\nThe variable "animalData.mat" doesn''t exist.')
    fprintf(2,'\nYou have to create it first.\n\n')
    return
end

% load Cohort Data
cohort_Data11 = animalData.cohort(11).animal;
cohort_Data15 = animalData.cohort(15).animal;
cohort_Data16 = animalData.cohort(16).animal;


%% Cohort11
% get dprime values for only Stage2
first_stage2 = nan(numel(cohort_Data11),1);
last_stage2 = nan(numel(cohort_Data11),1);
start_trial = zeros(numel(cohort_Data11),1);
end_trial = nan(numel(cohort_Data11),1);
for i = 1:numel(cohort_Data11)
    first_stage2(i) = find(contains(cohort_Data11(i).session_names,'P3.2'),1);
    last_stage2(i) = find(contains(cohort_Data11(i).session_names,'P3.2'),1,'last');
    cohort_Data11(i).Lick_Events_stage2 = cohort_Data11(i).Lick_Events(first_stage2(i):last_stage2(i));
    end_trial(i) = numel(vertcat(cohort_Data11(i).Lick_Events_stage2{1:last_stage2(i)-first_stage2(i)+1}));
    cohort_Data11(i).dvalues_sta2 = cohort_Data11(i).dvalues_trials(start_trial(i)+1:end_trial(i));
end

% adjust array size
longest = max(cellfun('size',{cohort_Data11.dvalues_sta2},1));
for i = 1:numel(cohort_Data11)
    cohort_Data11(i).dvalues_sta2 = [cohort_Data11(i).dvalues_sta2;...
        nan(longest-numel(cohort_Data11(i).dvalues_sta2),1)];
end

% mean dprime over trial
dprimetrials_mean = mean((horzcat(cohort_Data11.dvalues_sta2)),2,'omitnan');

% get Learning Speed
y2 = dprimetrials_mean(~isnan(dprimetrials_mean));
yval = y2(200:end);
offset = min(yval);
xval = 1:1:numel(yval);
xval = xval+200;
[params]=sigm_fit(xval', yval',[],[],0);
Qpre_fit = params(1) + (params(2) - params(1))./ (1 + 10.^((params(3) - xval) * params(4)));
Qpre_fit = Qpre_fit + offset;
Speed11 = find(Qpre_fit>1.65,1)+200;


%% Cohort 15

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
cohort_Data17 = animalData.cohort(17).animal;


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

% Learning Speed for each Animal + STD & Mean 
for i = 1:numel(cohort_Data11)
    yval_rev = cohort_Data11(i).dvalues_sta2(~isnan(cohort_Data11(i).dvalues_sta2));
    yval_rev = yval_rev(200:end);
    offset = min(yval_rev);
    yval = yval_rev - offset;
    xval = 1:1:numel(yval);
    xval = xval+200;
    [params]=sigm_fit(xval', yval',[],[],0);
    Qpre_fit = params(1) + (params(2) - params(1))./ (1 + 10.^((params(3) - xval) * params(4)));
    Qpre_fit = Qpre_fit + offset;
    cohort_Data11(i).LearningSpeed = find(Qpre_fit>1.65,1)+200;
end


%% Cohort 17
% get dprime values for only Stage2
first_stage2 = nan(numel(cohort_Data17),1);
last_stage2 = nan(numel(cohort_Data17),1);
start_trial = zeros(numel(cohort_Data17),1);
end_trial = nan(numel(cohort_Data17),1);
for i = 1:numel(cohort_Data17)
    first_stage2(i) = find(contains(cohort_Data17(i).session_names,'P3.2'),1);
    last_stage2(i) = find(contains(cohort_Data17(i).session_names,'P3.2'),1,'last');
    cohort_Data17(i).Lick_Events_stage2 = cohort_Data17(i).Lick_Events(first_stage2(i):last_stage2(i));
    end_trial(i) = numel(vertcat(cohort_Data17(i).Lick_Events_stage2{1:last_stage2(i)-first_stage2(i)+1}));
    cohort_Data17(i).dvalues_sta2 = cohort_Data17(i).dvalues_trials(start_trial(i)+1:end_trial(i));
end

% adjust array size
longest = max(cellfun('size',{cohort_Data17.dvalues_sta2},1));
for i = 1:numel(cohort_Data17)
    cohort_Data17(i).dvalues_sta2 = [cohort_Data17(i).dvalues_sta2;...
        nan(longest-numel(cohort_Data17(i).dvalues_sta2),1)];
end

% Learning Speed for each Animal + STD & Mean 
for i = 1:numel(cohort_Data17)
    yval_rev = cohort_Data17(i).dvalues_sta2(~isnan(cohort_Data17(i).dvalues_sta2));
    yval_rev = yval_rev(200:end);
    offset = min(yval_rev);
    yval = yval_rev - offset;
    xval = 1:1:numel(yval);
    xval = xval+200;
    [params]=sigm_fit(xval', yval',[],[],0);
    Qpre_fit = params(1) + (params(2) - params(1))./ (1 + 10.^((params(3) - xval) * params(4)));
    Qpre_fit = Qpre_fit + offset;
    cohort_Data17(i).LearningSpeed = find(Qpre_fit>1.65,1)+200;
end

Speed20 = horzcat(cohort_Data11.LearningSpeed, cohort_Data17.LearningSpeed);
Speed20_std = std(Speed20,0,2,'omitnan');
Speed20_mean = mean(Speed20,2,'omitnan');


%% Cohort 15
% get dprime values for only Stage2
first_stage2 = nan(numel(cohort_Data15),1);
last_stage2 = nan(numel(cohort_Data15),1);
start_trial = zeros(numel(cohort_Data15),1);
end_trial = nan(numel(cohort_Data15),1);
for i = 1:numel(cohort_Data15)
    first_stage2(i) = find(contains(cohort_Data15(i).session_names,'P3.2'),1);
    last_stage2(i) = find(contains(cohort_Data15(i).session_names,'P3.2'),1,'last');
    cohort_Data15(i).Lick_Events_stage2 = cohort_Data15(i).Lick_Events(first_stage2(i):last_stage2(i));
    end_trial(i) = numel(vertcat(cohort_Data15(i).Lick_Events_stage2{1:last_stage2(i)-first_stage2(i)+1}));
    cohort_Data15(i).dvalues_sta2 = cohort_Data15(i).dvalues_trials(start_trial(i)+1:end_trial(i));
end

% adjust array size
longest = max(cellfun('size',{cohort_Data15.dvalues_sta2},1));
for i = 1:numel(cohort_Data15)
    cohort_Data15(i).dvalues_sta2 = [cohort_Data15(i).dvalues_sta2;...
        nan(longest-numel(cohort_Data15(i).dvalues_sta2),1)];
end

% Learning Speed for each Animal + STD & Mean 
for i = 1:numel(cohort_Data15)
    yval_rev = cohort_Data15(i).dvalues_sta2(~isnan(cohort_Data15(i).dvalues_sta2));
    yval_rev = yval_rev(200:end);
    offset = min(yval_rev);
    yval = yval_rev - offset;
    xval = 1:1:numel(yval);
    xval = xval+200;
    [params]=sigm_fit(xval', yval',[],[],0);
    Qpre_fit = params(1) + (params(2) - params(1))./ (1 + 10.^((params(3) - xval) * params(4)));
    Qpre_fit = Qpre_fit + offset;
    cohort_Data15(i).LearningSpeed = find(Qpre_fit>1.65,1)+200;
end

Speed12 = horzcat(cohort_Data15.LearningSpeed);
Speed12_std = std(Speed12,0,2,'omitnan');
Speed12_mean = mean(Speed12,2,'omitnan');


%% Cohort 16
% get dprime values for only Stage2
first_stage2 = nan(numel(cohort_Data16),1);
last_stage2 = nan(numel(cohort_Data16),1);
start_trial = zeros(numel(cohort_Data16),1);
end_trial = nan(numel(cohort_Data16),1);
for i = 1:numel(cohort_Data16)
    first_stage2(i) = find(contains(cohort_Data16(i).session_names,'P3.2'),1);
    last_stage2(i) = find(contains(cohort_Data16(i).session_names,'P3.2'),1,'last');
    cohort_Data16(i).Lick_Events_stage2 = cohort_Data16(i).Lick_Events(first_stage2(i):last_stage2(i));
    end_trial(i) = numel(vertcat(cohort_Data16(i).Lick_Events_stage2{1:last_stage2(i)-first_stage2(i)+1}));
    cohort_Data16(i).dvalues_sta2 = cohort_Data16(i).dvalues_trials(start_trial(i)+1:end_trial(i));
end

% adjust array size
longest = max(cellfun('size',{cohort_Data16.dvalues_sta2},1));
for i = 1:numel(cohort_Data16)
    cohort_Data16(i).dvalues_sta2 = [cohort_Data16(i).dvalues_sta2;...
        nan(longest-numel(cohort_Data16(i).dvalues_sta2),1)];
end

% Learning Speed for each Animal 
for i = 1:numel(cohort_Data16)
    yval_rev = cohort_Data16(i).dvalues_sta2(~isnan(cohort_Data16(i).dvalues_sta2));
    yval_rev = yval_rev(200:end);
    offset = min(yval_rev);
    yval = yval_rev - offset;
    xval = 1:1:numel(yval);
    xval = xval+200;
    [params]=sigm_fit(xval', yval',[],[],0);
    Qpre_fit = params(1) + (params(2) - params(1))./ (1 + 10.^((params(3) - xval) * params(4)));
    Qpre_fit = Qpre_fit + offset;
    cohort_Data16(i).LearningSpeed = find(Qpre_fit>1.65,1)+200;
end

% STD & Mean for deltaA = 14
Speed14 = nan(1,3);
for i = 1:3
    Speed14_temp = cohort_Data16(i).LearningSpeed;
    Speed14(1,i) = Speed14_temp;
end
    
Speed14_std = std(Speed14,0,2,'omitnan');
Speed14_mean = mean(Speed14,2,'omitnan');

% STD & Mean for deltaA = 16
Speed16 = nan(1,3);
for i = 4:6
    Speed16_temp = cohort_Data16(i).LearningSpeed;
    Speed16(1,i-3) = Speed16_temp;
end
    
Speed16_std = std(Speed16,0,2,'omitnan');
Speed16_mean = mean(Speed16,2,'omitnan');


%% Plot Data
deltaA = [12,14,16,20];
Speed_mean = [Speed12_mean, Speed14_mean, Speed16_mean, Speed20_mean];
Speed_std = [Speed12_std, Speed14_std, Speed16_std, Speed20_std];
speed_all = [[12*ones(size(Speed12))';14*ones(size(Speed14))';16*ones(size(Speed16))';20*ones(size(Speed20))'],[Speed12';Speed14';Speed16';Speed20']];

figure; errorbar(deltaA,Speed_mean,Speed_std,'LineStyle','none','Marker','o')
hold on
plot(speed_all(:,1),speed_all(:,2),'LineStyle','none','Marker','.')
xlabel('deltaA [mm]')
ylabel('Learning Speed [Trials]')
title('Learning Speed per deltaA - initial Rules')
xlim([10 22])
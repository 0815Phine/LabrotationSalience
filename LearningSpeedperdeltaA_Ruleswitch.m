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
cohort_Data16 = animalData.cohort(16).animal;


%% Cohort11
Speed20 = horzcat(cohort_Data11.intersec_second);
Speed20_std = std(Speed20,0,2,'omitnan');
Speed20_mean = mean(Speed20,2,'omitnan');


%% Cohort 16
% STD & Mean for deltaA = 14
Speed14 = nan(1,2);
for i = 1:2
    Speed14_temp = cohort_Data16(i).intersec_second;
    Speed14(1,i) = Speed14_temp;
end
    
Speed14_std = std(Speed14,0,2,'omitnan');
Speed14_mean = mean(Speed14,2,'omitnan');

% STD & Mean for deltaA = 16
Speed16 = nan(1,3);
for i = 4:6
    Speed16_temp = cohort_Data16(i).intersec_second;
    Speed16(1,i-3) = Speed16_temp;
end
    
Speed16_std = std(Speed16,0,2,'omitnan');
Speed16_mean = mean(Speed16,2,'omitnan');


%% Plot Data
deltaA = [14,16,20];
Speed_mean = [Speed14_mean, Speed16_mean, Speed20_mean];
Speed_std = [Speed14_std, Speed16_std, Speed20_std];
speed_all = [[14*ones(size(Speed14))';16*ones(size(Speed16))';20*ones(size(Speed20))'],[Speed14';Speed16';Speed20']];

figure; errorbar(deltaA,Speed_mean,Speed_std,'LineStyle','none','Marker','o')
hold on
plot(speed_all(:,1),speed_all(:,2),'LineStyle','none','Marker','.')
xlabel('deltaA [mm]')
ylabel('Learning Speed [Trials]')
title('Learning Speed per deltaA - second Rules')
xlim([12 22])
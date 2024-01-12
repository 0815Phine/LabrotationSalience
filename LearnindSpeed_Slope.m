clearvars
close all

startPath = 'Z:\Filippo\Animals';
try
    load(fullfile(startPath,'animalData.mat'))
catch
    fprintf(2,'\nThe variable "animalData.mat" doesn''t exist.')
    fprintf(2,'\nYou have to create it first.\n\n')
    return
end

% load Cohort Data for 20mm contrast
cohort_Data11 = animalData.cohort(11).animal;
cohort_Data14 = animalData.cohort(14).animal;
cohort_Data17 = animalData.cohort(17).animal;

%% create slope variables
Slope20_ini = horzcat(cohort_Data11.slope_initial,cohort_Data14.slope_initial,cohort_Data17.slope_initial);
Slope20_sec = horzcat(cohort_Data11.slope_second);

%Slope20_ini_std = std(Slope20_ini,0,2,'omitnan');
Slope20_ini_mean = mean(Slope20_ini,2,'omitnan');

%Slope20_sec_std = std(Slope20_sec,0,2,'omitnan');
Slope20_sec_mean = mean(Slope20_sec,2,'omitnan');

[p0,~] = ranksum(Slope20_ini,Slope20_sec);

%% line plot
figure, hold on

xvalues = ones(1,length(Slope20_ini)); scatter(xvalues,Slope20_ini, 'k','filled')
xvalues = ones(1,length(Slope20_sec)); scatter(xvalues+1,Slope20_sec, 'k','filled'),

for i = 1:length(Slope20_sec)
    plot([1,2],[Slope20_ini(i),Slope20_sec(i)],'Color','k')
end

plot([1,2],[Slope20_ini_mean, Slope20_sec_mean],'LineWidth', 1.5)

slope_all = horzcat(Slope20_ini,Slope20_sec);
slope_max = max(slope_all);
plotStatistics(p0,slope_max,1,2)

title('learning speed per animal')
xticks([1,2]), xticklabels({'initial rule','switched rule'})
ylabel('Slope of logistic fit')
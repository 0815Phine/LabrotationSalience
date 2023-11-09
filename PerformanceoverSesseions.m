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

%% Population session d'prime initial rules (contrast: 20mm)
figure

alldvalues = NaN(47,19);
cohortFlag = [11, 14, 17];
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP2 = contains(cohortData(i).session_names,'P3.2');
        sesFlag_first = find(isP2, 1, 'first');
        sesFlag_last = find(isP2, 1, 'last');

        dvalues = cohortData(i).dvalues_sessions(sesFlag_first:sesFlag_last);
    
        if ii == 11
            alldvalues(1:length(dvalues),i) = dvalues;
        elseif ii == 14
            alldvalues(1:length(dvalues),i+6) = dvalues;
        elseif ii == 17
            alldvalues(1:length(dvalues),i+14) = dvalues;
        end
    end
end
alldvalues(:,17) = [];

session_dprime_mean = mean(alldvalues,2,'omitnan'); session_dprime_mean(isnan(session_dprime_mean)) =[];
session_dprime_std = std(alldvalues,0,2,'omitnan'); session_dprime_std(isnan(session_dprime_std)) =[];
curve1 = session_dprime_mean + session_dprime_std;
curve2 = session_dprime_mean - session_dprime_std;

speed = find(session_dprime_mean>1.65,1);

fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor','#a6a6a6', 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((1:length(session_dprime_mean)),session_dprime_mean, 'Color', 'k')
plot([speed speed], [-3 1.65], 'Color', 'k')

xlabel('Sessions')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
% title ('Population Performance over sessions (initial rules; contrast 20mm)')

%% switched rule
% figure

alldvalues = NaN(54,6);
cohortFlag = 11;

cohortData = animalData.cohort(cohortFlag).animal;
for i = 1:length(cohortData)
    isP4 = contains(cohortData(i).session_names,'P3.4');
    sesFlag_first = find(isP4, 1, 'first');
    sesFlag_last = find(isP4, 1, 'last');

    dvalues = cohortData(i).dvalues_sessions(sesFlag_first:sesFlag_last);
    alldvalues(1:length(dvalues),i) = dvalues;
end

session_dprime_mean = mean(alldvalues,2,'omitnan'); session_dprime_mean(isnan(session_dprime_mean)) =[];
session_dprime_std = std(alldvalues,0,2,'omitnan'); session_dprime_std(isnan(session_dprime_std)) =[];
curve1 = session_dprime_mean + session_dprime_std;
curve2 = session_dprime_mean - session_dprime_std;

speed =find(session_dprime_mean>1.65,1);

fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor','#e6e6e6', 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((1:length(session_dprime_mean)),session_dprime_mean, 'Color', [0.5 0.5 0.5])
plot([speed speed], [-3 1.65], 'Color', 'k')

% xlabel('Sessions')
% ylabel('d prime')
% yline([1.65, 1.65],'Color','black','LineStyle','--')
% yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Population Performance over sessions')

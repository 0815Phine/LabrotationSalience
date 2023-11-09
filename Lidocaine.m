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

%%

cohortFlag = [11,12];
sesFlag = 'P3.5';
miceFlag11 = 2;
alldvalues = NaN(8,4);

for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isLido = contains(cohortData(i).session_names,sesFlag);

        sesFlag_first = find(isLido, 1, 'first');
        sesFlag_last = find(isLido, 1, 'last');

        dvalues = cohortData(i).dvalues_sessions(sesFlag_first:sesFlag_last);

        if isempty (dvalues)
            continue
        elseif ii == 11 && miceFlag11 == i
            alldvalues(2:length(dvalues)+1,1) = dvalues;
        elseif ii == 12
            alldvalues(1:length(dvalues),i-1) = dvalues;
        else
            continue
        end
    end
end

% some statistics
dprimeBepa = vertcat(alldvalues(1,:),alldvalues(3,:),alldvalues(5,:),alldvalues(7,:));
dprimeBepa = vertcat(dprimeBepa(:,1),dprimeBepa(:,2),dprimeBepa(:,3),dprimeBepa(:,4));
dprimeLido = vertcat(alldvalues(2,:),alldvalues(4,:),alldvalues(6,:),alldvalues(8,:));
dprimeLido = vertcat(dprimeLido(:,1),dprimeLido(:,2),dprimeLido(:,3),dprimeLido(:,4));
[p,h] = ranksum(dprimeBepa,dprimeLido);

%% plot data
figure
xvalues = ones(length(dprimeBepa),1);

boxchart(xvalues, dprimeBepa, 'BoxFaceColor', 'k'), hold on
boxchart(xvalues+1, dprimeLido, 'BoxFaceColor', 'k')
scatter(xvalues, dprimeBepa,'Marker','.','Jitter','on','MarkerEdgeColor','k')
scatter(xvalues+1, dprimeLido,'Marker','.','Jitter','on','MarkerEdgeColor','k')

max_bepa = max(dprimeBepa);
plot([1 2],[max_bepa*1.05 max_bepa*1.05], 'k')
if p <= 0.05 && p > 0.01
    text(1.5, max_bepa*1.1,'*','HorizontalAlignment','center')
elseif p <= 0.01 && p > 0.001
    text(1.5, max_bepa*1.1,'**','HorizontalAlignment','center')
elseif p <= 0.001
    text(1.5, max_bepa*1.1,'***','HorizontalAlignment','center')
else
    text(1.5, max_bepa*1.1,'ns','HorizontalAlignment','center')
end

yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title('Performance with and without Lidocaine application')
xticks([1,2]), xticklabels({'Bepanthen','Lidocaine'})
ylabel('d prime')
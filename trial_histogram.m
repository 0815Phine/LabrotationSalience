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

%% trials per session initial rule
cohortFlag = [11, 14, 17];

alltrials = NaN (19,8);
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP2 = contains(cohortData(i).session_names,'P3.2');
        sesFlag_first = find(isP2, 1, 'first');
        sesFlag_last = find(isP2, 1, 'last');

        trialcountnaive = cellfun(@numel, animalData.cohort(ii).animal(i).Lick_Events(sesFlag_first:sesFlag_first+3));
        trialcountexp = cellfun(@numel, animalData.cohort(ii).animal(i).Lick_Events(sesFlag_last-3:sesFlag_last));
        
        if ii == 11
            alltrials(i,1:4) = trialcountnaive;
            alltrials(i,5:8) = trialcountexp;
        elseif ii == 14
            alltrials(i+6,1:4) = trialcountnaive;
            alltrials(i+6,5:8) = trialcountexp;
        elseif ii == 17
            alltrials(i+14,1:4) = trialcountnaive;
            alltrials(i+14,5:8) = trialcountexp;
        end
    end
end
alltrials(17,:) = [];

endflag = size(alltrials);
for i = 1:endflag(1)
    naivetrials_ini (i,1) = mean(alltrials(i,1:4));
    experttrials_ini (i,1) = mean(alltrials(i,5:8));
end
[p1,h1]=ranksum(naivetrials_ini,experttrials_ini);

ztrials = zscore(alltrials,0,2);

%% plot data
f1 = figure; trialbars = bar3(ztrials);

numBars = size(ztrials,1);
numSets = size(ztrials,2);
for i = 1:numSets
    zdata = ones(6*numBars,4);
    k = 1;
    for j = 0:6:(6*numBars-6)
      zdata(j+1:j+6,:) = ztrials(k,i);
      k = k+1;
    end
    set(trialbars(i),'Cdata',zdata)
end

colorbar
xlabel('Sessions'); xticks([]); xticklabels([])
ylabel('Animals'); yticks([]); yticklabels([])
title('Trialcount initial rule')

f3 = figure; edges = 0:10:150;
histogram(alltrials(:,1:4),edges); hold on
histogram(alltrials(:,5:8),edges)
title('Trial-Histogram initial rule')
xlabel('Trials')
legend('naive','expert'); legend('boxoff')

%% line plot
figure, hold on

for i = 1:length(experttrials_ini)
    plot([1,2],[naivetrials_ini(i),experttrials_ini(i)],'Color','k')
end

plot([1,2],[mean(naivetrials_ini),mean(experttrials_ini)],'LineWidth',1.5)

maxexpert = max(experttrials_ini);
plot([1 2],[maxexpert*1.05 maxexpert*1.05], 'k')
if p1 <= 0.05 && p1 > 0.01
    text(1.5, maxexpert*1.1,'*','HorizontalAlignment','center')
elseif p1 <= 0.01 && p1 > 0.001
    text(1.5, maxexpert*1.1,'**','HorizontalAlignment','center')
elseif p1 <= 0.001
    text(1.5, maxexpert*1.1,'***','HorizontalAlignment','center')
else
    text(1.5, maxexpert*1.1,'ns','HorizontalAlignment','center')
end

title('Trials per animal')
xticks([1 2]); xticklabels({'naive','expert'})
ylabel('Trials')

%% trials per session second rule
cohortFlag = 11;

alltrials = NaN (6,8);
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP4 = contains(cohortData(i).session_names,'P3.4');
        sesFlag_first = find(isP4, 1, 'first');
        sesFlag_last = find(isP4, 1, 'last');

        trialcountnaive = cellfun(@numel, animalData.cohort(ii).animal(i).Lick_Events(sesFlag_first:sesFlag_first+3));
        trialcountexp = cellfun(@numel, animalData.cohort(ii).animal(i).Lick_Events(sesFlag_last-3:sesFlag_last));
        
        alltrials(i,1:4) = trialcountnaive;
        alltrials(i,5:8) = trialcountexp;
       
    end
end

endflag = size(alltrials);
for i = 1:endflag(1)
    naivetrials_swi (i,1) = mean(alltrials(i,1:4));
    experttrials_swi (i,1) = mean(alltrials(i,5:8));
end
[p2,h2]=ranksum(naivetrials_swi,experttrials_swi);

ztrials = zscore(alltrials,0,2);

%% plot data
f2 = figure; trialbars = bar3(ztrials);

numBars = size(ztrials,1);
numSets = size(ztrials,2);
for i = 1:numSets
    zdata = ones(6*numBars,4);
    k = 1;
    for j = 0:6:(6*numBars-6)
      zdata(j+1:j+6,:) = ztrials(k,i);
      k = k+1;
    end
    set(trialbars(i),'Cdata',zdata)
end

colorbar
xlabel('Sessions'); xticks([]); xticklabels([])
ylabel('Animals'); yticks([]); yticklabels([])
title('Trialcount switched rule')

f4 = figure; histogram(alltrials(:,1:4),edges); hold on
histogram(alltrials(:,5:8),edges)
title('Trial-Histogram switched rule')
xlabel('Trials')
legend('naive','expert'); legend('boxoff')

%% line plot
figure, hold on

for i = 1:length(experttrials_swi)
    plot([1,2],[naivetrials_swi(i),experttrials_swi(i)],'Color','k')
end

plot([1,2],[mean(naivetrials_swi),mean(experttrials_swi)],'LineWidth',1.5)

maxexpert = max(experttrials_swi);
plot([1 2],[maxexpert*1.05 maxexpert*1.05], 'k')
if p2 <= 0.05 && p2 > 0.01
    text(1.5, maxexpert*1.1,'*','HorizontalAlignment','center')
elseif p2 <= 0.01 && p2 > 0.001
    text(1.5, maxexpert*1.1,'**','HorizontalAlignment','center')
elseif p2 <= 0.001
    text(1.5, maxexpert*1.1,'***','HorizontalAlignment','center')
else
    text(1.5, maxexpert*1.1,'ns','HorizontalAlignment','center')
end

title('Trials per animal')
xticks([1 2]); xticklabels({'naive','expert'})
ylabel('Trials')
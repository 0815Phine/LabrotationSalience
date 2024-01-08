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

%% initial rule
cohortFlag = [11, 14, 17];
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP2 = contains(cohortData(i).session_names,'P3.2');
        numSes = sum(isP2);
    
        if ii == 11
            SesCountini(i) = numSes;
        elseif ii == 14
            SesCountini(i+6) = numSes;
        elseif ii == 17
            SesCountini(i+14) = numSes;
        end
    end
end
SesCountini(17) = [];

%% second rule
cohortFlag = 11;
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP4 = contains(cohortData(i).session_names,'P3.4');
        numSes = sum(isP4);

        SesCountsec(i) = numSes;
    end
end

%% line plot
figure, hold on

xvalues = ones(1,length(SesCountini)); scatter(xvalues,SesCountini, 'k','filled')
xvalues = ones(1,length(SesCountsec)); scatter(xvalues+1,SesCountsec, 'k','filled'),

for i = 1:length(SesCountsec)
    plot([1,2],[SesCountini(i),SesCountsec(i)],'Color','k')
end

plot([1,2],[mean(SesCountini),mean(SesCountsec)],'LineWidth',1.5)

title('Number of sessions per animal')
xticks([1,2]), xticklabels({'initial rule','switched rule'})
ylabel('Number of sessions')
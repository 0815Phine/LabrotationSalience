% clearvars
% close all
% 
% startPath = 'Z:\Filippo\Animals';
% try
%     load(fullfile(startPath,'animalData.mat'))
% catch
%     fprintf(2,'\nThe variable "animalData.mat" doesn''t exist.')
%     fprintf(2,'\nYou have to create it first.\n\n')
%     return
% end

%% create dprime-array for sessions 
% ATTENTION: to run this script animalData.mat has do be loaded into the workspace
% -> last four conditioning, reversal and first four extinction
% -> animals per row and sessions per column

% add cohorts you want to analyze
cohorts = [12];
numCohorts = length(cohorts);
numMice = arrayfun(@(x) length(animalData.cohort(x).animal), cohorts);
numSes = 4;

% extinction phase is stage P3.6 for all animals in cohort 12
% P3.2 is the conditioning phase for all animals
% P3.4 is the reversal phase for all animals
alldprime = NaN (sum(numMice),numSes*3);
for cohortIdx = 1:numCohorts
    cohortData = animalData.cohort(cohorts(cohortIdx)).animal;
    mouseFlag = length(cohortData);

    for mouseIdx = 1:mouseFlag
        animalNum{mouseIdx} = cohortData(mouseIdx).animalName;

        isP6 = contains(cohortData(mouseIdx).session_names,'P3.6');
        isP2 = contains(cohortData(mouseIdx).session_names,'P3.2');
        isP4 = contains(cohortData(mouseIdx).session_names,'P3.4');

        if isempty(find(isP6, 1, 'first'))
            continue
        else
            sesFlag_first = find(isP6, 1, 'first');
            sesFlag_last(mouseIdx) = find(isP6, 1, 'last');
            sesFlag_last_rev = find(isP4, 1, 'last');
            sesFlag_last_cond = find(isP2, 1, 'last');
        end

        dprime_cond = cohortData(mouseIdx).dvalues_sessions(sesFlag_last_cond-numSes+1:sesFlag_last_cond);
        dprime_before = cohortData(mouseIdx).dvalues_sessions(sesFlag_last_rev-numSes+1:sesFlag_last_rev);
        dprime_after = cohortData(mouseIdx).dvalues_sessions(sesFlag_first:sesFlag_first+numSes-1);
        
        if isempty(dprime_after)
            continue
        else
            rowIdx = sum(numMice(1:cohortIdx-1)) + mouseIdx;
            alldprime(rowIdx, 1:numSes) = dprime_cond;
            alldprime(rowIdx, numSes+1:numSes*2) = dprime_before;
            alldprime(rowIdx, numSes*2+1:numSes*3) = dprime_after;
        end
    end
end

% remove NaNs that result from animals not going through the extinction stage
animalNum(find(isnan(alldprime(:,1)))) = [];
alldprime(isnan(alldprime(:,1)),:) = [];

%% prepare array for plotting
mouseFlag = 1:height(alldprime);
dprime_cond =  cell2mat(arrayfun(@(a) vertcat(alldprime(a,1:numSes)), mouseFlag, 'UniformOutput', false));
dprime_before =  cell2mat(arrayfun(@(a) vertcat(alldprime(a,numSes+1:numSes*2)), mouseFlag, 'UniformOutput', false));
dprime_after =  cell2mat(arrayfun(@(a) vertcat(alldprime(a,numSes*2+1:numSes*3)), mouseFlag, 'UniformOutput', false));

%% Repeated measures ANOVA
Intervention = ["ini","rev","ext"];
InterventionAno = horzcat(Intervention, Intervention, Intervention, Intervention, Intervention)';

animalNumAno = vertcat(animalNum,animalNum,animalNum);
animalNumAno = vertcat(animalNumAno(:,1),animalNumAno(:,2),animalNumAno(:,3),animalNumAno(:,4),animalNumAno(:,5));

dprime_table = table(animalNumAno, InterventionAno,...
    horzcat(alldprime(1,[1 5 9]),alldprime(2,[1 5 9]),alldprime(3,[1 5 9]),alldprime(4,[1 5 9]),alldprime(5,[1 5 9]))',...
    horzcat(alldprime(1,[2 6 10]),alldprime(2,[2 6 10]),alldprime(3,[2 6 10]),alldprime(4,[2 6 10]),alldprime(5,[2 6 10]))',...
    horzcat(alldprime(1,[3 7 11]),alldprime(2,[3 7 11]),alldprime(3,[3 7 11]),alldprime(4,[3 7 11]),alldprime(5,[3 7 11]))',...
    horzcat(alldprime(1,[4 8 12]),alldprime(2,[4 8 12]),alldprime(3,[4 8 12]),alldprime(4,[4 8 12]),alldprime(5,[4 8 12]))',...
    VariableNames = ["animal","Intervention","t1","t2","t3","t4"]);

rm = fitrm(dprime_table,"t1-t4~animal+Intervention");
ranova(rm)

%%
f1 = figure; hold on;
boxchart(ones(1,length(dprime_cond)), dprime_cond, 'BoxFaceColor', 'k')
scatter(ones(1,length(dprime_cond)), dprime_cond,'Marker','.','Jitter','on','MarkerEdgeColor','k')
boxchart(ones(1,length(dprime_before))+1, dprime_before, 'BoxFaceColor', 'k')
scatter(ones(1,length(dprime_before))+1, dprime_before,'Marker','.','Jitter','on','MarkerEdgeColor','k')
boxchart(ones(1,length(dprime_after))+2, dprime_after, 'BoxFaceColor', 'k', 'MarkerStyle', 'none')
scatter(ones(1,length(dprime_after))+2, dprime_after,'Marker','.','Jitter','on','MarkerEdgeColor','k')

yline([1.65, 1.65],'Color','black','LineStyle','--')
xticks([1 2 3]); xticklabels({'Conditioning','Reversal', 'Extinction'})
ylabel('d prime')
title('Population performance before and after extinction')

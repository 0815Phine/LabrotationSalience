%% Population trial d'prime CNO Cohort
% FOR THE FOLLOWING SECTIONS THERE IS STILL THE ERROR FOR THE SWITCHED RULE
% (REMOVING TOO MANY DVALUES FROM THE START)
fig_1 = figure;

alldvaluesCNO = NaN(969,8);
cohortFlag = [18, 19];
mice = string({'#70','#72','#74','#76','#79','#80','#83'});
for cohortNum = cohortFlag
    cohortData = animalData.cohort(cohortNum).animal;
    for mouseIDX = 1:length(cohortData)
        mouseflag = string(cohortData(mouseIDX).animalName) == mice;
        if sum(mouseflag) == 1
            isP2 = contains(cohortData(mouseIDX).session_names,'P3.2');
            sesFlag_first = find(isP2, 1, 'first');
            sesFlag_last = find(isP2, 1, 'last');
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));

            dvalues = cohortData(mouseIDX).dvalues_trials;
            dvalues(trialFlag+1:end) = [];
            dvalues(1:200) = [];

            %xvalues = (201:length(dvalues)+200)';
            %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
            
            if cohortNum == 18
                alldvaluesCNO(1:length(dvalues),mouseIDX) = dvalues;
            elseif mouseIDX == 2
                alldvaluesCNO(1:length(dvalues),mouseIDX-1) = dvalues;
            elseif mouseIDX == 6
                alldvaluesCNO(1:length(dvalues),mouseIDX-1) = dvalues;
            else
                alldvaluesCNO(1:length(dvalues),mouseIDX) = dvalues;
            end
        continue
        end
    end
end

trials_dprime_mean = mean(alldvaluesCNO,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvaluesCNO,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor',[1 0.8 0.8],'EdgeColor','none','FaceAlpha',0.5); hold on
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d')
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', [1 0.32 0.30])

% get d_values for Saline animals
alldvaluesSaline = NaN(1124,6);
mice = string({'#69','#71','#73','#75','#78','#82'});
for cohortNum = cohortFlag
    cohortData = animalData.cohort(cohortNum).animal;
    for mouseIDX = 1:length(cohortData)
        mouseflag = string(cohortData(mouseIDX).animalName) == mice;
        if sum(mouseflag) == 1
            isP2 = contains(cohortData(mouseIDX).session_names,'P3.2');
            sesFlag_first = find(isP2, 1, 'first');
            sesFlag_last = find(isP2, 1, 'last');
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));

            dvalues = cohortData(mouseIDX).dvalues_trials;
            dvalues(trialFlag+1:end) = [];
            dvalues(1:200) = [];

            %xvalues = (201:length(dvalues)+200)';
            %plot(xvalues, dvalues, 'Color', '#bfbfbf'), hold on
            
            if mouseIDX == 7
                alldvaluesSaline(1:length(dvalues),mouseIDX-1) = dvalues;
            elseif cohortNum == 18
                alldvaluesSaline(1:length(dvalues),mouseIDX) = dvalues;
            elseif mouseIDX == 1
                alldvaluesSaline(1:length(dvalues),mouseIDX+1) = dvalues;
            elseif mouseIDX == 5
                alldvaluesSaline(1:length(dvalues),mouseIDX-1) = dvalues;
            end
        continue
        end
    end
end

trials_dprime_mean = mean(alldvaluesSaline,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvaluesSaline,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor',[0.8 0.92 1],'EdgeColor','none','FaceAlpha',0.5)
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d')
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d');
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color', [0 0.45 0.74])

xlabel('Trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Initial rules')
plot([560.5 560.5], [-0.5 1.65], 'Color', [0 0.45 0.74], 'LineStyle', ':','LineWidth',1)
plot([559 559], [-0.5 1.65], 'Color', [1 0.32 0.30], 'LineStyle', ':','LineWidth',1)

% statistics on d'primes
endflag = size(alldvaluesCNO);
endflag = endflag(1);
[p0, h0] = ranksum(reshape(alldvaluesCNO(endflag-200:endflag,:),[],1), reshape(alldvaluesSaline(endflag-200:endflag,:), [], 1));
% plot([endflag endflag], [2.25 4.25], 'Color', [.7 .7 .7]); plot([endflag+200 endflag+200], [2.25 4.25], 'Color', [.7 .7 .7])

plotStatistics(p0,4.2,endflag,endflag+200)
legend('','CNO','','Saline'); legend('boxoff'); legend('location','best')

fig_2 = figure; hold on
boxchart(ones(numel(alldvaluesCNO(endflag-200:endflag,:)),1), reshape(alldvaluesCNO(endflag-200:endflag,:),[],1),...
    'BoxFaceColor', [1 0.32 0.30],'Notch', 'on')
hold on; boxchart(1+ones(numel(alldvaluesSaline(endflag-200:endflag,:)),1), reshape(alldvaluesSaline(endflag-200:endflag,:), [], 1),...
    'BoxFaceColor', [0 0.45 0.74], 'Notch', 'on')
scatter(ones(numel(alldvaluesCNO(endflag-200:endflag,:)),1), reshape(alldvaluesCNO(endflag-200:endflag,:),[],1),...
    'MarkerEdgeColor', [1 0.32 0.30], 'Marker', '.', 'XJitter', 'randn', 'MarkerEdgeAlpha', 0.4)
scatter(1+ones(numel(alldvaluesSaline(endflag-200:endflag,:)),1), reshape(alldvaluesSaline(endflag-200:endflag,:),[],1),...
    'MarkerEdgeColor', [0 0.45 0.74], 'Marker', '.', 'XJitter', 'randn', 'MarkerEdgeAlpha', 0.4)
plotStatistics(p0,4.2,1,2)
title('Population performance in expert animals (initial rule)')
xticks([1 2]), xticklabels({'CNO' 'Saline'}), ylabel('d prime')

% second rules
fig_3 = figure;
alldvaluesCNO = NaN(1532,8);
mice = string({'#70','#72','#74','#76','#79','#80','#83'});
for cohortNum = cohortFlag
    cohortData = animalData.cohort(cohortNum).animal;
    for mouseIDX = 1:length(cohortData)
        mouseflag = string(cohortData(mouseIDX).animalName) == mice;
        if sum(mouseflag) == 1
            isP3 = contains(cohortData(mouseIDX).session_names,'P3.3');
            sesFlag_first = find(isP3, 1, 'first');
            sesFlag_last = find(isP3, 1, 'last');

            dvalues = cohortData(mouseIDX).dvalues_trials;
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(1:sesFlag_first-1)));
            dvalues(1:trialFlag) = [];
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));
            if trialFlag == 0
                continue
            else
                dvalues(trialFlag-199:end) = [];
                dvalues(1:200) = [];
            end

            if mouseIDX == 7
                alldvaluesCNO(1:length(dvalues),mouseIDX-1) = dvalues;
            elseif cohortNum == 18
                alldvaluesCNO(1:length(dvalues),mouseIDX) = dvalues;
            elseif mouseIDX == 1
                alldvaluesCNO(1:length(dvalues),mouseIDX+1) = dvalues;
            elseif mouseIDX == 5
                alldvaluesCNO(1:length(dvalues),mouseIDX-1) = dvalues;
            end
        continue
        end
    end
end

trials_dprime_mean = mean(alldvaluesCNO,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvaluesCNO,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor',[1 0.8 0.8], 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color',  [1 0.32 0.30])

% Saline animals
alldvaluesSaline = NaN(2164,6);
mice = string({'#69','#71','#73','#75','#78','#82'});
for cohortNum = cohortFlag
    cohortData = animalData.cohort(cohortNum).animal;
    for mouseIDX = 1:length(cohortData)
        mouseflag = string(cohortData(mouseIDX).animalName) == mice;
        if sum(mouseflag) == 1
            isP3 = contains(cohortData(mouseIDX).session_names,'P3.4');
            sesFlag_first = find(isP3, 1, 'first');
            sesFlag_last = find(isP3, 1, 'last');

            dvalues = cohortData(mouseIDX).dvalues_trials;
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(1:sesFlag_first-1)));
            dvalues(1:trialFlag) = [];
            trialFlag = sum(cellfun(@numel, cohortData(mouseIDX).Lick_Events(sesFlag_first:sesFlag_last)));
            if trialFlag == 0
                continue
            else
                dvalues(trialFlag-199:end) = [];
                dvalues(1:200) = [];
            end

            if mouseIDX == 7
                alldvaluesSaline(1:length(dvalues),mouseIDX-1) = dvalues;
            elseif cohortNum == 18
                alldvaluesSaline(1:length(dvalues),mouseIDX) = dvalues;
            elseif mouseIDX == 1
                alldvaluesSaline(1:length(dvalues),mouseIDX+1) = dvalues;
            elseif mouseIDX == 5
                alldvaluesSaline(1:length(dvalues),mouseIDX-1) = dvalues;
            end
        continue
        end
    end
end

trials_dprime_mean = mean(alldvaluesSaline,2,'omitnan'); trials_dprime_mean(isnan(trials_dprime_mean)) =[];
trials_dprime_std = std(alldvaluesSaline,0,2,'omitnan'); trials_dprime_std(isnan(trials_dprime_std)) =[];
curve1 = trials_dprime_mean + trials_dprime_std;
curve2 = trials_dprime_mean - trials_dprime_std;
% plot(201:length(curve1)+200, curve1,'Color','#4d4d4d'); hold on
% plot(201:length(curve2)+200, curve2,'Color','#4d4d4d')
fill([201:length(curve1)+200 fliplr(201:length(curve1)+200)], [curve1' fliplr(curve2')],[0 0 .85],...
    'FaceColor',[0.8 0.92 1], 'EdgeColor','none','FaceAlpha',0.5); hold on
plot((201:length(trials_dprime_mean)+200),trials_dprime_mean, 'Color',  [0 0.45 0.74])

xlabel('Trials')
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
title ('Second rules')
plot([953 953], [-1.5 1.65], 'Color', [0 0.45 0.74], 'LineStyle', ':','LineWidth',1)
plot([1303 1303], [-1.5 1.65], 'Color', [1 0.32 0.30], 'LineStyle', ':','LineWidth',1)
xlim([200 2400]); ylim([-1.5 5])

% statistics on d'primes
endflag = size(alldvaluesCNO);
endflag = endflag(1);
[p1, h1] = ranksum(reshape(alldvaluesCNO(endflag-200:endflag,:),[],1), reshape(alldvaluesSaline(endflag-200:endflag,:), [], 1));
% plot([endflag endflag], [2.25 4.25], 'Color', [.7 .7 .7]); plot([endflag+200 endflag+200], [2.25 4.25], 'Color', [.7 .7 .7])

plotStatistics(p1,4.2,endflag,endflag+200)
plot([endflag endflag+200], [4.25 4.25], 'k');
crossflag = 953;
[p2, h2] = ranksum(reshape(alldvaluesCNO(crossflag-200:crossflag,:),[],1), reshape(alldvaluesSaline(crossflag-200:crossflag,:), [], 1));
plotStatistics(p2,4.2,crossflag-200,crossflag)
legend('','CNO','','Saline'); legend('boxoff'); legend('location','best')

fig_4 = figure; hold on
boxchart(ones(numel(alldvaluesCNO(endflag-200:endflag,:)),1), reshape(alldvaluesCNO(endflag-200:endflag,:),[],1),...
    'BoxFaceColor', [1 0.32 0.30],'Notch', 'on')
hold on; boxchart(1+ones(numel(alldvaluesSaline(endflag-200:endflag,:)),1), reshape(alldvaluesSaline(endflag-200:endflag,:), [], 1),...
    'BoxFaceColor', [0 0.45 0.74], 'Notch', 'on')
scatter(ones(numel(alldvaluesCNO(endflag-200:endflag,:)),1), reshape(alldvaluesCNO(endflag-200:endflag,:),[],1),...
    'MarkerEdgeColor', [1 0.32 0.30], 'Marker', '.', 'XJitter', 'randn', 'MarkerEdgeAlpha', 0.4)
scatter(1+ones(numel(alldvaluesSaline(endflag-200:endflag,:)),1), reshape(alldvaluesSaline(endflag-200:endflag,:),[],1),...
    'MarkerEdgeColor', [0 0.45 0.74], 'Marker', '.', 'XJitter', 'randn', 'MarkerEdgeAlpha', 0.4)
plotStatistics(p2,4.2,1,2)
title('Population performance in expert animals (switched rule)')
xticks([1 2]), xticklabels({'CNO' 'Saline'}), ylabel('d prime')

%% Save Figures
%saveFigure(fig_1,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Trial-dprime_CNO_saline_initial'),true,true)
%saveFigure(fig_2,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Peak_Performance_CNO_initial_rules'),true,true)
%saveFigure(fig_3,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Trial-dprime_CNO_saline_switched'),true,true)
%saveFigure(fig_4,fullfile('Z:\Josephine\Master-Thesis_Figures\Performance','Peak_Performance_CNO_switched_rules'),true,true)
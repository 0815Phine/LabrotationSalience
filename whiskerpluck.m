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

%% create whiskerpluck table
animalSelection = [11 14 16 17];
[dvalues, sessNames] = findSessions(animalData,animalSelection);

whiskerpluck_table = [nan(120,4)];
whiskerpluck_table(:,2) = repmat(setdiff((-3:3)',0),20,1);

% Cohort 11 + 17 (20mm contrast) - n=6
whiskerpluck_table(1:36,1)=20;
dvaluestemp = cellfun(@(c) cat(1, c{:}),dvalues([1,4]),'UniformOutput',false);
dvalues_20 = cat(1,dvaluestemp{:});
whiskerpluck_table(1:36,3) = dvalues_20;

% Cohort 16 (16mm (n=3) and 14mm (n=3) contrast)
whiskerpluck_table(37:54,1)=16;
whiskerpluck_table(55:72,1)=14;

dvalues_c16 = cellfun(@(c) cat(1, c{:}),dvalues(3),'UniformOutput',false);
whiskerpluck_table(37:54,3) = dvalues_c16{1}(1:18);
whiskerpluck_table(55:72,3) = dvalues_c16{1}(19:36);

% Cohort 14 (12mm (n=4) and 8mm (n=4) contrast)
whiskerpluck_table(73:96,1)=12;
whiskerpluck_table(97:120,1)=8;

dvalues_c14 = cellfun(@(c) cat(1, c{:}),dvalues(2),'UniformOutput',false);
whiskerpluck_table(73:84,3) = dvalues_c14{1}(1:12);
whiskerpluck_table(85:96,3) = dvalues_c14{1}(25:36);
whiskerpluck_table(97:108,3) = dvalues_c14{1}(13:24);
whiskerpluck_table(109:120,3) = dvalues_c14{1}(37:48);

for i = 1:120
    if whiskerpluck_table(i,2)<0
        whiskerpluck_table(i,4) = 1;
    elseif whiskerpluck_table(i,2)>0
        whiskerpluck_table(i,4) = 2;
    end
end

%% some statistics
p = nan(2, 6);

p(1,1) = anova1(whiskerpluck_table(:,3),whiskerpluck_table(:,4),'off');
p(2,1) = ranksum(whiskerpluck_table(whiskerpluck_table(:,4)==1,3),whiskerpluck_table(whiskerpluck_table(:,4)==2,3));
if p(1,1) < 0.05 && p(2,1) < 0.05
    fprintf('The d prime is significantly different before and after the whiskerpluck, p =  %.3f\n', p(2,1));
end

contrast = [20 16 14 12 8];
for i = contrast
    contFlag = whiskerpluck_table(:,1) == i;
    groupFlag = contFlag+(whiskerpluck_table(:,2)<2);
    prepluckFlag = whiskerpluck_table(contFlag, 2) < 0;
    postpluckFlag = whiskerpluck_table(contFlag, 2) == 1;
    ii = [false, ismember(contrast, i)];
    p(1,ii) = anova1(whiskerpluck_table(groupFlag == 2,3),whiskerpluck_table(groupFlag == 2,4),'off');
    p(2,ii) = ranksum(whiskerpluck_table(prepluckFlag,3),whiskerpluck_table(postpluckFlag,3));
    if p(1,ii) < 0.05 && p(2,ii) < 0.05
        fprintf('The d prime is significantly different before and after the whiskerpluck for a contrast of %dmm, p =  %.3f\n', i, p(2,ii))
    end
end

%% Plot Data
% all whiskerplucks combined before and after (3 sessions)
f1 = figure; boxchart(whiskerpluck_table(:,4), whiskerpluck_table(:,3),'BoxFaceColor', '#D95319','Notch','on','MarkerColor','k')
hold on; scatter(whiskerpluck_table(:,4),whiskerpluck_table(:,3),'Marker','.','Jitter','on')
xticks([1,2]); xticklabels({'pre whiskerpluck','post whiskerpluck'})
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
xlim([0 3])
ylim([-0.5 4.5])

dprime_max = arrayfun(@(c) max(whiskerpluck_table(whiskerpluck_table(:,1) == c, 3)), contrast);

if p(2,1) < 0.05
   plot([1 2],[max(dprime_max)+0.2 max(dprime_max)+0.2], 'k')
end

if p(2,1) <= 0.05 && p(2,1) > 0.01
   text(1.5, max(dprime_max)+0.3,'*','HorizontalAlignment','center')
elseif p(2,1) <= 0.01 && p(2,1) > 0.001
    text(1.5, max(dprime_max)+0.3,'**','HorizontalAlignment','center')
elseif p(2,1) <= 0.001
    text(1.5, max(dprime_max)+0.3,'***','HorizontalAlignment','center')
end

savefig(f1, fullfile('Z:\Josephine\Master-Thesis_Figures\Whiskerpluck','whiskerpluck_all.fig'))

% all whiskerplucks combined before and after (1 session)
sesFlag = (whiskerpluck_table(1:120,2)<2);
f2 = figure; boxchart(whiskerpluck_table(sesFlag == 1,4), whiskerpluck_table(sesFlag == 1,3),'BoxFaceColor', '#D95319','Notch','on','MarkerColor','k')
hold on; scatter(whiskerpluck_table(sesFlag == 1,4),whiskerpluck_table(sesFlag == 1,3),'Marker','.','Jitter','on')
xticks([1,2]); xticklabels({'pre whiskerpluck','post whiskerpluck'})
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')
xlim([0 3])
ylim([-0.5 4.5])

if p(2,1) < 0.05
   plot([1 2],[max(dprime_max)+0.2 max(dprime_max)+0.2], 'k')
end

if p(2,1) <= 0.05 && p(2,1) > 0.01
   text(1.5, max(dprime_max)+0.3,'*','HorizontalAlignment','center')
elseif p(2,1) <= 0.01 && p(2,1) > 0.001
    text(1.5, max(dprime_max)+0.3,'**','HorizontalAlignment','center')
elseif p(2,1) <= 0.001
    text(1.5, max(dprime_max)+0.3,'***','HorizontalAlignment','center')
end

savefig(f2, fullfile('Z:\Josephine\Master-Thesis_Figures\Whiskerpluck','whiskerpluck_all_first.fig'))

% for individual contrast
for i= contrast
    flag = (whiskerpluck_table(1:120,1) == i)+(whiskerpluck_table(1:120,2)<2);
    loopf = figure; boxchart(whiskerpluck_table(flag == 2,4), whiskerpluck_table(flag == 2,3),'BoxFaceColor', 'k','MarkerColor','k')
    hold on; xticks([1,2]); xticklabels({'pre whiskerpluck','post whiskerpluck'})
    ylabel('d prime')
    title(sprintf('Performance for contrast: %dmm',i))
    ylim([-0.5 max(whiskerpluck_table(whiskerpluck_table(:,1) == i, 3))+0.5])
    yline([1.65, 1.65],'Color','black','LineStyle','--')
    yline([0, 0],'Color',[.7 .7 .7],'LineStyle','--')

    ii = [false, ismember(contrast, i)];
    iii = [ismember(contrast, i)];
    if p(2,ii) < 0.05
        plot([1 2],[dprime_max(iii)+0.2 dprime_max(iii)+0.2], 'k')
    end
    
    
    if p(2,ii) <= 0.05 && p(2,ii) > 0.01
        text(1.5, dprime_max(iii)+0.3,'*','HorizontalAlignment','center')
    elseif p(2,ii) <= 0.01 && p(2,ii) > 0.001
        text(1.5, dprime_max(iii)+0.3,'**','HorizontalAlignment','center')
    elseif p(2,ii) <= 0.001
        text(1.5, dprime_max(iii)+0.3,'***','HorizontalAlignment','center')
    end

    savefig(loopf, fullfile('Z:\Josephine\Master-Thesis_Figures\Whiskerpluck',sprintf('whiskerpluck_%d.fig',i)))
end

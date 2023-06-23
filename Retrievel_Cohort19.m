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

cohort_Data19 = animalData.cohort(19).animal;
cohort_Table19 = create_cohort_table (cohort_Data19);

stages = string({'P3.2','P3.4'});
mice = string({'#78','#82'});
stageflag = string(cohort_Table19(:,2)) == stages;
mouseflag = string(cohort_Table19(:,1)) == mice;

retrieval_table_sa = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 8, 'last');
        retrieval_table_sa = [retrieval_table_sa;cohort_Table19(trueflag,:)];
    end
end

stages = string({'P3.3','P3.5'});
stageflag = string(cohort_Table19(:,2)) == stages;
mouseflag = string(cohort_Table19(:,1)) == mice;

retrieval_table_cno = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 4, 'first');
        retrieval_table_cno = [retrieval_table_cno;cohort_Table19(trueflag,:)];
    end
end

retrieval_table = vertcat(retrieval_table_sa,retrieval_table_cno);

for i = 1:length(retrieval_table)
    if retrieval_table(i,2) == string({'P3.2'})
        retrieval_table(i,5) = {1};
    elseif retrieval_table(i,2) == string({'P3.3'})
        retrieval_table(i,5) = {2};
    elseif retrieval_table(i,2) == string({'P3.4'})
        retrieval_table(i,5) = {4};
    else
        retrieval_table(i,5) = {5};
    end
end

%% Try out
mf = string(retrieval_table(:,1)) == mice;
stages = string(unique(retrieval_table(:,2)));
sf = string(retrieval_table(:,2)) == stages';
msf = mf & reshape(sf, [], 1, 4);
fnOpts = {'UniformOutput', false};

for cs = 1:numel(stages)
    splitFlag = arrayfun(@(m) find(msf(:, m, cs), 4, 'last'), [1,2], fnOpts{:});
    splitFlag = cat(1, splitFlag{:});
    retrieval_table(splitFlag, 5) = cellfun(@(x) x+1, retrieval_table(splitFlag, 5), fnOpts{:});
end

%% some statistics
ctrl1_flag = [retrieval_table{:,5}]' == [1,4];
ctrl2_flag = [retrieval_table{:,5}]' == [2,5];
injected_flag = [retrieval_table{:,5}]' == [3,6];
[p0,h0] = ranksum([retrieval_table{ctrl1_flag(:,1),4}]',[retrieval_table{ctrl2_flag(:,1),4}]');
[p1,h1] = ranksum([retrieval_table{ctrl1_flag(:,2),4}]',[retrieval_table{ctrl2_flag(:,2),4}]');
[p2,h2] = ranksum([retrieval_table{ctrl2_flag(:,1),4}]',[retrieval_table{injected_flag(:,1),4}]');
[p3,h3] = ranksum([retrieval_table{ctrl2_flag(:,2),4}]',[retrieval_table{injected_flag(:,2),4}]');

%% plot data
f1 = figure;
color_map = [[0 0.4470 0.7410]; [0 0.4470 0.7410]; [1 0.3216 0.3020]]; j=1;
for i = [1, 2, 3; 4, 5, 6]
    injflag = any([retrieval_table{:,5}]' == i',2);
    boxchart([retrieval_table{injflag,5}]', [retrieval_table{injflag,4}]','BoxFaceColor',color_map(j,:),'MarkerColor',color_map(j,:))
    j=j+1;
    if i(1) == 1
        hold on
    end
end
ylabel('d prime'), xlabel('sessions')
yline([1.65, 1.65],'Color','black','LineStyle','--')
xticks(3.5), xticklabels({'ruleswitch'}), ylim([0.5 5]), xlim([0.5 6.5])

max_initial = max(max([retrieval_table{ctrl1_flag(:,1),4}]',[retrieval_table{ctrl2_flag(:,1),4}]'));
plot([1 2],[max_initial+0.1 max_initial+0.1], 'k')
if p0 <= 0.05 && p0 > 0.01
    text(1.5, max_initial+0.2,'*','HorizontalAlignment','center')
elseif p0 <= 0.01 && p0 > 0.001
    text(1.5, max_initial+0.2,'**','HorizontalAlignment','center')
elseif p0 <= 0.001
    text(1.5, max_initial+0.2,'***','HorizontalAlignment','center')
else
    text(1.5, max_initial+0.2,'ns','HorizontalAlignment','center')
end

max_second = max(max([retrieval_table{ctrl1_flag(:,2),4}]',[retrieval_table{ctrl2_flag(:,2),4}]'));
plot([4 5],[max_second+0.1 max_second+0.1], 'k')
if p1 <= 0.05 && p1 > 0.01
    text(4.5, max_second+0.2,'*','HorizontalAlignment','center')
elseif p1 <= 0.01 && p1 > 0.001
    text(4.5, max_second+0.2,'**','HorizontalAlignment','center')
elseif p1 <= 0.001
    text(4.5, max_second+0.2,'***','HorizontalAlignment','center')
else
    text(4.5, max_second+0.25,'ns','HorizontalAlignment','center')
end

max_second = max(max([retrieval_table{ctrl2_flag(:,1),4}]',[retrieval_table{injected_flag(:,1),4}]'));
plot([2 3],[max_second+0.1 max_second+0.1], 'k')
if p2 <= 0.05 && p2 > 0.01
    text(2.5, max_second+0.2,'*','HorizontalAlignment','center')
elseif p2 <= 0.01 && p2 > 0.001
    text(2.5, max_second+0.2,'**','HorizontalAlignment','center')
elseif p2 <= 0.001
    text(2.5, max_second+0.2,'***','HorizontalAlignment','center')
else
    text(2.5, max_second+0.24,'ns','HorizontalAlignment','center')
end

max_second = max(max([retrieval_table{ctrl2_flag(:,2),4}]',[retrieval_table{injected_flag(:,2),4}]'));
plot([5 6],[max_second+0.2 max_second+0.2], 'k')
if p3 <= 0.05 && p3 > 0.01
    text(5.5, max_second+0.3,'*','HorizontalAlignment','center')
elseif p3 <= 0.01 && p3 > 0.001
    text(5.5, max_second+0.3,'**','HorizontalAlignment','center')
elseif p3 <= 0.001
    text(5.5, max_second+0.3,'***','HorizontalAlignment','center')
else
    text(5.5, max_second+0.35,'ns','HorizontalAlignment','center')
end

legend('saline','','CNO','Location','southeast'); legend('boxoff')

%% paired substraction
% first_Sa = [retrieval_table{string(retrieval_table(:,5)) == '1', 4}]';
% second_Sa = [retrieval_table{string(retrieval_table(:,5)) == '2', 4}]';

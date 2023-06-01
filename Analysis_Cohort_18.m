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

% load Cohort Data
cohort_Data18 = animalData.cohort(18).animal;
cohort_Table = create_cohort_table (cohort_Data18);

%% Retrieval-Test
stages = string({'P3.2','P3.4'});
mice = string({'#69','#71','#73','#75'});
stageflag = string(cohort_Table(:,2)) == stages;
mouseflag = string(cohort_Table(:,1)) == mice;

retrieval_table_sa = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 4, 'last');
        retrieval_table_sa = [retrieval_table_sa;cohort_Table(trueflag,:)];
    end
end

stages = string({'P3.3','P3.5','P3.7'});
mice = string({'#69','#71','#73','#75'});
stageflag = string(cohort_Table(:,2)) == stages;
mouseflag = string(cohort_Table(:,1)) == mice;

retrieval_table_cno = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 4, 'first');
        retrieval_table_cno = [retrieval_table_cno;cohort_Table(trueflag,:)];
    end
end

stageflag = string(retrieval_table_cno(:,2)) == 'P3.5';
mice = string({'#69','#75'});
mouseflag = any(string(retrieval_table_cno(:,1)) == mice,2);
deleteflag = mouseflag + stageflag;
retrieval_table_cno(deleteflag == 2, :) = [];

stageflag = string(retrieval_table_cno(:,2)) == 'P3.7';
mice = string({'#61','#73'});
mouseflag = any(string(retrieval_table_cno(:,1)) == mice,2);
deleteflag = mouseflag + stageflag;
retrieval_table_cno(deleteflag == 2, :) = [];

retrieval_table = vertcat(retrieval_table_sa,retrieval_table_cno);

for i = 1:length(retrieval_table)
    if retrieval_table(i,2) == string({'P3.2'})
        retrieval_table(i,5) = {1};
    elseif retrieval_table(i,2) == string({'P3.3'})
        retrieval_table(i,5) = {2};
    elseif retrieval_table(i,2) == string({'P3.4'})
        retrieval_table(i,5) = {3};
    else
        retrieval_table(i,5) = {4};
    end
end

% some statistics
ctrl_flag = [retrieval_table{:,5}]' == [1,3];
injected_flag = [retrieval_table{:,5}]' == [2,4];
[p0,h0] = ranksum([retrieval_table{ctrl_flag(:,1),4}]',[retrieval_table{injected_flag(:,1),4}]');
[p1,h1] = ranksum([retrieval_table{ctrl_flag(:,2),4}]',[retrieval_table{injected_flag(:,2),4}]');

% plot data
f1 = figure;
color_map = [lines(2);zeros(1,3)];
color_map(1,:) = []; j=1;
for i = [1, 2; 3, 4]
    injflag = any([retrieval_table{:,5}]' == i',2);
    boxchart([retrieval_table{injflag,5}]', [retrieval_table{injflag,4}]','BoxFaceColor',color_map(j,:))
    j=j+1;
    if i(1) == 1
        hold on
    end
end
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
xticks([1.5, 3.5]), xticklabels({'inital rules', 'second rules'}), ylim([0.5 4.5])

max_initial = max(max([retrieval_table{ctrl_flag(:,1),4}]',[retrieval_table{injected_flag(:,1),4}]'));
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

max_second = max(max([retrieval_table{ctrl_flag(:,2),4}]',[retrieval_table{injected_flag(:,2),4}]'));
plot([3 4],[max_second+0.1 max_second+0.1], 'k')
if p0 <= 0.05 && p0 > 0.01
    text(3.5, max_second+0.2,'*','HorizontalAlignment','center')
elseif p0 <= 0.01 && p0 > 0.001
    text(3.5, max_second+0.2,'**','HorizontalAlignment','center')
elseif p0 <= 0.001
    text(3.5, max_second+0.2,'***','HorizontalAlignment','center')
else
    text(3.5, max_second+0.2,'ns','HorizontalAlignment','center')
end

legend('saline','CNO','Location','southeast'); legend('boxoff')
savefig(f1, fullfile('Z:\Josephine\Master-Thesis_Figures\Cohort_18','retrieval_test.fig'))

%% Memory-Test (Break ad libitum)
% table for last four sessions before break
break_table_before = [];
stages = string({'P3.3','P3.4','P3.5'});
mice = string({'#69','#70','#72','#73','#74','#75','#76'});
stageflag = string(cohort_Table(:,2)) == stages;
mouseflag = string(cohort_Table(:,1)) == mice;

break_table_before = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 4, 'last');
        break_table_before = [break_table_before ;cohort_Table(trueflag,:)];
    end
end

stages = string({'P3.3','P3.5'});
stageflag = any(string(break_table_before(:,2)) == stages,2);
mice = string({'#69','#75'});
mouseflag = any(string(break_table_before(:,1)) == mice,2);
deleteflag = mouseflag + stageflag;
break_table_before(deleteflag == 2, :) = [];

stages = string({'P3.4','P3.5'});
stageflag = any(string(break_table_before(:,2)) == stages,2);
mice = string({'#70','#72','#74','#76'});
mouseflag = any(string(break_table_before(:,1)) == mice,2);
deleteflag = mouseflag + stageflag;
break_table_before(deleteflag == 2, :) = [];

stages = string({'P3.3','P3.4'});
stageflag = any(string(break_table_before(:,2)) == stages,2);
mouseflag = string(break_table_before(:,1)) == '#73';
deleteflag = mouseflag + stageflag;
break_table_before(deleteflag == 2, :) = [];

for i = 1:length(break_table_before)
    if break_table_before(i,1) == string({'#69'})
        break_table_before(i,5) = {1};
    elseif break_table_before(i,1) == string({'#73'})
        break_table_before(i,5) = {1};
    elseif break_table_before(i,1) == string({'#75'})
        break_table_before(i,5) = {1};
    else
        break_table_before(i,5) = {2};
    end
end

% table for first session after the break
break_table_after = [];
stages = string({'P3.4','P3.5','P3.6'});
mice = string({'#69','#70','#72','#73','#74','#75','#76'});
stageflag = string(cohort_Table(:,2)) == stages;
mouseflag = string(cohort_Table(:,1)) == mice;

break_table_after = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 1, 'first');
        break_table_after = [break_table_after ;cohort_Table(trueflag,:)];
    end
end

stages = string({'P3.4','P3.6'});
stageflag = any(string(break_table_after(:,2)) == stages,2);
mice = string({'#69','#75'});
mouseflag = any(string(break_table_after(:,1)) == mice,2);
deleteflag = mouseflag + stageflag;
break_table_after(deleteflag == 2, :) = [];

stages = string({'P3.5','P3.6'});
stageflag = any(string(break_table_after(:,2)) == stages,2);
mice = string({'#70','#72','#74','#76'});
mouseflag = any(string(break_table_after(:,1)) == mice,2);
deleteflag = mouseflag + stageflag;
break_table_after(deleteflag == 2, :) = [];

stages = string({'P3.4','P3.5'});
stageflag = any(string(break_table_after(:,2)) == stages,2);
mouseflag = string(break_table_after(:,1)) == '#73';
deleteflag = mouseflag + stageflag;
break_table_after(deleteflag == 2, :) = [];

for i = 1:length(break_table_after)
    if break_table_after(i,1) == string({'#69'})
        break_table_after(i,5) = {3};
    elseif break_table_after(i,1) == string({'#73'})
        break_table_after(i,5) = {3};
    elseif break_table_after(i,1) == string({'#75'})
        break_table_after(i,5) = {3};
    else
        break_table_after(i,5) = {4};
    end
end

% combine tables
break_table = vertcat(break_table_before,break_table_after);

% some statistics
before_flag = [break_table{:,5}]' == [1,2];
after_flag = [break_table{:,5}]' == [3,4];
[p3,h3] = ranksum([break_table{before_flag(:,1),4}]',[break_table{after_flag(:,1),4}]');
[p4,h4] = ranksum([break_table{before_flag(:,2),4}]',[break_table{after_flag(:,2),4}]');

% plot data
f2 = figure;
j=1;
for i = [1, 2; 3, 4]
    injflag = any([break_table{:,5}]' == i',2);
    boxchart([break_table{injflag,5}]', [break_table{injflag,4}]','BoxFaceColor',color_map(j,:))
    j=j+1;
    if i(1) == 1
        hold on
    end
end
ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
xticks([1.5, 3.5]), xticklabels({'before break', 'after break'})

max_saline = max([break_table{before_flag(:,1),4}]');
plot([1 3],[max_saline*1.05 max_saline*1.05], 'k')
if p3 <= 0.05 && p3 > 0.01
    text(2, max_saline*1.1,'*','HorizontalAlignment','center')
elseif p3 <= 0.01 && p3 > 0.001
    text(2, max_saline*1.1,'**','HorizontalAlignment','center')
elseif p3 <= 0.001
    text(2, max_saline*1.1,'***','HorizontalAlignment','center')
else
    text(2, max_saline*1.1,'ns','HorizontalAlignment','center')
end

max_cno = max([break_table{before_flag(:,2),4}]');
plot([2 4],[max_cno*1.05 max_cno*1.05], 'k')
if p4 <= 0.05 && p4 > 0.01
    text(3, max_cno*1.1,'*','HorizontalAlignment','center')
elseif p4 <= 0.01 && p4 > 0.001
    text(3, max_cno*1.1,'**','HorizontalAlignment','center')
elseif p4 <= 0.001
    text(3, max_cno*1.1,'***','HorizontalAlignment','center')
else
    text(3, max_cno*1.1,'ns','HorizontalAlignment','center')
end

legend('saline','CNO','Location','southwest'); legend('boxoff')
savefig(f2, fullfile('Z:\Josephine\Master-Thesis_Figures\Cohort_18','break.fig'))

% check if "memory deficit" results from bodyweight increase

%% no Backlights
% table for last two sessions with lights
backlights_table_before = [];
stages = string({'P3.4','P3.5','P3.6'});
mice = string({'#69','#72','#73','#74','#75','#76'});
stageflag = string(cohort_Table(:,2)) == stages;
mouseflag = string(cohort_Table(:,1)) == mice;

backlights_table_before = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 2, 'last');
        backlights_table_before = [backlights_table_before ;cohort_Table(trueflag,:)];
    end
end

stages = string({'P3.4','P3.6'});
stageflag = any(string(backlights_table_before(:,2)) == stages,2);
mice = string({'#69','#75'});
mouseflag = any(string(backlights_table_before(:,1)) == mice,2);
deleteflag = mouseflag + stageflag;
backlights_table_before(deleteflag == 2, :) = [];

stages = string({'P3.5','P3.6'});
stageflag = any(string(backlights_table_before(:,2)) == stages,2);
mice = string({'#72','#74','#76'});
mouseflag = any(string(backlights_table_before(:,1)) == mice,2);
deleteflag = mouseflag + stageflag;
backlights_table_before(deleteflag == 2, :) = [];

stages = string({'P3.4','P3.5'});
stageflag = any(string(backlights_table_before(:,2)) == stages,2);
mouseflag = string(backlights_table_before(:,1)) == '#73';
deleteflag = mouseflag + stageflag;
backlights_table_before(deleteflag == 2, :) = [];

backlights_table_before(1:length(backlights_table_before),5) = {1};

% table for first two sessions without light
backlights_table_after = [];
stages = string({'P3.5','P3.6','P3.7'});
mice = string({'#69','#72','#73','#74','#75','#76'});
stageflag = string(cohort_Table(:,2)) == stages;
mouseflag = string(cohort_Table(:,1)) == mice;

backlights_table_after = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 2, 'first');
        backlights_table_after = [backlights_table_after ;cohort_Table(trueflag,:)];
    end
end

stages = string({'P3.5','P3.7'});
stageflag = any(string(backlights_table_after(:,2)) == stages,2);
mice = string({'#69','#75'});
mouseflag = any(string(backlights_table_after(:,1)) == mice,2);
deleteflag = mouseflag + stageflag;
backlights_table_after(deleteflag == 2, :) = [];

stages = string({'P3.6','P3.7'});
stageflag = any(string(backlights_table_after(:,2)) == stages,2);
mice = string({'#72','#74','#76'});
mouseflag = any(string(backlights_table_after(:,1)) == mice,2);
deleteflag = mouseflag + stageflag;
backlights_table_after(deleteflag == 2, :) = [];

stages = string({'P3.5','P3.6'});
stageflag = any(string(backlights_table_after(:,2)) == stages,2);
mouseflag = string(backlights_table_after(:,1)) == '#73';
deleteflag = mouseflag + stageflag;
backlights_table_after(deleteflag == 2, :) = [];

backlights_table_after(1:length(backlights_table_after),5) = {2};

% combine both tables
backlights_table = vertcat(backlights_table_before,backlights_table_after);

% some statistics
[p2,h2] = ranksum([backlights_table_before{:,4}]',[backlights_table_after{:,4}]');

% plot data
f3 = figure; boxchart([backlights_table{:,5}]', [backlights_table{:,4}]','BoxFaceColor','k')
hold on; ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
xticks([1, 2]), xticklabels({'backlights on', 'backlights off'})

max_backlights = max([backlights_table{:,4}]');
plot([1 2],[max_backlights*1.05 max_backlights*1.05], 'k')
if p2 <= 0.05 && p2 > 0.01
    text(1.5, max_backlights*1.1,'*','HorizontalAlignment','center')
elseif p2 <= 0.01 && p2 > 0.001
    text(1.5, max_backlights*1.1,'**','HorizontalAlignment','center')
elseif p2 <= 0.001
    text(1.5, max_backlights*1.1,'***','HorizontalAlignment','center')
else
    text(1.5, max_backlights*1.1,'ns','HorizontalAlignment','center')
end

savefig(f3, fullfile('Z:\Josephine\Master-Thesis_Figures\Cohort_18','backlights.fig'))
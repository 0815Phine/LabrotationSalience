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
cohort_Table18 = create_cohort_table (cohort_Data18);

%% Retrieval-Test
stages = string({'P3.2','P3.4'});
mice = string({'#69','#71','#73','#75'});
stageflag = string(cohort_Table18(:,2)) == stages;
mouseflag = string(cohort_Table18(:,1)) == mice;

retrieval_table_sa = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 4, 'last');
        retrieval_table_sa = [retrieval_table_sa;cohort_Table18(trueflag,:)];
    end
end

stages = string({'P3.3','P3.5','P3.7'});
mice = string({'#69','#71','#73','#75'});
stageflag = string(cohort_Table18(:,2)) == stages;
mouseflag = string(cohort_Table18(:,1)) == mice;

retrieval_table_cno = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 4, 'first');
        retrieval_table_cno = [retrieval_table_cno;cohort_Table18(trueflag,:)];
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
[p0,~] = ranksum([retrieval_table{ctrl_flag(:,1),4}]',[retrieval_table{injected_flag(:,1),4}]');
[p1,~] = ranksum([retrieval_table{ctrl_flag(:,2),4}]',[retrieval_table{injected_flag(:,2),4}]');

% plot data
f1 = figure;
color_map = [[0 0.4470 0.7410]; [1 0.3216 0.3020]]; j=1;
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
xticks([1.5, 3.5]), xticklabels({'inital rules', 'second rules'}), ylim([0.5 4.5]), xlim([0.5 4.5])

max_initial = max(max([retrieval_table{ctrl_flag(:,1),4}]',[retrieval_table{injected_flag(:,1),4}]'));
plotStatistics(p0,max_initial,1,2)
max_second = max(max([retrieval_table{ctrl_flag(:,2),4}]',[retrieval_table{injected_flag(:,2),4}]'));
plotStatistics(p1,max_second,3,4)

legend('saline','CNO','Location','southeast'); legend('boxoff')
%savefig(f1, fullfile('Z:\Josephine\Master-Thesis_Figures\Cohort_18','retrieval_test.fig'))

%% Memory-Test (Break ad libitum)
% table for last four sessions before break
break_table_before = [];
stages = string({'P3.3','P3.4','P3.5'});
mice = string({'#69','#70','#72','#73','#74','#75','#76'});
stageflag = string(cohort_Table18(:,2)) == stages;
mouseflag = string(cohort_Table18(:,1)) == mice;

break_table_before = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 4, 'last');
        break_table_before = [break_table_before ;cohort_Table18(trueflag,:)];
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
stageflag = string(cohort_Table18(:,2)) == stages;
mouseflag = string(cohort_Table18(:,1)) == mice;

break_table_after = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 1, 'first');
        break_table_after = [break_table_after ;cohort_Table18(trueflag,:)];
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
[p1,~] = ranksum([break_table{before_flag(:,1),4}]',[break_table{after_flag(:,1),4}]');
[p2,~] = ranksum([break_table{before_flag(:,2),4}]',[break_table{after_flag(:,2),4}]');

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
plotStatistics(p1,max_saline,1,3)
max_cno = max([break_table{before_flag(:,2),4}]');
plotStatistics(p2,max_cno,2,4)

legend('saline','CNO','Location','southwest'); legend('boxoff')
%savefig(f2, fullfile('Z:\Josephine\Master-Thesis_Figures\Cohort_18','break.fig'))

% check if "memory deficit" results from NGFs or GFs
% + plot bodyweight
event_table = NaN(8,7);
for i = 1:length(cohort_Data18)
    if i == 3
        continue
    elseif i == 5
        isbefore = contains(cohort_Data18(i).session_names,'ruleswitch_CNO');
        sesFlagbe = find(isbefore, 1, 'last');
        isafter = contains(cohort_Data18(i).session_names,'retrain');
        sesFlagaf = find(isafter, 1, 'first');

        eventsbe = cohort_Data18(i).Lick_Events{sesFlagbe};
        Go_tot = (sum(strcmp('Go Failure (LP1)',eventsbe))+sum(strcmp('Go Failure (LP2)',eventsbe))...
            +sum(strcmp('Go Success (LP1)',eventsbe))+sum(strcmp('Go Success (LP2)',eventsbe)));
        GoFail = ((sum(strcmp('Go Failure (LP1)',eventsbe))+sum(strcmp('Go Failure (LP2)',eventsbe)))/Go_tot)*100;
        NoGo_tot = (sum(strcmp('No-Go Failure (LP1), Noise triggered',eventsbe))+...
            sum(strcmp('No-Go Failure (LP2), Noise triggered',eventsbe))+...
            sum(strcmp('No-Go Success (LP1)',eventsbe))+sum(strcmp('No-Go Success (LP2)',eventsbe)));
        NoGoFail = ((sum(strcmp('No-Go Failure (LP1), Noise triggered',eventsbe))+...
            sum(strcmp('No-Go Failure (LP2), Noise triggered',eventsbe)))/NoGo_tot)*100;

        event_table(i,1) = GoFail; event_table(i,2) = NoGoFail;

        eventsaf = cohort_Data18(i).Lick_Events{sesFlagaf};
        Go_tot = (sum(strcmp('Go Failure (LP1)',eventsaf))+sum(strcmp('Go Failure (LP2)',eventsaf))...
            +sum(strcmp('Go Success (LP1)',eventsaf))+sum(strcmp('Go Success (LP2)',eventsaf)));
        GoFail = ((sum(strcmp('Go Failure (LP1)',eventsaf))+sum(strcmp('Go Failure (LP2)',eventsaf)))/Go_tot)*100;
        NoGo_tot = (sum(strcmp('No-Go Failure (LP1), Noise triggered',eventsaf))+...
            sum(strcmp('No-Go Failure (LP2), Noise triggered',eventsaf))+...
            sum(strcmp('No-Go Success (LP1)',eventsaf))+sum(strcmp('No-Go Success (LP2)',eventsaf)));
        NoGoFail = ((sum(strcmp('No-Go Failure (LP1), Noise triggered',eventsaf))+...
            sum(strcmp('No-Go Failure (LP2), Noise triggered',eventsaf)))/NoGo_tot)*100;

        event_table(i,3) = GoFail; event_table(i,4) = NoGoFail;
        event_table(i,5) = cohort_Data18(i).bodyweight(sesFlagbe,2); event_table(i,6) = cohort_Data18(i).bodyweight(sesFlagaf,2);
    else
        isbefore = contains(cohort_Data18(i).session_names,'ruleswitch_ses');
        sesFlagbe = find(isbefore, 1, 'last');
        isafter = contains(cohort_Data18(i).session_names,'retrain');
        sesFlagaf = find(isafter, 1, 'first');

        eventsbe = cohort_Data18(i).Lick_Events{sesFlagbe};
        Go_tot = (sum(strcmp('Go Failure (LP1)',eventsbe))+sum(strcmp('Go Failure (LP2)',eventsbe))...
            +sum(strcmp('Go Success (LP1)',eventsbe))+sum(strcmp('Go Success (LP2)',eventsbe)));
        GoFail = ((sum(strcmp('Go Failure (LP1)',eventsbe))+sum(strcmp('Go Failure (LP2)',eventsbe)))/Go_tot)*100;
        NoGo_tot = (sum(strcmp('No-Go Failure (LP1), Noise triggered',eventsbe))+...
            sum(strcmp('No-Go Failure (LP2), Noise triggered',eventsbe))+...
            sum(strcmp('No-Go Success (LP1)',eventsbe))+sum(strcmp('No-Go Success (LP2)',eventsbe)));
        NoGoFail = ((sum(strcmp('No-Go Failure (LP1), Noise triggered',eventsbe))+...
            sum(strcmp('No-Go Failure (LP2), Noise triggered',eventsbe)))/NoGo_tot)*100;
        
        event_table(i,1) = GoFail; event_table(i,2) = NoGoFail;

        eventsaf = cohort_Data18(i).Lick_Events{sesFlagaf};
        Go_tot = (sum(strcmp('Go Failure (LP1)',eventsaf))+sum(strcmp('Go Failure (LP2)',eventsaf))...
            +sum(strcmp('Go Success (LP1)',eventsaf))+sum(strcmp('Go Success (LP2)',eventsaf)));
        GoFail = ((sum(strcmp('Go Failure (LP1)',eventsaf))+sum(strcmp('Go Failure (LP2)',eventsaf)))/Go_tot)*100;
        NoGo_tot = (sum(strcmp('No-Go Failure (LP1), Noise triggered',eventsaf))+...
            sum(strcmp('No-Go Failure (LP2), Noise triggered',eventsaf))+...
            sum(strcmp('No-Go Success (LP1)',eventsaf))+sum(strcmp('No-Go Success (LP2)',eventsaf)));
        NoGoFail = ((sum(strcmp('No-Go Failure (LP1), Noise triggered',eventsaf))+...
            sum(strcmp('No-Go Failure (LP2), Noise triggered',eventsaf)))/NoGo_tot)*100;

        event_table(i,3) = GoFail; event_table(i,4) = NoGoFail;
        event_table(i,5) = cohort_Data18(i).bodyweight(sesFlagbe,2); event_table(i,6) = cohort_Data18(i).bodyweight(sesFlagaf,2);
    end
end
event_table(:,7) = [1,2,1,2,1,2,1,2]';

% figure, hold on
% scatter(1,event_table(event_table(:,7)==1,1), 'MarkerEdgeColor', '#D95319', 'Jitter', 'on')
% scatter(1,event_table(event_table(:,7)==1,2), 'MarkerEdgeColor', '#D95319', 'Jitter', 'on', 'Marker', 'square')
% scatter(1,event_table(event_table(:,7)==2,1), 'MarkerEdgeColor', 'k', 'Jitter', 'on')
% scatter(1,event_table(event_table(:,7)==2,2), 'MarkerEdgeColor', 'k', 'Jitter', 'on', 'Marker', 'square')
% 
% scatter(1,event_table(event_table(:,7)==1,3), 'MarkerEdgeColor', '#D95319', 'MarkerFaceColor', '#D95319', 'Jitter', 'on')
% scatter(1,event_table(event_table(:,7)==1,4), 'MarkerEdgeColor', '#D95319', 'MarkerFaceColor', '#D95319', 'Jitter', 'on', 'Marker', 'square')
% scatter(1,event_table(event_table(:,7)==2,3), 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'Jitter', 'on')
% scatter(1,event_table(event_table(:,7)==2,4), 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'Jitter', 'on', 'Marker', 'square')
% 
% xticks([])
% ylabel('Counts [%]')
% title({'Distribution of Failures', 'before and after Break'})
% legend('Go Failure','','','','No-Go Failure'); legend('boxoff')
% 
% figure, hold on
% scatter(1,event_table(event_table(:,7)==1,5), 'MarkerEdgeColor', '#D95319', 'Jitter', 'on')
% scatter(1,event_table(event_table(:,7)==2,5), 'MarkerEdgeColor', 'k', 'Jitter', 'on')
% scatter(1,event_table(event_table(:,7)==1,6), 'MarkerEdgeColor', '#D95319', 'MarkerFaceColor', '#D95319', 'Jitter', 'on')
% scatter(1,event_table(event_table(:,7)==2,6), 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'Jitter', 'on')
% 
% title('Bodyweight before and after Break')
% ylabel('Bodyweight [%]')

figure, hold on
for i = 1:8
    if event_table(i,7)==1
        plot([1,2],[event_table(i,1),event_table(i,3)],'Color',[0 0.45 0.74],'LineStyle','--')
    elseif event_table(i,7)==2
        plot([1,2],[event_table(i,1),event_table(i,3)],'Color',[1 0.32 0.30],'LineStyle','--')
    end
end
% plot([1,2],[mean(event_table(:,1),'omitnan'),mean(event_table(:,3),'omitnan')],'LineWidth',2,'Color','k')
plot([1,2],[mean(event_table(event_table(:,7)==1,1),'omitnan'), mean(event_table(event_table(:,7)==1,3),'omitnan')],...
    'LineWidth',2,'Color',[0 0.45 0.74])
plot([1,2],[mean(event_table(event_table(:,7)==2,1),'omitnan'), mean(event_table(event_table(:,7)==2,3),'omitnan')],...
    'LineWidth',2,'Color',[1 0.32 0.30])
ylabel('Proportion [%]')
title({'Distribution of Go-Failures', 'before and after Break'})
xticks([1, 2]), xticklabels({'before', 'after'})
legend('saline','CNO'); legend('boxoff')

figure, hold on
for i = 1:8
    if event_table(i,7)==1
        plot([1,2],[event_table(i,2),event_table(i,4)],'Color',[0 0.45 0.74],'LineStyle','--')
    elseif event_table(i,7)==2
        plot([1,2],[event_table(i,2),event_table(i,4)],'Color',[1 0.32 0.30],'LineStyle','--')
    end
end
% plot([1,2],[mean(event_table(:,2),'omitnan'),mean(event_table(:,4),'omitnan')],'LineWidth',2,'Color','k')
plot([1,2],[mean(event_table(event_table(:,7)==1,2),'omitnan'), mean(event_table(event_table(:,7)==1,4),'omitnan')],...
    'LineWidth',2,'Color',[0 0.45 0.74])
plot([1,2],[mean(event_table(event_table(:,7)==2,2),'omitnan'), mean(event_table(event_table(:,7)==2,4),'omitnan')],...
    'LineWidth',2,'Color',[1 0.32 0.30])
ylabel('Proportion [%]')
title({'Distribution of NoGo-Failures', 'before and after Break'})
xticks([1, 2]), xticklabels({'before', 'after'})
legend('saline','CNO'); legend('boxoff')

figure, hold on
for i = 1:8
    if event_table(i,7)==1
        plot([1,2],[event_table(i,5),event_table(i,6)],'Color',[0 0.45 0.74],'LineStyle','--')
    elseif event_table(i,7)==2
        plot([1,2],[event_table(i,5),event_table(i,6)],'Color',[1 0.32 0.30],'LineStyle','--')
    end
end
% plot([1,2],[mean(event_table(:,5),'omitnan'),mean(event_table(:,6),'omitnan')],'LineWidth',2,'Color','k')
plot([1,2],[mean(event_table(event_table(:,7)==1,5),'omitnan'), mean(event_table(event_table(:,7)==1,6),'omitnan')],...
    'LineWidth',2,'Color',[0 0.45 0.74])
plot([1,2],[mean(event_table(event_table(:,7)==2,5),'omitnan'), mean(event_table(event_table(:,7)==2,6),'omitnan')],...
    'LineWidth',2,'Color',[1 0.32 0.30])
title('Bodyweight')
ylabel('[%]')
xticks([1, 2]), xticklabels({'before', 'after'})
legend('saline','CNO'); legend('boxoff')

bwdif = diff(event_table(:,[5,6]),1,2)./sum(event_table(:,[5,6]),2);
%clownshow = flip(color_map,1);
figure, hold on
arrayfun(@(id) scatter(bwdif(event_table(:,7)==id),event_table(event_table(:,7)==id,3),[],color_map(id,:)),[1,2])
xline(0,'--','Color',[.7 .7 .7])
legend('Saline', 'CNO'); legend('boxoff'); legend('location','best')
xlabel('Weight-Modulation-Index')
ylabel('Go-Failures Proportion')
title('hungry motherfuckers')

%% no Backlights
% table for last two sessions with lights
backlights_table_before = [];
stages = string({'P3.4','P3.5','P3.6'});
mice = string({'#69','#72','#73','#74','#75','#76'});
stageflag = string(cohort_Table18(:,2)) == stages;
mouseflag = string(cohort_Table18(:,1)) == mice;

backlights_table_before = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 2, 'last');
        backlights_table_before = [backlights_table_before ;cohort_Table18(trueflag,:)];
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
stageflag = string(cohort_Table18(:,2)) == stages;
mouseflag = string(cohort_Table18(:,1)) == mice;

backlights_table_after = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 2, 'first');
        backlights_table_after = [backlights_table_after ;cohort_Table18(trueflag,:)];
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
backlights_table(1:end,6) = num2cell(repmat([1,2]',height(backlights_table)/2,1));

% some statistics
%[p,~] = ranksum([backlights_table_before{:,4}]',[backlights_table_after{:,4}]');
p_paired = anova1([backlights_table{:,4}],[backlights_table{:,5}],'off');

% plot data
f3 = figure; boxchart([backlights_table{:,5}]', [backlights_table{:,4}]','BoxFaceColor','k')
hold on; ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
xticks([1, 2]), xticklabels({'backlights on', 'backlights off'})

max_backlights = max([backlights_table{:,4}]');
plotStatistics(p_paired,max_backlights,1,2)

%savefig(f3, fullfile('Z:\Josephine\Master-Thesis_Figures\Cohort_18','backlights.fig'))
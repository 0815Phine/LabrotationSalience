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

%% choose cohorts
cohorts = arrayfun(@(x) num2str(x), 1:numel(animalData.cohort), 'UniformOutput', false);
answer = listdlg('ListString',cohorts,'PromptString','Choose your cohort.');
cohorts = cellfun(@str2double, cohorts(answer));
cohortData = horzcat(animalData.cohort(cohorts).animal);

%% get lick rates
numMice = length(cohortData);
max_gosuc = max(arrayfun(@(m) length(cohortData(m).gogo_suc), 1:sum(numMice)));
max_nogosuc = max(arrayfun(@(m) length(cohortData(m).nogo_suc), 1:sum(numMice)));
allgosuc_initial = NaN(max_gosuc, numMice);
allnogosuc_initial = NaN(max_nogosuc, numMice);
allgosuc_switched = NaN(max_gosuc, numMice);
allnogosuc_switched = NaN(max_nogosuc, numMice);

all_ses_ini = []; all_ses_swi = all_ses_ini;
for i = 1:length(cohortData)
    % initial rule
    isP2 = contains(cohortData(i).session_names,'P3.2');
    sesFlag_first = find(isP2, 1, 'first');
    sesFlag_last = find(isP2, 1, 'last');
    num_ses = sesFlag_last-sesFlag_first;

    norm_ses_ini = (1:num_ses)/num_ses;
    all_ses_ini = cat(1, all_ses_ini(:), {norm_ses_ini});

    gosuc = cohortData(i).gogo_suc;
    gosuc(sesFlag_last+1:end) = [];
    gosuc(1:sesFlag_first-1) = [];
    allgosuc_initial(1:length(gosuc),i) = gosuc;

    nogosuc = cohortData(i).nogo_suc;
    nogosuc(sesFlag_last+1:end) = [];
    nogosuc(1:sesFlag_first-1) = [];
    allnogosuc_initial(1:length(nogosuc),i) = nogosuc;

    % reversed rule
    isP4 = contains(cohortData(i).session_names,'P3.4');
    sesFlag_first = find(isP4, 1, 'first');
    sesFlag_last = find(isP4, 1, 'last');
    num_ses = sesFlag_last-sesFlag_first;

    norm_ses_swi = (1:num_ses)/num_ses;
    all_ses_swi = cat(1, all_ses_swi(:), {norm_ses_swi});

    gosuc = cohortData(i).gogo_suc;
    gosuc(sesFlag_last+1:end) = [];
    gosuc(1:sesFlag_first-1) = [];
    allgosuc_switched(1:length(gosuc),i) = gosuc;

    nogosuc = cohortData(i).nogo_suc;
    nogosuc(sesFlag_last+1:end) = [];
    nogosuc(1:sesFlag_first-1) = [];
    allnogosuc_switched(1:length(nogosuc),i) = nogosuc;
end

%% plot data
fig_1 = plot_patch(1-allnogosuc_initial,all_ses_ini,'r',30);
plot_patch(allgosuc_initial,all_ses_ini,'g',30,fig_1);
title('Population lick rates (initial rule)')
xlabel('Session proportion'); ylabel('Lick rate')
legend({'No-go trials' '' 'Go trials'}, 'Box', 'off', 'Location', 'best')
set(gca,'Box','off','Color','none')

fig_2 = plot_patch(1-allnogosuc_switched,all_ses_swi,'r',40);
plot_patch(allgosuc_switched,all_ses_swi,'g',40,fig_2);
title('Population lick rates (switched rule)')
xlabel('Session proportion'); ylabel('Lick rate')
legend({'No-go trials' '' 'Go trials'}, 'Box', 'off', 'Location', 'best')
set(gca,'Box','off','Color','none')

%saveFigure(fig_1,fullfile('Z:\Josephine\Master-Thesis_Figures\Lick_Rates','Initial_20'),true,true)
%saveFigure(fig_2,fullfile('Z:\Josephine\Master-Thesis_Figures\Lick_Rates','Switched_20'),true,true)

%% neutral state
all_ses_neu = [];
for i = 1:length(cohortData)
    isP3 = contains(cohortData(i).session_names,'P3.3');
    sesFlag_first = find(isP3, 1, 'first');
    sesFlag_last = find(isP3, 1, 'last');
    num_ses = sesFlag_last-sesFlag_first;

    if isempty(num_ses)
        continue
    else
        % norm_ses_neu = (1:num_ses)/num_ses;
        % all_ses_neu = cat(1, all_ses_neu(:), {norm_ses_neu});

        gosuc = cohortData(i).gogo_suc;
        gosuc(sesFlag_last+1:end) = [];
        gosuc(1:sesFlag_first-1) = [];
        allgosuc(1:length(gosuc),i) = gosuc;

        nogosuc = cohortData(i).nogo_suc;
        nogosuc(sesFlag_last+1:end) = [];
        nogosuc(1:sesFlag_first-1) = [];
        allnogosuc(1:length(nogosuc),i) = nogosuc;

        neulick = cohortData(i).medium_lick;
        neulick(sesFlag_last+1:end) = [];
        neulick(1:sesFlag_first-1) = [];
        allneutral(1:length(neulick),i) = neulick;
    end
end

% plot data with session proportion
% fig_prop = plot_patch(1-allnogosuc,all_ses_neu,'r',7);
% plot_patch(allgosuc,all_ses_neu,'g',7,fig_prop);
% plot_patch(allneutral,all_ses_neu,'#EDB120',7,fig_prop)

% as all animals had 8 sessions in stage 3 we don't necessarly need the
% proportion function
xvalues = 1:8;

% nogo trials
sig_plot = std(1-allnogosuc,1,2,'omitnan');
mu_plot = mean(1-allnogosuc,2,"omitnan");
curve1 = mu_plot + sig_plot;
curve2 = mu_plot - sig_plot;

figure, plot(xvalues, mu_plot, 'Color', 'r'); hold on
fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],...
     'FaceColor','r', 'EdgeColor','none','FaceAlpha',0.1);

% go trials
sig_plot = std(allgosuc,1,2,'omitnan');
mu_plot = mean(allgosuc,2,"omitnan");
curve1 = mu_plot + sig_plot;
curve2 = mu_plot - sig_plot;

plot(xvalues, mu_plot, 'Color', 'g')
fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],...
     'FaceColor','g', 'EdgeColor','none','FaceAlpha',0.1);

% neutral trials
sig_plot = std(allneutral,1,2,'omitnan');
mu_plot = mean(allneutral,2,"omitnan");
curve1 = mu_plot + sig_plot;
curve2 = mu_plot - sig_plot;

plot(xvalues, mu_plot, 'Color', '#EDB120')
fill([1:length(curve1) fliplr(1:length(curve1))], [curve1' fliplr(curve2')],[0 0 .85],...
     'FaceColor','#EDB120', 'EdgeColor','none','FaceAlpha',0.1);

% labels
ylim([0,1])
title('Population lick rates (neutral aperture state)')
xlabel('Session'); ylabel('Lick rate')
legend({'No-go trials' '' 'Go trials' '' 'Neutral trials'}, 'Box', 'off', 'Location', 'best')
set(gca,'Box','off','Color','none')

%% slow- vs. fast-learner initial rule
%{
[~,columns] = cellfun(@size,all_ses_ini);
[~,max_position] = max(columns);
[~,min_position] = min(columns);
fnOpts = {'UniformOutput', false};
common_axis = (1:30)/30;

% absolute rates
figure, hold on
plot(1:length(allgosuc_initial),allgosuc_initial(:,max_position), 'Color', 'g')
plot(1:length(allnogosuc_initial),1-allnogosuc_initial(:,max_position), 'Color', 'r')
plot(1:length(allgosuc_initial),allgosuc_initial(:,min_position), 'Color', 'g', 'LineStyle', '--')
plot(1:length(allnogosuc_initial),1-allnogosuc_initial(:,min_position), 'Color', 'r', 'LineStyle', '--')

% interpolated on common axis
inter_data_go_slow = interp1(all_ses_ini{max_position}, allgosuc_initial(1:numel(all_ses_ini{max_position}),max_position), common_axis);
inter_data_nogo_slow = interp1(all_ses_ini{max_position}, allnogosuc_initial(1:numel(all_ses_ini{max_position}),max_position), common_axis);
inter_data_go_fast = interp1(all_ses_ini{min_position}, allgosuc_initial(1:numel(all_ses_ini{min_position}),min_position), common_axis);
inter_data_nogo_fast = interp1(all_ses_ini{min_position}, allnogosuc_initial(1:numel(all_ses_ini{min_position}),min_position), common_axis);

figure, hold on
plot(common_axis,inter_data_go_slow, 'Color', 'g'); plot(common_axis,1-inter_data_nogo_slow, 'Color', 'r')
plot(common_axis,inter_data_go_fast, 'Color', 'g', 'LineStyle', '--'); plot(common_axis,1-inter_data_nogo_fast, 'Color', 'r', 'LineStyle', '--')
%}
%% slow- vs. fast-learner switched rule
%{
[rows,columns] = cellfun(@size,all_ses_swi);
[~, max_position] = max(columns);
[~, min_position] = min(columns);
fnOpts = {'UniformOutput', false};
common_axis = (1:40)/40;

% absolute rates
figure, hold on
plot(1:length(allgosuc_switched),allgosuc_switched(:,max_position), 'Color', 'g')
plot(1:length(allnogosuc_switched),1-allnogosuc_switched(:,max_position), 'Color', 'r')
plot(1:length(allgosuc_switched),allgosuc_switched(:,min_position), 'Color', 'g', 'LineStyle', '--')
plot(1:length(allnogosuc_switched),1-allnogosuc_switched(:,min_position), 'Color', 'r', 'LineStyle', '--')

% interpolated on common axis
inter_data_go_slow = interp1(all_ses_swi{max_position}, allgosuc_switched(1:numel(all_ses_swi{max_position}),max_position), common_axis);
inter_data_nogo_slow = interp1(all_ses_swi{max_position}, allnogosuc_switched(1:numel(all_ses_swi{max_position}),max_position), common_axis);
inter_data_go_fast = interp1(all_ses_swi{min_position}, allgosuc_switched(1:numel(all_ses_swi{min_position}),min_position), common_axis);
inter_data_nogo_fast = interp1(all_ses_swi{min_position}, allnogosuc_switched(1:numel(all_ses_swi{min_position}),min_position), common_axis);

figure, hold on
plot(common_axis,inter_data_go_slow, 'Color', 'g'); plot(common_axis,1-inter_data_nogo_slow, 'Color', 'r')
plot(common_axis,inter_data_go_fast, 'Color', 'g', 'LineStyle', '--'); plot(common_axis,1-inter_data_nogo_fast, 'Color', 'r', 'LineStyle', '--')
%}
%% c-values
%{
allcvalues = NaN(766,19);
cohortFlag = [11, 14, 17];
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP2 = contains(cohortData(i).session_names,'P3.2');
        sesFlag_first = find(isP2, 1, 'first');
        sesFlag_last = find(isP2, 1, 'last');
        trialFlag = sum(cellfun(@numel, cohortData(i).Lick_Events(sesFlag_first:sesFlag_last)));

        cvalues = cohortData(i).cvalues_trials;
        cvalues(trialFlag+1:end) = [];
        cvalues(1:200) = [];
        
        if ii == 11
            allcvalues(1:length(cvalues),i) = cvalues;
        elseif ii == 14
            allcvalues(1:length(cvalues),i+6) = cvalues;
        elseif ii == 17
            allcvalues(1:length(cvalues),i+14) = cvalues;
        end
    end
end

figure, hold on
for i = 1:size(allcvalues,2)
    plot(201:200+size(allcvalues,1),allcvalues(:,i))
end
%}
%% lick rates over learning speed
fnOpts = {'UniformOutput', false};
cohort_Data11 = animalData.cohort(11).animal; cohort_Data14 = animalData.cohort(14).animal; cohort_Data17 = animalData.cohort(17).animal;
Speed20_initial = horzcat(cohort_Data11.intersec_initial,cohort_Data14.intersec_initial,cohort_Data17.intersec_initial);
Speed20_second = horzcat(cohort_Data11.intersec_second);
speed20 = {Speed20_initial, Speed20_second};

ngf = {'No-Go Failure (LP1)', 'No-Go Failure (LP2)'};
gs = {'Go Success (LP1)', 'Go Success (LP2)'};

cohortFlag = [11 14 17];
relativeEvents = [];
for ii = cohortFlag
    cohortData = animalData.cohort(ii).animal;
    for i = 1:length(cohortData)
        isP2 = contains(cohortData(i).session_names,'P3.2');
        sesFlag_first = find(isP2, 1, 'first');
        sesFlag_last = find(isP2, 1, 'last');
        
        Events = cohortData(i).Lick_Events;
        Events(sesFlag_last+1:end) = [];
        Events(1:sesFlag_first) = [];
        failure_nogo = []; success_go = [];
        for iii=1:length(Events)
            failure_nogo(iii) = sum(contains(Events{iii},ngf));
            success_go(iii) = sum(strcmp(Events{iii},gs{1}))+sum(strcmp(Events{iii},gs{2}));
        end

        allLickEvents = sum(failure_nogo) + sum(success_go);
        allEvents = sum(cellfun(@numel, Events));
        
        if ii == 11
            relativeEvents(i) = allLickEvents/allEvents;
        elseif ii == 14
            relativeEvents(i+6) = allLickEvents/allEvents;
        elseif ii == 17
            relativeEvents(i+14) = allLickEvents/allEvents;
        end
    end
end
relativeEvents(17) = [];

%plot data
fig_3 = figure; hold on
scatter(Speed20_initial, relativeEvents, 'MarkerEdgeColor','k')
title('Total lick events (initial rule, contrast: 20mm)')
ylabel('Lick rate'); xlabel('Trials to expert')

%second rule
cohortData = animalData.cohort(11).animal;
relLicks = {relativeEvents};
relativeEvents = [];
for i = 1:length(cohortData)
    isP4 = contains(cohortData(i).session_names,'P3.4');
    sesFlag_first = find(isP4, 1, 'first');
    sesFlag_last = find(isP4, 1, 'last');

    Events = cohortData(i).Lick_Events;
    Events(sesFlag_last+1:end) = [];
    Events(1:sesFlag_first) = [];
    failure_nogo = []; success_go = [];
    for iii=1:length(Events)
        failure_nogo(iii) = sum(contains(Events{iii},ngf));
        success_go(iii) = sum(strcmp(Events{iii},gs{1}))+sum(strcmp(Events{iii},gs{2}));
    end

    allLickEvents = sum(failure_nogo) + sum(success_go);
    allEvents = sum(cellfun(@numel, Events));

    relativeEvents(i) = allLickEvents/allEvents;
end
relLicks = [relLicks(:)', {relativeEvents}];

%plot data
fig_4 = figure; hold on
scatter(Speed20_second, relativeEvents, 'MarkerEdgeColor','k')
title('Total lick events (switched rule, contrast: 20mm)')
ylabel('Lick rate'); xlabel('Trials to expert')

mdls = cellfun(@(x,y) fit(x(:), y(:), 'poly1'), speed20, relLicks, fnOpts{:});
mdls2 = cellfun(@(x,y) fit(x(:), y(:), 'poly2'), speed20, relLicks, fnOpts{:});
hold('all')
ax = get(fig_3, 'Children'); plot(ax, xlim(ax), feval(mdls{1}, xlim(ax)), '--k')
plot(ax, min(speed20{1}):10:max(speed20{1}), feval(mdls2{1}, min(speed20{1}):10:max(speed20{1})), '-.k')
ax = get(fig_4, 'Children');
plot(ax, xlim(ax), feval(mdls{2}, xlim(ax)), '--k')

%saveFigure(fig_3,fullfile('Z:\Josephine\Master-Thesis_Figures\Lick_Rates','Initial_total_events_20'),true, true)
%saveFigure(fig_4,fullfile('Z:\Josephine\Master-Thesis_Figures\Lick_Rates','Switched_total_events_20'),true, true)
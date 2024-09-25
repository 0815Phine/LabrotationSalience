%% Single Wing Experiments
% only works if animalData.m is loaded
currentFolder = pwd;
load(fullfile(currentFolder,'/RawData/animalData'))

%% load relevant Cohort Data
cohortData = animalData.cohort(12).animal; %experiments were only done with cohort 12
numMice = length(cohortData);

SesFlag = arrayfun(@(m) contains(cohortData(m).session_names,{'P3.9_'}), 1:numMice, 'UniformOutput', false);
numSes = arrayfun(@(m) sum(SesFlag{m}), 1:numMice);

% 
alld_tW = NaN(numMice,max(numSes));
alld_oW = NaN(numMice,max(numSes));
dprime_right = NaN(numMice,max(numSes));
dprime_left = NaN(numMice,max(numSes));
for mouseIDX = 1:numMice
    % ----- load dprime per session -------------------------------------------------------
    d_oW = cohortData(mouseIDX).dvalues_sessions(SesFlag{mouseIDX});
    tWFlag = find(SesFlag{mouseIDX},1, 'first')-numSes;
    d_tW = cohortData(mouseIDX).dvalues_sessions(tWFlag:tWFlag+(numSes-1));

    if isempty(d_oW)
        continue
    else
        alld_tW(mouseIDX,:) = d_tW;
        alld_oW(mouseIDX,:) = d_oW;
    end
    
    % ----- calculate dprime per wing (whisker stimulus on left or right side) ------------
    if strcmp(cohortData(mouseIDX).animalName, '#33')
        wing = ["b","b","f","f","b","b","f","f"];
    else
        wing = ["f","f","b","b","f","f","b","b"];
    end

    % load lick events for relevant sessions
    Lick_EventsS9 = cohortData(mouseIDX).Lick_Events(SesFlag{mouseIDX});
    Lick_Events= cell(2,numel(Lick_EventsS9));
    for i = 1:numel(Lick_EventsS9)
        if wing(i) == "f"
            Lick_Events{1,i} = Lick_EventsS9{i}(contains(Lick_EventsS9{i},"LP1"));
            Lick_Events{2,i} = Lick_EventsS9{i}(contains(Lick_EventsS9{i},"LP2"));
        else
            Lick_Events{1,i} = Lick_EventsS9{i}(contains(Lick_EventsS9{i},"LP2"));
            Lick_Events{2,i} = Lick_EventsS9{i}(contains(Lick_EventsS9{i},"LP1"));
        end
    end

    for sessionIDX = 1:length(Lick_Events)
        for wingIDX = 1:height(Lick_Events)
            % calculating go and no-go succes rate
            go_suc = sum(strncmpi(Lick_Events{wingIDX,sessionIDX},"Go Success",8));
            go_fail = sum(strncmpi(Lick_Events{wingIDX,sessionIDX},"Go Failure",8));
            nogo_suc = sum(strncmpi(Lick_Events{wingIDX,sessionIDX},"No-Go Success",8));
            nogo_fail = sum(strncmpi(Lick_Events{wingIDX,sessionIDX},"No-Go Failure",8));
            go_suc_rate = go_suc/(go_suc+go_fail);
            nogo_suc_rate = nogo_suc/(nogo_suc+nogo_fail);

            % calculate dprime
            [dprime_wing, ~] = dprime(go_suc_rate, 1-nogo_suc_rate,...
                go_suc+go_fail, nogo_suc+nogo_fail);

            if wingIDX == 1
                dprime_right(mouseIDX,sessionIDX) = dprime_wing;
            elseif wingIDX == 2
                dprime_left(mouseIDX,sessionIDX) = dprime_wing;
            end
        end
    end
end


%% Comparison both vs. one wing
% statistics
d_oWf = reshape(alld_oW(:,1:4),[],1); % first 4 with only one wing remaining
d_tWe = reshape(alld_tW(:,5:8),[],1); % 4 expert sessions
alldprime = horzcat(d_tWe, d_oWf);

[~,p_paired] = ttest(d_tWe, d_oWf);

% plot data
figure; hold on
boxchart(alldprime, 'BoxFaceColor','k', 'MarkerColor', 'k')
scatter(1:width(alldprime),alldprime,'Marker','.','Jitter','on','MarkerEdgeColor','k')

ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
xticklabels({'two wings', 'one wing'})
title('Population performance two wings vs. one wing')
max_dprime = max(max(alldprime));
plotStatistics(min(p_paired),max_dprime,1,2)

%% Comparison left wing vs. right wing remaining
% statistics
d_right = reshape(dprime_right(:,:),[],1);
d_left = reshape(dprime_left(:,:),[],1); 
alldprime = horzcat(d_right, d_left);

[~, p_paired] = ttest(d_right, d_left);

% plot data
figure; hold on
boxchart(alldprime, 'BoxFaceColor','k', 'MarkerColor', 'k')
scatter(1:width(alldprime),alldprime,'Marker','.','Jitter','on','MarkerEdgeColor','k')

ylabel('d prime')
yline([1.65, 1.65],'Color','black','LineStyle','--')
xticklabels({'right wing', 'left wing'})
title('Population performance right wing vs. left wing remaining')
max_dprime = max(max(alldprime));
plotStatistics(min(p_paired),max_dprime,1,2)

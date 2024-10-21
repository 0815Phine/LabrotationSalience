function [rate_w, rate_n, HS_Trials] = get_lickrates(animal_str)
startpath = 'Z:\GrohLab\Extinction';
%animal_str = char(animal);
startpath = fullfile(startpath,animal_str);

FileInfo = dir(fullfile(startpath,'**\*HispeedTrials.mat'));
Sessions = cell(numel(FileInfo),1);

rate_w = zeros(numel(FileInfo), 1);
rate_n = zeros(numel(FileInfo), 1);
for sessionIDX = 1:numel(FileInfo)
    % collect all highspeed-files
    Sessions{sessionIDX} = fullfile(FileInfo(sessionIDX).folder,FileInfo(sessionIDX).name);
    HS_Trials(sessionIDX)= load(Sessions{sessionIDX});

    % calculate lick rates and store in array
    for stateIDX = 1:2
        stateFlag = HS_Trials(sessionIDX).HispeedTrials.Go_NoGo_Neutral_settingBased == stateIDX;
        licks = HS_Trials(sessionIDX).HispeedTrials.Lick(stateFlag);
        licks = licks(~isnan(licks));
        rate = sum(licks)/length(licks);

        if stateIDX == 1
            rate_n(sessionIDX) = rate;
        elseif stateIDX == 2
            rate_w(sessionIDX) = rate;
        end
    end
end
end
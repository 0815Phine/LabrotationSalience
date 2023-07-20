clearvars
%% Selecting experiment
% Choosing the working directory
dataDir = uigetdir('E:\Data\VPM\Jittering\Silicon Probes\',...
    'Choose a working directory');
if dataDir == 0
    return
end
%% Loading data
% Creating the figure directory
FigureDir = fullfile(dataDir,'Figures\');
if ~exist(FigureDir, "dir")
    if ~mkdir(FigureDir)
        error("Could not create figure directory!\n")
    end
end
%WARNING! Protocol getter is not fully stable!
if isempty(dir(fullfile(dataDir, '*analysis.mat')))
    pgObj = ProtocolGetter(dataDir);
    pgObj.getConditionSignals;
    pgObj.getSignalEdges;
    pgObj.getFrequencyEdges;
    pgObj.pairStimulus;
    pgObj.saveConditions;
end
% Loading the necessary files
if ~loadTriggerData(dataDir)
    fprintf(1,'Not possible to load all the necessary variables\n')
    return
end
fnOpts = {'UniformOutput', false};
axOpts = {'Box','off','Color','none'};
spk_file_vars = {'spike_times','gclID','Nt','Ns','goods'};

%% Constructing the helper 'global' variables

spkPttrn = "%s_Spike_Times.mat";
spk_path = fullfile(dataDir, sprintf(spkPttrn, expName));
if ~exist(spk_path, "file")
    % Number of total samples
    Ns = structfun(@numel,Triggers); Ns = min(Ns(Ns>1));
    % Total duration of the recording
    Nt = Ns/fs;
    % Useless clusters (labeled as noise or they have very low firing rate)
    badsIdx = cellfun(@(x) x==3,sortedData(:,3));
    bads = find(badsIdx);
    totSpkCount = cellfun(@numel,sortedData(:,2));
    clusterSpikeRate = totSpkCount/Nt;
    silentUnits = clusterSpikeRate < 0.1;
    bads = union(bads,find(silentUnits));
    goods = setdiff(1:size(sortedData,1),bads);
    badsIdx = badsIdx | silentUnits;
    if ~any(ismember(clInfo.Properties.VariableNames,'ActiveUnit'))
        clInfo = addvars(clInfo,~badsIdx,'After',1,...
            'NewVariableNames','ActiveUnit');
        writeClusterInfo(clInfo, fullfile(dataDir, 'cluster_info.tsv'), 1);
    end
    gclID = sortedData(goods,1);
    badsIdx = StepWaveform.subs2idx(bads,size(sortedData,1));
    spike_times = sortedData(~badsIdx, 2);
    save(spk_path, spk_file_vars{:})
else
    % Subscript column vectors for the rest good clusters
    load(spk_path, spk_file_vars{:})
end
spkSubs = cellfun(@(x) round(x.*fs),spike_times, fnOpts{:});
% Number of good clusters
Ncl = numel(goods);
% Redefining the stimulus signals from the low amplitude to logical values
whStim = {'piezo','whisker','mech','audio'};
cxStim = {'laser','light'};
lfpRec = {'lfp','s1','cortex','s1lfp'};
trigNames = fieldnames(Triggers);
numTrigNames = numel(trigNames);
ctn = 1;
continuousSignals = cell(numTrigNames,1);
continuousNameSub = zeros(size(trigNames));
while ctn <= numTrigNames
    if contains(trigNames{ctn},whStim,'IgnoreCase',true)
        continuousSignals{ctn} = Triggers.(trigNames{ctn});
        continuousNameSub(ctn) = ctn;
    end
    if contains(trigNames{ctn},cxStim,'IgnoreCase',true)
        continuousSignals{ctn} = Triggers.(trigNames{ctn});
        continuousNameSub(ctn) = ctn;
    end
    if contains(trigNames{ctn},lfpRec,'IgnoreCase',true)
        continuousSignals{ctn} = Triggers.(trigNames{ctn});
        continuousNameSub(ctn) = ctn;
    end
    ctn = ctn + 1;
end
continuousSignals(continuousNameSub == 0) = [];
continuousNameSub(continuousNameSub == 0) = [];
trigNames = trigNames(continuousNameSub);

%% Getting the ActiveUnit ISIs from sortedData
% ind = clInfo.ActiveUnit;
% Ncl = sum(ind);
% gclID = clInfo.id(ind == true);
ind = ismember(sortedData(:,1), gclID);
spkSubs = cellfun(@(x) round(x.*fs), sortedData(ind,2),...
    'UniformOutput', false);
ISIVals = cellfun(@(x) [x(1)/fs; diff(x)/fs], spkSubs,...
    'UniformOutput', 0);
NnzvPcl = cellfun(@numel,ISIVals);
Nnzv = sum(NnzvPcl);
rows = cell2mat(arrayfun(@(x,y) repmat(x,y,1), (1:Ncl)', NnzvPcl,...
    'UniformOutput', 0));
cols = cell2mat(spkSubs);
vals = cell2mat(ISIVals);
ISIspar = sparse(rows, cols, vals);

%% Select Time lapse, bin size, and spontaneous and response windows
promptStrings = {'Viewing window (time lapse) [s]:','Response window [s]',...
    'Bin size [s]:'};
defInputs = {'-0.1, 0.1', '0.002, 0.05', '0.001'};
answ = inputdlg(promptStrings,'Inputs', [1, 30],defInputs);
if isempty(answ)
    fprintf(1,'Cancelling...\n')
    return
else
    timeLapse = str2num(answ{1}); %#ok<*ST2NM>
    if numel(timeLapse) ~= 2
        timeLapse = str2num(inputdlg('Please provide the time window [s]:',...
            'Time window',[1, 30], '-0.1, 0.1'));
        if isnan(timeLapse) || isempty(timeLapse)
            fprintf(1,'Cancelling...')
            return
        end
    end
    responseWindow = str2num(answ{2});
    binSz = str2double(answ(3));
end
fprintf(1,'Time window: %.2f - %.2f ms\n',timeLapse*1e3)
fprintf(1,'Response window: %.2f - %.2f ms\n',responseWindow*1e3)
fprintf(1,'Bin size: %.3f ms\n', binSz*1e3)
sponAns = questdlg('Mirror the spontaneous window?','Spontaneous window',...
    'Yes','No','Yes');
spontaneousWindow = -flip(responseWindow);
if strcmpi(sponAns,'No')
    spontPrompt = "Time before the trigger in [s] (e.g. -0.8, -0.6 s)";
    sponDef = string(sprintf('%.3f, %.3f',spontaneousWindow(1),...
        spontaneousWindow(2)));
    sponStr = inputdlg(spontPrompt, 'Inputs',[1,30],sponDef);
    if ~isempty(sponStr)
        spontAux = str2num(sponStr{1});
        if length(spontAux) ~= 2 || spontAux(1) > spontAux(2) || ...
                spontAux(1) < timeLapse(1)
            fprintf(1, 'The given input was not valid.\n')
            fprintf(1, 'Keeping the mirror version!\n')
        else
            spontaneousWindow = spontAux;
        end
    end
end
fprintf(1,'Spontaneous window: %.2f to %.2f ms before the trigger\n',...
    spontaneousWindow(1)*1e3, spontaneousWindow(2)*1e3)

%% Creating the TrigISIs Struct
Conditions(4).name = 'lastCNO';
lastTrials = length(Conditions(3).Triggers) - length(Conditions(2).Triggers) + 1;
Conditions(4).Triggers = Conditions(3).Triggers(lastTrials:end,:);
ConsConds = Conditions([2,4]);
nCond = length(ConsConds);
% sortedData = sortedData(:,1);
for chCond = 1:nCond
    TrigISIs(chCond).name = ConsConds(chCond).name;
    TrigISIs(chCond).Vals(1).name = 'Spontaneous';
    TrigISIs(chCond).Vals(2).name = 'Evoked';
end

%% Select the onset or the offset of a trigger
fprintf(1,'Condition ''%s''\n', Conditions(chCond).name)
onOffStr = questdlg('Trigger on the onset or on the offset?','Onset/Offset',...
    'on','off','Cancel','on');
if strcmpi(onOffStr,'Cancel')
    fprintf(1,'Cancelling...\n')
    return
end

%% Adding ISIs to TrigISIs
spontaneousWindow = -flip(responseWindow);

for chCond = 1:nCond


    % contains will give multiple units when looking for e.g. cl45
    %     spkLog = StepWaveform.subs2idx(round(sortedData{goods(1),2}*fs),Ns);
    % spkSubs replaces round(sortedData{goods(1),2}*fs) for the rest of the
    % clusters
    % Subscript column vectors for the rest good clusters
    for wIndex = 1:2
        if wIndex == 1
            Window = spontaneousWindow;
        else
            Window = responseWindow;
        end
        [~, isiStack] = getStacks(false,ConsConds(chCond).Triggers, onOffStr,...
            Window,fs,fs,[],ISIspar);
        lInda = isiStack > 0;
        % timelapse becomes spontaneousWindow for pre-trigger, and responseWindow
        % for post
        TrigISIs(chCond).Vals(wIndex).TriggeredIsI = isiStack;
        for histInd = 1: Ncl
            [hisi, edges] = histcounts(log10(isiStack(histInd,:,:)), 'BinEdges', log10(0.001):0.01:log10(responseWindow(2)));
            TrigISIs(chCond).Vals(wIndex).cts{histInd} = hisi;
            TrigISIs(chCond).Vals(wIndex).bns{histInd} = (edges(1:end-1) + edges(2:end))/2;

        end

    end
end
%% ISIs and CumISIs
for chCond = 1:nCond
    for a = 1:length(TrigISIs(chCond).Vals(wIndex).cts)
        TrigISIs(chCond).Vals(1).ISI{a} = TrigISIs(chCond).Vals(1).cts{a}./sum(TrigISIs(chCond).Vals(1).cts{a});
        TrigISIs(chCond).Vals(2).ISI{a} = TrigISIs(chCond).Vals(2).cts{a}./sum(TrigISIs(chCond).Vals(2).cts{a});
        TrigISIs(chCond).Vals(1).CumISI{a} = cumsum(TrigISIs(chCond).Vals(1).ISI{a});
        TrigISIs(chCond).Vals(2).CumISI{a} = cumsum(TrigISIs(chCond).Vals(2).ISI{a});
    end
end
%% Saving ISIhist
save(fullfile(dataDir,[expName,'_', num2str(responseWindow), '_TriggeredISIshistBase10.mat']), 'TrigISIs', 'ConsConds', '-v7.3');
%% Plotting
wIndex = 2;

figure('Color', 'White', 'Name', [TrigISIs(chCond).name]);
hold on
for chCond = 1:2
    clr = {[0.5, 0, 0], [0, 1, 1]};
    IsiStack = zeros(length(TrigISIs(chCond).Vals(wIndex).ISI), length(TrigISIs(chCond).Vals(wIndex).ISI{1}));
    cumIsiStack = zeros(length(TrigISIs(chCond).Vals(wIndex).CumISI), length(TrigISIs(chCond).Vals(wIndex).CumISI{1}));
    for cInd = 1:length(TrigISIs(chCond).Vals(wIndex).CumISI)
        IsiStack(cInd,:) =  TrigISIs(chCond).Vals(wIndex).ISI{cInd};
        cumIsiStack(cInd,:) =  TrigISIs(chCond).Vals(wIndex).CumISI{cInd};
    end
    % Getting rid of NaNs
    cumIsiStack(length(TrigISIs(chCond).Vals(wIndex).CumISI) + 1,:) = NaN;
    IsiStack(length(TrigISIs(chCond).Vals(wIndex).ISI) + 1,:) = NaN;
    cumIndNaN = (length(TrigISIs(chCond).Vals(wIndex).CumISI) + 1);
    for nInd = 1:(length(TrigISIs(chCond).Vals(wIndex).CumISI))
        if isnan(cumIsiStack(nInd,:)) == true
            cumIndNaN = [cumIndNaN; nInd];
        end
    end
    cumIndNaN = sort(cumIndNaN, 'descend');
    cumIsiStack(cumIndNaN,:) =[];
    IsiStack(cumIndNaN,:) = [];
    stckSz = size(cumIsiStack);
    ISIcum = sum(cumIsiStack)/stckSz(1);
    % Only if the bin widths are constant!!!
    plot(TrigISIs(1).Vals(1).bns{1}, ISIcum, 'Color', clr{chCond})
end
legend(TrigISIs.name)
ylabel('Cumulative Fraction');
xlabel('ISI (msecs)');
% xlim([-4, 1]);
% xticks([-4:1])
ylim([0, 1]);
fig = gcf;
ax = gca;
ax.FontSize = 20;
ax.XTick = ax.XTick(1:2:end);
ax.XTickLabel = 10.^cellfun(@str2double,ax.XTickLabel) * 1e3;
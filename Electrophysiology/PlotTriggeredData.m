%% Plot TriggeredData -- Rasters
nConds = size(TriggeredData,2);

nUnits = size(TriggeredData(1).relSpks,1);
for cu = 1:nUnits
    loopf = figure('Color','white', 'Name', ['Raster ', num2str(cu)]);

    consconds = [1 2];
    for chcond = consconds

        t = size(TriggeredData(chcond).relSpks,2);

        subplot(1,length(consconds), chcond)
        plot(zeros(length(spks)+2,1), 0:length(spks)+1, 'LineStyle',':', 'LineWidth', 1, 'Color',[0,0,1])

        hold on
        spkleg = false;
        burstleg = false;

        for ct = 1:t


            spks = TriggeredData(chcond).relSpks{cu,ct};
            burstspkinds = TriggeredData(chcond).burstSpkInds{cu,ct};


            for r = 1:length(spks)

                ind = ismember(1:length(spks{r}), burstspkinds{r})';


                leg = legend;

                if ~isempty(ind) && ~spkleg && sum(~ind)>0
                    plot(spks{r}(~ind), r*ones(length(spks{r}(~ind))), 'LineStyle','none', 'Marker','|', 'Color', [0,0,0], 'MarkerSize', 5)
                    leg = legend([{'Trigger Onset'},{'Spikes'}]);
                    spkleg = true;
                else
                    plot(spks{r}(~ind), r*ones(length(spks{r}(~ind))), 'LineStyle','none', 'Marker','|', 'Color', [0,0,0], 'MarkerSize', 5, 'HandleVisibility','off')
                end


                if ~isempty(~ind) && spkleg && ~burstleg && sum(ind)>0
                    plot(spks{r}(ind), r*ones(length(spks{r}(ind))), 'LineStyle','none', 'Marker','|', 'Color', [1,0,0],  'MarkerSize', 5)
                    leg.String = [leg.String(1),leg.String(2), leg.String(end)]; 
                    leg.String{end} = ['ISI<', num2str(ISIcutoff*10^3), ' ms'];
                    burstleg = true;
                else
                    plot(spks{r}(ind), r*ones(length(spks{r}(ind))), 'LineStyle','none', 'Marker','|', 'Color', [1,0,0],  'MarkerSize', 5, 'HandleVisibility','off')
                end
            end

        end

        ax = gca;
        ax.FontSize = 20;
        ax.FontName = 'Arial';
        ax.YLim = [0, length(spks)+1];
        ax.XLabel.String = 'Time relative to Trigger [secs]';
        ax.YLabel.String = 'Trials';
        ax.YTick = length(spks);
        ax.Title.String = TriggeredData(chcond).ConditionName;
        ax.YAxis.Visible = 'off';
        ax.XLim = [-timeBeforesecs, timeAftersecs];
        %         leg = legend('Trigger Onset');
        leg.Box = 'off';
        leg.Location =  "southoutside";
        leg.FontSize = 12;


    end

    RasterDir = fullfile(FigureDir,'Raster_Plots\');
    saveFigure(loopf,fullfile(RasterDir,sprintf('Raster_%d',cu)),true,true)
end
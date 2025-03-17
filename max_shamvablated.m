T = readtable("Z:\GrohLab\max d prime ablated vs sham_plot.xlsx");

figure, hold on
boxchart(ones(1,length(T.ablated)), T.ablated,'BoxFaceColor',[0.6 0.3216 0.651]);
scatter(ones(1,length(T.ablated)), T.ablated,'Marker','.','MarkerEdgeColor',[0.6 0.3216 0.651],'Jitter','on')
boxchart(ones(1,length(T.sham))*2, T.sham,'BoxFaceColor','k');
scatter(ones(1,length(T.sham))*2, T.sham,'Marker','.','MarkerEdgeColor','k','Jitter','on')

[~,p_paired,ci,stats] = ttest(T.ablated,T.sham);
plotStatistics(p_paired,max(T.sham),1,2,'k')

yline([1.65, 1.65],'Color','black','LineStyle','--')
ylabel('d prime')
xticks([1,2]); xticklabels({'Ablated','Sham'})
title('Max population dprime')

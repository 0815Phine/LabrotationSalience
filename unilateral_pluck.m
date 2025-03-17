T = readtable("Z:\GrohLab\uni-lateral_whisker_pluck_data.xlsx");

contrast = unique(T.c);
colormap = [[0.6 0.3216 0.651];[0 0 0]];

figure, hold on
for contrastIDX = 1:length(contrast)
    contFlag = (T.c == contrast(contrastIDX));

    boxchart(ones(1,length(T.before(contFlag)))*contrastIDX, T.before(contFlag),'BoxFaceColor',colormap(contrastIDX,:))
    scatter(ones(1,length(T.before(contFlag)))*contrastIDX, T.before(contFlag),'Marker','.','MarkerEdgeColor',colormap(contrastIDX,:),'Jitter','on')
    boxchart(ones(1,length(T.after(contFlag)))*(contrastIDX+3), T.after(contFlag),'BoxFaceColor',colormap(contrastIDX,:))
    scatter(ones(1,length(T.after(contFlag)))*(contrastIDX+3), T.after(contFlag),'Marker','.','MarkerEdgeColor',colormap(contrastIDX,:),'Jitter','on')

    [~,p_paired,ci,stats] = ttest(T.before(contFlag),T.after(contFlag));
    if p_paired < 0.05
        fprintf('The d prime is significantly different before and after the whiskerpluck. p =  %.3f\n', p_paired)
    else
        fprintf('The d prime is not significantly different before and after the whiskerpluck. p =  %.3f\n', p_paired)
    end
    plotStatistics(p_paired,max(T.before)+(contrastIDX/2),contrastIDX,contrastIDX+3,'k')
end

yline([1.65, 1.65],'Color','black','LineStyle','--')
ylabel('d prime')
xticks([1.5,4.5]); xticklabels({'Pre pluck','Post pluck'})
title('Population performance before and after unilateral whisker pluck')
legend(sprintf('%d mm', contrast(1)),'','','','',sprintf('%d mm', contrast(2)))
legend('Location','best','Box','off')
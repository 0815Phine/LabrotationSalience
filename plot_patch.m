function [fig] = plot_patch(data,axis,color,int_steps,figgi)

fnOpts = {'UniformOutput', false};
common_axis = (1:int_steps)/int_steps;

inter_data = arrayfun(@(x) interp1(axis{x}, data(1:numel(axis{x}),x), common_axis), 1:size(data,2), fnOpts{:});
inter_data = cat(1, inter_data{:});
if ~exist('figgi','var') || isempty(figgi)
    fig = figure;
else
    fig = figgi; hold on
end
plot(common_axis, mean(inter_data, 1, "omitnan"), "Color", color)
ylim([0,1]); hold on;
sig_plot = std(inter_data,1,1,'omitnan');
mu_plot = mean(inter_data,1,"omitnan");
nogosuc_patch = patch('XData', [common_axis, flip(common_axis)],'YData', [sig_plot+mu_plot, flip(-sig_plot+mu_plot)]);
nogosuc_patch.FaceAlpha = 0.1; nogosuc_patch.EdgeColor = "none";
nogosuc_patch.FaceColor = color;
end
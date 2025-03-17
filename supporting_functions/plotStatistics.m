function plotStatistics(p, max, xedgemin, xedgemax, color)

if isempty(color)
    color = 'k';
end

if isempty(xedgemax)
    xvalue = xedgemin;
else
    xvalue = (xedgemin+xedgemax)/2;
    plot([xedgemin xedgemax],[max*1.05 max*1.05], 'Marker', '|', 'Color', 'k')
end

if p <= 0.05 && p > 0.01
    text(xvalue, max*1.1,'*','HorizontalAlignment','center','VerticalAlignment','top','Color', color)
elseif p <= 0.01 && p > 0.001
    text(xvalue, max*1.1,'**','HorizontalAlignment','center','VerticalAlignment','top','Color', color)
elseif p <= 0.001
    text(xvalue, max*1.1,'***','HorizontalAlignment','center','VerticalAlignment','top','Color', color)
else
    text(xvalue, max*1.1,'ns','HorizontalAlignment','center','Color', color)
end

end
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

cohort_Data19 = animalData.cohort(19).animal;
cohort_Data18 = animalData.cohort(18).animal;
cohort_Table19 = create_cohort_table (cohort_Data19);
cohort_Table18 = create_cohort_table (cohort_Data18);

%% Retrieval Table cohort 18
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

retrieval_table_18 = vertcat(retrieval_table_sa,retrieval_table_cno);

for i = 1:length(retrieval_table_18)
    if retrieval_table_18(i,2) == string({'P3.2'})
        retrieval_table_18(i,5) = {1};
    elseif retrieval_table_18(i,2) == string({'P3.3'})
        retrieval_table_18(i,5) = {2};
    elseif retrieval_table_18(i,2) == string({'P3.4'})
        retrieval_table_18(i,5) = {3};
    else
        retrieval_table_18(i,5) = {4};
    end
end

%% Retrieval Table Cohort 19
stages = string({'P3.2','P3.4'});
mice = string({'#78','#82'});
stageflag = string(cohort_Table19(:,2)) == stages;
mouseflag = string(cohort_Table19(:,1)) == mice;

retrieval_table_sa = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 8, 'last');
        retrieval_table_sa = [retrieval_table_sa;cohort_Table19(trueflag,:)];
    end
end

stages = string({'P3.3','P3.5'});
stageflag = string(cohort_Table19(:,2)) == stages;
mouseflag = string(cohort_Table19(:,1)) == mice;

retrieval_table_cno = [];
for mf = mouseflag
    for sf = stageflag
        trueflag = find(mf & sf, 4, 'first');
        retrieval_table_cno = [retrieval_table_cno;cohort_Table19(trueflag,:)];
    end
end

retrieval_table_19 = vertcat(retrieval_table_sa,retrieval_table_cno);

for i = 1:length(retrieval_table_19)
    if retrieval_table_19(i,2) == string({'P3.2'})
        retrieval_table_19(i,5) = {1};
    elseif retrieval_table_19(i,2) == string({'P3.3'})
        retrieval_table_19(i,5) = {2};
    elseif retrieval_table_19(i,2) == string({'P3.4'})
        retrieval_table_19(i,5) = {4};
    else
        retrieval_table_19(i,5) = {5};
    end
end

% Try out
mf = string(retrieval_table_19(:,1)) == mice;
stages = string(unique(retrieval_table_19(:,2)));
sf = string(retrieval_table_19(:,2)) == stages';
msf = mf & reshape(sf, [], 1, 4);
fnOpts = {'UniformOutput', false};

for cs = 1:numel(stages)
    splitFlag = arrayfun(@(m) find(msf(:, m, cs), 4, 'last'), [1,2], fnOpts{:});
    splitFlag = cat(1, splitFlag{:});
    retrieval_table_19(splitFlag, 5) = cellfun(@(x) x+1, retrieval_table_19(splitFlag, 5), fnOpts{:});
end

%% paired substraction first progression initial
first_Sa_19 = [retrieval_table_19{string(retrieval_table_19(:,5)) == '1', 4}]';
second_Sa_19 = [retrieval_table_19{string(retrieval_table_19(:,5)) == '2', 4}]';
sub_19 = [second_Sa_19]-[first_Sa_19];

first_Sa_18 = [retrieval_table_18{string(retrieval_table_18(:,5)) == '1', 4}]';
second_CNO_18 = [retrieval_table_18{string(retrieval_table_18(:,5)) == '2', 4}]';
sub_18 = [second_CNO_18]-[first_Sa_18];

combined_sub = nan(4,6);
combined_sub(1:4,1) = sub_19(1:4); combined_sub(1:4,2) = sub_19(5:8);
combined_sub(1:4,3) = sub_18(1:4); combined_sub(1:4,4) = sub_18(5:8); combined_sub(1:4,5) = sub_18(9:12); combined_sub(1:4,6) = sub_18(13:16);

[p,h] = ranksum(abs(reshape(combined_sub(:,[1,2]),[],1)), abs(reshape(combined_sub(:,3:6),[],1)));

% xvalues = [1 2 3 4]';
% figure; hold on
% for i = 1:6
%     plot(xvalues,combined_sub(:,i))
% end
% xticks([])
% ylabel('Distance [d prime]')

xvalues = ones(numel(reshape(combined_sub(:,[1,2]),[],1)),1);
figure, boxchart(xvalues, abs(reshape(combined_sub(:,[1,2]),[],1))); hold on
xvalues = [ones(numel(reshape(combined_sub(:,3:6),[],1)),1)]+1;
boxchart(xvalues, abs(reshape(combined_sub(:,3:6),[],1)), 'BoxFaceColor', [1.0000, 0.3216, 0.3020])
xticks([1 2]), xticklabels({'saline-saline', 'saline-CNO'})
ylabel('absolute Change [d prime]')

max_change = max(max(abs(combined_sub)));
plot([1 2],[max_change+0.1 max_change+0.1], 'k')
if p <= 0.05 && p > 0.01
    text(1.5, max_change+0.2,'*','HorizontalAlignment','center')
elseif p <= 0.01 && p > 0.001
    text(1.5, max_change+0.2,'**','HorizontalAlignment','center')
elseif p <= 0.001
    text(1.5, max_change+0.2,'***','HorizontalAlignment','center')
else
    text(1.5, max_change+0.2,'ns','HorizontalAlignment','center')
end

%% paired substraction first progression second
first_Sa_19 = [retrieval_table_19{string(retrieval_table_19(:,5)) == '4', 4}]';
second_Sa_19 = [retrieval_table_19{string(retrieval_table_19(:,5)) == '5', 4}]';
sub_19 = [second_Sa_19]-[first_Sa_19];

first_Sa_18 = [retrieval_table_18{string(retrieval_table_18(:,5)) == '3', 4}]';
second_CNO_18 = [retrieval_table_18{string(retrieval_table_18(:,5)) == '4', 4}]';
sub_18 = [second_CNO_18]-[first_Sa_18];

combined_sub = nan(4,6);
combined_sub(1:4,1) = sub_19(1:4); combined_sub(1:4,2) = sub_19(5:8);
combined_sub(1:4,3) = sub_18(1:4); combined_sub(1:4,4) = sub_18(5:8); combined_sub(1:4,5) = sub_18(9:12); combined_sub(1:4,6) = sub_18(13:16);

[p,h] = ranksum(abs(reshape(combined_sub(:,[1,2]),[],1)), abs(reshape(combined_sub(:,3:6),[],1)));

xvalues = ones(numel(reshape(combined_sub(:,[1,2]),[],1)),1);
figure, boxchart(xvalues, abs(reshape(combined_sub(:,[1,2]),[],1))); hold on
xvalues = [ones(numel(reshape(combined_sub(:,3:6),[],1)),1)]+1;
boxchart(xvalues, abs(reshape(combined_sub(:,3:6),[],1)), 'BoxFaceColor', [1.0000, 0.3216, 0.3020])
xticks([1 2]), xticklabels({'saline-saline', 'saline-CNO'})
ylabel('absolute Change [d prime]')

max_change = max(max(abs(combined_sub)));
plot([1 2],[max_change+0.1 max_change+0.1], 'k')
if p <= 0.05 && p > 0.01
    text(1.5, max_change+0.2,'*','HorizontalAlignment','center')
elseif p <= 0.01 && p > 0.001
    text(1.5, max_change+0.2,'**','HorizontalAlignment','center')
elseif p <= 0.001
    text(1.5, max_change+0.2,'***','HorizontalAlignment','center')
else
    text(1.5, max_change+0.2,'ns','HorizontalAlignment','center')
end

%% paired substraction second progression
first_Sa_19 = [retrieval_table_19{string(retrieval_table_19(:,5)) == '2', 4}]';
second_CNO_19 = [retrieval_table_19{string(retrieval_table_19(:,5)) == '3', 4}]';
sub_19_initial = [second_CNO_19]-[first_Sa_19];

first_Sa_19 = [retrieval_table_19{string(retrieval_table_19(:,5)) == '5', 4}]';
second_CNO_19 = [retrieval_table_19{string(retrieval_table_19(:,5)) == '6', 4}]';
sub_19_second = [second_CNO_19]-[first_Sa_19];

combined_sub = nan(4,4);
combined_sub(1:4,1) = sub_19_initial(1:4); combined_sub(1:4,2) = sub_19_initial(5:8);
combined_sub(1:4,3) = sub_19_second(1:4); combined_sub(1:4,4) = sub_19_second(5:8);

for i = [1 3]
    xvalues = ones(numel(reshape(combined_sub(:,[i,i+1]),[],1)),1);
    figure, boxchart(xvalues, abs(reshape(combined_sub(:,[i,i+1]),[],1)),...
        'BoxFaceColor', [1.0000, 0.3216, 0.3020], 'MarkerColor', [1.0000, 0.3216, 0.3020])
    xticks([1]), xticklabels({'saline-CNO'})
    ylabel('absolute Change [d prime]')

    if i == 1
        title('initial rules')
    else
        title('second rules')
    end
end

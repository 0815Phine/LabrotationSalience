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

% load Cohort Data
cohort_Data = animalData.cohort(14).animal;
cohort_Table = create_cohort_table (cohort_Data);

% adjust Cohort Table
stageflag = string(cohort_Table(:,2)) == 'P3.1';
cohort_Table(stageflag == 1, :) = [];
stageflag = string(cohort_Table(:,2)) == 'P3.10';
cohort_Table(stageflag == 1, :) = [];
stageflag = string(cohort_Table(:,2)) == 'P3.10.1';
cohort_Table(stageflag == 1, :) = [];
stageflag = string(cohort_Table(:,2)) == 'P3.11';
cohort_Table(stageflag == 1, :) = [];
stageflag = string(cohort_Table(:,2)) == 'P3.11.1';
cohort_Table(stageflag == 1, :) = [];

stageflag = string(cohort_Table(:,2)) == 'P3.2';
mouseflag = string(cohort_Table(:,1)) == '#47';
flag = stageflag + mouseflag;


cohort_Table(flag == 2, :);


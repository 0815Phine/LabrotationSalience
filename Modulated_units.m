% check for significance 
n_Units = length(Results(1).Activity(1).Direction);

modUnits = find(Results(1).Activity(1).Pvalues <= 0.05);
modDir = Results(1).Activity(1).Direction(modUnits,1);
n_depUnits = sum(modDir < 0); n_potUnits = sum(modDir > 0);

fprintf('From %d units, %d are potentiated and %d are deprived in spontaneous activity compared to the control. \n', n_Units, n_potUnits, n_depUnits)

modUnits = find(Results(1).Activity(2).Pvalues <= 0.05);
modDir = Results(1).Activity(2).Direction(modUnits,1);
n_depUnits = sum(modDir < 0); n_potUnits = sum(modDir > 0);

fprintf('From %d units, %d are potentiated and %d are deprived in evoked activity compared to the control. \n', n_Units, n_potUnits, n_depUnits)

clearvars
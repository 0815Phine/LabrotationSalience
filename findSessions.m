function [dvalues, sessNames] = findSessions (animalData,Selection)
% thanks Emilio (:

% Check annonymus functions
isWP = @(x) contains(x, 'whiskerpluck');
% Function options for non-uniform outputs
fnOpts = {'UniformOutput', false};
cohortStruct = animalData.cohort(Selection);
wpFlag = arrayfun(@(c) arrayfun(@(a) ...
    sum(isWP(a.session_names))>0, c.animal), ...
    cohortStruct, fnOpts{:});
wpSessionPos = arrayfun(@(c, f) arrayfun(@(a) ...
    find(isWP(a.session_names), 1, 'first'), c.animal(f{:})), cohortStruct, ...
    wpFlag, fnOpts{:});

dvalues = arrayfun(@(c, f, s) arrayfun(@(a, ss) ...
    a.dvalues_sessions(ss + (-3:2)), c.animal(f{:}), s{:}, fnOpts{:}), ...
    cohortStruct, wpFlag, wpSessionPos, fnOpts{:});

sessNames = arrayfun(@(c, f, s) arrayfun(@(a, ss) ...
    a.session_names(ss + (-3:2)), c.animal(f{:}), s{:}, fnOpts{:}), ...
    cohortStruct, wpFlag, wpSessionPos, fnOpts{:});
end
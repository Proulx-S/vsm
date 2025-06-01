function [rCond, info, QA] = convertHRdelayToVsmCenSur(p, workDir)
%CONVERTHRDELAYTOVSMCENSUR Convert HRdelay data structure to vsmCenSur format
%
% Inputs:
%   p - HRdelay parameters structure (from downloadHRdelayData)
%   workDir - Working directory for output files
%
% Outputs:
%   rCond - Converted data structure in vsmCenSur format
%   info - Information structure
%   QA - Quality assurance structure

disp('Converting HRdelay data to vsmCenSur format...')

% Initialize structures following generalPreproc pattern
info.dataSetLabel = 'HRdelay';
info.workDir = workDir;
info.workFile = fullfile(workDir,[info.dataSetLabel '_generalPreproc.mat']);
info.indexFile = fullfile(workDir,[info.dataSetLabel '_indexFile.mat']);

% Create rCond structure following vsmCenSur pattern
rCond = {};
subList = p.meta.subjList;
acqList = {'bold'};  % HRdelay uses BOLD data
taskList = {'vglnc'};  % HRdelay has 3 stimulus conditions
condList = {'grat1' 'grat2' 'plaid'};  % HRdelay has 3 stimulus conditions
conditionMap = [1 2 3]; % HRdelay condition IDs that map to grat1, grat2, plaid

% Load and convert each subject's data
for S = 1:length(subList)
    subj = subList{S};
    disp(['Converting subject ' subj ' (' num2str(S) '/' num2str(length(subList)) ')...'])
    
    % Load HRdelay timeseries data
    hrDataFile = fullfile(p.dataPath.V1,'ts',[subj '.mat']);
    hrData = load(hrDataFile);
    
    % Initialize subject structure
    rCond{S,1} = runCond();
    rCond{S}.sub  = subj;
    rCond{S}.acq  = acqList{1};

    % Collect data from all sessions and runs
    allOnsets = [];
    allDurations = [];
    allConditions = [];
    allDesigns = {}; % Store design for each run
    
    for ses = 1:length(hrData.d.fun)
        disp(['  Processing session ' num2str(ses) '/' num2str(length(hrData.d.fun))])
        
        % Get data for this session
        sessionData = hrData.d.fun(ses);
        nRuns = length(sessionData.data);
        validRuns = ~sessionData.excl; % Non-excluded runs
        nValidRuns = sum(validRuns);
        
        % Add session and task info for valid runs
        rCond{S}.ses  = cat(1, rCond{S}.ses,  repmat(ses, nValidRuns, 1));
        rCond{S}.task = cat(1, rCond{S}.task, repmat(taskList(1), nValidRuns, 1)); % All runs have same task
        rCond{S}.cond = cat(1, rCond{S}.cond, condList(sessionData.condLabel(validRuns))');
        
        % Add other run properties for valid runs
        rCond{S}.tr     = cat(1, rCond{S}.tr    , repmat(hrData.p.tr, nValidRuns, 1)                   );
        rCond{S}.nFrame = cat(1, rCond{S}.nFrame, cellfun(@(x) size(x, 4), sessionData.data(validRuns))); % Each run has 120 timepoints
        
        % Process each valid run for design matrix
        validRunIndices = find(validRuns);
        for runIdx = 1:length(validRunIndices)
            run = validRunIndices(runIdx);
            
            % Get condition for this run
            conditionId = sessionData.condLabel(run);
            
            % Extract stimulus onset times from design matrix
            design = sessionData.design{run}; % [time x 1] binary
            stimOnsets = find(design == 1); % Frame indices where stimulus starts
            stimOnsets_sec = (stimOnsets - 1) * hrData.p.tr; % Convert to seconds (0-indexed)
            
            % Create design structure for this specific run
            runDsgn_obj = runDsgn();
            runDsgn_obj.task = taskList{1}; % Same task for all runs (vglnc)
            runDsgn_obj.onsetList = stimOnsets_sec; % Onset times for this run
            runDsgn_obj.ondurList = repmat(hrData.p.stimDur, length(stimOnsets), 1); % Durations for this run
            runDsgn_obj.dt = hrData.p.tr; % Time resolution
            runDsgn_obj.cond = ones(length(stimOnsets), 1); % All stimuli in this run are the same condition
            runDsgn_obj.condLabel = {condList{conditionId}}; % Specific condition label for this run (grat1/grat2/plaid)
            runDsgn_obj.condK = 1; % One condition per run
            runDsgn_obj.nReg = 1; % One regressor per run
            
            allDesigns{end+1} = runDsgn_obj;
            
            % Add to combined lists for summary
            allOnsets = [allOnsets; stimOnsets_sec];
            allDurations = [allDurations; repmat(hrData.p.stimDur, length(stimOnsets), 1)];
            allConditions = [allConditions; repmat(conditionId, length(stimOnsets), 1)];
        end
    end
    
    % Set up file lists (empty as requested)
    nTotalRuns = length(rCond{S}.ses);
    
    % Store run-specific designs
    rCond{S}.dsgn = allDesigns'; % Cell array of runDsgn objects, one per run
    
    % Display summary
    disp(['    Total runs: ' num2str(nTotalRuns)])
    disp(['    Total stimuli: ' num2str(length(allOnsets))])
    disp(['    Task: ' taskList{1}])
    disp(['    Conditions: ' strjoin(condList, ', ')])
    
    % Count stimuli per condition
    for c = 1:length(condList)
        nStim = sum(allConditions == c);
        disp(['      ' condList{c} ': ' num2str(nStim) ' stimuli'])
    end
end

% Create info structure
info.subList = subList;
info.acqList = acqList;
info.taskList = taskList;
info.condList = condList;

% Create placeholder QA structure
QA = struct();

disp('Data conversion completed!')
disp(['Subjects: ' num2str(length(subList))])
disp(['Acquisition types: ' strjoin(acqList, ', ')])
disp(['Task: ' taskList{1}])
disp(['Conditions: ' strjoin(condList, ', ')])

% Save converted data
disp('Saving converted data structure...')
save(info.indexFile,'rCond','info','QA','-v7.3');
disp(['Saved to: ' info.indexFile])

end 
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
taskList = {'grat1' 'grat2' 'plaid'};  % HRdelay has 3 stimulus conditions

% Load and convert each subject's data
for S = 1:length(subList)
    subj = subList{S};
    disp(['Converting subject ' subj ' (' num2str(S) '/' num2str(length(subList)) ')...'])
    
    % Load HRdelay timeseries data
    hrData = load(fullfile(p.dataPath.V1,'ts',[subj '.mat']));
    
    % Initialize subject structure
    rCond{S,1} = struct();
    
    % For each acquisition type (only BOLD in HRdelay)
    acq = acqList{1};
    rCond{S}.(acq) = struct();
    
    % For each task condition
    for T = 1:length(taskList)
        task = ['task_' taskList{T}];
        
        % Create runCond-like structure for this task
        rCond{S}.(acq).(task) = struct();
        rCond{S}.(acq).(task).sub = subj;
        rCond{S}.(acq).(task).ses = '1';  % HRdelay has single session per subject
        rCond{S}.(acq).(task).acq = acq;
        rCond{S}.(acq).(task).task = task;
        
        % Extract timeseries for this condition
        % HRdelay data structure: hrData.d.fun(sessInd).data contains the timeseries
        % We'll need to extract condition-specific data
        
        % For now, store reference to original data - will need to implement
        % proper conversion based on HRdelay's data organization
        rCond{S}.(acq).(task).hrData = hrData;
        
        % Create basic design structure
        dsgn = struct();
        dsgn.task = task;
        dsgn.condLabel = {taskList{T}};
        rCond{S}.(acq).(task).dsgn = dsgn;
        
        % Placeholder for other required fields
        rCond{S}.(acq).(task).fList = {};
        rCond{S}.(acq).(task).tr = [];
        rCond{S}.(acq).(task).date = [];
    end
end

% Create info structure
info.subList = subList;
info.acqList = acqList;
info.taskList = taskList;

% Create placeholder QA structure
QA = struct();

disp('Data conversion completed!')
disp(['Subjects: ' num2str(length(subList))])
disp(['Acquisition types: ' strjoin(acqList, ', ')])
disp(['Task conditions: ' strjoin(taskList, ', ')])

% Save converted data
disp('Saving converted data structure...')
save(info.indexFile,'rCond','info','QA','-v7.3');
disp(['Saved to: ' info.indexFile])

end 
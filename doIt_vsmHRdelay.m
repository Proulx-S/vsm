clear all
close all

%%%%%%%%%%%%%%%%%%%%%
%% Set up environment
%%%%%%%%%%%%%%%%%%%%%
% Detect computing environment
os   = char(java.lang.System.getProperty('os.name'));
host = char(java.net.InetAddress.getLocalHost.getHostName);
user = char(java.lang.System.getProperty('user.name'));

% Configure paths accordingly
if strcmp(os,'Linux') && strcmp(host,'takoyaki') && strcmp(user,'sebp')
    storageDir = '/local/users/Proulx-S/';
    scratchDir = '/scratch/users/Proulx-S/';
    workScript = mfilename;
    workFile   = [workScript '.mat'];
    workDir    = fullfile(getenv('HOME'),'/work/vsm/',workScript); if ~exist(workDir,'dir'); mkdir(workDir); end
    toolDir    = fullfile(workDir,'tools'); if ~exist(toolDir,'dir'); mkdir(toolDir); end  % Local tools directory
    workFile   = fullfile(fileparts(workDir),workFile);
    envId      = 1;
    setenv('SINGULARITY_BINDPATH',strjoin({storageDir scratchDir toolDir workDir},','));
else
    dbstack; error('not implemented')
end

% Load dependencies (locally managed)
%%% matlab
addpath(genpath(         workDir                                 ))
tool = 'vasomoTools'; toolURL = 'https://github.com/Proulx-S/vasomoTools.git';
if ~exist(fullfile(toolDir, tool), 'dir'); system(['git clone ' toolURL ' ' fullfile(toolDir, tool)]); end
addpath(genpath(fullfile(toolDir,tool)))
tool = 'bassReg2'; toolURL = 'https://github.com/Proulx-S/vasomoTools.git';
if ~exist(fullfile(toolDir, tool), 'dir'); system(['git clone ' toolURL ' ' fullfile(toolDir, tool)]); end
addpath(genpath(fullfile(toolDir,tool)))
tool = 'util'; toolURL = 'https://github.com/Proulx-S/util.git';
if ~exist(fullfile(toolDir, tool), 'dir'); system(['git clone ' toolURL ' ' fullfile(toolDir, tool)]); end
addpath(genpath(fullfile(toolDir,tool)))
tool = 'chronux'; toolURL = 'https://github.com/Proulx-S/chronux';
if ~exist(fullfile(toolDir, tool), 'dir'); system(['git clone ' toolURL ' ' fullfile(toolDir, tool)]); end
addpath(genpath(fullfile(toolDir,'chronux/chronux_2_12/modified')))
tool = 'fieldtrip'; toolURL = 'https://github.com/fieldtrip/fieldtrip';
if ~exist(fullfile(toolDir, tool), 'dir'); system(['git clone ' toolURL ' ' fullfile(toolDir, tool)]); end
addpath(genpath(fullfile(toolDir,'fieldtrip/external/freesurfer')))
tool = 'multigradient'; toolURL = 'https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/4dc86a0f-886b-488c-9318-59a1c9fb0f3e/e5d982ae-3ddd-4768-8b34-8d71d956d893/packages/zip';
if ~exist(fullfile(toolDir, tool), 'dir'); tmpZip = fullfile(tempdir, 'multigradient.zip'); websave(tmpZip, toolURL); unzip(tmpZip, fullfile(toolDir, tool)); delete(tmpZip); end
addpath(genpath(fullfile(toolDir,tool)))

% Clone generalPreproc repository locally
tool = 'generalPreproc'; toolURL = 'https://github.com/Proulx-S/generalPreproc.git';
if ~exist(fullfile(toolDir, tool), 'dir'); system(['git clone ' toolURL ' ' fullfile(toolDir, tool)]); end
addpath(genpath(fullfile(toolDir,tool)))

%%% neurodesk
switch envId
    case 1
        global src
        %%%% afni
        src.afni = 'ml afni/24.3.00';
        system([src.afni '; 3dinfo > /dev/null'],'-echo');
        %%%% ants
        src.ants = 'ml ants/2.5.3';
        system([src.ants '; antsRegistration --version > /dev/null'],'-echo');
        %%%% freesurfer
        src.fs   = 'ml freesurfer/8.0.0';
        system([src.fs   '; mri_convert > /dev/null'],'-echo');
    otherwise
        dbstack; error('not implemented')
end

disp('Dependencies setup completed successfully!')
disp(['Local tools directory: ' toolDir])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load and convert HRdelay data to vsmCenSur data structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up HRdelay analysis parameters (mimicking initAnalysis.m)
HRdelay_wd = fullfile(getenv('HOME'),'/work/vsm/HRdelay');
p.wd = HRdelay_wd;
p.anaID = 'vsmHRdelay_analysis';
p.dataPath.V1 = fullfile(p.wd,'data','V1');
p.meta.subjList = {'02jp' '03sk' '04sp' '05bm' '06sb' '07bj'}';

% Add HRdelay functions to path
addpath(genpath(fullfile(HRdelay_wd,'fun')));

% Download HRdelay data if needed
disp('Getting HRdelay data...')
if ~exist(fullfile(p.dataPath.V1,'ts'),'dir')
    % Need to run HRdelay's downloadData function
    cd(HRdelay_wd);
    downloadData;
    cd(workDir);
    disp('HRdelay data downloaded successfully!')
else
    disp('HRdelay data already available!')
end

% Convert HRdelay data structure to vsmCenSur format
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

%% TODO: Next steps
% 1. Implement detailed HRdelay -> vsmCenSur data conversion
% 2. Extract proper timeseries data for each condition
% 3. Create proper design matrices
% 4. Implement vsmCenSur analysis pipeline

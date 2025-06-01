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
%% Download HRdelay data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HRdelay_wd = fullfile(getenv('HOME'),'/work/vsm/HRdelay');
p = downloadHRdelayData(HRdelay_wd);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Convert HRdelay data to vsmCenSur data structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rCond, info, QA] = convertHRdelayToVsmCenSur(p, workDir);

%% TODO: Next steps
% 1. Implement detailed HRdelay -> vsmCenSur data conversion
% 2. Extract proper timeseries data for each condition
% 3. Create proper design matrices
% 4. Implement vsmCenSur analysis pipeline

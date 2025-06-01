function p = downloadHRdelayData(HRdelay_wd)
%DOWNLOADHRDELAYDATA Download HRdelay data if not already present
%
% Input:
%   HRdelay_wd - Working directory for HRdelay project
%
% Output:
%   p - Structure with HRdelay parameters and paths

% Set up HRdelay analysis parameters (mimicking initAnalysis.m)
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
    currentDir = pwd;
    cd(HRdelay_wd);
    downloadData;
    cd(currentDir);
    disp('HRdelay data downloaded successfully!')
else
    disp('HRdelay data already available!')
end

end 
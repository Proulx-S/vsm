# VSM HRdelay Project Log

## Project Overview
Converting HRdelay neuroimaging data format to vsmCenSur data structure format.

**Subjects**: 02jp, 03sk, 04sp, 05bm, 06sb, 07bj (6 total)
**Conditions**: grat1, grat2, plaid (3 stimulus conditions)
**Data Type**: BOLD fMRI

## Current Status
- ✅ Environment setup completed (MATLAB + neuroimaging tools)
- ✅ Basic conversion framework implemented in `doIt_vsmHRdelay.m`
- ✅ Code refactored into modular functions
- ✅ HRdelay data downloaded successfully  
- ⏳ **CURRENT TASK**: Fix data structure format to match vsmCenSur specification

## TODO List
1. ✅ ~~Wrap data downloading into function (downloadHRdelayData.m)~~
2. ✅ ~~Wrap data conversion into function (convertHRdelayToVsmCenSur.m)~~
3. ⏳ **Fix rCond and dsgn fields to match vsmCenSur format**
4. Extract proper timeseries data for each condition
5. Create proper design matrices
6. Implement vsmCenSur analysis pipeline

## Session Notes

### Session Dec 31, 2024 - Initial Setup
- Created main conversion script
- Set up tool dependencies
- Basic data structure conversion framework

### Session Dec 31, 2024 - Refactoring and Data Download
- Refactored code into modular functions:
  - `downloadHRdelayData.m` - handles data downloading
  - `convertHRdelayToVsmCenSur.m` - handles data conversion
- Successfully downloaded HRdelay data from Zenodo
- Identified issue: rCond structure needs to match vsmCenSur format
- Need to examine vsmCenSur data structure to fix conversion

**Current Issue**: The rCond variable should match the structure defined in the vsmCenSur project, and the dsgn field needs proper design matrix format.

**Next steps**: 
1. Fix data structure format based on vsmCenSur examples
2. Extract actual timeseries data instead of storing raw HRdelay structure
3. Create proper design matrices for each condition

## Key Files
- `doIt_vsmHRdelay.m` - Main conversion script
- `downloadHRdelayData.m` - Data downloading function
- `convertHRdelayToVsmCenSur.m` - Data conversion function
- `HRdelay/` - Source data project
- `vsmCenSur/` - Target format project
- `doIt_vsmHRdelay/` - Working directory for conversion

## Quick Context for AI Assistant
When starting a new session, share this file and mention:
"I'm working on converting HRdelay neuroimaging data to vsmCenSur format. The main script is doIt_vsmHRdelay.m. Please check the PROJECT_LOG.md for current status." 
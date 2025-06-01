# VSM HRdelay Project Log

## Project Overview
Converting HRdelay neuroimaging data format to vsmCenSur data structure format.

**Subjects**: 02jp, 03sk, 04sp, 05bm, 06sb, 07bj (6 total)
**Task**: vglnc (visual vigilance)
**Conditions**: grat1, grat2, plaid (3 stimulus conditions)
**Data Type**: BOLD fMRI

## Current Status
- ✅ Environment setup completed (MATLAB + neuroimaging tools)
- ✅ Code refactored into modular functions
- ✅ HRdelay data downloaded successfully
- ✅ **Fixed rCond and dsgn structure format to use proper runCond and runDsgn classes**
- ✅ **Implemented proper data conversion with run-specific designs**
- ⏳ **CURRENT TASK**: Test and verify the conversion results

## TODO List
1. ✅ ~~Wrap data downloading into function (downloadHRdelayData.m)~~
2. ✅ ~~Wrap data conversion into function (convertHRdelayToVsmCenSur.m)~~
3. ✅ ~~Fix rCond and dsgn fields to match vsmCenSur format~~
4. ✅ ~~Extract proper timeseries data for each condition~~
5. ✅ ~~Create proper design matrices~~
6. ⏳ **Test and validate conversion results**
7. Implement vsmCenSur analysis pipeline

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

### Session Dec 31, 2024 - Fixed Data Structure Format
- **Major breakthrough**: Fixed rCond and dsgn structure format
- Found and used proper `runCond` and `runDsgn` classes from vasomoTools
- Completely rewrote conversion logic to create proper data structure:
  - Each subject is now a single `runCond` object (not nested under acquisition)
  - All runs from both sessions combined into arrays (ses, task, cond, etc.)
  - Run-specific design matrices using `runDsgn` objects
  - Proper separation of task ('vglnc') vs conditions ('grat1', 'grat2', 'plaid')
  - Empty file lists as requested (no invented file paths)
  - Proper handling of excluded runs
- Data conversion now extracts actual stimulus onset times and creates proper design matrices
- Structure follows vsmCenSur conventions and should be compatible with analysis pipeline

**Key Changes Made**:
- Use `runCond()` and `runDsgn()` classes instead of basic structs
- Combine all runs per subject into single object with arrays
- Run-specific designs instead of combined design
- Proper task/condition separation
- Extract actual stimulus timing from HRdelay design matrices

**Next steps**: 
1. Test the conversion results in MATLAB
2. Verify data structure compatibility with vsmCenSur pipeline
3. Run analysis pipeline on converted data

## Key Files
- `doIt_vsmHRdelay.m` - Main conversion script
- `downloadHRdelayData.m` - Data downloading function
- `convertHRdelayToVsmCenSur.m` - Data conversion function (major updates)
- `HRdelay/` - Source data project
- `vsmCenSur/` - Target format project
- `doIt_vsmHRdelay/` - Working directory for conversion

## Quick Context for AI Assistant
When starting a new session, share this file and mention:
"I'm working on converting HRdelay neuroimaging data to vsmCenSur format. The main script is doIt_vsmHRdelay.m. The data structure conversion has been completed using proper runCond/runDsgn classes. Please check the PROJECT_LOG.md for current status." 
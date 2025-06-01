# VSM HRdelay Project Log

## Project Overview
Converting HRdelay neuroimaging data format to vsmCenSur data structure format for 6 subjects (02jp, 03sk, 04sp, 05bm, 06sb, 07bj) with 3 stimulus conditions (grat1, grat2, plaid).

## Progress Summary

### ✅ Code Development (Completed)
- **Main Script**: `doIt_vsmHRdelay.m` - orchestrates the full conversion pipeline
- **Download Function**: `downloadHRdelayData.m` - downloads HRdelay data from Zenodo
- **Conversion Function**: `convertHRdelayToVsmCenSur.m` - converts to vsmCenSur format using proper runCond/runDsgn classes

### ✅ Data Structure Implementation (Completed)
- Each subject: single runCond object (not nested under acquisition)
- Arrays for: ses, task, cond, tr, nFrame
- Task separation: taskList = {'vglnc'}, condList = {'grat1' 'grat2' 'plaid'}
- Design (dsgn): cell array of runDsgn objects, one per run
- Proper stimulus timing extracted from HRdelay design matrices

### ✅ Data Download (Completed)
- Successfully downloaded all HRdelay data from Zenodo
- 6 subjects × 2 sessions each with ~33 total runs
- Data validated and ready for conversion

### ✅ Repository Tracking (Completed)
- **vasomoTools**: Created vsmHRdelay-project branch and committed modification (added 'cond' property to runCond class)
- **Other tool repos**: No project branches created since no changes were made
- **Policy**: Only create project branches for repositories that have actual modifications

### 🔄 Next Steps
1. Test/validate the data conversion pipeline
2. Verify converted data structure compatibility with vsmCenSur analysis tools
3. Document any issues or refinements needed

## Technical Details
- HRdelay data: 2 sessions/subject, 120 timepoints/run, TR=1s, stimulus duration=6s
- Data excludes certain runs as specified in original HRdelay dataset
- Timing converted from binary onsets to seconds for runDsgn compatibility

## Repository Status
- Main project: All changes committed to VSM repo
- vasomoTools: Project branch vsmHRdelay-project created and pushed to GitHub
- Other tool repos: No changes made, no project branches needed

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
# VSM HRdelay Project Log

## Project Overview
Converting HRdelay neuroimaging data format to vsmCenSur data structure format.

**Subjects**: 02jp, 03sk, 04sp, 05bm, 06sb, 07bj (6 total)
**Conditions**: grat1, grat2, plaid (3 stimulus conditions)
**Data Type**: BOLD fMRI

## Current Status
- ✅ Environment setup completed (MATLAB + neuroimaging tools)
- ✅ Basic conversion framework implemented in `doIt_vsmHRdelay.m`
- ✅ Data structure skeleton created
- ⏳ **CURRENT TASK**: Implement detailed data conversion

## TODO List
1. Implement detailed HRdelay → vsmCenSur data conversion
2. Extract proper timeseries data for each condition
3. Create proper design matrices
4. Implement vsmCenSur analysis pipeline

## Session Notes

### Session [DATE] - Initial Setup
- Created main conversion script
- Set up tool dependencies
- Basic data structure conversion framework

### Session [DATE] - [Next session notes]
- [Add notes about what was worked on]
- [Current challenges/blockers]
- [Next steps for following session]

## Key Files
- `doIt_vsmHRdelay.m` - Main conversion script
- `HRdelay/` - Source data project
- `vsmCenSur/` - Target format project
- `doIt_vsmHRdelay/` - Working directory for conversion

## Quick Context for AI Assistant
When starting a new session, share this file and mention:
"I'm working on converting HRdelay neuroimaging data to vsmCenSur format. The main script is doIt_vsmHRdelay.m. Please check the PROJECT_LOG.md for current status." 
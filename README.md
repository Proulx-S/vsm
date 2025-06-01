# VSM HRdelay Data Conversion Project

This project converts neuroimaging data from the HRdelay format to the vsmCenSur data structure format.

## Project Structure

- `doIt_vsmHRdelay.m` - Main conversion script
- `PROJECT_LOG.md` - Detailed project progress and session notes
- `vsm.code-workspace` - VS Code workspace configuration

## Data Directories (Not Tracked)

The following directories contain large datasets and tools, so they are not tracked in git:
- `HRdelay/` - Source data in HRdelay format
- `vsmCenSur/` - Target data structure
- `doIt_vsmHRdelay/` - Working directory with tools and intermediate files

## For AI Assistant Sessions

When starting a new coding session with an AI assistant:

1. Share the `PROJECT_LOG.md` file
2. Mention: "I'm working on converting HRdelay neuroimaging data to vsmCenSur format. Please check the PROJECT_LOG.md and recent git commits for current status."
3. The main script is `doIt_vsmHRdelay.m`

## Setup

The script automatically handles:
- MATLAB environment setup
- Tool dependencies (AFNI, ANTs, FreeSurfer, etc.)
- Data downloading if needed

## Data

- **Subjects**: 6 participants (02jp, 03sk, 04sp, 05bm, 06sb, 07bj)
- **Conditions**: 3 stimulus types (grat1, grat2, plaid)
- **Data Type**: BOLD fMRI 
#
# Module manifest for DiskReportingTools
#

@{
    RootModule           = 'DiskReportingTools.psm1'
    ModuleVersion        = '0.12.0'
    CompatiblePSEditions = @('Core', 'Desktop')
    GUID                 = '20e6a37d-d899-4594-96fe-39ab7f608371'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2021-2025 JDH Information Technology Solutions, Inc.'
    Description          = 'A set of PowerShell tools for disk reporting and visualization. The tools rely on CIM cmdlets so this module requires a Windows platform.'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = @(
        'Show-DriveUsage',
        'Show-DriveView',
        'New-HtmlDriveReport',
        'Get-RecycleBinSize',
        'Show-FolderUsage',
        'Get-DiskReportingTools'
    )
    AliasesToExport = 'sdu', 'rbsz', 'sfu','sdv'
    TypesToProcess = @()
    FormatsToProcess = @(
        'formats\PSDriveUsage.format.ps1xml',
        'formats\RecycleBinInfo.format.ps1xml',
        'formats\modulecommand.format.ps1xml'
    )
    VariablesToExport = 'DiskReportingANSI', 'DiskReportingModule'
    PrivateData = @{
        PSData = @{
            Tags                     = @('disk', 'reporting', 'visualization', 'html', 'drive', 'RecycleBin')
            LicenseUri               = 'https://github.com/jdhitsolutions/DiskReportingTools/blob/main/License.txt'
            ProjectUri               = 'https://github.com/jdhitsolutions/DiskReportingTools'
            #IconUri = ''
            ReleaseNotes             = @"
## [0.12.0] - 2025-06-19

### Added

- Added command `Get-DiskReportingTools` to display a module command summary.

### Changed

- Changed `Threshold` parameter in `Show-FolderUsage` from an `int` to a `double` so users can use a value like 2.5.
- Adjusted Computername title in formatted output for `Show-DriveUsage`.
- Updated `Show-FolderUsage` to show the number of files in the graphical output.
- Added sorting parameters to `Show-FolderUsage`.
- Revised `Show-FolderUsage` to support a `Threshold` value of 0 which should show all extensions.
- Revised `Show-FolderUsage` to convert paths to complete file system paths.
- Refactored `Show-FolderUsage` and `Show-DriveUsage` to support non-Windows platforms in PowerShell 7. These commands use dynamic parameters for Windows-only parameters.
- Updated casing on the `en-US` folder to correct localization problems on non-Windows platforms.
- Added more information stream items to module commands.

### Fixed

- Fixed localization error with Invariant cultures.
- Fixed error in exporting module functions.
"@
            RequireLicenseAcceptance = $false
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}

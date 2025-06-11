#
# Module manifest for DiskReportingTools
#

@{
    RootModule           = 'DiskReportingTools.psm1'
    ModuleVersion        = '0.10.0'
    CompatiblePSEditions = @('Core', 'Desktop')
    GUID                 = '20e6a37d-d899-4594-96fe-39ab7f608371'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2021-2025 JDH Information Technology Solutions, Inc.'
    Description          = 'A set of PowerShell tools for disk reporting and visualization. The tools rely on CIM cmdlets so this module requires a Windows platform.'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = 'Show-DriveUsage', 'Show-DriveView', 'New-HtmlDriveReport', 'Get-RecycleBinSize'
    AliasesToExport      = 'sdu', 'rbsz'
    TypesToProcess       = @()
    FormatsToProcess     = @(
        'formats\PSDriveUsage.format.ps1xml',
        'formats\RecycleBinInfo.format.ps1xml'
    )
    VariablesToExport    = 'DiskReportingANSI', 'DiskReportingModule'
    PrivateData          = @{
        PSData = @{
            Tags                     = @('disk', 'reporting', 'visualization', 'html', 'drive', 'RecycleBin')
            LicenseUri               = 'https://github.com/jdhitsolutions/DiskReportingTools/blob/main/License.txt'
            ProjectUri               = 'https://github.com/jdhitsolutions/DiskReportingTools'
            #IconUri = ''
            ReleaseNotes = @"
# DiskReportingTools
## 0.10.0

This is the first public release to the PowerShell Gallery.

### Changed

- Modified `Get-RecycleBinSize` to accept multiple computer names as a parameter value.
- Updated manifest tags.
- Updated parameter validations.
- Updated commands that query remote computers to support alternate credentials.
- Updated `README.md.`
- Updated help documentation.
"@
            RequireLicenseAcceptance = $false
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}

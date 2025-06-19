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
            ReleaseNotes             = ''
            RequireLicenseAcceptance = $false
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}

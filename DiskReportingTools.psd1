#
# Module manifest for DiskReportingTools
#

@{
    RootModule           = 'DiskReportingTools.psm1'
    ModuleVersion        = '0.9.0'
    CompatiblePSEditions = @('Core', 'Desktop')
    GUID                 = '20e6a37d-d899-4594-96fe-39ab7f608371'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2021-2024 JDH Information Technology Solutions, Inc.'
    Description          = 'A set of PowerShell tools for disk reporting and visualization. The tools rely on CIM cmdlets so this module requires a Windows platform.'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = 'Show-DriveUsage', 'Show-DriveView','New-HTMLDriveReport'
    AliasesToExport      = 'sdu'
    TypesToProcess       = @()
    FormatsToProcess     = @('formats\PSDriveUsage.format.ps1xml')
    VariablesToExport    = 'DiskReportingANSI', 'DiskReportingModule'
    PrivateData          = @{
        PSData = @{
            Tags = @('disk', 'reporting')
            # LicenseUri     = ''
            # ProjectUri     = ''
            # IconUri = ''
            ReleaseNotes = ''
            RequireLicenseAcceptance = $false
            ExternalModuleDependencies = ""
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}

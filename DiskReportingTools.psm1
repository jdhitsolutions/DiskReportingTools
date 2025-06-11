#region Test for Windows

If ($IsLinux -OR $IsMacOS) {
    Write-Host "`e[91;3mThis module is only supported on Windows systems.`e[0m"
    Return
}
#endregion

#region load string data
# used for culture debugging
# write-host "Importing with culture $(Get-Culture)" -ForeGroundColor yellow

if ((Get-Culture).Name -match '\w+') {
    #write-host "Using culture $(Get-Culture)" -ForegroundColor yellow
    Import-LocalizedData -BindingVariable strings
}
else {
    #force using En-US if no culture found, which might happen on non-Windows systems.
    #write-host "Loading $PSScriptRoot/en-us/PSWorkItem.psd1" -ForegroundColor yellow
    Import-LocalizedData -BindingVariable strings -FileName DiskReportingTools.psd1 -BaseDirectory $PSScriptRoot/en-us
}

#endregion

Get-ChildItem $PSScriptRoot\functions\*.ps1 | ForEach-Object { . $_.FullName }

#a hash table to store ANSI escape sequences for different commands used in verbose output with the
#private _verbose helper function
$DiskReportingANSI = @{
    'Show-DriveUsage'     = '[1;38;5;171m'
    'Show-DriveView'      = '[1;38;5;111m'
    'New-HtmlDriveReport' = '[1;38;5;192m'
    'Get-RecycleBinSize'  = '[1;38;5;155m'
    Default               = '[1;38;5;51m'
}
Set-Variable -Name DiskReportingANSI -Description "a hash table to store ANSI escape sequences for different commands used in verbose output. You can modify settings using ANSI sequences or `$PSStyle"

#Export the module version to a global variable that will be used in Verbose messages
New-Variable -Name DiskReportingModule -Value '0.10.0' -Description 'The DiskReportingTools module version used in verbose messaging.'

Export-ModuleMember -Variable DiskReportingANSI, DiskReportingModule -Alias sdu,rbsz
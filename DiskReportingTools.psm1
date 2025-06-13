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

#define ANSI escape sequences for color
$green = "$([char]27)[92m"
$yellow = "$([char]27)[38;5;226m"
$red = "$([char]27)[38;5;197m"
$greenBG = "$([char]27)[42m"
$yellowBG = "$([char]27)[48;5;226m"
$redBG = "$([char]27)[48;5;197m"
$Reset = "$([char]27)[0m"
$bold = "$([char]27)[1m"
$italic = "$([char]27)[3m"
$pathStyle = "$([char]27)[1;4;38;5;227m"
$cnStyle = "$([char]27)[3;38;5;212m"

#a hash table to store ANSI escape sequences for different commands used in verbose output with the
#private _verbose helper function
$DiskReportingANSI = @{
    'Show-DriveUsage'     = '[1;38;5;171m'
    'Show-DriveView'      = '[1;38;5;111m'
    'New-HtmlDriveReport' = '[1;38;5;192m'
    'Get-RecycleBinSize'  = '[1;38;5;155m'
    'Show-FolderUsage'    = '[1;38;5;226m'
    Default               = '[1;38;5;51m'
}
Set-Variable -Name DiskReportingANSI -Description "a hash table to store ANSI escape sequences for different commands used in verbose output. You can modify settings using ANSI sequences or `$PSStyle"

#Export the module version to a global variable that will be used in Verbose messages
$mod = Import-PowerShellDataFile -Path $PSScriptRoot\DiskReportingTools.psd1 -ErrorAction Stop

New-Variable -Name DiskReportingModule -Value $mod.moduleVersion -Description 'The DiskReportingTools module version used in verbose messaging.'

Export-ModuleMember -Variable DiskReportingANSI, DiskReportingModule -Alias sdu, rbsz,sdv,sfu
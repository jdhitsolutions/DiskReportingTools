#requires -version 4.0


Function Show-DriveUsage {

<#
.SYNOPSIS
Display a colorized graph of disk usage
.DESCRIPTION
This command uses the PowerShell console to display a colorized graph of disk usage. The graph will be color coded depending on the amount of free disk space. By default the command will display all fixed drives but you can limit output to a single drive.

NOTE: This command does NOT write anything to the pipeline.
.PARAMETER Computername
 The name of the computer to query. This command has aliases of: CN
.PARAMETER Drive
 The name of the drive to check, including the colon. See examples.
.EXAMPLE
PS C:\> Show-DriveUsage

WIN81-ENT-01
C: [|||||                                             ] 9.14%
D: [|||||                                             ] 9.12%
E: [|||||||||||||||||||||||||||||||||||               ] 70.71%
F: [|||||||||||||||||||||||||                         ] 49.77%

The output would be colored for drives C: and D:, yellow for F: and green for E:
.EXAMPLE
PS C:\> Show-DriveUsage -computer chi-dc04 -drive c:

CHI-DC04
C: [|||||||||||||||||||||||||                         ] 49.63%

.NOTES
NAME        :  Show-DriveUsage
VERSION     :  1.0   
LAST UPDATED:  4/29/2016
AUTHOR      :  Jeff Hicks (@JeffHicks)

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
.LINK
.INPUTS
.OUTPUTS
#>

[cmdletbinding()]
Param(
[Parameter(Position=0)]
[ValidateSet('A:','B:','C:','D:','E:','F:','G:','H:',
'I:','J:','K:','L:','M:','N:','O:','P:',
'Q:','R:','S:','T:','U:','V:','W:','X:','Y:','Z:')]
[string]$Drive,

[ValidateNotNullorEmpty()]
[Alias("CN")]
[string]$Computername = $env:COMPUTERNAME
)

Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"

if ($Drive) {
    $filter = "DeviceID='$Drive'"
}
else {
    $filter = "DriveType = 3"
}

Try {
    Write-Verbose "[PROCESS] Querying $Computername"

    $disks = Get-Ciminstance -ClassName Win32_LogicalDisk -filter $Filter -ComputerName $Computername -ErrorAction Stop
}
Catch {
    Write-Warning "Failed to retrieve disk information from $Computername. $($_.exception.message)"
    #bail out
    Return
}

#display symbol
$sym = " "

Write-Host "`n$($disks[0].SystemName)"
foreach ($disk in $disks) {
    Write-Verbose ($disk | Select DeviceID,Size,Freespace | Out-String)
    #calculate %free but use a scale of 0 to 50
    [double]$pct = ($disk.FreeSpace/$disk.Size )*50
    [int]$used = 50 - $pct

    #show the actual percentage
    $displayPct = [math]::Round($pct*2,2)
   
    #the comparison value is a relative percentage
    #based on 0 to 50
    if ($pct -ge 30) {
        $color = "DarkGreen"
    }
    elseif ($pct -ge 10) {
        $color = "Yellow"
    }
    else {
        $color = "Red"
    }
        
    write-host "$($disk.deviceID) [" -nonewline
    Write-Host "$($sym * $pct)" -nonewline -backgroundColor $color
    Write-Host "$(' '*$used)" -nonewline
    write-Host "] " -noNewLine
    Write-Host "$DisplayPct%" -ForegroundColor $color
} #foreach

Write-Host "`n"
Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"

}

Set-Alias -name sdu -value Show-DriveUsage
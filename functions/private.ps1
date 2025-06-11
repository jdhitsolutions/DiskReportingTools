#these are the module's private helper functions

function _verbose {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Message,
        [string]$Block = 'PROCESS',
        [string]$Command
    )

    #Display each command name in a different color sequence
    if ($global:DiskReportingAnsi.ContainsKey($Command)) {
        [string]$ANSI =  $global:DiskReportingAnsi[$Command]
    }
    else {
        [string]$ANSI =  $global:DiskReportingAnsi['DEFAULT']
    }

    $BlockString = $Block.toUpper().PadRight(7, ' ')
    $Reset = "$([char]27)[0m"
    $ToD = (Get-Date).TimeOfDay
    $AnsiCommand = "$([char]27)$Ansi$($command)"
    $Italic = "$([char]27)[3m"
    #Write-Verbose "[$((Get-Date).TimeOfDay) $BlockString] $([char]27)$Ansi$($command)$([char]27)[0m: $([char]27)[3m$message$([char]27)[0m"
    if ($Host.Name -eq 'Windows PowerShell ISE Host') {
        $msg = '[{0} {1}] {2}-> {3}' -f $Tod, $BlockString, $Command, $Message
    }
    else {
        $msg = '[{0} {1}] {2}{3}-> {4} {5}{3}' -f $Tod, $BlockString, $AnsiCommand, $Reset, $Italic, $Message
    }
    Write-Verbose -Message $msg

}


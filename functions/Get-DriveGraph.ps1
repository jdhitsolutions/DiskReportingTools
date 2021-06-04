
Function Show-DriveUsage {


    [cmdletbinding()]
    [alias("sdu")]
    Param(
        [Parameter(Position = 0)]
        [ValidateSet('A:', 'B:', 'C:', 'D:', 'E:', 'F:', 'G:', 'H:',
            'I:', 'J:', 'K:', 'L:', 'M:', 'N:', 'O:', 'P:',
            'Q:', 'R:', 'S:', 'T:', 'U:', 'V:', 'W:', 'X:', 'Y:', 'Z:')]
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

        $disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter $Filter -ComputerName $Computername -ErrorAction Stop
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
        Write-Verbose ($disk | Select-Object DeviceID, Size, Freespace | Out-String)
        #calculate %free but use a scale of 0 to 50
        [double]$pct = ($disk.FreeSpace / $disk.Size ) * 50
        [int]$used = 50 - $pct

        #show the actual percentage
        $displayPct = [math]::Round($pct * 2, 2)

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

        Write-Host "$($disk.deviceID) [" -NoNewline
        Write-Host "$($sym * $pct)" -NoNewline -BackgroundColor $color
        Write-Host "$(' '*$used)" -NoNewline
        Write-Host "] " -NoNewline
        Write-Host "$DisplayPct%" -ForegroundColor $color
    } #foreach

    Write-Host "`n"
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"

}

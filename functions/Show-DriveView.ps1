Function Show-DriveView {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("cn")]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName = $env:ComputerName
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
        #initialize an array to hold results
        $data = @()

        #mapping hashtable
        $TypeMap = @{
            0 = "Unknown"
            1 = "NoRootDirectory"
            2 = "RemovableDisk"
            3 = "LocalDisk"
            4 = "NetworkDrive"
            5 = "CD/DVD"
            6 = "RAMDisk"
        }

    } #begin

    Process {

        foreach ($computer in $ComputerName) {
            Write-Verbose "[PROCESS] Querying $($Computer.toUpper())"
            Try {
                $data += Get-CimInstance -class win32_logicaldisk -ComputerName $computer -ErrorAction Stop |
                Select-Object @{Name = "ComputerName"; Expression = { $_.SystemName } },
                @{Name = "Drive"; Expression = { $_.DeviceID } },
                @{Name = "Label"; Expression = { $_.VolumeName } },
                @{Name = "Type"; Expression = { $TypeMap.item($_.DriveType -as [int]) } },
                @{Name = "SizeGB"; Expression = { [int]($_.Size / 1GB) } },
                @{Name = "FreeGB"; Expression = { [math]::Round($_.FreeSpace / 1GB, 2) } },
                @{Name = "UsedGB"; Expression = { [math]::round(($_.size - $_.FreeSpace) / 1GB, 2) } },
                @{Name = "Free%"; Expression = { [math]::round(($_.FreeSpace / $_.Size) * 100, 2) } },
                @{Name = "FreeGraph"; Expression = {
                        [int]$per = ($_.FreeSpace / $_.Size) * 100
                        "|" * $per }
                }
            } #try
            Catch {
                Write-Error "[$($Computer.toUpper())] $($_.exception.message)"

            }
        } #foreach

    } #process

    End {
        #send the results to Out-GridView
        $data | Out-GridView -Title "Drive Report"

        Write-Verbose "[END    ] Ending: $($MyInvocation.MyCommand)"
    } #end

}

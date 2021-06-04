Function Show-DriveView {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("cn")]
        [ValidateNotNullorEmpty()]
        [string[]]$Computername = $env:COMPUTERNAME
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        #initialize an array to hold results
        $data = @()

        #mapping hashtable
        $typemap = @{
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

        foreach ($computer in $Computername) {
            Write-Verbose "[PROCESS] Querying $($Computer.toUpper())"
            Try {
                $data += Get-CimInstance -class win32_logicaldisk -ComputerName $computer -ErrorAction Stop |
                Select-Object @{Name = "Computername"; Expression = { $_.Systemname } },
                @{Name = "Drive"; Expression = { $_.DeviceID } },
                @{Name = "Label"; Expression = { $_.volumename } },
                @{Name = "Type"; Expression = { $typeMap.item($_.DriveType -as [int]) } },
                @{Name = "SizeGB"; Expression = { [int]($_.Size / 1GB) } },
                @{Name = "FreeGB"; Expression = { [math]::Round($_.Freespace / 1GB, 2) } },
                @{Name = "UsedGB"; Expression = { [math]::round(($_.size - $_.Freespace) / 1GB, 2) } },
                @{Name = "Free%"; Expression = { [math]::round(($_.Freespace / $_.Size) * 100, 2) } },
                @{Name = "FreeGraph"; Expression = {
                        [int]$per = ($_.Freespace / $_.Size) * 100
                        "|" * $per }
                }
            } #try
            Catch {
                Write-Error "[$($Computer.toUpper())] $($_.exception.message)"

            }
        } #foreach

    } #process

    End {
        #send the results to Out-Gridview
        $data | Out-GridView -Title "Drive Report"

        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end

}
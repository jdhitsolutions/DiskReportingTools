Function Show-DriveUsage {
    [cmdletbinding(DefaultParameterSetName = '__AllParameterSets')]
    [OutputType('PSDriveUsageRaw',ParameterSetName='raw')]
    [OutputType('PSDriveUsage',ParameterSetName='__AllParameterSets')]
    [alias('sdu')]
    Param(
        [Parameter(Position = 0)]
        [ValidateSet('A:', 'B:', 'C:', 'D:', 'E:', 'F:', 'G:', 'H:',
            'I:', 'J:', 'K:', 'L:', 'M:', 'N:', 'O:', 'P:',
            'Q:', 'R:', 'S:', 'T:', 'U:', 'V:', 'W:', 'X:', 'Y:', 'Z:')]
        [string]$Drive,

        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the name of a remote computer. You must have admin rights. The default is the localhost.'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [string[]]$ComputerName = $env:ComputerName,

        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify an alternate credential for the remote computer.'
        )]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential,

        [Parameter(ParameterSetName = 'raw', HelpMessage = 'Display raw output without formatting.')]
        [switch]$Raw
    )

    Begin {
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        $PSDefaultParameterValues['_verbose:block'] = 'Begin'
        _verbose -message $strings.Starting
        if ($MyInvocation.CommandOrigin -eq 'Runspace') {
            #Hide this metadata when the command is called from another command
            _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
            _verbose -message ($strings.UsingHost -f $host.Name)
            _verbose -message ($strings.UsingModule -f $DiskReportingModule)
        }
        if ($Drive) {
            $filter = "DeviceID='$Drive'"
        }
        else {
            $filter = 'DriveType = 3'
        }

    } #begin
    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'
        Write-Information $PSBoundParameters -Tags runtime
        ForEach ($computer in $ComputerName) {
            Try {
                _verbose -message ($strings.QueryComputer -f $Computer.toUpper())
                #create a temporary CIM session
                If ($Credential) {
                    _verbose ($strings.RunAs -f $Credential.UserName)
                    $cs = New-CimSession -ComputerName $Computer -Credential $Credential -ErrorAction Stop
                }
                else {
                    $cs = New-CimSession -ComputerName $Computer -ErrorAction Stop
                }

                $disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter $Filter -CimSession $cs -ErrorAction Stop
                Write-Information $disks -Tags data
            }
            Catch {
                Write-Warning ($strings.DiskFailure -f $ComputerName, $_.exception.message)
                #bail out
                Return
            }

            #display symbol
            $sym = ' '

            if ($Raw) {
               $cn = $disks[0].SystemName
               $typeName = 'PSDriveUsageRaw'
            }
            else {
                $cn = "{0}{1}{2}{3}" -f $bold, $italic, $disks[0].SystemName, $reset
                $typeName = 'PSDriveUsage'
            }
            $h = [ordered]@{
                PSTypeName   = $typeName
                ComputerName =  $cn
            }

            $diskInfo = @()

            foreach ($disk in $disks) {
                Write-Debug ($disk | Select-Object DeviceID, Size, FreeSpace | Out-String)
                #calculate %free but use a scale of 0 to 50
                [double]$pct = ($disk.FreeSpace / $disk.Size ) * 50
                if ($Raw) {
                    #add the percentage to the disk object
                    $disk | Add-Member -MemberType NoteProperty -Name 'PercentageFree' -Value $pct
                }
                [int]$used = 50 - $pct

                #show the actual percentage
                $displayPct = [math]::Round($pct * 2, 2)

                #the comparison value is a relative percentage
                #based on 0 to 50
                if ($pct -ge 30) {
                    $bgColor = $greenBG
                    $fgColor = $green
                }
                elseif ($pct -ge 10) {
                    $bgColor = $yellowBG
                    $fgColor = $yellow
                }
                else {
                    $bgColor = $redBG
                    $fgColor = $red
                }

                if ($raw) {
                    $di = $disk | Select-Object -Property VolumeName,DeviceID,Size,FreeSpace,PercentageFree,Compressed
                }
                else {
                    $di = '{0} [{1}{2}{3}{4}] {5}{6}%{3}' -f $disk.DeviceID, $bgColor, ($sym * $pct), $Reset, (' ' * $used), $fgColor, $DisplayPct
                }
                $diskInfo += $di

            } #foreach

            $h.Add('Drives', $diskInfo)

            New-Object PSObject -Property $h

            if ($cs) {
                $cs | Remove-CimSession -ErrorAction SilentlyContinue
            }
        }  #foreach computer
    } #process
    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        _verbose $strings.Ending
    } #end
}

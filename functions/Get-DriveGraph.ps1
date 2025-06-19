Function Show-DriveUsage {
    [cmdletbinding(DefaultParameterSetName = '__AllParameterSets')]
    [OutputType('PSDriveUsageRaw', 'PSDriveUsage')]
    [alias('sdu')]
    Param(
        [Parameter(HelpMessage = 'Display raw output without formatting.')]
        [switch]$Raw
    )
    DynamicParam {
        If ($isWindows -OR ($PSEdition -eq 'Desktop')) {
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

            #Drive
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = 'Windows'
            $attributes.HelpMessage = 'Specify a drive like C:'

            # Adding ValidateSet parameter validation
            $value = @('A:', 'B:', 'C:', 'D:', 'E:', 'F:', 'G:', 'H:',
                'I:', 'J:', 'K:', 'L:', 'M:', 'N:', 'O:', 'P:',
                'Q:', 'R:', 'S:', 'T:', 'U:', 'V:', 'W:', 'X:', 'Y:', 'Z:')
            $v = New-Object System.Management.Automation.ValidateSetAttribute($value)
            $AttributeCollection.Add($v)
            $attributeCollection.Add($attributes)

            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('Drive', [String], $attributeCollection)
            $paramDictionary.Add('Drive', $dynParam1)

            #Computername
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = 'Windows'
            $attributes.ValueFromPipelineByPropertyName = $True
            $attributes.ValueFromPipeline = $True
            $attributes.HelpMessage = 'Specify the name of a remote computer. You must have admin rights. The default is the localhost.'

            $v = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
            $AttributeCollection.Add($v)
            $attributeCollection.Add($attributes)

            $dynAlias = New-Object System.Management.Automation.AliasAttribute -ArgumentList 'CN'
            $attributeCollection.Add($dynAlias)

            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('ComputerName', [String[]], $attributeCollection)
            $dynParam1.Value = $env:Computername
            $paramDictionary.Add('ComputerName', $dynParam1)

            #credential
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = 'Windows'
            $attributes.ValueFromPipelineByPropertyName = $True
            $attributes.HelpMessage = 'specify an alternate credential'

            $v = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
            $AttributeCollection.Add($v)
            $attributeCollection.Add($attributes)

            $dynAlias = New-Object System.Management.Automation.AliasAttribute -ArgumentList 'RunAs'
            $attributeCollection.Add($dynAlias)

            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('Credential', [PSCredential], $attributeCollection)
            $paramDictionary.Add('Credential', $dynParam1)

            return $paramDictionary
        } # end if
    } #end DynamicParam

    Begin {
        if ($IsMacOS) {
            Write-Warning $strings.Unsupported
            break
        }
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        Write-Information $MyInvocation -Tags runtime
        $PSDefaultParameterValues['_verbose:block'] = 'Begin'
        _verbose -message $strings.Starting
        $platformOS = If ($PSVersionTable.OS) {
            $PSVersionTable.OS
        }
        else {
            'Windows'
        }
        if ($MyInvocation.CommandOrigin -eq 'Runspace') {
            #Hide this metadata when the command is called from another command
            _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
            _verbose -message ($strings.UsingHost -f $host.Name)
            _verbose -message ($strings.UsingOS -f $platformOS)
            _verbose -message ($strings.UsingModule -f $DiskReportingModule)
        }

        #display symbol
        $sym = ' '

        If ($IsWindows -OR ($PSEdition -eq 'Desktop')) {
            #Windows only settings
            $Drive = $PSBoundParameters['Drive']
            if ($Drive) {
                $filter = "DeviceID='$Drive'"
            }
            else {
                $filter = 'DriveType = 3'
            }
        }
    } #begin
    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'
        _verbose ($strings.DetectedParameterSet -f $PSCmdlet.ParameterSetName)
        Write-Information $PSBoundParameters -Tags runtime
        Write-Information $ParamDictionary -Tags runtime

        If ($IsWindows -OR ($PSEdition -eq 'Desktop')) {
            if (-Not $PSBoundParameters.ContainsKey('ComputerName')) {
                $Computername = $env:computername
            }
            else {
                #get the value from the dynamic parameter
                $Computername = $PSBoundParameters['ComputerName']
            }
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

                if ($Raw) {
                    $cn = $disks[0].SystemName
                    $typeName = 'PSDriveUsageRaw'
                }
                else {
                    $cn = '{0}{1}{2}{3}' -f $bold, $italic, $disks[0].SystemName, $reset
                    $typeName = 'PSDriveUsage'
                }
                $h = [ordered]@{
                    PSTypeName   = $typeName
                    ComputerName = $cn
                }

                $diskInfo = @()

                foreach ($disk in $disks) {
                    Write-Debug ($disk | Select-Object DeviceID,Size,FreeSpace | Out-String)
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
                    #colors are defined as module-scoped variables
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
                        $di = $disk | Select-Object -Property VolumeName, DeviceID, Size, FreeSpace, PercentageFree, Compressed
                    }
                    else {
                        $di = '{0} [{1}{2}{3}{4}] {5}{6}%{3}' -f $disk.DeviceID, $bgColor, ($sym * $pct), $Reset, (' '*$used), $fgColor, $DisplayPct
                    }
                    $diskInfo += $di

                } #foreach

                $h.Add('Drives', $diskInfo)

                New-Object PSObject -Property $h

                if ($cs) {
                    $cs | Remove-CimSession -ErrorAction SilentlyContinue
                }
            }  #foreach computer
        } #Windows
        else {
            #Linux code using df
            'df', 'tr' | ForEach-Object {
                Try {
                    $n = $_
                    $cmd = Get-Command -Name $n -ErrorAction Stop
                }
                Catch {
                    Write-Warning ($strings.missingCommand -f $n)
                    #bail out
                    break
                }
            } #foreach

            $drives = df -l | tr -s ' ' | Select-Object -Skip 1 |
            ConvertFrom-Csv -Delimiter ' ' -Header 'Path', 'TotalSize', 'Used', 'Free', 'UsedPercent', 'Mount' |
            where { $_.Path -match '^/dev' } |
            Select-Object -Property 'Path','TotalSize','Used','Free',
            @{Name = 'UsedPercent'; Expression = { ($_.UsedPercent -replace '%', '') -as [int]}}, Mount

            Write-Information $drives -Tags data,linux
            if ($Raw) {
                [PSCustomObject]@{
                    PSTypeName   = 'PSDriveUsageRaw'
                    ComputerName = [System.Environment]::MachineName.ToUpper()
                    Drives = $Drives
                }
            }
            else {
                $h = @{
                    PSTypeName   = 'PSDriveUsage'
                    ComputerName = [System.Environment]::MachineName.ToUpper()
                }
                $di = @()
                foreach ($item in $drives) {
                    [double]$pct = ($item.Free / $item.TotalSize) * 50

                    $displayPct = 100-$item.UsedPercent
                    [int]$used = 50 - $pct
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

                    $di += '{0} [{1}{2}{3}{4}] {5}{6}%{3}' -f $item.Path, $bgColor, ($sym * $pct), $Reset, (' ' *$used), $fgColor, $DisplayPct

                }
                $h.Add('Drives', $di)
                New-Object PSObject -Property $h
            }
        }
    } #process
    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        _verbose $strings.Ending
        Write-Information $strings.Ending -Tags runtime
    } #end
}

<#
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
#>
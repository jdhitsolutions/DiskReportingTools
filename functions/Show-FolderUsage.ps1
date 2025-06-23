Function Show-FolderUsage {
    [cmdletbinding(DefaultParameterSetName = '__AllParameterSets')]
    [alias('sfu')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the path to the folder to analyze. Use a full file system path')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the minimum percentage to display. The default is 5%'
        )]
        [ValidateRange(0, 99)]
        [double]$Threshold = 5,

        [Parameter(HelpMessage = "Sort the graphical output by size or extension in ascending order")]
        [ValidateSet('Size', 'Name')]
        [string]$Sort = "Name",

        [switch]$Descending,

        [Parameter(HelpMessage = 'Display raw output without formatting.')]
        [switch]$Raw
    )
    DynamicParam {
        If ($isWindows -OR ($PSEdition -eq 'Desktop')) {
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

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
            $dynParam1.Value = '$env:Computername'
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
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        $PSDefaultParameterValues['_verbose:block'] = 'Begin'
        _verbose -message $strings.Starting
        Write-Information $MyInvocation -Tags runtime
        if ($MyInvocation.CommandOrigin -eq 'Runspace') {
            $platformOS = If ($PSVersionTable.OS) {
                $PSVersionTable.OS
            }
            else {
                'Windows'
            }

            #Hide this metadata when the command is called from another command
            _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
            _verbose -message ($strings.UsingHost -f $host.Name)
            _verbose -message ($strings.UsingOS -f $platformOS)
            _verbose -message ($strings.UsingModule -f $DiskReportingModule)
        }

        $sym = ' '

        #define the scriptblock to run remotely
        $sb = {
            param($path)
            Try {
                #validate the path
                $test = Get-Item -Path $path -ErrorAction Stop
                $files = Get-ChildItem -Path $path -File -Recurse -ErrorAction Stop
            }
            Catch {
                $_
            }
            If ($files) {
                $files | Group-Object -Property extension |
                Select-Object -Property Name, Count,
                @{Name = 'Size'; Expression = { ($_.Group | Measure-Object -Property length -Sum).sum } },
                @{Name = 'Computername'; Expression = { [System.Environment]::MachineName } }
            }
        }

        $icmSplat = @{
            ScriptBlock  = $sb
            ArgumentList = ''
            ErrorAction  = 'Stop'
        }
    } #begin
    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'
        $Path = Convert-Path $Path
        $icmSplat['ArgumentList'] = $Path
        _verbose ($strings.DetectedParameterSet -f $PSCmdlet.ParameterSetName)
        Write-Information $PSBoundParameters -Tags runtime
        if ($PSCmdlet.ParameterSetName -eq 'Windows') {
            $Credential = $PSBoundParameters['Credential']
            If ($Credential) {
                _verbose ($strings.RunAs -f $Credential.UserName)
                $icmSplat['Credential'] = $Credential
            }
            $ComputerName = $PSBoundParameters['ComputerName']
        } #Windows
        else {
            $Computername = [System.Environment]::MachineName
        }
        #Process computers individually
        foreach ($Computer in $ComputerName) {
            _verbose ($strings.FolderUsage -f $Path, ($Computer.ToUpper()))
            if ($computer -ne [System.Environment]::MachineName) {
                #don't include the local computer name for Invoke-Command
                $icmSplat['ComputerName'] = $Computer
                $icmSplat['HideComputerName'] = $True
            }
            else {
                #make sure Computername has been removed
                $icmSplat.Remove('ComputerName')
                $icmSplat.Remove('HideComputerName')
            }
            Write-Information $icmSplat -Tags runtime
            Try {
                $data = Invoke-Command @icmSplat
            }
            Catch {
                Write-Information $_ -Tags error
                $_
            }

            If ($data) {
                #get the total sum of all files
                $totalSum = ($data | Measure-Object -Property size -Sum).Sum
                $totalCount = ($data | Measure-Object -Property Count -Sum).Sum
                Write-Information "Total size: $totalSum bytes" -Tags data
                $data | Add-Member -MemberType NoteProperty -Name 'Total' -Value $totalSum -Force
                $data | Add-Member -MemberType ScriptProperty -Name 'Pct' -Value { ($this.Size / $this.total) * 100 } -Force
                Write-Information $data -Tags data

                if ($raw) {
                    $data.PSObject.Properties.Remove("RunspaceID")
                    $data | Add-Member -MemberType NoteProperty -Name Path -Value (_toTitleCase $Path) -Force
                    $data.PSObject.TypeNames.Insert(0, 'FolderUsageRaw')
                    $data
                }
                else {
                    #format the results
                    $header = "[$cnStyle{1}$reset] $pathStyle{0}$reset" -f (_toTitleCase $Path), $data[0].Computername
                    #this will be the output
                    $out = @"

$header


"@
                    #filter out extensions with less than the threshold percentage
                    $filtered = $data.Where({ $_.Pct -ge $Threshold }) | Sort-Object -Property $Sort -Descending:$Descending
                    #get longest extension name
                    $maxLength = ($filtered.name) | Select-Object -ExpandProperty length |
                    Sort-Object | Select-Object -Last 1
                    #get the longest file count
                    [string]$maxCount = ($filtered | Sort-Object Count | Select -Last 1 -ExpandProperty Count)

                    foreach ($item in $filtered) {
                        $pct = $item.Pct
                        [double]$scaled = $pct / 2
                        [int]$used = 50 - $scaled
                        $displayPct = [math]::Round($scaled * 2, 2)
                        $bar = ($sym * $scaled)

                        $remain = 50 - $scaled
                        #colors are defined as module-scoped variables
                        if ($pct -gt 50) {
                            $bgColor = $redBG
                            $fgColor = $red
                        }
                        elseif ($pct -gt 20) {
                            $bgColor = $yellowBG
                            $fgColor = $yellow
                        }
                        else {
                            $bgColor = $greenBG
                            $fgColor = $green
                        }

                        #19 June 2025 Include file count in the output
                        #format as Black
                        $fileCount = "$([char]27)[30m{0}" -f ([string]$item.count).PadRight($maxCount.Length)
                        $out += "{0} [{1} {7}{2}{3}{4}] {5}{6:P2}{3}`n" -f ($item.Name).PadRight($maxLength), $bgColor, $bar, $Reset, (' ' * $remain), $fgColor, ($pct / 100),$fileCount

                    } #foreach item

                     $out +="`n{0:N0} total files measuring {1:N2}MB" -f $totalCount, ($totalSum / 1MB)
                    $out
                }
                Clear-Variable -Name data
            } #if data
        } #foreach computer
    } #process
    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        _verbose $strings.Ending
        Write-Information $strings.Ending -Tags runtime
    } #end
}

<#
Function Show-FolderUsage {
    [cmdletbinding(DefaultParameterSetName = '__AllParameterSets')]
    [alias('sfu')]
    [OutputType('PSObject',ParameterSetName='raw')]
    [OutputType('System.String',ParameterSetName='__AllParameterSets')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the path to the folder to analyze. Use a full file system path')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(
            Position = 1,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the name of a remote computer. You must have admin rights. The default is the localhost.'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("CN")]
        [string[]]$ComputerName = [System.Environment]::MachineName,

        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify an alternate credential for the remote computer.'
        )]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential,

        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the minimum percentage to display. The default is 5%'
        )]
        [ValidateRange(1, 99)]
        [int]$Threshold = 5,

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

        $sym = ' '

        #define the scriptblock to run remotely
        $sb = {
            param($path)
            Try {
                #validate the path
                $test = Get-Item -Path $path -ErrorAction Stop
                $files = Get-ChildItem -Path $path -File -Recurse -ErrorAction Stop
            }
            Catch {
                $_
            }
            If ($files) {
                $files | Group-Object -Property extension |
                Select-Object -Property Name, Count,
                @{Name = 'Size'; Expression = { ($_.Group | Measure-Object -Property length -Sum).sum } }
            }
        }

        $icmSplat = @{
            ScriptBlock      = $sb
            ArgumentList     = ''
            HideComputerName = $True
            ErrorAction      = 'Stop'
        }

    } #begin
    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'
        Write-Information $PSBoundParameters -Tags runtime
        If ($Credential) {
            _verbose ($strings.RunAs -f $Credential.UserName)
            $icmSplat['Credential'] = $Credential
        }
        #Process computers individually
        foreach ($Computer in $ComputerName) {
            _verbose ($strings.FolderUsage -f $Path, ($Computer.ToUpper()))
            $icmSplat['ArgumentList'] = $Path
            $icmSplat['ComputerName'] = $Computer
            Write-Information $icmSplat -Tags runtime
            Try {
                $data = Invoke-Command @icmSplat
            }
            Catch {
                $_
            }

            If ($data) {
                #get the total sum of all files
                $totalSum = ($data | Measure-Object -Property size -Sum).Sum
                Write-Information "Total size: $totalSum bytes" -Tags data
                $data | Add-Member -MemberType NoteProperty -Name 'Total' -Value $totalSum -Force
                $data | Add-Member -MemberType ScriptProperty -Name 'Pct' -Value { ($this.Size / $this.total) * 100 } -Force
                Write-Information $data -Tags data

                if ($raw) {
                    $data | Select-Object -Property *,
                    @{Name="Path";Expression={_toTitleCase $Path}},
                    @{Name="ComputerName" ;Expression = {$_.PSComputername.ToUpper()}} -ExcludeProperty RunspaceID
                }
                else {
                    #format the results
                    $header = "[$cnStyle{1}$reset] $pathStyle{0}$reset" -f (_toTitleCase $Path), $data[0].PSComputername.ToUpper()
                    #this will be the output
                    $out = @"

$header


"@
                    #filter out extensions with less than the threshold percentage
                    $filtered = $data.Where({ $_.Pct -ge $Threshold })
                    #get longest extension name
                    $maxLength = ($filtered.name) | Select-Object -ExpandProperty length | Sort-Object | Select-Object -Last 1

                    foreach ($item in $filtered) {
                        $pct = $item.Pct
                        [double]$scaled = $pct / 2
                        [int]$used = 50 - $scaled
                        $displayPct = [math]::Round($scaled * 2, 2)
                        $bar = ($sym * $scaled)
                        $remain = 50 - $scaled
                        if ($pct -gt 50) {
                            $bgColor = $redBG
                            $fgColor = $red
                        }
                        elseif ($pct -gt 20) {
                            $bgColor = $yellowBG
                            $fgColor = $yellow
                        }
                        else {
                            $bgColor = $greenBG
                            $fgColor = $green
                        }
                        $out += "{0} [{1}{2}{3}{4}] {5}{6:P2}{3}`n" -f ($item.Name).PadRight($maxLength), $bgColor, $bar, $Reset, (' ' * $remain), $fgColor, ($pct / 100)

                    } #foreach item

                    $out
                }
            } #if data


        } #foreach computer
    } #process
    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        _verbose $strings.Ending
    } #end
}
#>
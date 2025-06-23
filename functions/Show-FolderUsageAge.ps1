Function Show-FolderUsageAge {
    [cmdletbinding(DefaultParameterSetName = '__AllParameterSets')]
    [alias('sfa')]
    [OutputType("FileAging","None")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the path to the folder to analyze. Use a full file system path')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(HelpMessage = "Specify the file aging property. Default is 'LastWriteTime'.")]
        [ValidateSet('LastWriteTime', 'CreationTime')]
        [string]$Property = 'LastWriteTime',

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
            $attributes.ValueFromPipeline = $true
            $attributes.ValueFromPipelineByPropertyName = $True
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
        $sb = {
            Param($Path, $Property, $Warning)

            Try {
                #validate the path
                $test = Get-Item -Path $path -ErrorAction Stop
                $Path = Convert-Path $Path
                $files = Get-ChildItem -Path $path -File -Recurse -ErrorAction Stop
                $now = Get-Date
            }
            Catch {
                $_
            }
            If ($files) {
                #initialize
                $Total2yr = 0
                $Total90 = 0
                $Total6mo = 0
                $Total1yr = 0
                $Total30 = 0
                $Total7 = 0
                $TotalCurrent = 0
                $2yrs = 0
                $1yr = 0
                $6mo = 0
                $3mo = 0
                $1mo = 0
                $1wk = 0
                $current = 0
                $count = 0

                #enumerate files and get information
                foreach ($file in $files) {
                    #$age = ($now.subtract(($file.LastWriteTime))).days
                    $age = (New-TimeSpan -Start $file.$Property -End $now).Days
                    $count = $count + 1
                    Write-Progress -Activity 'File Aging Report' -Status 'Processing files in folder' -CurrentOperation $file.DirectoryName
                    switch ($age) {
                        { $age -ge 730 } { $2yrs = $2yrs + 1; $Total2yr = $Total2Yr + $file.length; break }
                        { $age -ge 365 } { $1yr = $1yr + 1; $Total1yr = $Total1Yr + $file.length; break }
                        { $age -ge 180 } { $6mo = $6mo + 1; $Total6mo = $Total6mo + $file.length; break }
                        { $age -ge 90 } { $3Mo = $3Mo + 1; $Total90 = $Total90 + $file.length; break }
                        { $age -ge 30 } { $1Mo = $1Mo + 1; $Total30 = $Total30 + $file.length; break }
                        { $age -ge 7 } { $1wk = $1wk + 1; $Total7 = $Total7 + $file.length; break }
                        { $age -lt 7 } { $current = $current + 1; $TotalCurrent = $TotalCurrent + $file.Length; break }
                    }
                }
                Write-Progress -Activity 'File Aging Report' -Completed -Status "Processed $count files."
                $grandTotal = ($files | Measure-Object -Property Length -Sum).Sum

                $buckets = @()
                $buckets += [PSCustomObject]@{
                    PSTypeName = 'FileAgingGroup'
                    Name       = '2Yrs'
                    Count      = $2yrs
                    Size       = $Total2yr
                    PctTotal   = ($Total2yr / $grandTotal) * 100
                }
                $buckets += [PSCustomObject]@{
                    PSTypeName = 'FileAgingGroup'
                    Name       = '1Yrs'
                    Count      = $1yr
                    Size       = $Total1yr
                    PctTotal   = ($Total1yr / $grandTotal) * 100
                }
                $buckets += [PSCustomObject]@{
                    PSTypeName = 'FileAgingGroup'
                    Name       = '6Mo'
                    Count      = $6mo
                    Size       = $Total6mo
                    PctTotal   = ($Total6mo / $grandTotal) * 100
                }
                $buckets += [PSCustomObject]@{
                    PSTypeName = 'FileAgingGroup'
                    Name       = '3Mo'
                    Count      = $3mo
                    Size       = $Total90
                    PctTotal   = ($Total90 / $grandTotal) * 100
                }
                $buckets += [PSCustomObject]@{
                    PSTypeName = 'FileAgingGroup'
                    Name       = '1Mo'
                    Count      = $1mo
                    Size       = $Total30
                    PctTotal   = ($Total30 / $grandTotal) * 100
                }
                $buckets += [PSCustomObject]@{
                    PSTypeName = 'FileAgingGroup'
                    Name       = '1Wk'
                    Count      = $1wk
                    Size       = $Total7
                    PctTotal   = ($Total7 / $grandTotal) * 100
                }
                $buckets += [PSCustomObject]@{
                    PSTypeName = 'FileAgingGroup'
                    Name       = 'Current'
                    Count      = $current
                    Size       = $TotalCurrent
                    PctTotal   = ($TotalCurrent / $grandTotal) * 100
                }

                [PSCustomObject]@{
                    PSTypeName   = 'FileAging'
                    Path         = $Path
                    Property     = $Property
                    AgingGroups  = $buckets
                    TotalFiles   = $count
                    TotalSize    = $grandTotal
                    Computername = [System.Environment]::MachineName
                }
            } #if
            else {
                Write-Warning $Warning
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

        $icmSplat['ArgumentList'] = @($Path, $Property, $strings.NoFiles)
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
                Write-Information $data -Tags data
                #update type names
                $data.PSObject.Properties.Remove('RunspaceID')
                if ($Raw) {
                    $data.PSObject.TypeNames.Insert(0, 'FileAging')
                    $data.AgingGroups.foreach({ $_.PSObject.TypeNames.Insert(0, 'FileAgingGroup') })
                    $data
                }
                else {
                    #Format the graphical output
                    $Path = Convert-Path $data.Path
                    $header = "[$cnStyle{1}$reset] $pathStyle{0}$reset" -f (_toTitleCase $Path), $data[0].Computername
                    #this will be the output
                    $out = @"

$header


"@
                    #get the longest file count
                    [string]$maxCount = ($data.AgingGroups | Sort-Object Count | Select -Last 1 -ExpandProperty Count)
                    #this is the length of the longest aging group name
                    $maxLength = 7
                    foreach ($item in $data.AgingGroups) {
                        $pct = $item.PctTotal
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
                        $fileCount = "$([char]27)[30m{0}" -f ([string]$item.count).PadRight($maxCount.Length)
                        $out += "{0} [{1} {7}{2}{3}{4}] {5}{6:P2} ({8:N2}KB){3}`n" -f ($item.Name).PadRight($maxLength), $bgColor, $bar, $reset, (' ' * $remain), $fgColor, ($pct / 100),$fileCount,$($item.Size/1KB)

                    } #foreach item

                    $out +="`n{0:N0} total files measuring {1:N2}MB" -f $data.TotalFiles, ($data.TotalSize / 1MB)
                    $out
                }
                 Clear-Variable -Name data
            }
        }# Foreach computer
    }#process

    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        _verbose $strings.Ending
        Write-Information $strings.Ending -Tags runtime
    } #end
}
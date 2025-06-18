Function Show-DriveView {
    [cmdletbinding(DefaultParameterSetName = '__AllParameterSets')]
    [Alias('sdv')]
    [OutputType('PSObject',ParameterSetName='raw')]
    [OutputType('None',ParameterSetName='__AllParameterSets')]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the name of a remote computer. You must have admin rights. The default is the localhost.'
        )]
        [Alias('CN')]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName = $env:ComputerName,

        [Parameter(HelpMessage = 'Specify the view title')]
        [ValidateNotNullOrEmpty()]
        [string]$Title = 'Drive Report',

        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify an alternate credential for the remote computer.'
        )]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential,

        [Parameter(ParameterSetName = 'raw', HelpMessage = 'Display raw output without formatting.')]
        [switch]$Raw
    )
    DynamicParam {
        # This will imply PowerShell 7
        If (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable) {
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

            # Defining parameter attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = '__AllParameterSets'
            $attributes.HelpMessage = 'Use Out-ConsoleGridView if available'
            $attributeCollection.Add($attributes)

            # Adding a parameter alias
            $dynAlias = New-Object System.Management.Automation.AliasAttribute -ArgumentList 'cgv'
            $attributeCollection.Add($dynAlias)

            # Defining the runtime parameter
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('ConsoleGridView', [Switch], $attributeCollection)
            $paramDictionary.Add('ConsoleGridView', $dynParam1)

            return $paramDictionary
        } # end if
    } #end DynamicParam
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
        #initialize an array to hold results
        $data = @()

        #mapping hashtable
        $TypeMap = @{
            0 = 'Unknown'
            1 = 'NoRootDirectory'
            2 = 'RemovableDisk'
            3 = 'LocalDisk'
            4 = 'NetworkDrive'
            5 = 'CD/DVD'
            6 = 'RAMDisk'
        }

        $splat = @{
            Title      = $Title
            OutputMode = 'None'
        }
    } #begin

    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'
        Write-Information $PSBoundParameters -Tags runtime
        foreach ($computer in $ComputerName) {
            _verbose -message ($strings.QueryComputer -f $Computer.toUpper())
            Try {
                #create a temporary CIM session
                If ($Credential) {
                    _verbose ($strings.RunAs -f $Credential.UserName)
                    $cs = New-CimSession -ComputerName $Computer -Credential $Credential -ErrorAction Stop
                }
                else {
                    $cs = New-CimSession -ComputerName $Computer -ErrorAction Stop
                }
                $diskData = Get-CimInstance -class win32_logicaldisk -CimSession $cs -ErrorAction Stop

                If ($Raw) {
                    $data += $diskData | Select-Object @{Name = 'ComputerName'; Expression = { $_.SystemName } },
                    DeviceID, @{Name = 'Type'; Expression = { $TypeMap.item($_.DriveType -as [int]) } },
                    Size,FreeSpace,@{Name = 'UsedSpace'; Expression = { $_.Size - $_.FreeSpace } },
                    @{Name = 'Free%'; Expression = { [math]::round(($_.FreeSpace / $_.Size) * 100, 2) } }
                }
                else {
                    $data += $diskData | Select-Object @{Name = 'ComputerName'; Expression = { $_.SystemName } },
                    @{Name = 'Drive'; Expression = { $_.DeviceID } },
                    @{Name = 'Type'; Expression = { $TypeMap.item($_.DriveType -as [int]) } },
                    @{Name = 'SizeGB'; Expression = { [int]($_.Size / 1GB) } },
                    @{Name = 'FreeGB'; Expression = { [math]::Round($_.FreeSpace / 1GB, 2) } },
                    @{Name = 'UsedGB'; Expression = { [math]::round(($_.size - $_.FreeSpace) / 1GB, 2) } },
                    @{Name = 'Free%'; Expression = { [math]::round(($_.FreeSpace / $_.Size) * 100, 2) } },
                    @{Name = 'FreeGraph'; Expression = {
                            #scale the free space to a range of 0 to 50
                            [int]$per = (($_.FreeSpace / $_.Size) * 100) / 2
                            '|' * $per }
                    }
                }

                Write-Information $data -Tags data
            } #try
            Catch {
                Write-Error "[$($Computer.toUpper())] $($_.exception.message)"
            }
            if ($cs) {
                $cs | Remove-CimSession -ErrorAction SilentlyContinue
            }
        } #foreach

    } #process

    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        Write-Information $splat -Tags runtime
        if ($Raw) {
            $data
        }
        else {
            if ($PSBoundParameters.ContainsKey('ConsoleGridView')) {
                $data | Out-ConsoleGridView @splat
            }
            else {
                $data | Out-GridView @splat
            }
        }
        _verbose $strings.Ending
    } #end

}

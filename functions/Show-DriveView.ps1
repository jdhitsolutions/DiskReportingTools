Function Show-DriveView {
    [cmdletbinding()]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('CN')]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName = $env:ComputerName,
        [Parameter(HelpMessage = "Specify the grid title")]
        [string]$Title = 'Drive Report'
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
        if ($MyInvocation.CommandOrigin -eq "Runspace") {
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
            Title = $Title
            OutputMode = 'None'
        }
    } #begin

    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'

        foreach ($computer in $ComputerName) {
            _verbose -message ($strings.QueryComputer -f $Computer.toUpper())
            Try {
                $data += Get-CimInstance -class win32_logicaldisk -ComputerName $computer -ErrorAction Stop |
                Select-Object @{Name = 'ComputerName'; Expression = { $_.SystemName } },
                @{Name = 'Drive'; Expression = { $_.DeviceID } },
                @{Name = 'Type'; Expression = { $TypeMap.item($_.DriveType -as [int]) } },
                @{Name = 'SizeGB'; Expression = { [int]($_.Size / 1GB) } },
                @{Name = 'FreeGB'; Expression = { [math]::Round($_.FreeSpace / 1GB, 2) } },
                @{Name = 'UsedGB'; Expression = { [math]::round(($_.size - $_.FreeSpace) / 1GB, 2) } },
                @{Name = 'Free%'; Expression = { [math]::round(($_.FreeSpace / $_.Size) * 100, 2) } },
                @{Name = 'FreeGraph'; Expression = {
                    #scale the free space to a range of 0 to 50
                        [int]$per = (($_.FreeSpace / $_.Size) * 100)/2
                        '|' * $per }
                }
            } #try
            Catch {
                Write-Error "[$($Computer.toUpper())] $($_.exception.message)"
            }
        } #foreach

    } #process

    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
       # $splat['InputObject'] = $data
        if ($PSBoundParameters.ContainsKey('ConsoleGridView')) {
           $data | Out-ConsoleGridView @splat
        }
        else {
          $data |  Out-GridView @splat
        }

        _verbose $strings.Ending
    } #end

}

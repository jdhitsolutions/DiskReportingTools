Function Get-RecycleBinSize {
    [cmdletbinding()]
    [OutputType('RecycleBinInfo')]
    [alias('rbsz')]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the name of a remote computer. You must have admin rights. The default is the localhost.'
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [parameter(HelpMessage = 'Specify an alternate credential.')]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential
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

        #define a script block to run remotely
        $getSB = {
            Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object {
                $rbSize = Get-ChildItem -Path "$($_.DeviceID)\`$Recycle.Bin" -Force -File -Recurse -ErrorAction SilentlyContinue |
                Measure-Object -Property Length -Sum
                #return a hashtable
                @{
                    ComputerName   = $env:COMPUTERNAME
                    Drive          = $_.DeviceID
                    RecycleBinSize = $rbSize.Sum
                }
            }
        }
        $PSBoundParameters.Add('ScriptBlock', $getSB)
        $PSBoundParameters.Add('HideComputerName', $true)
        If ($Credential) {
            _verbose ($strings.RunAs -f $Credential.UserName)
        }
    } #begin

    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'

        foreach ($Computer in $ComputerName) {
            _verbose ($strings.RBSize -f $ComputerName.ToUpper())
            If (-Not ($PSBoundParameters.ContainsKey('ComputerName'))) {
                $PSBoundParameters['ComputerName'] = $ComputerName
            }
            else {
                $PSBoundParameters['ComputerName'] = $Computer
            }
            $PSBoundParameters | Out-String | Write-Debug
            $r = Invoke-Command @PSBoundParameters
            if ($r) {
                $r | ForEach-Object {
                    #create a custom object
                    [PSCustomObject]@{
                        PSTypeName     = 'RecycleBinInfo'
                        ComputerName   = $_.ComputerName
                        Drive          = $_.Drive
                        RecycleBinSize = $_.RecycleBinSize
                    }
                }
            }
            else {
                Write-Warning ($strings.DiskFailure -f $ComputerName.ToUpper(), $_.exception.message)
            }
        } #foreach Computer
    } #process

    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        _verbose $strings.Ending
    } #end

} #close Get-RecycleBinSize
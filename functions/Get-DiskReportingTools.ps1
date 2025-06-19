Function Get-DiskReportingTools {
    [cmdletbinding(DefaultParameterSetName = 'name')]
    [OutputType('ModuleCommand')]

    Param()

    Begin {
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

        $Name = 'DiskReportingTools'
        $CommandName = '*'

        #region local functions
        function getModuleInfo {
            [cmdletbinding()]
            param(
                $module,
                $CommandName
            )

            $cmds = @()
            $cmds += $module.ExportedFunctions.keys | Where-Object { $_ -like "$CommandName" } | Get-Command
            $cmds += $module.ExportedCmdlets.keys | Where-Object { $_ -like "$CommandName" } | Get-Command

            $out = foreach ($cmd in $cmds) {
                #get aliases, ignoring errors for those commands without one
                $alias = (Get-Alias -Definition $cmd.Name -ErrorAction SilentlyContinue).name

                #it is assumed you have updated help
                [PSCustomObject]@{
                    PSTypeName = 'ModuleCommand'
                    Name       = $cmd.name
                    Alias      = $alias
                    Verb       = $cmd.verb
                    Noun       = $cmd.noun
                    Synopsis   = (Get-Help $cmd.name).synopsis.trim()
                    Type       = $cmd.CommandType
                    Version    = $cmd.version
                    Help       = $cmd.HelpUri
                    ModuleName = $module.name
                    ModulePath = $module.Path
                    Compatible = $module.CompatiblePSEditions
                    PSVersion  = $module.PowerShellVersion
                }
            } #foreach cmd

            $out
        }
        #endregion
    } #begin
    Process {
        $PSDefaultParameterValues['_verbose:block'] = 'Process'
        _verbose -message ($strings.GettingInfo)
        $m = Get-Module -Name $Name
        $out = getModuleInfo -module $m -CommandName $CommandName

        Write-Information $m -Tags data

        #display results sorted by name for better formatting
        $out | Sort-Object -Property ModuleName, Name
    } #process
    End {
        $PSDefaultParameterValues['_verbose:block'] = 'End'
        $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
        _verbose $strings.Ending
        Write-Information $strings.Ending -Tags runtime
    } #end

} #close function


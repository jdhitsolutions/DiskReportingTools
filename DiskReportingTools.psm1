#requires -version 5.0

#region Main

. $PSScriptRoot\Get-DriveGraph.ps1
#. $psscriptRoot\Get-DriveGridView.ps1
. $psScriptRoot\Show-DriveView.ps1

#endregion

Export-ModuleMember -Function Show-DriveUsage,Show-DriveView -alias sdu

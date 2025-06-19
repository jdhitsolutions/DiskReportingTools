---
external help file: DiskReportingTools-help.xml
Module Name: DiskReportingTools
online version: https://jdhitsolutions.com/yourls/c42e81
schema: 2.0.0
---

# Get-DiskReportingTools

## SYNOPSIS

Get command details for DiskReportingTools.

## SYNTAX

```yaml
Get-DiskReportingTools [<CommonParameters>]
```

## DESCRIPTION

Use this command to get a brief summary of commands in the DiskReportingTools module. The command will return a list of commands with their names, aliases, and a brief description.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-DiskReportingTools

   ModuleName: DiskReportingTools [v0.12.0]

Name                   Alias Synopsis
----                   ----- --------
Get-DiskReportingTools       Get command details for DiskReportingTools.
Get-RecycleBinSize     rbsz  Get recycle bin size
New-HtmlDriveReport          Create a drive HTML report
Show-DriveUsage        sdu   Display a colorized graph of disk usage
Show-DriveView         sdv   Display a summary view of all drives.
Show-FolderUsage       sfu   Show folder usage by file extension.
```

The output only shows exported commands. Users on non-Windows platforms will get a different set of commands.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### ModuleCommand

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-Module]()

[Get-Command]()

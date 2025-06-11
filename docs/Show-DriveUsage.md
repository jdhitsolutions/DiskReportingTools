---
external help file: DiskReportingTools-help.xml
Module Name: DiskReportingTools
online version: https://jdhitsolutions.com/yourls/029bca
schema: 2.0.0
---

# Show-DriveUsage

## SYNOPSIS

Display a colorized graph of disk usage

## SYNTAX

```yaml
Show-DriveUsage [[-Drive] <String>] [-ComputerName <String[]>] [-Credential <PSCredential>]
 [<CommonParameters>]
```

## DESCRIPTION

This command uses the PowerShell console to display a colorized graph of disk usage.
The graph will be color coded depending on the amount of free disk space.
By default the command will display all fixed drives but you can limit output to a single drive.

This command writes an object to the pipeline, but the properties are ANSI formatted strings.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Show-DriveUsage

WIN10-ENT-01
C: \[|||||                                             \] 9.14%
D: \[|||||                                             \] 9.12%
E: \[|||||||||||||||||||||||||||||||||||               \] 70.71%
F: \[|||||||||||||||||||||||||                         \] 49.77%
```

The output would be colored blocks for drives C: and D:, yellow for F: and green for E:

### EXAMPLE 2

```powershell
PS C:\> Show-DriveUsage -computer chi-dc04 -drive c:

CHI-DC04
C: \[|||||||||||||||||||||||||                         \] 49.63%
```

## PARAMETERS

### -Drive

The name of the drive to check, including the colon.
See examples.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputerName

The name of the computer to query.
This command has aliases of: CN

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: CN

Required: False
Position: Named
Default value: $env:COMPUTERNAME
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Credential

Specify an alternate credential.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Show-DriveView](Show-DriveView.md)

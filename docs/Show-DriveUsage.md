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

### __AllParameterSets (Default)

```yaml
Show-DriveUsage [-Raw] [<CommonParameters>]
```

### Windows

```yaml
Show-DriveUsage [-Raw] [[-Drive] <String>] [-ComputerName <String[]>] [-Credential <PSCredential>]
 [<CommonParameters>]
```

## DESCRIPTION

This command uses the PowerShell console to display a colorized graph of disk usage.
The graph will be color coded depending on the amount of free disk space.
By default the command will display all fixed drives but you can limit output to a single drive.

This command writes an object to the pipeline, but the properties are ANSI formatted strings.

## EXAMPLES

### Example 1

```powershell
PS C:\> Show-DriveUsage

WIN10-ENT-01

C: [|||||                                             ] 9.14%
D: [|||||                                             ] 9.12%
E: [|||||||||||||||||||||||||||||||||||               ] 70.71%
F: [|||||||||||||||||||||||||                         ] 49.77%
```

The output would be colored blocks for drives C: and D:, yellow for F: and green for E:

### Example 2

```powershell
PS C:\> Show-DriveUsage -computer chi-dc04 -drive c:

CHI-DC04

C: [|||||||||||||||||||||||||                         ] 49.63%
```

### Example 3

```powershell
PS C:\> $r = Show-DriveUsage -ComputerName Win10 -Raw
PS C:\> $r

ComputerName Drives
------------ ------
WIN10        {@{VolumeName=; DeviceID=C:; Size=135951020032; FreeSpace=84002979840; PercentageFree…

PS C:\> $r.drives

VolumeName     :
DeviceID       : C:
Size           : 135951020032
FreeSpace      : 84002979840
PercentageFree : 30.8945750536581
Compressed     : False
```

Return raw data so you can create your own formatting or visualization.

### Example 4

```powershell
PS /home/jeff> Show-DriveUsage

BAMBAM

  /dev/sdd [||||||||||||||||||||||||||||||||||||||||||||    ] 94%
```

An example of output on a Linux system.

## PARAMETERS

### -Drive

The name of the drive to check, including the colon.
See examples.
This parameter is only supported on Windows.

```yaml
Type: String
Parameter Sets: Windows
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
This parameter is only supported on Windows.

```yaml
Type: String[]
Parameter Sets: Windows
Aliases: CN

Required: False
Position: Named
Default value: $env:COMPUTERNAME
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Credential

Specify an alternate credential. This parameter is only supported on Windows.

```yaml
Type: PSCredential
Parameter Sets: Windows
Aliases: RunAs

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Raw

Display raw output without formatting.

```yaml
Type: SwitchParameter
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

### System.String

### System.String[]

### System.Management.Automation.PSCredential

### System.Int32

## OUTPUTS

### String

### PSDriveUsageRaw

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Show-DriveView](Show-DriveView.md)

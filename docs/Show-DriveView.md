---
external help file: DiskReportingTools-help.xml
Module Name: DiskReportingTools
online version: https://jdhitsolutions.com/yourls/aac2ca
schema: 2.0.0
---

# Show-DriveView

## SYNOPSIS

Display a summary view of all drives

## SYNTAX

### __AllParameterSets (Default)

```yaml
Show-DriveView [[-ComputerName] <String[]>] [-Title <String>] [-Credential <PSCredential>] [<CommonParameters>]
```

### raw

```yaml
Show-DriveView [[-ComputerName] <String[]>] [-Title <String>] [-Credential <PSCredential>] [-Raw]
 [<CommonParameters>]
```

## DESCRIPTION

This command will display a summary view of all local, fixed drives. The default behavior is to send the output to Out-GridView. But if you are running PowerShell 7 and have the Microsoft.PowerShell.ConsoleGuiTools module installed, you can use the dynamic ConsoleGridView parameter.

## EXAMPLES

### Example 1

```powershell
PS C:\> Show-DriveView
```

This will show all drives on the local computer in an Out-GridView.

### Example 2

```powershell
PS C:\> Get-Content C:\scripts\company.txt | Show-DriveView -Title "Company Servers" -cgv
```

Get the server names from a text file and pipe them to Show-DriveView. This example is using the parameter alias for the dynamic parameter ConsoleGridView. This implies a PowerShell 7 environment with the Microsoft.PowerShell.ConsoleGuiTools module installed. The output will be a ConsoleGridView window with the title "Company Servers".

### Example 3

```powershell
PS C:\> Show-DriveView -ComputerName DOM1 -Raw

ComputerName : DOM1
DeviceID     : C:
Type         : LocalDisk
Size         : 135951020032
FreeSpace    : 119664275456
UsedSpace    : 16286744576
Free%        : 88.02
```

Get raw data for your own processing and formatting.

## PARAMETERS

### -ComputerName

The name of a remote computer.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: CN

Required: False
Position: 0
Default value: Localhost
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Title

Specify the grid title.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Drive Report
Accept pipeline input: False
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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Raw

Display raw output without formatting.

```yaml
Type: SwitchParameter
Parameter Sets: raw
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

### System.String[]

### System.Management.Automation.PSCredential

## OUTPUTS

### None

### PSObject

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Show-DriveUsage](Show-DriveUsage.md)

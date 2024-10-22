---
external help file: DiskReportingTools-help.xml
Module Name: DiskReportingTools
online version:
schema: 2.0.0
---

# Show-DriveView

## SYNOPSIS

Display a summary view of all drives.

## SYNTAX

```yaml
Show-DriveView [[-ComputerName] <String[]>] [-Title <String>] [<CommonParameters>]
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

```powershell`

PS C:\> Get-Content C:\scripts\company.txt | Show-DriveView -Title "Company Servers" -cgv
```

Get the server names from a text file and pipe them to Show-DriveView. This example is using the parameter alias for ConsoleGridView.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

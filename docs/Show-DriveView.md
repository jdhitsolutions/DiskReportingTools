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
Show-DriveView [[-Computername] <String[]>] [<CommonParameters>]
```

## DESCRIPTION

This command will display a summary view of all local, fixed drives.

## EXAMPLES

### Example 1

```powershell
PS C:\> Show-DriveView
```

## PARAMETERS

### -Computername

The name of a remote computer.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: cn

Required: False
Position: 0
Default value: Localhost
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

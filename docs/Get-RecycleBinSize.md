---
external help file: DiskReportingTools-help.xml
Module Name: DiskReportingTools
online version:
schema: 2.0.0
---

# Get-RecycleBinSize

## SYNOPSIS

Get recycle bin size

## SYNTAX

```yaml
Get-RecycleBinSize [[-ComputerName] <String[]>] [-Credential <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to get the size of the recycle bin on a computer. The command will return size information for each drive found.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-RecycleBinSize -ComputerName SRV1

    Computername: SRV1

Drive RecycleBinMB
----- ------------
C:    908.53
```

The default is a formatted view.

### Example 2

```powershell
PS C:\> rbsz "win10","win11" -Credential $artd

   Computername: WIN10

Drive RecycleBinMB
----- ------------
C:    2907.99

   Computername: WIN11

Drive RecycleBinMB
----- ------------
C:    301.09
```

This command is using the Get-RecycleBinSize alias to query remote computers using an alternate credential.

## PARAMETERS

### -ComputerName

Specify the name of a remote computer

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: localhost
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

### System.String

## OUTPUTS

### RecycleBinInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

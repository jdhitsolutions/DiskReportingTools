---
external help file: DiskReportingTools-help.xml
Module Name: DiskReportingTools
online version:
schema: 2.0.0
---

# Show-FolderUsageAge

## SYNOPSIS

Show folder usage by file age

## SYNTAX

### __AllParameterSets (Default)

```yaml
Show-FolderUsageAge [-Path] <String> [-Property <String>] [-Raw] [<CommonParameters>]
```

### Windows

```yaml
Show-FolderUsageAge [-Path] <String> [-Property <String>] [-Raw] [-ComputerName <String[]>]
 [-Credential <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to show folder usage by file age. The default aging criteria is based on the LastWriteTime property, but you can use the CreationTime property instead. The default output is a color formatted display of extensions showing a percentage of the total folder size.

The assumption is that you will process a folder with many files.

## EXAMPLES

### Example 1

```powershell
PS C:\> Show-FolderUsageAge C:\Presentations\ -ComputerName Cadenza

[CADENZA] C:\Presentations\

2Yrs    [ 106 ||||||||||||||||||||||||||||||                   ] 67.81% (63,766.04KB)
1Yrs    [ 46  ||||                                             ] 0.43% (408.49KB)
6Mo     [ 1   ||                                               ] 0.06% (52.19KB)
3Mo     [ 46  ||||                                             ] 13.58% (12,766.72KB)
1Mo     [ 66  ||||||||||                                       ] 6.89% (6,480.22KB)
1Wk     [ 50  |||||||||||||||                                  ] 11.23% (10,556.82KB)
Current [ 0                                                    ] 0.00% (0.00KB)

315 total files measuring 91.83MB
```

The default output will be a color formatted bar chart. The number in the graph is the number of files for each aging group.

### Example 2

```powershell
PS C:\> Show-FolderUsageAge c:\work -Raw | Tee-Object -Variable r

Path         : C:\work
Property     : LastWriteTime
AgingGroups  : {@{Name=2Yrs; Count=476; Size=55326826; PctTotal=73.6998166270543},
               @{Name=1Yrs;         Count=113;Size=16610523; PctTotal=22.1265629656664},
               @{Name=6Mo; Count=33; Size=1490966;PctTotal=1.98608755899304}, @{Name=3Mo;
               Count=39; Size=481521; PctTotal=0.641425000633072}}
TotalFiles   : 677
TotalSize    : 75070507
Computername : PROSPERO

PS C:\> $r.AgingGroups

Name    Count     Size PctTotal
----    -----     ---- --------
2Yrs      476 55326826    73.70
1Yrs      113 16610523    22.13
6Mo        33  1490966     1.99
3Mo        39   481521     0.64
1Mo         3   502482     0.67
1Wk         3   601009     0.80
Current    10    57180     0.08
```

Get raw folder usage data.

## PARAMETERS

### -ComputerName

Specify the name of a remote computer.
You must have admin rights.
The default is the localhost. This is a dynamic parameter and will only be available on Windows PowerShell.

```yaml
Type: String[]
Parameter Sets: Windows
Aliases: CN

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName,ByValue)
Accept wildcard characters: False
```

### -Credential

specify an alternate credential. This is a dynamic parameter and will only be available on Windows

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

### -Path

Specify the path to the folder to analyze.
Use a full file system path. The path will be searched recursively.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Property

Specify the file aging property.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: LastWriteTime, CreationTime

Required: False
Position: Named
Default value: LastWriteTime
Accept pipeline input: False
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

## OUTPUTS

### FileAging

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Show-FolderUsage](Show-FolderUsage.md)

---
external help file: DiskReportingTools-help.xml
Module Name: DiskReportingTools
online version: https://jdhitsolutions.com/yourls/c09320
schema: 2.0.0
---

# Show-FolderUsage

## SYNOPSIS

Show folder usage by file extension.

## SYNTAX

### __AllParameterSets (Default)

```yaml
Show-FolderUsage [-Path] <String> [-Threshold <Double>] [-Sort <String>] [-Descending] [-Raw]
 [<CommonParameters>]
```

### Windows

```yaml
Show-FolderUsage [-Path] <String> [-Threshold <Double>] [-Sort <String>] [-Descending] [-Raw]
 [[-ComputerName] <String[]>] [-Credential <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION

Use this cmdlet to show folder usage by file extension. The default output is a color formatted display of extensions showing a percentage of the total folder size. The output is limited to files that meet a minimum threshold percentage of the total folder size. The default threshold is 5%. You can change this value with the -Threshold parameter.

## EXAMPLES

### Example 1

```powershell
PS C:\> Show-FolderUsage c:\temp

[PROSPERO] C:\Temp

.mp3 [ 1||||||||||||                                      ] 17.54%
.zip [ 8||||||||||||||||||||                              ] 38.33%
.m4a [ 1|||||||||||||                                     ] 18.93%
.csv [ 4||||                                              ] 8.41%
```

The output will be color formatted and styled. The number in the graph is the number of files for each extension.

### Example 2

```powershell
PS C:\> Show-FolderUsage c:\scripts -ComputerName win10 -Raw | Format-Table

Name       Count     Size     Total   Pct Path       ComputerName
----       -----     ----     -----   --- ----       ------------
.gitignore     1   658.00 127583.00  0.52 C:\Scripts WIN10
.md            7 11212.00 127583.00  8.79 C:\Scripts WIN10
.psd1          2  2277.00 127583.00  1.78 C:\Scripts WIN10
.psm1          1  1770.00 127583.00  1.39 C:\Scripts WIN10
.html          1  1873.00 127583.00  1.47 C:\Scripts WIN10
.txt           2  2316.00 127583.00  1.82 C:\Scripts WIN10
.ps1           9 20647.00 127583.00 16.18 C:\Scripts WIN10
.json          4  5322.00 127583.00  4.17 C:\Scripts WIN10
.xml           1 25339.00 127583.00 19.86 C:\Scripts WIN10
.ps1xml        2  2730.00 127583.00  2.14 C:\Scripts WIN10
.png           1 53439.00 127583.00 41.89 C:\Scripts WIN10
```

Get the raw data so that you can do you own formatting or visualization.

### Example 3

```powershell
PS /home/jeff> Show-FolderUsage . -Sort Size -Descending

[BamBam] /Home/Jeff

.mp3 [ 8  ||||||||||||||||||||||                            ] 39.80 %
.zip [ 7  ||||||||||||||||                                  ] 19.33 %
.jpg [ 10 ||||||||||                                        ] 15.03 %
.m4a [ 1  |||||||                                           ] 12.22 %
.pdf [ 7  ||||                                              ] 5.87 %
```

This command is supported on non-Windows platforms, although it can only query the local computer. In this example, the output sorted on the Size in descending order.

## PARAMETERS

### -Path

Specify the path to the folder to analyze.
Use a full file system path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ComputerName

Specify the name of a remote computer.
You must have admin rights.
The default is the localhost.
This is a dynamic parameter and only available on Windows platforms.

```yaml
Type: String[]
Parameter Sets: Windows
Aliases: CN

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Credential

Specify an alternate credential for the remote computer. This is a dynamic parameter and only available on Windows platforms.

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

### -Threshold

Specify the minimum percentage to display.
The default is 5%

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Sort

Sort the graphical output by size or extension name in ascending order.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Size
Accept pipeline input: False
Accept wildcard characters: False
```

### -Descending

Sort the graphical output in descending order.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### PSCustomObject

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Show-DriveUsage](Show-DriveUsage.md)

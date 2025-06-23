---
external help file: DiskReportingTools-help.xml
Module Name: DiskReportingTools
online version: https://jdhitsolutions.com/yourls/c09320
schema: 2.0.0
---

# Show-FolderUsage

## SYNOPSIS

Show folder usage by file extension

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

Use this command to show folder usage by file extension. The default output is a color formatted display of extensions showing a percentage of the total folder size. The output is limited to files that meet a minimum threshold percentage of the total folder size. The default threshold is 5%. You can change this value with the -Threshold parameter.

## EXAMPLES

### Example 1

```powershell
PS C:\> Show-FolderUsage c:\temp

[PROSPERO] C:\Temp

.mp3 [ 1||||||||||||                                      ] 17.54%
.zip [ 8||||||||||||||||||||                              ] 38.33%
.m4a [ 1|||||||||||||                                     ] 18.93%
.csv [ 4||||                                              ] 8.41%

193 total files measuring 50.03MB
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

[BamBam] /home/jeff

.mp3 [ 8  ||||||||||||||||||||||                            ] 39.80 %
.zip [ 7  ||||||||||||||||                                  ] 19.33 %
.jpg [ 10 ||||||||||                                        ] 15.03 %
.m4a [ 1  |||||||                                           ] 12.22 %
.pdf [ 7  ||||                                              ] 5.87 %

122 total files measuring 73.68MB
```

This command is supported on non-Windows platforms, although it can only query the local computer. In this example, the output sorted on the Size in descending order.

### Example 4

```powershell
PS C:\> $j = Start-Job { Show-FolderUsage c:\temp -raw}
PS C:\> Receive-Job $j -Keep | Sort-Object  pct -Descending |
Select-Object -first 10 | Format-Table -GroupBy Path -Property Name,Count,Size,Pct

   Path: C:\Temp

Name   Count        Size   Pct
----   -----        ----   ---
.db        3 37792768.00 23.38
.so       22 28143040.00 17.41
.zip       9 25895471.00 16.02
.mp3       3 19099220.00 11.82
.dll      34 16268488.00 10.07
.dylib     8  8832364.00  5.46
.pack      1  4365349.00  2.70
         218  4043113.00  2.50
.png      41  2895345.00  1.79
.pdf       4  2574520.00  1.59
```

Run a module command as a background job and then sort the results by percentage. The output is grouped by the path.

## PARAMETERS

### -Path

Specify the path to the folder to analyze.
Use a full file system path.  The path will be searched recursively.

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

### FolderUsageRaw

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Show-FolderUsageAge](Show-FolderUsageAge.md)

[Show-DriveUsage](Show-DriveUsage.md)

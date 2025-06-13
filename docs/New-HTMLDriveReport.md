---
external help file: DiskReportingTools-help.xml
Module Name: DiskReportingTools
online version: https://jdhitsolutions.com/yourls/c9011d
schema: 2.0.0
---

# New-HtmlDriveReport

## SYNOPSIS

Create a drive HTML report

## SYNTAX

```yaml
New-HtmlDriveReport [[-ComputerName] <String[]>] [-Credential <PSCredential>] [-ReportTitle <String>] [-HeadingTitle <String>] [-Path <String>] [-Passthru] [<CommonParameters>]
```

## DESCRIPTION

This creates an Html drive report with a gradient table displaying drive usage.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-HtmlDriveReport -Passthru -Path c:\temp\srv1-drive.html -ReportTitle "SRV1 Drive Report" -ComputerName SRV1 -HeadingTitle "Drive Utilization"

    Directory: C:\temp

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           5/20/2025  4:11 PM           1876 srv1-drive.html
```

## PARAMETERS

### -ComputerName

Specify the name of a remote computer.
You must have admin rights.
The default is the localhost

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: CN

Required: False
Position: 0
Default value: local host
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -HeadingTitle

Specify the heading title for the HTML report.
This will be displayed at the top of the page.

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

### -Passthru

Get the report file.

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

### -Path

Specify the file name and path for the HTML report

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: DriveReport.html
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportTitle

Specify the page title for the HTML report

```yaml
Type: String
Parameter Sets: (All)
Aliases: Title

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### None

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

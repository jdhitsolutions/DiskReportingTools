# DiskReportingTools

This PowerShell module contains a few functions you can use to generate reports or gather information about storage devices on your system. The module should work on Windows PowerShell and PowerShell 7 on Windows platforms. Install the module from the PowerShell Gallery.

```powershell
Install-PSResource DiskReportingTools
```

While you can use the commands in production, they might be equally valuable as models for your own PowerShell scripting.

## Commands

The module contains the following commands:

| Name | Alias | Synopsis |
|------|-------|----------|
| [Get-RecycleBinSize](docs/Get-RecycleBinSize.md) | *rbsz* | Get recycle bin size |
| [New-HtmlDriveReport](docs/New-HtmlDriveReport.md) |  | Create a drive HTML report |
| [Show-DriveUsage](docs/Show-DriveUsage.md) | *sdu* | Display a colorized graph of disk usage |
| [Show-DriveView](docs/Show-DriveView.md) |  | Display a summary view of all drives. |

### Get-RecycleBinSize

This command will return the size of the recycle bin for each logical drive.

```powershell
PS C:\> Get-RecycleBinSize

   Computername: PROSPERO

Drive RecycleBinMB
----- ------------
C:    0.3
D:    4.97
G:    0
H:    0
```

The default is a formatted view with size formatted to megabytes. The "raw" value is in bytes.

```powershell
PS C:\> Get-RecycleBinSize | Where Drive -EQ 'c:' | Select *

ComputerName Drive RecycleBinSize
------------ ----- --------------
PROSPERO     C:         310112.00
```

You can also query a remote computer.

```powershell
PS C:\> Get-RecycleBinSize -ComputerName cadenza

   Computername: CADENZA

Drive RecycleBinMB
----- ------------
C:    1286.6
G:    0.21
```

Or multiple remote computers.

```powershell
PS C:\> rbsz "Win10","win11","srv1" -Credential $artd

   Computername: WIN10

Drive RecycleBinMB
----- ------------
C:    39.24

   Computername: WIN11

Drive RecycleBinMB
----- ------------
C:    301.09

   Computername: SRV1

Drive RecycleBinMB
----- ------------
C:    0
```

This example is using the `rbsz` alias for `Get-RecycleBinSize`.

### New-HtmlDriveReport

This command will create an HTML report of disk usage for one or more computers. Drive usage will be represented as a bar graph. You can customize the report title and heading.

```powershell
New-HtmlDriveReport -ComputerName DOM1,DOM2,SRV1,SRV2,WIN10,WIN11 -ReportTitle "Company Disk Report" -HeadingTitle "June 2024 Company Server Disk Report" -Path c:\temp\company-disk.html
```

![Company Disk Usage Report](images/html-disk-report.png)

### Show-DriveUsage

This command uses the PowerShell console to display a colorized graph of disk usage.
The graph will be color coded depending on the amount of free disk space.

![Show-DriveUsage](images/show-driveusage.png)

The default behavior is to display the graph for all local, fixed drives. You can specify a single drive or multiple drives.

![Show-DriveUsage Single Drive](images/show-driveusage-company.png)

The drive usage thresholds are hard-coded into the command. They could be surfaced as parameters.

### Show-DriveView

A related command in `Show-DriveView`. This command will display a summary view of all local, fixed drives. The default behavior is to send the output to `Out-GridView`.

```powershell
Show-DriveView -computername $computers
```

![Show-DriveView](images/show-drivereport.png)

But if you are running PowerShell 7 and have the `Microsoft.PowerShell.ConsoleGuiTools` module installed, you can use the dynamic `ConsoleGridView` parameter.

```powershell
Show-DriveView -Title "Company Drive View" -ComputerName SRV1,SRV2,Dom1,Dom2 -ConsoleGridView
```

![Show-DriveView ConsoleGridView](images/console-driveview.png)

## Other Features

This module uses localization for Verbose and other messages. The module also uses a private helper function to display verbose messages using ANSI formatting.

![custom verbose message](images/custom-verbose.png)

## Feedback

I am open to pull requests if you want to contribute to the module. If you find bugs or have suggestions, please open an issue on the [GitHub repository](https://github.com/jdhitsolutions/DiskReportingTools). I have also enabled [Discussions](https://github.com/jdhitsolutions/DiskReportingTools/discussions) for non-issue questions or comments.

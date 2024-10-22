<#
Get-Content c:\work\servers.txt | New-HTMLDriveReport -Title "Company Drive Report" -Path D:\temp\drivereport.html -Verbose -HeadingTitle "Company Server Disk Report<br>October 2024"
#>
Function New-HTMLDriveReport {
  [cmdletbinding()]

  Param (
    [Parameter(
      Position = 0,
      ValueFromPipeline,
      HelpMessage = 'Specify the name of a remote computer. You must have admin rights.'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]$ComputerName = $env:ComputerName,
    [Parameter(HelpMessage = 'Specify the page title for the HTML report')]
    [alias("Title")]
    [ValidateNotNullOrEmpty()]
    [string]$ReportTitle = 'Drive Report',
    [Parameter(HelpMessage = 'Specify the heading title for the HTML report. This will be displayed at the top of the page.')]
    [ValidateNotNullOrEmpty()]
    [string]$HeadingTitle = "Drive Report",
    [Parameter(HelpMessage = 'Specify the file name and path for the HTML report')]
    [ValidateNotNullOrEmpty()]
    [string]$Path = 'DriveReport.html'
  )

  Begin {
    $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand
    $PSDefaultParameterValues['_verbose:block'] = 'Begin'
    _verbose -message $strings.Starting
    if ($MyInvocation.CommandOrigin -eq 'Runspace') {
      #Hide this metadata when the command is called from another command
      _verbose -message ($strings.PSVersion -f $PSVersionTable.PSVersion)
      _verbose -message ($strings.UsingHost -f $host.Name)
      _verbose -message ($strings.UsingModule -f $DiskReportingModule)
    }

    #this is the graph character
    #$g= '&#9608;'  #"|"  #[char]9608
    [string]$g = '#9608;'
    [string]$g2 = "&$g"

    #embed a CSS style sheet in the html header
    $head = @"
  <style>
  body { background-color:#FFFFCC;
         font-family:font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;
         font-size:10pt; }
  td, th { border:1px solid #000033;
           border-collapse:collapse; }
  th { color:white;
       background-color:#000033; }
  table, tr, td, th { padding: 2px; margin: 0px }
  table { margin-left:8px; }
  </style>
  <Title>$ReportTitle</Title>
"@

    #define an array for html fragments
    $fragments = @()
    $fragments += "<H2>$HeadingTitle</H2>"
  } #Begin

  Process {
    $PSDefaultParameterValues['_verbose:block'] = 'Process'

    ForEach ($computer in $ComputerName) {
      _verbose ($strings.QueryComputer -f $Computer.toUpper())
      Try {
        #get the drive data
        $data = Get-CimInstance -ClassName Win32_logicaldisk -Filter 'DriveType=3' -computer $Computer -ErrorAction Stop
      }
      Catch {
        Write-Warning ($strings.DiskFailure -f $Computer.ToUpper(), $_.exception.message)
      }

      If ($Data) {
        #group data by ComputerName
        $groups = $Data | Group-Object -Property SystemName

        #create html fragments for each computer
        #iterate through each group object

        ForEach ($computer in $groups) {

          $fragments += "<H3>$($computer.Name)</H3>"

          #define a collection of drives from the group object
          $Drives = $computer.group

          #create an html fragment
          $html = $drives | Select-Object @{Name = 'Drive'; Expression = { $_.DeviceID } },
          @{Name = 'SizeGB'; Expression = { $_.Size / 1GB -as [int] } },
          @{Name = 'UsedGB'; Expression = { '{0:N2}' -f (($_.Size - $_.FreeSpace) / 1GB) } },
          @{Name = 'FreeGB'; Expression = { '{0:N2}' -f ($_.FreeSpace / 1GB) } },
          @{Name = 'Usage'; Expression = {
              $UsedPer = (($_.Size - $_.FreeSpace) / $_.Size) * 100
              $UsedGraph = $g * ($UsedPer / 2)
              $FreeGraph = $g * ((100 - $UsedPer) / 2)
              #I'm using place holders for the < and > characters
              'xOpenFont color=RedxClose{0}xOpen/FontxClosexOpenFont Color=GreenxClose{1}xOpen/fontxClose' -f $usedGraph, $FreeGraph
            }
          } | ConvertTo-Html -Fragment

          #fix special character by inserting the & character.
          $html = $html -replace $g, $g2
          #replace the tag place holders. It is a hack but it works.
          $html = $html -replace 'xOpen', '<'
          $html = $html -replace 'xClose', '>'

          #add to fragments
          $Fragments += $html

          #insert a return between each computer
          $fragments += '</p>'

        } #foreach computer
      } #if data
    }
  } #Process

  End {
    $PSDefaultParameterValues['_verbose:block'] = 'End'
    $PSDefaultParameterValues['_verbose:Command'] = $MyInvocation.MyCommand

    _verbose $strings.FinalizingHTML
    #add a footer
    $footer = ('<br><I>Report run {0} by {1}\{2}</I>' -f (Get-Date -DisplayHint date), $env:userdomain, $env:username)
    $fragments += $footer

    #write the result to a file
    _verbose ($strings.HTMLFile -f $Path)
    ConvertTo-Html -Head $head -Body $fragments | Out-File -FilePath $Path
    _verbose $strings.Ending
  } #end


}
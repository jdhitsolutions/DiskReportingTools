#localized string data for verbose messaging, errors, and warnings.

ConvertFrom-StringData @"
    DetectedParameterSet = Detected parameter set {0}
    DiskFailure = Failed to retrieve disk information from {0}. {1}
    Ending = Ending DiskReportingTools module command
    FinalizingHTML = Finalizing the HTML report.
    FolderUsage = Getting folder usage information for {0} on {1}
    HTMLFile = Writing HTML report to {0}
    missingCommand = The command '{0}' was not found. Please install it to use this command.
    PSVersion = Running under PowerShell version {0}
    QueryComputer = Querying disk information from {0}
    RBSize = Getting recycle bin size information for {0}
    RunAs = Using alternate credentials for {0}
    Starting = Starting DiskReportingTools module command
    Unsupported = This command has not been validated for this platform.
    UsingHost = Using PowerShell Host {0}
    UsingModule = Using module DiskReportingTools version {0}
    UsingOS = Using PSVersion OS {0}
"@
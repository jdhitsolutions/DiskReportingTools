#localized string data for verbose messaging, errors, and warnings.

ConvertFrom-StringData @"
    DetectedParameterSet = Detected parameter set {0}
    Ending = Ending DiskReportingTools module command
    PSVersion = Running under PowerShell version {0}
    Starting = Starting DiskReportingTools module command
    UsingHost = Using PowerShell Host {0}
    UsingModule = Using module DiskReportingTools version {0}
    QueryComputer = Querying disk information from {0}
    DiskFailure = Failed to retrieve disk information from {0}. {1}
    FinalizingHTML = Finalizing the HTML report.
    HTMLFile = Writing HTML report to {0}
    RBSize = Getting recycle bin size information for {0}
    RunAs = Using alternate credentials for {0}
"@
# Changelog for DiskReportingTools

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Refactored `Show-FolderUsage` to support non-Windows platforms in PowerShell 7.

### Fixed
- Fixed localization error with Invariant cultures.
- Fixed error in exporting module functions.

## [0.11.0] - 2025-06-13

### Added

- Added alias `sdv` for `Show-DriveView`.
- Added command `Show-FolderUsage` with an alias of `sfu`.`

### Changed

- Added `Raw` parameter to all commands that display visualized output to emit the raw, unformatted data. This is so the user can create their own formatting or visualizations.
- Added the `CN` alias to the `Computername` parameter on all commands.
- Moved ANSI definitions to the root module.
- Help updates.
- Modified `Credential` parameter on functions to accept pipeline input by property name.
- Added missing online help links.
- Updated `README.md`.

## [0.10.0] - 2025-06-11

This is the first public release to the PowerShell Gallery.

### Changed

- Modified `Get-RecycleBinSize` to accept multiple computer names as a parameter value.
- Updated manifest tags.
- Updated parameter validations.
- Updated commands that query remote computers to support alternate credentials.
- Updated `README.md.`
- Updated help documentation.

## [0.9.0] - 2024-10-22

This is private release

### Added

- Initial project files

[Unreleased]: https://github.com/jdhitsolutions/DiskReportingTools/compare/v0.11.0..HEAD
[0.11.0]: https://github.com/jdhitsolutions/DiskReportingTools/compare/v0.10.0..v0.11.0
[0.10.0]:
[0.9.0]:

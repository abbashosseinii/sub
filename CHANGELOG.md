## 1.2.0

#### Added

- **Multi-Encoding Support**: The parser now supports SRT files encoded in various character encodings, including UTF-8, Windows-1252, ISO-8859-1, Shift_JIS, GBK, UTF-16, and more. This enhancement allows users to parse a wider range of subtitle files without manual encoding specification.

- **Automatic Encoding Detection**: Implemented automatic detection and decoding of file content using a list of common encodings. The parser attempts to decode the file with each encoding until it succeeds, improving flexibility and user experience.

- **Detailed Documentation**: Added comprehensive comments and documentation throughout the codebase. This includes explanations of classes, methods, and significant code sections to improve maintainability and readability.

#### Fixed

- **Encoding Errors**: Resolved the `FormatException: Missing extension byte` error by handling files with different encodings properly. The parser no longer throws exceptions when encountering non-UTF-8 encoded files.

#### Changed

- **Parsing Logic**: Modified the parsing logic to read the entire file content at once and process it accordingly. This change enhances performance and reliability, especially when dealing with files in various encodings.

## 1.1.1
### Bug Fixes
- Fixed an issue with incorrect parsing of subtitles containing special characters (e.g., Persian).
- Improved error handling for different subtitle formats.

## 1.1.0
- Renamed `SubParser` class to `Sub`.
- Renamed method `parseSrtFile` to `parse`.

## 1.0.1
### Added
- Added detailed documentation for the `SubModel` and `SubParser` classes.

## 1.0.0

- Initial version.

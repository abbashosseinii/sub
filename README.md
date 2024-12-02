# Sub Parser

A Dart package for parsing SRT (SubRip Subtitle) files into a list of subtitle models, supporting multiple character encodings. This parser is designed to handle SRT files encoded in various formats, making it versatile for different languages and regions.

## Features

- **Multi-Encoding Support**: Automatically detects and decodes SRT files with different character encodings such as UTF-8, Windows-1252, ISO-8859-1, Shift_JIS, GBK, UTF-16, and more.
- **Accurate Parsing**: Parses subtitle IDs, timing information, and text accurately.
- **Easy to Use**: Simple API to parse subtitle files with minimal code.
- **Well Documented**: Includes detailed comments and documentation for easy understanding and maintenance.

## Installation

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  sub_parser: ^1.2.0
```

Then run:

```bash
dart pub get
```

## Usage

Import the package in your Dart file:

```dart
import 'package:sub_parser/sub_parser.dart';
```

Use the `Sub` class to parse an SRT file:

```dart
void main() async {
  // Replace 'path_to_subtitle.srt' with the path to your SRT file.
  List<SubModel> subtitles = await Sub.parse('path_to_subtitle.srt');

  // Iterate over the subtitles and print their details.
  for (var subtitle in subtitles) {
    print('ID: ${subtitle.id}');
    print('Start: ${subtitle.start}');
    print('End: ${subtitle.end}');
    print('Text: ${subtitle.text}');
    print('---');
  }
}
```

## API Reference

### `Sub.parse(String filePath)`

Parses an SRT file and returns a `Future<List<SubModel>>` representing the subtitles.

- **Parameters**:
  - `filePath` (`String`): The path to the SRT file to be parsed.

- **Returns**: A `Future` that completes with a list of `SubModel` instances.

### `SubModel`

A model representing a single subtitle entry.

- **Fields**:
  - `id` (`int`): The subtitle ID.
  - `start` (`Duration`): The start time of the subtitle.
  - `end` (`Duration`): The end time of the subtitle.
  - `text` (`String`): The subtitle text.

## How It Works

The parser reads the entire SRT file as bytes and attempts to decode it using a list of common encodings. It processes the decoded content to extract subtitle blocks, including their IDs, timing information, and text.

### Supported Encodings

- UTF-8
- Windows-1252
- ISO-8859-1
- Shift_JIS
- GBK
- UTF-16
- UTF-16LE
- UTF-16BE
- EUC-KR
- Big5
- *(Add other encodings as needed)*

## Dependencies

- **[charset_converter](https://pub.dev/packages/charset_converter)**: Used for decoding file content with various character encodings.

## Example

An example of parsing a subtitle file and displaying the subtitles:

```dart
import 'package:sub_parser/sub_parser.dart';

void main() async {
  List<SubModel> subtitles = await Sub.parse('example.srt');

  for (var subtitle in subtitles) {
    print('Subtitle ${subtitle.id}:');
    print('From ${subtitle.start} to ${subtitle.end}');
    print(subtitle.text);
    print('');
  }
}
```

## Error Handling

- **File Not Found**: If the specified file does not exist, the parser prints a message and returns an empty list.
- **Decoding Failure**: If the parser fails to decode the file with the provided encodings, it prints a message and returns an empty list.
- **Invalid Timing Lines**: If a timing line does not match the expected format, the parser logs a message and skips that subtitle block.

## Contributing

Contributions are welcome! If you'd like to improve this package, please:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Write tests to cover your changes.
4. Submit a pull request.

Please ensure your code adheres to the existing style conventions and passes all tests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or suggestions, please open an issue on the repository or contact the maintainer at [abbashosseini7698@gmail.com](mailto:abbashosseini7698@gmail.com).
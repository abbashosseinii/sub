Here's an example of a `README.md` file for your package named **`sub`**, which includes the **`SubModel`** and **`SubParser`**:

---

# Sub

`sub` is a Dart package designed for parsing subtitle files like SRT and VTT. It provides an easy way to parse subtitle files into a structured model, **`SubModel`**, and includes a parser, **`SubParser`**, for reading and interpreting subtitle data.

## Features

- Parse subtitle files (SRT, VTT, etc.) into a structured `SubModel`.
- Support for time-based subtitles, with `start` and `end` timestamps.
- Easily extract subtitle text for use in your application.

## Installation

Add `sub` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  sub: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the Package

Import the `sub` package into your Dart file:

```dart
import 'package:sub/sub.dart';
```

### SubModel

The `SubModel` represents a subtitle object, which contains the following fields:

- `id`: The index of the subtitle.
- `start`: The start time of the subtitle.
- `end`: The end time of the subtitle.
- `text`: The actual subtitle text.

```dart
class SubModel {
  final int id;
  final Duration start;
  final Duration end;
  final String text;

  SubModel({
    required this.id,
    required this.start,
    required this.end,
    required this.text,
  });
}
```

### SubParser

The `SubParser` is responsible for parsing subtitle files and converting them into a list of `SubModel` objects.

#### Example of Parsing an SRT File

```dart
import 'dart:io';
import 'package:sub/sub.dart';

void main() async {
  // Specify the path to your subtitle file
  String filePath = 'assets/subtitles/sample.srt';

  try {
    // Parse the subtitle file
    List<SubModel> subtitles = await SubParser.parse(filePath);

    // Print the parsed subtitles
    for (var subtitle in subtitles) {
      print('ID: ${subtitle.id}');
      print('Start: ${subtitle.start}');
      print('End: ${subtitle.end}');
      print('Text: ${subtitle.text}\n');
    }
  } catch (e) {
    print('Error parsing subtitle file: $e');
  }
}
```

#### Parsing Logic

- The `SubParser.parse` method takes the file path of the subtitle file (SRT format) and returns a list of `SubModel` objects.
- The parser extracts each subtitle's ID, start time, end time, and text.
- The `start` and `end` times are parsed into `Duration` objects, which can be used to synchronize subtitles with media.

### Supported Subtitle Formats

- **SRT (SubRip Subtitle)**: The most common subtitle format. Each subtitle block consists of an index, a time range (start and end), and the subtitle text.
- **VTT (WebVTT)**: A similar format to SRT but with different formatting conventions. You can extend the `SubParser` class to support VTT or other formats if needed.

## License

This package is open source and available under the [MIT License](LICENSE).

---

### Key Sections in the README:

1. **Installation**: Provides the necessary steps to add your package to a Flutter/Dart project.
2. **Usage**: Details how to use the `SubParser` and `SubModel` to parse subtitles.
3. **Code Example**: A real example of how to integrate the package, including reading subtitle files and printing parsed data.
4. **License**: Links to the open-source license, typically the MIT License.

You can customize this README as needed based on your package's unique features or usage instructions.
# Sub

`sub` is a Dart package designed for parsing subtitle files like SRT and VTT. It provides an easy way to parse subtitle files into a structured model, **`SubModel`**, and includes a parser, **`Sub`**, for reading and interpreting subtitle data.

## Features

- Parse subtitle files (SRT, VTT, etc.) into a structured `SubModel`.
- Support for time-based subtitles, with `start` and `end` timestamps.
- Easily extract subtitle text for use in your application.
- Enhanced support for non-Latin scripts like Persian.
- Optimized memory usage for large subtitle files by using streaming parsing.

## Installation

Add `sub` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  sub: ^1.1.1
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

### Sub

The `Sub` class is responsible for parsing subtitle files and converting them into a list of `SubModel` objects.

#### Example of Parsing an SRT File

```dart
import 'dart:io';
import 'package:sub/sub.dart';

void main() async {
  // Specify the path to your subtitle file
  String filePath = 'assets/subtitles/sample.srt';

  try {
    // Parse the subtitle file
    List<SubModel> subtitles = await Sub.parse(filePath);

    // Print the parsed subtitles
    for (var subtitle in subtitles) {
      print('ID: ${subtitle.id}');
      print('Start: ${subtitle.start}');
      print('End: ${subtitle.end}');
      print('Text: ${subtitle.text}');
    }
  } catch (e) {
    print('Error parsing subtitle file: $e');
  }
}
```

## License

This package is open source and available under the MIT License.
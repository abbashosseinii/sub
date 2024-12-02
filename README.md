# Sub

A powerful and flexible Dart library for parsing SRT subtitle files into structured data.

This package provides a simple API to extract subtitle information from SRT files, making it perfect for applications that need to process and display subtitles dynamically.

## 📖 Table of Contents

- [Key Features](#key-features)
- [Use Cases](#use-cases)
- [Installation](#installation)
- [Usage](#usage)
- [API Reference](#api-reference)
- [License](#license)
- [Contributing](#contributing)
- [Contact](#contact)

## 🚀 Key Features

- **Multi-Encoding Support**: Automatically handles various text encodings like UTF-8, Latin-1, and more.
- **Easy Integration**: Minimal setup required for seamless integration.
- **Customizable and Extensible**: Provides structured output via `SubModel` for further customization.

## 🎯 Use Cases

- Video players with subtitles.
- Processing subtitles for AI models or transcription tools.
- Subtitle validation, editing, and conversion applications.

## 📦 Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  sub: ^1.2.1
```

Then run:

```shell
dart pub get
```

## 📝 Usage

Here's a simple example of how to use the `Sub` package to parse an SRT file:

```dart
import 'package:sub/sub.dart';

Future<void> main() async {
  List<SubModel> subtitles = await Sub.parse('assets/subtitles.srt');
  for (var subtitle in subtitles) {
    print('${subtitle.id}: ${subtitle.text} (${subtitle.start} - ${subtitle.end})');
  }
}
```

## 📚 API Reference

### `Sub.parse(String filePath)`

Parses an SRT file and returns a list of `SubModel` instances.

**Parameters:**

- `filePath`: The file path to the SRT subtitle file.

**Returns:**

A `Future` that resolves to a list of `SubModel` objects, each representing a subtitle block with its ID, start time, end time, and text.

If the file is missing, empty, or cannot be decoded, an empty list is returned.

### `SubModel`

Represents a single subtitle block with the following properties:

- `int id`: The sequence number of the subtitle.
- `Duration start`: The start time of the subtitle.
- `Duration end`: The end time of the subtitle.
- `String text`: The subtitle text.

## 🛡️ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request for any bugs, improvements, or features.

## 📬 Contact

If you have any questions or suggestions, feel free to reach out:

- **Email**: [abbashosseini7698@gmail.com](mailto:abbashosseini7698@gmail.com)
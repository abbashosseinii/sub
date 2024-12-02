import 'dart:convert';
import 'dart:io';
import 'package:sub/src/sub_model.dart';

/// A powerful and flexible Dart library for parsing SRT subtitle files into structured data.
///
/// This package provides a simple API to extract subtitle information from SRT files,
/// making it perfect for applications that need to process and display subtitles dynamically.
///
/// ### Key Features:
/// - **Multi-Encoding Support**: Automatically handles various text encodings like UTF-8, Latin-1, and more.
/// - **Easy Integration**: Minimal setup required for seamless integration.
/// - **Customizable and Extensible**: Provides structured output via [SubModel] for further customization.
///
/// ### Use Cases:
/// - Video players with subtitles.
/// - Processing subtitles for AI models or transcription tools.
/// - Subtitle validation, editing, and conversion applications.
///
/// ### Example:
/// ```dart
/// import 'package:sub/sub.dart';
///
/// Future<void> main() async {
///   List<SubModel> subtitles = await Sub.parse('assets/subtitles.srt');
///   for (var subtitle in subtitles) {
///     print('${subtitle.id}: ${subtitle.text} (${subtitle.start} - ${subtitle.end})');
///   }
/// }
/// ```
///
/// Get started with `Sub` to make subtitle processing effortless!
class Sub {
  /// Parses an SRT file and returns a list of [SubModel] instances.
  ///
  /// ### Parameters:
  /// - [filePath]: The file path to the SRT subtitle file.
  ///
  /// ### Returns:
  /// A [Future] that resolves to a list of [SubModel] objects, each representing
  /// a subtitle block with its ID, start time, end time, and text.
  ///
  /// If the file is missing, empty, or cannot be decoded, an empty list is returned.
  static Future<List<SubModel>> parse(String filePath) async {
    final File file = File(filePath);

    // Validate the file's existence
    if (!await file.exists()) {
      print('File does not exist: $filePath');
      return [];
    }

    // Read the file content as bytes
    final bytes = await file.readAsBytes();
    String content = '';

    // Encodings to try for decoding the file
    final encodings = [
      utf8,
      latin1,
      Encoding.getByName('iso-8859-1') ?? latin1,
      Encoding.getByName('windows-1252') ?? latin1,
    ];

    bool decoded = false;

    // Attempt decoding with various encodings
    for (var encoding in encodings) {
      try {
        content = encoding.decode(bytes);
        decoded = true;
        print('File decoded using encoding: ${encoding.name}');
        break;
      } catch (e) {
        // Continue to next encoding if decoding fails
        continue;
      }
    }

    if (!decoded) {
      print('Failed to decode the file with the provided encodings.');
      return [];
    }

    final List<SubModel> subtitles = [];
    final List<String> lines = content.split(RegExp(r'\r\n|\r|\n'));

    int id = 0;
    String subtitleText = '';
    Duration? startTime;
    Duration? endTime;

    int lineIndex = 0;

    while (lineIndex < lines.length) {
      final line = lines[lineIndex].trim();

      if (line.isEmpty) {
        lineIndex++;
        continue;
      }

      if (RegExp(r'^\d+$').hasMatch(line)) {
        if (id != 0 &&
            subtitleText.isNotEmpty &&
            startTime != null &&
            endTime != null) {
          subtitles.add(SubModel(
            id: id,
            start: startTime,
            end: endTime,
            text: subtitleText.trim(),
          ));
        }

        id = int.parse(line);
        subtitleText = '';
        startTime = null;
        endTime = null;
        lineIndex++;

        if (lineIndex < lines.length) {
          final timingLine = lines[lineIndex].trim();
          final RegExp timePattern =
              RegExp(r'(\d{2}):(\d{2}):(\d{2}),(\d{3})\s*-->\s*'
                  r'(\d{2}):(\d{2}):(\d{2}),(\d{3})');

          final match = timePattern.firstMatch(timingLine);

          if (match != null) {
            startTime = _parseTime(
              match.group(1)!,
              match.group(2)!,
              match.group(3)!,
              match.group(4)!,
            );

            endTime = _parseTime(
              match.group(5)!,
              match.group(6)!,
              match.group(7)!,
              match.group(8)!,
            );

            lineIndex++;
          } else {
            print('Invalid timing line at line ${lineIndex + 1}');
            lineIndex++;
            continue;
          }
        } else {
          break;
        }

        while (lineIndex < lines.length && lines[lineIndex].trim().isNotEmpty) {
          subtitleText += lines[lineIndex] + '\n';
          lineIndex++;
        }
      } else {
        lineIndex++;
      }
    }

    if (id != 0 &&
        subtitleText.isNotEmpty &&
        startTime != null &&
        endTime != null) {
      subtitles.add(SubModel(
        id: id,
        start: startTime,
        end: endTime,
        text: subtitleText.trim(),
      ));
    }

    return subtitles;
  }

  /// Parses a timing line into a [Duration].
  ///
  /// ### Parameters:
  /// - [hours], [minutes], [seconds], [milliseconds]: String representations of time components.
  ///
  /// ### Returns:
  /// A [Duration] instance representing the parsed time.
  static Duration _parseTime(
      String hours, String minutes, String seconds, String milliseconds) {
    return Duration(
      hours: int.parse(hours),
      minutes: int.parse(minutes),
      seconds: int.parse(seconds),
      milliseconds: int.parse(milliseconds),
    );
  }
}

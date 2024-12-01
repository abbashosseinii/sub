import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sub/src/sub_model.dart';

class Sub {
  /// Parse a file in SRT format into a list of [SubModel]s.
  ///
  /// The file is expected to be in the format:
  ///
  ///     1
  ///     00:00:01,000 --> 00:00:04,000
  ///     Hello, welcome to the test!
  ///
  ///     2
  ///     00:00:05,000 --> 00:00:08,000
  ///     This is the second subtitle.
  ///
  /// Where each block of text is separated by a blank line, and the first
  /// line of each block is the subtitle ID, the second line is the timing
  /// information in the format `HH:MM:SS,MMM --> HH:MM:SS,MMM`, and the
  /// third line is the subtitle text.
  ///
  /// The file is read in a streaming fashion to avoid loading large files
  /// into memory all at once, which improves performance for larger subtitle files.
  /// The method returns a [Future] that completes when the entire file has been parsed.
  /// The [Future] resolves to a [List] of [SubModel]s, which can then be used
  /// for further processing, such as displaying the subtitles.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// List<SubModel> subtitles = await SubParser.parse('path_to_subtitle.srt');
  /// ```
  static Future<List<SubModel>> parse(String filePath) async {
    final File file = File(filePath);

    if (!await file.exists()) {
      print('File does not exist: $filePath');
      return [];
    }

    final Stream<List<int>> inputStream = file.openRead();
    final List<SubModel> subtitles = [];
    final Completer<void> completer = Completer<void>();

    int id = 0;
    String subtitleText = '';
    Duration? startTime;
    Duration? endTime;

    inputStream.transform(Utf8Decoder()).listen(
      (String chunk) {
        final List<String> lines = chunk.split('\n');
        for (var line in lines) {
          if (line.isEmpty) continue;

          if (id == 0 || line.contains(RegExp(r'^\d+$'))) {
            // New subtitle block, save previous one if exists
            if (id != 0 && subtitleText.isNotEmpty) {
              subtitles.add(SubModel(
                id: id,
                start: startTime!,
                end: endTime!,
                text: subtitleText.trim(),
              ));
            }

            // Initialize new subtitle block
            id = int.parse(line);
            subtitleText = '';
            continue;
          }

          if (line.contains(RegExp(r'-->'))) {
            // Extract start and end times from the subtitle line
            final RegExp timePattern = RegExp(
                r'(\d{2}):(\d{2}):(\d{2}),(\d{3}) --> (\d{2}):(\d{2}):(\d{2}),(\d{3})');
            final match = timePattern.firstMatch(line);
            if (match != null) {
              final startHours = int.parse(match.group(1)!);
              final startMinutes = int.parse(match.group(2)!);
              final startSeconds = int.parse(match.group(3)!);
              final startMilliseconds = int.parse(match.group(4)!);

              final endHours = int.parse(match.group(5)!);
              final endMinutes = int.parse(match.group(6)!);
              final endSeconds = int.parse(match.group(7)!);
              final endMilliseconds = int.parse(match.group(8)!);

              startTime = Duration(
                hours: startHours,
                minutes: startMinutes,
                seconds: startSeconds,
                milliseconds: startMilliseconds,
              );
              endTime = Duration(
                hours: endHours,
                minutes: endMinutes,
                seconds: endSeconds,
                milliseconds: endMilliseconds,
              );
            }
            continue;
          }

          // Collect subtitle text
          subtitleText += line + '\n';
        }
      },
      onDone: () {
        if (subtitleText.isNotEmpty) {
          // Add the last subtitle block to the list
          subtitles.add(SubModel(
            id: id,
            start: startTime!,
            end: endTime!,
            text: subtitleText.trim(),
          ));
        }
        completer.complete();
      },
      onError: (error) {
        completer.completeError(error);
      },
    );

    // Wait for the stream to complete and return the list of subtitles
    await completer.future;
    return subtitles;
  }
}

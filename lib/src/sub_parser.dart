import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sub/src/sub_model.dart';

class SubParser {
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
  /// The file is read in a streaming fashion, and the method returns a
  /// [Future] that completes when the entire file has been parsed. The
  /// [Future] resolves to a [List] of [SubModel]s, which can then be used
  /// for further processing.
  ///
  static Future<List<SubModel>> parseSrtFile(String filePath) async {
    final File file = File(filePath);
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
            // New subtitle block, save previous if exists
            if (id != 0 && subtitleText.isNotEmpty) {
              subtitles.add(SubModel(
                  id: id,
                  start: startTime!,
                  end: endTime!,
                  text: subtitleText
                      .trim() // Use trim to remove trailing newlines
                  ));
              subtitleText = ''; // Reset for new subtitle
            }
            id = int.parse(line);
          } else if (line.contains(RegExp(r'-->'))) {
            // Extract start and end times
            final times = line.split(' --> ');
            startTime = _parseTime(times[0]);
            endTime = _parseTime(times[1]);
          } else {
            // Collect subtitle text
            subtitleText += '$line\n';
          }
        }
      },
      onDone: () {
        // Handle the last subtitle
        if (id != 0 && subtitleText.isNotEmpty) {
          subtitles.add(SubModel(
            id: id,
            start: startTime!,
            end: endTime!,
            text: subtitleText.trim(), // Trim the last subtitle text
          ));
        }
        completer.complete();
      },
    );

    // Return the result once parsing is done
    await completer.future;
    return subtitles;
  }

  /// Parses a time string in the format `HH:MM:SS,MMM` into a [Duration] object.
  ///
  /// The time string represents hours, minutes, seconds, and milliseconds
  /// separated by colons and a comma, respectively. This method converts the
  /// string into a [Duration] by extracting and parsing each component.
  ///
  /// Example input: "00:00:01,000"
  ///
  /// Returns a [Duration] representing the parsed time.
  static Duration _parseTime(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final secondAndMs = parts[2].split(',');
    final second = int.parse(secondAndMs[0]);
    final millisecond = int.parse(secondAndMs[1]);

    return Duration(
      hours: hour,
      minutes: minute,
      seconds: second,
      milliseconds: millisecond,
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:charset_converter/charset_converter.dart';
import 'package:sub/src/sub_model.dart';

/// A class for parsing SRT subtitle files into a list of [SubModel] instances.
///
/// This parser can handle SRT files encoded in various character encodings,
/// making it flexible for different subtitle file formats.
///
/// Example usage:
///
/// ```dart
/// List<SubModel> subtitles = await Sub.parse('path_to_subtitle.srt');
/// ```
class Sub {
  /// Parses an SRT file and returns a list of [SubModel] instances.
  ///
  /// The method attempts to decode the file using a list of common encodings
  /// until it succeeds. It reads the entire file content into memory and
  /// processes it to extract subtitle entries.
  ///
  /// [filePath] is the path to the SRT file to be parsed.
  ///
  /// Returns a [Future] that completes with a list of [SubModel] instances
  /// representing the subtitles in the file.
  ///
  /// If the file does not exist or cannot be decoded with the provided
  /// encodings, the method returns an empty list.
  static Future<List<SubModel>> parse(String filePath) async {
    final File file = File(filePath);

    // Check if the file exists at the given path.
    if (!await file.exists()) {
      print('File does not exist: $filePath');
      return [];
    }

    // Read the entire file content as bytes.
    final bytes = await file.readAsBytes();

    // Initialize an empty string to hold the decoded content.
    String content = '';

    // List of possible encodings to try decoding the file with.
    List<String> possibleEncodings = [
      'utf-8',
      'windows-1252',
      'iso-8859-1',
      'shift_jis',
      'gbk',
      'utf-16',
      'utf-16le',
      'utf-16be',
      'euc-kr',
      'big5',
      // Add other encodings as needed.
    ];

    // Flag to indicate whether the file has been successfully decoded.
    bool decoded = false;

    // Attempt to decode the file content using each encoding in the list.
    for (String encoding in possibleEncodings) {
      try {
        // Decode the bytes into a string using the specified encoding.
        content = await CharsetConverter.decode(encoding, bytes);
        decoded = true;
        print('File decoded using encoding: $encoding');
        break; // Exit the loop upon successful decoding.
      } catch (e) {
        // If decoding fails, continue to the next encoding.
        continue;
      }
    }

    // If decoding failed with all provided encodings, return an empty list.
    if (!decoded) {
      print('Failed to decode the file with the provided encodings.');
      return [];
    }

    // Initialize a list to hold the parsed subtitles.
    final List<SubModel> subtitles = [];

    // Split the content into lines, accounting for different newline characters.
    final List<String> lines = content.split(RegExp(r'\r\n|\r|\n'));

    // Variables to hold the current subtitle block data.
    int id = 0;
    String subtitleText = '';
    Duration? startTime;
    Duration? endTime;

    int lineIndex = 0; // Index to track the current position in the lines list.

    // Loop through the lines to parse subtitle blocks.
    while (lineIndex < lines.length) {
      final line = lines[lineIndex].trim();

      // Skip empty lines.
      if (line.isEmpty) {
        lineIndex++;
        continue;
      }

      // Check if the line is a subtitle ID (an integer).
      if (RegExp(r'^\d+$').hasMatch(line)) {
        // If there's an existing subtitle block, save it before starting a new one.
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

        // Parse the subtitle ID.
        id = int.parse(line);
        subtitleText = ''; // Reset the subtitle text.
        startTime = null; // Reset the start time.
        endTime = null; // Reset the end time.
        lineIndex++;

        // Ensure there are more lines to read for the timing information.
        if (lineIndex < lines.length) {
          final timingLine = lines[lineIndex].trim();

          // Regular expression to match the timing line.
          final RegExp timePattern = RegExp(
              r'(\d{2}):(\d{2}):(\d{2}),(\d{3})\s*-->\s*'
              r'(\d{2}):(\d{2}):(\d{2}),(\d{3})');

          final match = timePattern.firstMatch(timingLine);

          // If the timing line matches the expected format, parse the times.
          if (match != null) {
            // Parse start time components.
            final startHours = int.parse(match.group(1)!);
            final startMinutes = int.parse(match.group(2)!);
            final startSeconds = int.parse(match.group(3)!);
            final startMilliseconds = int.parse(match.group(4)!);

            // Parse end time components.
            final endHours = int.parse(match.group(5)!);
            final endMinutes = int.parse(match.group(6)!);
            final endSeconds = int.parse(match.group(7)!);
            final endMilliseconds = int.parse(match.group(8)!);

            // Create Duration instances for start and end times.
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

            lineIndex++; // Move to the next line to read subtitle text.
          } else {
            // If the timing line is invalid, log a message and skip to the next line.
            print('Invalid timing line at line ${lineIndex + 1}');
            lineIndex++;
            continue;
          }
        } else {
          // If there are no more lines, exit the loop.
          break;
        }

        // Collect the subtitle text lines until an empty line or the end of the file.
        while (lineIndex < lines.length && lines[lineIndex].trim().isNotEmpty) {
          subtitleText += lines[lineIndex] + '\n';
          lineIndex++;
        }
      } else {
        // If the line doesn't match any expected format, move to the next line.
        lineIndex++;
      }
    }

    // Add the last subtitle block to the list if it exists and is valid.
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

    // Return the list of parsed subtitles.
    return subtitles;
  }
}

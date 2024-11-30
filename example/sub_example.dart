import 'dart:io';
import 'package:sub/sub.dart';

void main() async {
  // Example SRT content for testing
  String srtContent = """
1
00:00:01,000 --> 00:00:04,000
Hello, welcome to the test!

2
00:00:05,000 --> 00:00:08,000
This is the second subtitle.
""";

  // Write the example content to a file
  final file = File('test_data.srt');
  await file.writeAsString(srtContent);

  // Parse the SRT file using SubtitleParser
  final List<SubModel> subtitles = await SubParser.parseSrtFile('test_data.srt');

  // Print the parsed subtitles
  for (var subtitle in subtitles) {
    print(subtitle);
  }
}

import 'dart:io';
import 'package:sub/sub.dart';
import 'package:test/test.dart';

// test_data.srt (mock data)
String srtContent = """
1
00:00:01,000 --> 00:00:04,000
Hello, welcome to the test!

2
00:00:05,000 --> 00:00:08,000
This is the second subtitle.
""";

void main() {
  group('SubtitleParser Tests', () {
    test('parses SRT file correctly', () async {
      // Prepare mock data for testing
      final file = File('test_data.srt');
      await file.writeAsString(srtContent);

      // Call the SubtitleParser to parse the file
      final List<SubModel> subtitles =
          await SubParser.parseSrtFile('test_data.srt');

      // Verify the parsed data
      expect(subtitles, isNotEmpty);
      expect(subtitles.length, 2);
      expect(subtitles[0].id, 1);
      expect(subtitles[0].start, Duration(seconds: 1));
      expect(subtitles[0].end, Duration(seconds: 4));
      expect(subtitles[0].text, 'Hello, welcome to the test!');

      expect(subtitles[1].id, 2);
      expect(subtitles[1].start, Duration(seconds: 5));
      expect(subtitles[1].end, Duration(seconds: 8));
      expect(subtitles[1].text, 'This is the second subtitle.');
    });

    test('handles empty file gracefully', () async {
      final emptyFile = File('empty.srt');
      await emptyFile.writeAsString('');

      final List<SubModel> subtitles =
          await SubParser.parseSrtFile('empty.srt');

      expect(subtitles, isEmpty);
    });
  });
}

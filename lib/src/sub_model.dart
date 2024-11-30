/// Represents a subtitle with its timing and text content.
///
/// This model holds the data for a single subtitle, including its
/// start time, end time, and the text to be displayed during that
/// time frame. It is used by the `SubParser` to represent each
/// subtitle entry from subtitle files (e.g., SRT or VTT).
class SubModel {
  /// The unique identifier for this subtitle.
  ///
  /// This is typically the index of the subtitle in the subtitle file.
  final int id;

  /// The start time for this subtitle in the format [Duration].
  ///
  /// This indicates when the subtitle should start appearing on screen.
  final Duration start;

  /// The end time for this subtitle in the format [Duration].
  ///
  /// This indicates when the subtitle should stop appearing on screen.
  final Duration end;

  /// The text content of the subtitle.
  ///
  /// This contains the actual text that will be displayed to the user
  /// during the subtitle's time frame.
  final String text;

  /// Creates a new [SubModel] instance.
  ///
  /// Takes the [id], [start], [end], and [text] as parameters and
  /// initializes a subtitle object.
  SubModel({
    required this.id,
    required this.start,
    required this.end,
    required this.text,
  });
}

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

  @override
  String toString() => 'ID: $id, Start: $start, End: $end, Text: $text';
}

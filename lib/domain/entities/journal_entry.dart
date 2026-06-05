enum JournalMood { great, good, okay, bad, terrible }

extension JournalMoodX on JournalMood {
  String get emoji {
    switch (this) {
      case JournalMood.great:
        return '😄';
      case JournalMood.good:
        return '🙂';
      case JournalMood.okay:
        return '😐';
      case JournalMood.bad:
        return '😕';
      case JournalMood.terrible:
        return '😢';
    }
  }
}

class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.date,
  });

  final String id;
  final String title;
  final String content;
  final JournalMood mood;
  final DateTime date;

  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    JournalMood? mood,
    DateTime? date,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      date: date ?? this.date,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

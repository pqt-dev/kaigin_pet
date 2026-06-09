import 'package:kaigin_pet/data/models/journal_entry_model.dart';
import 'package:kaigin_pet/domain/entities/journal_entry.dart';

extension JournalEntryModelX on JournalEntryModel {
  JournalEntry toEntity() => JournalEntry(
        id: id,
        title: title,
        content: content,
        mood: _moodFromString(mood),
        date: DateTime.fromMillisecondsSinceEpoch(dateMs),
      );

  JournalMood _moodFromString(String value) =>
      JournalMood.values.firstWhere(
        (m) => m.name == value,
        orElse: () => JournalMood.okay,
      );
}

extension JournalEntryX on JournalEntry {
  JournalEntryModel toModel() => JournalEntryModel(
        id: id,
        title: title,
        content: content,
        mood: mood.name,
        dateMs: date.millisecondsSinceEpoch,
      );
}

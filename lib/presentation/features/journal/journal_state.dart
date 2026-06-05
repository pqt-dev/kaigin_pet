import 'package:kaigin_pet/domain/entities/journal_entry.dart';

sealed class JournalState {
  const JournalState();
}

final class JournalInitial extends JournalState {
  const JournalInitial();
}

final class JournalLoading extends JournalState {
  const JournalLoading();
}

final class JournalLoaded extends JournalState {
  const JournalLoaded(this.entries);

  final List<JournalEntry> entries;

  JournalLoaded copyWith(List<JournalEntry>? entries) =>
      JournalLoaded(entries ?? this.entries);
}

final class JournalError extends JournalState {
  const JournalError(this.message);

  final String message;
}

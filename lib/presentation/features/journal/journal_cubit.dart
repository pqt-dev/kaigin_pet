import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/journal_entry.dart';
import 'package:kaigin_pet/domain/use_cases/journal/delete_journal_entry_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/journal/get_journal_entries_use_case.dart';
import 'package:kaigin_pet/domain/use_cases/journal/save_journal_entry_use_case.dart';
import 'package:kaigin_pet/presentation/features/journal/journal_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class JournalCubit extends Cubit<JournalState> {
  JournalCubit(
    this._getEntries,
    this._saveEntry,
    this._deleteEntry,
  ) : super(const JournalInitial());

  final GetJournalEntriesUseCase _getEntries;
  final SaveJournalEntryUseCase _saveEntry;
  final DeleteJournalEntryUseCase _deleteEntry;

  Future<void> load() async {
    emit(const JournalLoading());
    final result = await _getEntries();
    if (result is Failure) {
      emit(const JournalError('Failed to load journal'));
      return;
    }
    emit(JournalLoaded((result as Success<List<JournalEntry>>).value));
  }

  Future<void> saveEntry(JournalEntry entry) async {
    final result = await _saveEntry(entry);
    if (result is Failure) return;
    final current = state;
    if (current is JournalLoaded) {
      final updated = [
        ...current.entries.where((e) => e.id != entry.id),
        entry,
      ]..sort((a, b) => b.date.compareTo(a.date));
      emit(current.copyWith(updated));
    }
  }

  Future<void> deleteEntry(String id) async {
    final result = await _deleteEntry(id);
    if (result is Failure) return;
    final current = state;
    if (current is JournalLoaded) {
      final updated = current.entries.where((e) => e.id != id).toList();
      emit(current.copyWith(updated));
    }
  }
}

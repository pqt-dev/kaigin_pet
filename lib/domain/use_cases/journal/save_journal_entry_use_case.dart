import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/journal_entry.dart';
import 'package:kaigin_pet/domain/repositories/journal/journal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveJournalEntryUseCase {
  SaveJournalEntryUseCase(this._repository);

  final JournalRepository _repository;

  Future<Result<void>> call(JournalEntry entry) =>
      _repository.saveEntry(entry);
}

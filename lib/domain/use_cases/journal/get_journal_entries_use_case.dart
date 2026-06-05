import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/journal_entry.dart';
import 'package:kaigin_pet/domain/repositories/journal/journal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetJournalEntriesUseCase {
  GetJournalEntriesUseCase(this._repository);

  final JournalRepository _repository;

  Future<Result<List<JournalEntry>>> call() => _repository.getEntries();
}

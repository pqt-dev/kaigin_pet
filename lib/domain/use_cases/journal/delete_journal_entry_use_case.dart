import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/repositories/journal/journal_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteJournalEntryUseCase {
  DeleteJournalEntryUseCase(this._repository);

  final JournalRepository _repository;

  Future<Result<void>> call(String id) => _repository.deleteEntry(id);
}

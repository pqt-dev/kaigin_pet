import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/journal_entry.dart';

abstract interface class JournalRepository {
  Future<Result<List<JournalEntry>>> getEntries();
  Future<Result<void>> saveEntry(JournalEntry entry);
  Future<Result<void>> deleteEntry(String id);
}

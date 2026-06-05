import 'package:kaigin_pet/data/datasource/journal/journal_datasource.dart';
import 'package:kaigin_pet/data/mappers/journal_mapper.dart';
import 'package:kaigin_pet/domain/core/app_error.dart';
import 'package:kaigin_pet/domain/core/result.dart';
import 'package:kaigin_pet/domain/entities/journal_entry.dart';
import 'package:kaigin_pet/domain/repositories/journal/journal_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: JournalRepository)
class JournalRepositoryImpl implements JournalRepository {
  JournalRepositoryImpl(this._datasource);

  final JournalDatasource _datasource;

  @override
  Future<Result<List<JournalEntry>>> getEntries() async {
    try {
      final models = await _datasource.getEntries();
      final entries = models.map((m) => m.toEntity()).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return Success(entries);
    } catch (e) {
      return const Failure(UnexpectedError());
    }
  }

  @override
  Future<Result<void>> saveEntry(JournalEntry entry) async {
    try {
      final current = await _datasource.getEntries();
      final updated = current.where((e) => e.id != entry.id).toList()
        ..add(entry.toModel());
      await _datasource.saveEntries(updated);
      return const Success(null);
    } catch (e) {
      return const Failure(UnexpectedError());
    }
  }

  @override
  Future<Result<void>> deleteEntry(String id) async {
    try {
      final current = await _datasource.getEntries();
      final updated = current.where((e) => e.id != id).toList();
      await _datasource.saveEntries(updated);
      return const Success(null);
    } catch (e) {
      return const Failure(UnexpectedError());
    }
  }
}

import 'package:kaigin_pet/data/models/journal/journal_entry_model.dart';

abstract interface class JournalDatasource {
  Future<List<JournalEntryModel>> getEntries();
  Future<void> saveEntries(List<JournalEntryModel> entries);
}

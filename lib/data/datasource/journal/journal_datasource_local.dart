import 'dart:convert';

import 'package:kaigin_pet/data/datasource/journal/journal_datasource.dart';
import 'package:kaigin_pet/data/models/journal_entry_model.dart';
import 'package:kaigin_pet/core/constants/storage_keys.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: JournalDatasource)
class JournalDatasourceLocal implements JournalDatasource {
  JournalDatasourceLocal(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<List<JournalEntryModel>> getEntries() async {
    final raw = _prefs.getString(StorageKeys.journalDataKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => JournalEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveEntries(List<JournalEntryModel> entries) async {
    final json = entries.map((e) => e.toJson()).toList();
    await _prefs.setString(StorageKeys.journalDataKey, jsonEncode(json));
  }
}

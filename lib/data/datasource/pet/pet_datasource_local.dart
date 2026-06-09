import 'dart:convert';

import 'package:kaigin_pet/data/datasource/pet/pet_datasource.dart';
import 'package:kaigin_pet/data/models/pet_model.dart';
import 'package:kaigin_pet/core/constants/storage_keys.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: PetDatasource)
class PetDatasourceLocal implements PetDatasource {
  PetDatasourceLocal(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<PetModel?> getPet() async {
    final raw = _prefs.getString(StorageKeys.petDataKey);
    if (raw == null) return null;
    return PetModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> savePet(PetModel pet) async {
    await _prefs.setString(StorageKeys.petDataKey, jsonEncode(pet.toJson()));
  }
}

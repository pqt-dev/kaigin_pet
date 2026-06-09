import 'package:json_annotation/json_annotation.dart';

part 'journal_entry_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class JournalEntryModel {
  const JournalEntryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.dateMs,
  });

  final String id;
  final String title;
  final String content;
  final String mood;
  final int dateMs;

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$JournalEntryModelToJson(this);
}

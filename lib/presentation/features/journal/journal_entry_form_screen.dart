import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/domain/entities/journal_entry.dart';
import 'package:kaigin_pet/generated/locale_keys.g.dart';
import 'package:kaigin_pet/presentation/features/journal/journal_cubit.dart';

class JournalEntryFormScreen extends StatefulWidget {
  const JournalEntryFormScreen({
    this.existing,
    super.key,
  });

  final JournalEntry? existing;

  @override
  State<JournalEntryFormScreen> createState() => _JournalEntryFormScreenState();
}

class _JournalEntryFormScreenState extends State<JournalEntryFormScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late JournalMood _mood;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.existing?.content ?? '');
    _mood = widget.existing?.mood ?? JournalMood.okay;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isEditing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing
            ? LocaleKeys.journal_edit_entry.tr()
            : LocaleKeys.journal_new_entry.tr()),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              LocaleKeys.save.tr(),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.journal_how_are_you.tr(),
                style: textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _MoodSelector(
                selected: _mood,
                onChanged: (mood) => setState(() => _mood = mood),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _titleCtrl,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: LocaleKeys.journal_entry_title_hint.tr(),
                  hintStyle: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Divider(color: scheme.outlineVariant),
              const SizedBox(height: 12),
              TextField(
                controller: _contentCtrl,
                maxLines: null,
                minLines: 6,
                style: textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: LocaleKeys.journal_entry_content_hint.tr(),
                  hintStyle: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.4),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final entry = JournalEntry(
      id: widget.existing?.id ??
          'journal_${DateTime.now().millisecondsSinceEpoch}',
      title: title.isEmpty ? LocaleKeys.journal_untitled.tr() : title,
      content: content,
      mood: _mood,
      date: widget.existing?.date ?? DateTime.now(),
    );

    context.read<JournalCubit>().saveEntry(entry);
    Navigator.pop(context);
  }
}

class _MoodSelector extends StatelessWidget {
  const _MoodSelector({
    required this.selected,
    required this.onChanged,
  });

  final JournalMood selected;
  final ValueChanged<JournalMood> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: JournalMood.values.map((mood) {
        final isSelected = selected == mood;
        return GestureDetector(
          onTap: () => onChanged(mood),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                mood.emoji,
                style: TextStyle(fontSize: isSelected ? 28 : 22),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

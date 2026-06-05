import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaigin_pet/domain/entities/journal_entry.dart';
import 'package:kaigin_pet/generated/locale_keys.g.dart';
import 'package:kaigin_pet/infrastructure/di/injection.dart';
import 'package:kaigin_pet/presentation/features/journal/journal_cubit.dart';
import 'package:kaigin_pet/presentation/features/journal/journal_entry_form_screen.dart';
import 'package:kaigin_pet/presentation/features/journal/journal_state.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<JournalCubit>()..load(),
      child: const _JournalView(),
    );
  }
}

class _JournalView extends StatelessWidget {
  const _JournalView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalCubit, JournalState>(
      builder: (context, state) {
        if (state is JournalLoading || state is JournalInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is JournalError) {
          return Center(child: Text(state.message));
        }
        if (state is JournalLoaded) {
          return _buildLoaded(context, state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoaded(BuildContext context, JournalLoaded state) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  LocaleKeys.journal_title.tr(),
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            if (state.entries.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📖', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text(
                        LocaleKeys.journal_empty.tr(),
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList.separated(
                  itemCount: state.entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = state.entries[index];
                    return _JournalCard(
                      entry: entry,
                      onTap: () => _openEntry(context, entry),
                      onDelete: () =>
                          context.read<JournalCubit>().deleteEntry(entry.id),
                    );
                  },
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNewEntry(context),
        icon: const Icon(Icons.edit_rounded),
        label: Text(LocaleKeys.journal_new_entry.tr()),
      ),
    );
  }

  void _openNewEntry(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<JournalCubit>(),
          child: const JournalEntryFormScreen(),
        ),
      ),
    );
  }

  void _openEntry(BuildContext context, JournalEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<JournalCubit>(),
          child: JournalEntryFormScreen(existing: entry),
        ),
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  const _JournalCard({
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  final JournalEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final isToday = _isSameDay(entry.date, now);
    final isYesterday =
        _isSameDay(entry.date, now.subtract(const Duration(days: 1)));

    final dateLabel = isToday
        ? LocaleKeys.journal_today.tr()
        : isYesterday
            ? LocaleKeys.journal_yesterday.tr()
            : DateFormat('MMM d, y').format(entry.date);

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: scheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_rounded, color: scheme.onError),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.mood.emoji,
                    style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (entry.content.isNotEmpty)
                        Text(
                          entry.content,
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 6),
                      Text(
                        dateLabel,
                        style: textTheme.labelSmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

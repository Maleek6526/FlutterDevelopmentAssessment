import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/items_provider.dart';
import '../../providers/theme_provider.dart';
import 'item_tile.dart';
import '../edit/edit_item_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(itemsProvider.notifier).load();
      await ref.read(themeModeProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(itemsProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                final isDark = themeMode == ThemeMode.dark;
                final bg = isDark ? cs.primaryContainer : cs.secondaryContainer;
                final fg = isDark ? cs.onPrimaryContainer : cs.onSecondaryContainer;
                return FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    backgroundColor: bg,
                    foregroundColor: fg,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onPressed: () => themeNotifier.toggle(),
                  icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                  label: Text(isDark ? 'Dark' : 'Light'),
                );
              },
            ),
          ),
        ],
      ),
      body: items.isEmpty
          ? _EmptyState(onAdd: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditItemPage()),
              );
            })
          : ListView.separated(
              padding: const EdgeInsets.only(top: 8, bottom: 88),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  background: _deleteBg(alignment: Alignment.centerLeft),
                  secondaryBackground: _deleteBg(alignment: Alignment.centerRight),
                  onDismissed: (_) async {
                    final messenger = ScaffoldMessenger.of(context);
                    await ref.read(itemsProvider.notifier).remove(item.id);
                    messenger.showSnackBar(const SnackBar(content: Text('Item deleted')));
                  },
                  child: ItemTile(
                    item: item,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EditItemPage(initial: item)),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EditItemPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
}

Widget _deleteBg({required Alignment alignment}) {
  return Container(
    alignment: alignment,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.red, Color(0xFFB71C1C)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: const Icon(Icons.delete, color: Colors.white),
  );
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 72, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text('No items yet', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Tap the button below to add your first item.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('Add Item')),
          ],
        ),
      ),
    );
  }
}
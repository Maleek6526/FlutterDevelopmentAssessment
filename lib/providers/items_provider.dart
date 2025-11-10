import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';

final itemsProvider = StateNotifierProvider<ItemsNotifier, List<Item>>((ref) {
  return ItemsNotifier();
});

class ItemsNotifier extends StateNotifier<List<Item>> {
  ItemsNotifier() : super(const []);

  static const _prefsKey = 'items_v1';
  SharedPreferences? _prefs;

  Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> load() async {
    await _ensurePrefs();
    final list = _prefs!.getStringList(_prefsKey) ?? const <String>[];
    state = list.map(Item.fromJsonString).toList();
  }

  Future<void> _persist() async {
    await _ensurePrefs();
    final list = state.map(Item.toJsonString).toList();
    await _prefs!.setStringList(_prefsKey, list);
  }

  Future<void> add(String title, {String? note}) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    state = [...state, Item(id: id, title: title, note: note)];
    await _persist();
  }

  Future<void> update(Item next) async {
    state = [
      for (final item in state)
        if (item.id == next.id) next else item,
    ];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = [
      for (final item in state)
        if (item.id != id) item,
    ];
    await _persist();
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import '../repositories/item_repository.dart';

// Repository Provider
final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepositoryImpl();
});

// Items State Provider (AsyncValue for loading states)
final itemsProvider = FutureProvider<List<ItemModel>>((ref) async {
  final repository = ref.watch(itemRepositoryProvider);
  return await repository.getItems();
});

// Selected Item Provider (for detail screen)
final selectedItemProvider = StateProvider<ItemModel?>((ref) => null);

// Current Carousel Index Provider
final currentCarouselIndexProvider = StateProvider<int>((ref) => 0);

// Filtered Items Provider (by category)
final filteredItemsProvider = Provider.family<List<ItemModel>, String?>((ref, category) {
  final itemsAsyncValue = ref.watch(itemsProvider);

  return itemsAsyncValue.when(
    data: (items) {
      if (category == null || category.isEmpty) {
        return items;
      }
      return items.where((item) => item.category == category).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Item Detail Provider (by id)
final itemDetailProvider = FutureProvider.family<ItemModel?, String>((ref, id) async {
  final repository = ref.watch(itemRepositoryProvider);
  return await repository.getItemById(id);
});

// Categories Provider
final categoriesProvider = Provider<List<String>>((ref) {
  final itemsAsyncValue = ref.watch(itemsProvider);

  return itemsAsyncValue.when(
    data: (items) {
      final categories = items.map((item) => item.category).toSet().toList();
      categories.sort();
      return categories;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Selected Category Provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
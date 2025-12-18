import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/item_model.dart';
import '../repositories/item_repository.dart';

part 'item_provider.g.dart';

// Repository Provider
@riverpod
ItemRepository itemRepository(Ref ref) {
  return ItemRepositoryImpl();
}

// Items Provider (AsyncValue for loading states)
@riverpod
Future<List<ItemModel>> items(Ref ref) async {
  final repository = ref.watch(itemRepositoryProvider);
  return await repository.getItems();
}

// Selected Item Provider (for detail screen)
@riverpod
class SelectedItem extends _$SelectedItem {
  @override
  ItemModel? build() => null;

  void select(ItemModel? item) {
    state = item;
  }

  void clear() {
    state = null;
  }
}

// Current Carousel Index Provider
@riverpod
class CurrentCarouselIndex extends _$CurrentCarouselIndex {
  @override
  int build() => 0;

  void update(int index) {
    state = index;
  }
}

// Filtered Items Provider (by category)
@riverpod
List<ItemModel> filteredItems(Ref ref, String? category) {
  final itemsAsyncValue = ref.watch(itemsProvider);

  return itemsAsyncValue.when(
    data: (items) {
      if (category == null || category.isEmpty) {
        return items;
      }
      return items.where((item) => item.category == category).toList();
    },
    loading: () => [],
    error: (_, _) => [],
  );
}

// Item Detail Provider (by id)
@riverpod
Future<ItemModel?> itemDetail(Ref ref, String id) async {
  final repository = ref.watch(itemRepositoryProvider);
  return await repository.getItemById(id);
}

// Categories Provider
@riverpod
List<String> categories(Ref ref) {
  final itemsAsyncValue = ref.watch(itemsProvider);

  return itemsAsyncValue.when(
    data: (items) {
      final categories = items.map((item) => item.category).toSet().toList();
      categories.sort();
      return categories;
    },
    loading: () => [],
    error: (_, _) => [],
  );
}

// Selected Category Provider
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String? build() => null;

  void select(String? category) {
    state = category;
  }

  void clear() {
    state = null;
  }
}
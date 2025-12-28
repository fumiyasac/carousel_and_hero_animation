import '../database/database.dart';
import '../models/item_model.dart';
import 'item_repository.dart';

abstract class FavoriteRepository {
  Future<void> addFavorite(String itemId);
  Future<void> removeFavorite(String itemId);
  Future<bool> isFavorite(String itemId);
  Future<List<String>> getAllFavoriteIds();
  Future<List<ItemModel>> getAllFavoriteItems();
  Future<int> getFavoriteCount();
  Future<void> clearAllFavorites();
}

class FavoriteRepositoryImpl implements FavoriteRepository {
  final AppDatabase _database;
  final ItemRepository _itemRepository;

  FavoriteRepositoryImpl({
    required AppDatabase database,
    required ItemRepository itemRepository,
  })  : _database = database,
        _itemRepository = itemRepository;

  @override
  Future<void> addFavorite(String itemId) async {
    await _database.addFavorite(itemId);
  }

  @override
  Future<void> removeFavorite(String itemId) async {
    await _database.removeFavorite(itemId);
  }

  @override
  Future<bool> isFavorite(String itemId) async {
    return await _database.isFavorite(itemId);
  }

  @override
  Future<List<String>> getAllFavoriteIds() async {
    return await _database.getAllFavoriteIds();
  }

  @override
  Future<List<ItemModel>> getAllFavoriteItems() async {
    final favoriteIds = await getAllFavoriteIds();
    if (favoriteIds.isEmpty) return [];

    // 全アイテムを取得してフィルタリング
    final allItems = await _itemRepository.getItems();
    return allItems.where((item) => favoriteIds.contains(item.id)).toList();
  }

  @override
  Future<int> getFavoriteCount() async {
    return await _database.getFavoriteCount();
  }

  @override
  Future<void> clearAllFavorites() async {
    await _database.clearAllFavorites();
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/database.dart';
import '../repositories/favorite_repository.dart';
import '../models/item_model.dart';
import 'item_provider.dart';

part 'favorite_provider.g.dart';

// Database Provider
@riverpod
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
}

// Repository Provider
@riverpod
FavoriteRepository favoriteRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  final itemRepository = ref.watch(itemRepositoryProvider);
  return FavoriteRepositoryImpl(
    database: database,
    itemRepository: itemRepository,
  );
}

// お気に入り一覧プロバイダー（全ItemModelを含む）
@riverpod
Future<List<ItemModel>> favoriteItems(Ref ref) async {
  final repository = ref.watch(favoriteRepositoryProvider);
  return await repository.getAllFavoriteItems();
}

// お気に入りID一覧プロバイダー
@riverpod
Future<List<String>> favoriteIds(Ref ref) async {
  final repository = ref.watch(favoriteRepositoryProvider);
  return await repository.getAllFavoriteIds();
}

// 特定IDがお気に入りかチェック
@riverpod
Future<bool> isFavorite(Ref ref, String itemId) async {
  final repository = ref.watch(favoriteRepositoryProvider);
  return await repository.isFavorite(itemId);
}

// お気に入り操作用Notifier
@riverpod
class FavoriteNotifier extends _$FavoriteNotifier {
  @override
  FutureOr<void> build() {}

  // お気に入り追加
  Future<void> addFavorite(String itemId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(favoriteRepositoryProvider);
      await repository.addFavorite(itemId);
      // 関連プロバイダーを無効化して再取得
      ref.invalidate(favoriteItemsProvider);
      ref.invalidate(favoriteIdsProvider);
      ref.invalidate(isFavoriteProvider);
    });
  }

  // お気に入り削除
  Future<void> removeFavorite(String itemId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(favoriteRepositoryProvider);
      await repository.removeFavorite(itemId);
      // 関連プロバイダーを無効化して再取得
      ref.invalidate(favoriteItemsProvider);
      ref.invalidate(favoriteIdsProvider);
      ref.invalidate(isFavoriteProvider);
    });
  }

  // お気に入りトグル
  Future<void> toggleFavorite(String itemId) async {
    final repository = ref.read(favoriteRepositoryProvider);
    final isFav = await repository.isFavorite(itemId);

    if (isFav) {
      await removeFavorite(itemId);
    } else {
      await addFavorite(itemId);
    }
  }

  // すべてクリア
  Future<void> clearAll() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(favoriteRepositoryProvider);
      await repository.clearAllFavorites();
      ref.invalidate(favoriteItemsProvider);
      ref.invalidate(favoriteIdsProvider);
    });
  }
}

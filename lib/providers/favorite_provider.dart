import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/database.dart';
import '../repositories/favorite_repository.dart';
import '../models/item_model.dart';
import 'item_provider.dart';

// build_runnerで自動生成されるコードをインポート
part 'favorite_provider.g.dart';

// ========================================
// Database Provider（データベースインスタンス管理）
// ========================================
// Drift（SQLite）データベースのインスタンスを提供するProvider
// アプリケーション全体で単一のデータベース接続を共有する
@riverpod
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  // ref.onDispose()でProviderが破棄される際のクリーンアップ処理を登録
  // データベース接続を適切にクローズすることでメモリリークを防ぐ
  ref.onDispose(() => database.close());
  return database;
}

// ========================================
// Favorite Repository Provider（お気に入りリポジトリ）
// ========================================
// お気に入り機能のリポジトリを提供するProvider
// データベースとアイテムリポジトリの両方に依存している
@riverpod
FavoriteRepository favoriteRepository(Ref ref) {
  // 複数のProviderを監視して、それらの値を使ってリポジトリを構築
  final database = ref.watch(appDatabaseProvider);
  final itemRepository = ref.watch(itemRepositoryProvider);
  return FavoriteRepositoryImpl(
    database: database,
    itemRepository: itemRepository,
  );
}

// ========================================
// Favorite Items Provider（お気に入りアイテム一覧）
// ========================================
// お気に入りに登録されている全アイテム（ItemModel）を取得するProvider
// お気に入り画面で使用される
@riverpod
Future<List<ItemModel>> favoriteItems(Ref ref) async {
  final repository = ref.watch(favoriteRepositoryProvider);
  // データベースからお気に入りIDを取得し、ItemModelに変換したリストを返す
  return await repository.getAllFavoriteItems();
}

// ========================================
// Favorite IDs Provider（お気に入りID一覧）
// ========================================
// お気に入りに登録されているアイテムのID一覧を取得するProvider
// アイテム全体ではなくIDのみが必要な場合に使用（軽量）
@riverpod
Future<List<String>> favoriteIds(Ref ref) async {
  final repository = ref.watch(favoriteRepositoryProvider);
  return await repository.getAllFavoriteIds();
}

// ========================================
// Is Favorite Provider（お気に入り判定）
// ========================================
// 指定されたアイテムIDがお気に入りに登録されているかを判定するProvider
// パラメータ付きProviderのため、isFavoriteProvider(itemId) という形で使用する
@riverpod
Future<bool> isFavorite(Ref ref, String itemId) async {
  final repository = ref.watch(favoriteRepositoryProvider);
  return await repository.isFavorite(itemId);
}

// ========================================
// Favorite Notifier（お気に入り操作用Notifier）
// ========================================
// お気に入りの追加・削除・トグル・全削除などの操作を行うNotifier
// 非同期アクションを実行し、状態（AsyncValue）を管理する
@riverpod
class FavoriteNotifier extends _$FavoriteNotifier {
  // 初期状態を定義（FutureOr<void>はFutureまたはvoidを返すことを表す）
  // この場合、特に初期処理は必要ないためvoidを返す
  @override
  FutureOr<void> build() {}

  // ========================================
  // お気に入り追加メソッド
  // ========================================
  Future<void> addFavorite(String itemId) async {
    // 処理開始時にloading状態にする（UIでローディング表示が可能）
    state = const AsyncValue.loading();
    // AsyncValue.guard()は例外を自動的にキャッチしてAsyncValue.errorに変換する
    // try-catchを書く必要がなく、エラーハンドリングが簡潔になる
    state = await AsyncValue.guard(() async {
      // ref.read()は値を一度だけ取得する（監視しない）
      // アクション内では通常ref.read()を使用する
      final repository = ref.read(favoriteRepositoryProvider);
      await repository.addFavorite(itemId);

      // ref.invalidate()で関連するProviderのキャッシュを無効化
      // これにより、次回のref.watch()時に自動的に再取得される
      // お気に入り一覧を更新
      ref.invalidate(favoriteItemsProvider);
      // お気に入りID一覧を更新
      ref.invalidate(favoriteIdsProvider);
      // お気に入り判定を更新（全てのitemIdパターンのキャッシュをクリア）
      ref.invalidate(isFavoriteProvider);
    });
  }

  // ========================================
  // お気に入り削除メソッド
  // ========================================
  Future<void> removeFavorite(String itemId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(favoriteRepositoryProvider);
      await repository.removeFavorite(itemId);
      // 削除後も関連Providerを無効化して、UIを最新の状態に更新
      ref.invalidate(favoriteItemsProvider);
      ref.invalidate(favoriteIdsProvider);
      ref.invalidate(isFavoriteProvider);
    });
  }

  // ========================================
  // お気に入りトグルメソッド
  // ========================================
  // お気に入り状態を反転させる（登録済みなら削除、未登録なら追加）
  // ハートボタンなどのトグル操作で使用される
  Future<void> toggleFavorite(String itemId) async {
    final repository = ref.read(favoriteRepositoryProvider);
    // 現在のお気に入り状態をチェック
    final isFav = await repository.isFavorite(itemId);

    // 状態に応じて追加または削除を実行
    if (isFav) {
      await removeFavorite(itemId);
    } else {
      await addFavorite(itemId);
    }
  }

  // ========================================
  // 全てクリアメソッド
  // ========================================
  // お気に入りに登録されている全てのアイテムを削除する
  Future<void> clearAll() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(favoriteRepositoryProvider);
      await repository.clearAllFavorites();
      // 全削除後、関連Providerを無効化
      ref.invalidate(favoriteItemsProvider);
      ref.invalidate(favoriteIdsProvider);
      // isFavoriteProviderは全てfalseになるため、無効化は任意
    });
  }
}

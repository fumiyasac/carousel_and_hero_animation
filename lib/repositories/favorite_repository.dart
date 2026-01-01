import '../database/database.dart';
import '../models/item_model.dart';
import 'item_repository.dart';

// ========================================
// Favorite Repository（お気に入りリポジトリ抽象クラス）
// ========================================
// お気に入り機能のデータ操作を定義する抽象クラス
// データベース（永続化）とアイテムデータ（表示用）の橋渡しを行う
abstract class FavoriteRepository {
  // お気に入りに追加
  Future<void> addFavorite(String itemId);

  // お気に入りから削除
  Future<void> removeFavorite(String itemId);

  // お気に入り登録済みかチェック
  Future<bool> isFavorite(String itemId);

  // お気に入りIDの一覧を取得
  Future<List<String>> getAllFavoriteIds();

  // お気に入りアイテム（ItemModel）の一覧を取得
  Future<List<ItemModel>> getAllFavoriteItems();

  // お気に入りの件数を取得
  Future<int> getFavoriteCount();

  // お気に入りを全て削除
  Future<void> clearAllFavorites();
}

// ========================================
// Favorite Repository Implementation（実装クラス）
// ========================================
// FavoriteRepositoryの実装クラス
// データベースとアイテムリポジトリの両方に依存している
class FavoriteRepositoryImpl implements FavoriteRepository {
  // Driftデータベースインスタンス（お気に入りIDを永続化）
  final AppDatabase _database;
  // アイテムリポジトリ（IDからItemModelを取得するため）
  final ItemRepository _itemRepository;

  // コンストラクタで依存関係を注入（Dependency Injection）
  // required パラメータにより、インスタンス化時に必ず指定する必要がある
  FavoriteRepositoryImpl({
    required AppDatabase database,
    required ItemRepository itemRepository,
  })  : _database = database,
        _itemRepository = itemRepository;

  // ========================================
  // お気に入り追加
  // ========================================
  @override
  Future<void> addFavorite(String itemId) async {
    // データベースのaddFavoriteメソッドを呼び出してIDを永続化
    await _database.addFavorite(itemId);
  }

  // ========================================
  // お気に入り削除
  // ========================================
  @override
  Future<void> removeFavorite(String itemId) async {
    // データベースのremoveFavoriteメソッドを呼び出してIDを削除
    await _database.removeFavorite(itemId);
  }

  // ========================================
  // お気に入り登録チェック
  // ========================================
  @override
  Future<bool> isFavorite(String itemId) async {
    // データベースに該当IDが存在するかチェック
    return await _database.isFavorite(itemId);
  }

  // ========================================
  // お気に入りID一覧取得
  // ========================================
  @override
  Future<List<String>> getAllFavoriteIds() async {
    // データベースから全てのお気に入りIDを取得
    return await _database.getAllFavoriteIds();
  }

  // ========================================
  // お気に入りアイテム一覧取得
  // ========================================
  // データベースに保存されているIDから、実際のItemModelオブジェクトを取得する
  // これにより、お気に入り画面で表示に必要な全ての情報を取得できる
  @override
  Future<List<ItemModel>> getAllFavoriteItems() async {
    // まずお気に入りIDの一覧を取得
    final favoriteIds = await getAllFavoriteIds();
    // お気に入りがない場合は空リストを返す
    if (favoriteIds.isEmpty) return [];

    // 全アイテムを取得
    final allItems = await _itemRepository.getItems();
    // お気に入りIDに含まれるアイテムのみをフィルタリング
    // where()で条件に一致するアイテムを抽出
    // contains()でIDが一覧に含まれるかチェック
    return allItems.where((item) => favoriteIds.contains(item.id)).toList();
  }

  // ========================================
  // お気に入り件数取得
  // ========================================
  @override
  Future<int> getFavoriteCount() async {
    // データベースからお気に入りの総数を取得
    return await _database.getFavoriteCount();
  }

  // ========================================
  // 全削除
  // ========================================
  @override
  Future<void> clearAllFavorites() async {
    // データベースから全てのお気に入りを削除
    await _database.clearAllFavorites();
  }
}

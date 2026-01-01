import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/item_model.dart';
import '../repositories/item_repository.dart';

// build_runnerで自動生成されるコード（item_provider.g.dart）をインポートするための宣言
// コマンド: dart run build_runner build --delete-conflicting-outputs
part 'item_provider.g.dart';

// ========================================
// Repository Provider
// ========================================
// ItemRepositoryの実装インスタンスを提供するProvider
// @riverpod アノテーションにより、関数名に基づいて自動的に Provider が生成される
// 生成されるProvider名: itemRepositoryProvider
// この関数が返す値は、他のProviderで ref.watch(itemRepositoryProvider) として使用できる
@riverpod
ItemRepository itemRepository(Ref ref) {
  // Repositoryの具体的な実装を返す
  // 本来はAPI実装やモック実装を切り替えることが可能（DI: Dependency Injection）
  return ItemRepositoryImpl();
}

// ========================================
// Items Provider（全アイテムリスト取得）
// ========================================
// 全てのアイテムデータを非同期で取得するProvider
// 戻り値がFuture<T>の場合、自動的にAsyncValue<T>にラップされる
// AsyncValueは以下3つの状態を持つ: loading（読込中）、data（成功）、error（エラー）
// UIでは ref.watch(itemsProvider).when() でこれらの状態に応じた処理を実装する
@riverpod
Future<List<ItemModel>> items(Ref ref) async {
  // ref.watch()で他のProviderを監視する（依存関係を作る）
  // itemRepositoryProviderの値が変わると、このProviderも自動的に再実行される
  final repository = ref.watch(itemRepositoryProvider);

  // リポジトリからアイテムリストを非同期取得
  // この処理の間、UIではAsyncValue.loading状態になる
  return await repository.getItems();
}

// ========================================
// Selected Item Provider（選択中のアイテム管理）
// ========================================
// 現在選択されているアイテムを保持するProvider
// クラスベースのProviderは「状態の変更（mutation）」を行う場合に使用する
// @riverpodクラスは内部で _$SelectedItem という基底クラスを自動生成する
@riverpod
class SelectedItem extends _$SelectedItem {
  // build()メソッドで初期状態を定義する
  // この場合、初期状態は「何も選択されていない」ことを表すnull
  @override
  ItemModel? build() => null;

  // アイテムを選択するメソッド
  // stateを更新すると、このProviderを監視しているWidgetが自動的に再描画される
  void select(ItemModel? item) {
    state = item;
  }

  // 選択をクリアするメソッド
  void clear() {
    state = null;
  }
}

// ========================================
// Current Carousel Index Provider（カルーセルの現在位置）
// ========================================
// カルーセル（スライダー）の現在のインデックスを管理するProvider
// ページ切り替えやドット表示の更新などで使用される
@riverpod
class CurrentCarouselIndex extends _$CurrentCarouselIndex {
  // 初期状態は0（最初のスライド）
  @override
  int build() => 0;

  // カルーセルがスライドした際に、インデックスを更新する
  void update(int index) {
    state = index;
  }
}

// ========================================
// Filtered Items Provider（カテゴリーフィルタリング）
// ========================================
// カテゴリーに基づいてアイテムリストをフィルタリングするProvider
// パラメータを受け取るProviderの例: filteredItemsProvider(category) という形式で使用する
// パラメータが変更されると、自動的に再計算される
@riverpod
List<ItemModel> filteredItems(Ref ref, String? category) {
  // itemsProviderの値を監視（AsyncValue<List<ItemModel>>）
  final itemsAsyncValue = ref.watch(itemsProvider);

  // AsyncValue.when()で状態に応じた処理を行う
  // data: データ取得成功時の処理
  // loading: 読込中の処理（空リストを返す）
  // error: エラー時の処理（空リストを返す）
  return itemsAsyncValue.when(
    data: (items) {
      // categoryがnullまたは空文字の場合は全てのアイテムを返す
      if (category == null || category.isEmpty) {
        return items;
      }
      // 指定されたカテゴリーに一致するアイテムのみをフィルタリング
      return items.where((item) => item.category == category).toList();
    },
    loading: () => [],
    error: (_, _) => [],
  );
}

// ========================================
// Item Detail Provider（個別アイテム詳細取得）
// ========================================
// 指定されたIDのアイテム詳細を非同期で取得するProvider
// パラメータ付きProviderのため、itemDetailProvider(id) という形で使用する
// 異なるIDで呼び出すと、それぞれ独立したキャッシュを持つ
@riverpod
Future<ItemModel?> itemDetail(Ref ref, String id) async {
  final repository = ref.watch(itemRepositoryProvider);
  // リポジトリから指定IDのアイテムを取得（存在しない場合はnull）
  return await repository.getItemById(id);
}

// ========================================
// Categories Provider（カテゴリー一覧抽出）
// ========================================
// 全アイテムから重複なしのカテゴリー一覧を抽出するProvider
// itemsProviderに依存しており、アイテムデータが更新されると自動的に再計算される
@riverpod
List<String> categories(Ref ref) {
  final itemsAsyncValue = ref.watch(itemsProvider);

  return itemsAsyncValue.when(
    data: (items) {
      // 各アイテムのcategoryプロパティをmap()で抽出
      // toSet()で重複を除去（Setは重複を許さないコレクション）
      // toList()でリストに変換
      final categories = items.map((item) => item.category).toSet().toList();
      // アルファベット順にソート
      categories.sort();
      return categories;
    },
    loading: () => [],
    error: (_, _) => [],
  );
}

// ========================================
// Selected Category Provider（選択中のカテゴリー管理）
// ========================================
// 現在選択されているカテゴリーを保持するProvider
// フィルタリングUIで使用される
@riverpod
class SelectedCategory extends _$SelectedCategory {
  // 初期状態はnull（全てのカテゴリーを表示）
  @override
  String? build() => null;

  // カテゴリーを選択する
  void select(String? category) {
    state = category;
  }

  // 選択をクリアする（全て表示に戻す）
  void clear() {
    state = null;
  }
}
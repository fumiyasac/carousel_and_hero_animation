import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/item_model.dart';
import '../models/search_filter_model.dart';
import 'item_provider.dart';

// build_runnerで自動生成されるコードをインポート
part 'search_provider.g.dart';

// ========================================
// Search Query Provider（検索クエリ管理）
// ========================================
// ユーザーが入力した検索文字列を管理するProvider
// 検索バーの入力内容とリアルタイムで同期される
@riverpod
class SearchQuery extends _$SearchQuery {
  // 初期状態は空文字列（検索なし）
  @override
  String build() => '';

  // 検索文字列を更新する
  // TextFieldのonChangedコールバックで使用される
  void update(String query) {
    state = query;
  }

  // 検索文字列をクリアする
  void clear() {
    state = '';
  }
}

// ========================================
// Search Filter Provider（検索フィルター条件管理）
// ========================================
// 検索時の詳細なフィルター条件を管理するProvider
// カテゴリー、価格範囲、評価、ベジタリアン、辛さ、タグなどの複合条件を扱う
@riverpod
class SearchFilter extends _$SearchFilter {
  // 初期状態は全てのフィルターが未設定（SearchFilterModelのデフォルト値）
  @override
  SearchFilterModel build() => SearchFilterModel();

  // カテゴリーフィルターを更新
  void updateCategory(String? category) {
    // state.copyWith()で現在の状態をコピーし、指定したフィールドのみ更新する
    // clearCategory: trueの場合、categoryフィールドをnullにリセットする
    state = state.copyWith(
      category: category,
      clearCategory: category == null,
    );
  }

  // 価格範囲フィルターを更新
  // 最小価格と最大価格を同時に設定できる
  void updatePriceRange(double? minPrice, double? maxPrice) {
    state = state.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      clearMinPrice: minPrice == null,
      clearMaxPrice: maxPrice == null,
    );
  }

  // 最小評価フィルターを更新
  // 例: 4.0以上の評価のアイテムのみ表示
  void updateMinRating(double? rating) {
    state = state.copyWith(
      minRating: rating,
      clearMinRating: rating == null,
    );
  }

  // ベジタリアンフィルターを更新
  // true: ベジタリアン向けのみ、false: 非ベジタリアンのみ、null: 条件なし
  void updateIsVegetarian(bool? value) {
    state = state.copyWith(
      isVegetarian: value,
      clearIsVegetarian: value == null,
    );
  }

  // 辛さフィルターを更新
  // true: 辛い料理のみ、false: 辛くない料理のみ、null: 条件なし
  void updateIsSpicy(bool? value) {
    state = state.copyWith(
      isSpicy: value,
      clearIsSpicy: value == null,
    );
  }

  // タグフィルターを更新
  // 複数のタグを指定可能（例: ["人気", "おすすめ"]）
  void updateTags(List<String>? tags) {
    state = state.copyWith(
      tags: tags,
      clearTags: tags == null || tags.isEmpty,
    );
  }

  // 全てのフィルターをクリアする
  // 新しいSearchFilterModelインスタンスを作成することで初期状態に戻す
  void clearAll() {
    state = SearchFilterModel();
  }

  // フィルター全体を一括更新する
  // FilterBottomSheetで「適用」ボタンを押した際などに使用
  void updateAll(SearchFilterModel filter) {
    state = filter;
  }
}

// ========================================
// View Mode（表示モード列挙型）
// ========================================
// 検索結果の表示形式を定義する列挙型
// list: リスト表示（縦に並ぶ）、grid: グリッド表示（2列で並ぶ）
enum ViewMode { list, grid }

// ========================================
// Search View Mode Provider（表示モード管理）
// ========================================
// 検索結果画面の表示モード（リスト/グリッド）を管理するProvider
@riverpod
class SearchViewMode extends _$SearchViewMode {
  // 初期状態はグリッド表示
  @override
  ViewMode build() => ViewMode.grid;

  // 表示モードをトグル（切り替え）する
  // グリッド→リスト、リスト→グリッドと交互に変更される
  void toggle() {
    state = state == ViewMode.grid ? ViewMode.list : ViewMode.grid;
  }

  // 表示モードを直接設定する
  void set(ViewMode mode) {
    state = mode;
  }
}

// ========================================
// Search Results Provider（検索結果取得）
// ========================================
// 検索クエリとフィルター条件に基づいて、マッチするアイテムを取得するProvider
// searchQueryProviderとsearchFilterProviderの両方に依存しており、
// どちらかが変更されると自動的に再検索が実行される
@riverpod
Future<List<ItemModel>> searchResults(Ref ref) async {
  // 現在の検索文字列を取得
  final query = ref.watch(searchQueryProvider);
  // 現在のフィルター条件を取得
  final filter = ref.watch(searchFilterProvider);
  // アイテムリポジトリを取得
  final repository = ref.watch(itemRepositoryProvider);

  // リポジトリの検索メソッドを呼び出して結果を取得
  // 検索クエリとフィルター条件の全てを渡す
  return await repository.searchItems(
    query: query,
    category: filter.category,
    minPrice: filter.minPrice,
    maxPrice: filter.maxPrice,
    minRating: filter.minRating,
    isVegetarian: filter.isVegetarian,
    isSpicy: filter.isSpicy,
    tags: filter.tags,
  );
}

// ========================================
// Available Tags Provider（利用可能なタグ一覧）
// ========================================
// 全アイテムから重複なしのタグ一覧を抽出するProvider
// フィルター画面でタグ選択肢を表示する際に使用される
@riverpod
List<String> availableTags(Ref ref) {
  final itemsAsyncValue = ref.watch(itemsProvider);

  return itemsAsyncValue.when(
    data: (items) {
      // Set<String>を使用して重複を自動的に除去
      final tags = <String>{};
      // 各アイテムのtagsリストを全てSetに追加
      for (var item in items) {
        tags.addAll(item.tags);
      }
      // SetをListに変換
      final tagList = tags.toList();
      // アルファベット順にソート
      tagList.sort();
      return tagList;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

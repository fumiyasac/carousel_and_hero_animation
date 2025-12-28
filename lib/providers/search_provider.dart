import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/item_model.dart';
import '../models/search_filter_model.dart';
import 'item_provider.dart';

part 'search_provider.g.dart';

// 検索クエリプロバイダー
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

// フィルター条件プロバイダー
@riverpod
class SearchFilter extends _$SearchFilter {
  @override
  SearchFilterModel build() => SearchFilterModel();

  void updateCategory(String? category) {
    state = state.copyWith(
      category: category,
      clearCategory: category == null,
    );
  }

  void updatePriceRange(double? minPrice, double? maxPrice) {
    state = state.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      clearMinPrice: minPrice == null,
      clearMaxPrice: maxPrice == null,
    );
  }

  void updateMinRating(double? rating) {
    state = state.copyWith(
      minRating: rating,
      clearMinRating: rating == null,
    );
  }

  void updateIsVegetarian(bool? value) {
    state = state.copyWith(
      isVegetarian: value,
      clearIsVegetarian: value == null,
    );
  }

  void updateIsSpicy(bool? value) {
    state = state.copyWith(
      isSpicy: value,
      clearIsSpicy: value == null,
    );
  }

  void updateTags(List<String>? tags) {
    state = state.copyWith(
      tags: tags,
      clearTags: tags == null || tags.isEmpty,
    );
  }

  void clearAll() {
    state = SearchFilterModel();
  }

  void updateAll(SearchFilterModel filter) {
    state = filter;
  }
}

// 表示モードプロバイダー（リスト/グリッド）
enum ViewMode { list, grid }

@riverpod
class SearchViewMode extends _$SearchViewMode {
  @override
  ViewMode build() => ViewMode.grid;

  void toggle() {
    state = state == ViewMode.grid ? ViewMode.list : ViewMode.grid;
  }

  void set(ViewMode mode) {
    state = mode;
  }
}

// 検索結果プロバイダー
@riverpod
Future<List<ItemModel>> searchResults(Ref ref) async {
  final query = ref.watch(searchQueryProvider);
  final filter = ref.watch(searchFilterProvider);
  final repository = ref.watch(itemRepositoryProvider);

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

// 利用可能なタグ一覧プロバイダー
@riverpod
List<String> availableTags(Ref ref) {
  final itemsAsyncValue = ref.watch(itemsProvider);

  return itemsAsyncValue.when(
    data: (items) {
      final tags = <String>{};
      for (var item in items) {
        tags.addAll(item.tags);
      }
      final tagList = tags.toList();
      tagList.sort();
      return tagList;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

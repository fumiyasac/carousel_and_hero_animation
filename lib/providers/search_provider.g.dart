// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchQuery)
const searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  const SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'b07ebd22fb9cb0db36c8d833cc6e21f4fcbd9b7b';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SearchFilter)
const searchFilterProvider = SearchFilterProvider._();

final class SearchFilterProvider
    extends $NotifierProvider<SearchFilter, SearchFilterModel> {
  const SearchFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchFilterHash();

  @$internal
  @override
  SearchFilter create() => SearchFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchFilterModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFilterModel>(value),
    );
  }
}

String _$searchFilterHash() => r'c0c3c46b213ec99f4299337b4a0195a2e15fb9b1';

abstract class _$SearchFilter extends $Notifier<SearchFilterModel> {
  SearchFilterModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SearchFilterModel, SearchFilterModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchFilterModel, SearchFilterModel>,
              SearchFilterModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SearchViewMode)
const searchViewModeProvider = SearchViewModeProvider._();

final class SearchViewModeProvider
    extends $NotifierProvider<SearchViewMode, ViewMode> {
  const SearchViewModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchViewModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchViewModeHash();

  @$internal
  @override
  SearchViewMode create() => SearchViewMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ViewMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ViewMode>(value),
    );
  }
}

String _$searchViewModeHash() => r'67d95dff1d450de242e145097dcebe1293d1b6f9';

abstract class _$SearchViewMode extends $Notifier<ViewMode> {
  ViewMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ViewMode, ViewMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ViewMode, ViewMode>,
              ViewMode,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(searchResults)
const searchResultsProvider = SearchResultsProvider._();

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ItemModel>>,
          List<ItemModel>,
          FutureOr<List<ItemModel>>
        >
    with $FutureModifier<List<ItemModel>>, $FutureProvider<List<ItemModel>> {
  const SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<ItemModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ItemModel>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'e0d7c5b689725ce8b479a3d99f6b2ada754219c4';

@ProviderFor(availableTags)
const availableTagsProvider = AvailableTagsProvider._();

final class AvailableTagsProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  const AvailableTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableTagsHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return availableTags(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$availableTagsHash() => r'5c7640aa008d47b12897e0b96dec30ccbe77493f';

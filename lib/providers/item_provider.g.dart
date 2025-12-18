// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(itemRepository)
const itemRepositoryProvider = ItemRepositoryProvider._();

final class ItemRepositoryProvider
    extends $FunctionalProvider<ItemRepository, ItemRepository, ItemRepository>
    with $Provider<ItemRepository> {
  const ItemRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'itemRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$itemRepositoryHash();

  @$internal
  @override
  $ProviderElement<ItemRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ItemRepository create(Ref ref) {
    return itemRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ItemRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ItemRepository>(value),
    );
  }
}

String _$itemRepositoryHash() => r'0c701f27579c7ec66e70043c5ed873448df6fcf2';

@ProviderFor(items)
const itemsProvider = ItemsProvider._();

final class ItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ItemModel>>,
          List<ItemModel>,
          FutureOr<List<ItemModel>>
        >
    with $FutureModifier<List<ItemModel>>, $FutureProvider<List<ItemModel>> {
  const ItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'itemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$itemsHash();

  @$internal
  @override
  $FutureProviderElement<List<ItemModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ItemModel>> create(Ref ref) {
    return items(ref);
  }
}

String _$itemsHash() => r'fc9421dd058d46e1e14eda33ac4f660fee65971f';

@ProviderFor(SelectedItem)
const selectedItemProvider = SelectedItemProvider._();

final class SelectedItemProvider
    extends $NotifierProvider<SelectedItem, ItemModel?> {
  const SelectedItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedItemHash();

  @$internal
  @override
  SelectedItem create() => SelectedItem();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ItemModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ItemModel?>(value),
    );
  }
}

String _$selectedItemHash() => r'97ec715a46d92f780fc0563a2ca4c6c06aaf2aff';

abstract class _$SelectedItem extends $Notifier<ItemModel?> {
  ItemModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ItemModel?, ItemModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ItemModel?, ItemModel?>,
              ItemModel?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CurrentCarouselIndex)
const currentCarouselIndexProvider = CurrentCarouselIndexProvider._();

final class CurrentCarouselIndexProvider
    extends $NotifierProvider<CurrentCarouselIndex, int> {
  const CurrentCarouselIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentCarouselIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentCarouselIndexHash();

  @$internal
  @override
  CurrentCarouselIndex create() => CurrentCarouselIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$currentCarouselIndexHash() =>
    r'9e38bebf2b13e8c011322636aad03ee69c41dfe0';

abstract class _$CurrentCarouselIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(filteredItems)
const filteredItemsProvider = FilteredItemsFamily._();

final class FilteredItemsProvider
    extends
        $FunctionalProvider<List<ItemModel>, List<ItemModel>, List<ItemModel>>
    with $Provider<List<ItemModel>> {
  const FilteredItemsProvider._({
    required FilteredItemsFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'filteredItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredItemsHash();

  @override
  String toString() {
    return r'filteredItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<ItemModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<ItemModel> create(Ref ref) {
    final argument = this.argument as String?;
    return filteredItems(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ItemModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ItemModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredItemsHash() => r'd9d50d850ec79064a91588d1fc2913b6d0887f0f';

final class FilteredItemsFamily extends $Family
    with $FunctionalFamilyOverride<List<ItemModel>, String?> {
  const FilteredItemsFamily._()
    : super(
        retry: null,
        name: r'filteredItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilteredItemsProvider call(String? category) =>
      FilteredItemsProvider._(argument: category, from: this);

  @override
  String toString() => r'filteredItemsProvider';
}

@ProviderFor(itemDetail)
const itemDetailProvider = ItemDetailFamily._();

final class ItemDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<ItemModel?>,
          ItemModel?,
          FutureOr<ItemModel?>
        >
    with $FutureModifier<ItemModel?>, $FutureProvider<ItemModel?> {
  const ItemDetailProvider._({
    required ItemDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'itemDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$itemDetailHash();

  @override
  String toString() {
    return r'itemDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ItemModel?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ItemModel?> create(Ref ref) {
    final argument = this.argument as String;
    return itemDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$itemDetailHash() => r'3049592ccd48096cca1fb1b7dfd50d236e544294';

final class ItemDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ItemModel?>, String> {
  const ItemDetailFamily._()
    : super(
        retry: null,
        name: r'itemDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ItemDetailProvider call(String id) =>
      ItemDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'itemDetailProvider';
}

@ProviderFor(categories)
const categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  const CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return categories(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$categoriesHash() => r'194a2edd41f517651930790226ecbca370126f76';

@ProviderFor(SelectedCategory)
const selectedCategoryProvider = SelectedCategoryProvider._();

final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, String?> {
  const SelectedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedCategoryHash() => r'15a9bfca2a88632b35a96235378d29638f43194c';

abstract class _$SelectedCategory extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

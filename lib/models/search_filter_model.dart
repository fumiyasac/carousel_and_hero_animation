class SearchFilterModel {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? isVegetarian;
  final bool? isSpicy;
  final List<String>? tags;

  SearchFilterModel({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.isVegetarian,
    this.isSpicy,
    this.tags,
  });

  SearchFilterModel copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? isVegetarian,
    bool? isSpicy,
    List<String>? tags,
    bool clearCategory = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinRating = false,
    bool clearIsVegetarian = false,
    bool clearIsSpicy = false,
    bool clearTags = false,
  }) {
    return SearchFilterModel(
      category: clearCategory ? null : (category ?? this.category),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      minRating: clearMinRating ? null : (minRating ?? this.minRating),
      isVegetarian: clearIsVegetarian ? null : (isVegetarian ?? this.isVegetarian),
      isSpicy: clearIsSpicy ? null : (isSpicy ?? this.isSpicy),
      tags: clearTags ? null : (tags ?? this.tags),
    );
  }

  // フィルターがアクティブかどうか
  bool get hasActiveFilters {
    return category != null ||
        minPrice != null ||
        maxPrice != null ||
        minRating != null ||
        isVegetarian != null ||
        isSpicy != null ||
        (tags != null && tags!.isNotEmpty);
  }

  // アクティブなフィルター数
  int get activeFilterCount {
    int count = 0;
    if (category != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (minRating != null) count++;
    if (isVegetarian != null) count++;
    if (isSpicy != null) count++;
    if (tags != null && tags!.isNotEmpty) count++;
    return count;
  }
}

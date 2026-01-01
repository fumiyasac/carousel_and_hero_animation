// ========================================
// Search Filter Model（検索フィルターモデル）
// ========================================
// 検索画面で使用するフィルター条件を保持するデータクラス
// 全てのフィールドがnull許容型（?付き）で、フィルターが設定されていない場合はnull
// nullの場合はそのフィルター条件を適用しない（すべての結果を表示）
class SearchFilterModel {
  // カテゴリーフィルター（例: '和食', '洋食'）
  // nullの場合は全カテゴリーを表示
  final String? category;

  // 最小価格フィルター（この価格以上のアイテムを表示）
  // nullの場合は下限なし
  final double? minPrice;

  // 最大価格フィルター（この価格以下のアイテムを表示）
  // nullの場合は上限なし
  final double? maxPrice;

  // 最小評価フィルター（この評価以上のアイテムを表示）
  // nullの場合は評価条件なし
  final double? minRating;

  // ベジタリアンフィルター
  // true: ベジタリアン向けのみ、false: 非ベジタリアンのみ、null: 条件なし
  final bool? isVegetarian;

  // 辛さフィルター
  // true: 辛い料理のみ、false: 辛くない料理のみ、null: 条件なし
  final bool? isSpicy;

  // タグフィルター（複数のタグを指定可能）
  // nullまたは空リストの場合はタグ条件なし
  final List<String>? tags;

  // ========================================
  // コンストラクタ
  // ========================================
  // 全てのパラメータがオプション（省略可能）
  // デフォルトではすべてnullで、フィルターが適用されていない状態
  SearchFilterModel({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.isVegetarian,
    this.isSpicy,
    this.tags,
  });

  // ========================================
  // copyWith メソッド
  // ========================================
  // 一部のフィルター条件だけを変更した新しいインスタンスを作成
  // clear系のパラメータ: trueにすると対応するフィールドを強制的にnullにする
  // これがないと、nullを明示的に設定できない（null ?? this.field でthis.fieldが使われる）
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
    // 三項演算子を使った条件分岐
    // clearXxx ? null : (xxx ?? this.xxx) の意味:
    // - clearXxxがtrueなら強制的にnullを設定（フィルターをクリア）
    // - clearXxxがfalseなら、パラメータxxxがnullでなければそれを使い、nullならthis.xxxを使う
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

  // ========================================
  // hasActiveFilters getter（アクティブなフィルターの有無）
  // ========================================
  // 何かしらのフィルターが設定されているかどうかを判定
  // 1つでもフィルターが設定されていればtrue、すべてnullならfalse
  // UIでフィルターバッジの表示/非表示を切り替える際などに使用
  bool get hasActiveFilters {
    // || 演算子: OR（論理和）、いずれか1つでもtrueならtrue
    // tags!.isNotEmpty: ! は非null表明演算子（tagsがnullでないことを保証）
    return category != null ||
        minPrice != null ||
        maxPrice != null ||
        minRating != null ||
        isVegetarian != null ||
        isSpicy != null ||
        (tags != null && tags!.isNotEmpty);
  }

  // ========================================
  // activeFilterCount getter（アクティブなフィルター数）
  // ========================================
  // 現在設定されているフィルターの数をカウント
  // UIで「フィルター (3)」のように件数を表示する際に使用
  // 注意: minPriceとmaxPriceは1つのフィルター（価格範囲）として扱う
  int get activeFilterCount {
    int count = 0;
    // 各フィルターが設定されているかチェックし、設定されていればカウントアップ
    if (category != null) count++;
    // 価格範囲フィルター（最小・最大のどちらか一方でも設定されていれば1カウント）
    if (minPrice != null || maxPrice != null) count++;
    if (minRating != null) count++;
    if (isVegetarian != null) count++;
    if (isSpicy != null) count++;
    // タグフィルター（nullでなく、かつ空でない場合のみカウント）
    if (tags != null && tags!.isNotEmpty) count++;
    return count;
  }
}

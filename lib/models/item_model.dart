class ItemModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final double rating;

  // 追加の詳細情報
  final int price; // 価格（円）
  final int cookingTime; // 調理時間（分）
  final int calories; // カロリー（kcal）
  final String difficulty; // 難易度: '簡単', '普通', '難しい'
  final List<String> ingredients; // 主な材料
  final List<String> allergens; // アレルゲン情報
  final String chef; // シェフ名
  final int reviewCount; // レビュー数
  final bool isSpicy; // 辛い料理かどうか
  final bool isVegetarian; // ベジタリアン対応
  final String servingSize; // 提供サイズ
  final List<String> tags; // タグ（特徴）

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.price,
    required this.cookingTime,
    required this.calories,
    required this.difficulty,
    required this.ingredients,
    required this.allergens,
    required this.chef,
    required this.reviewCount,
    this.isSpicy = false,
    this.isVegetarian = false,
    required this.servingSize,
    required this.tags,
  });

  ItemModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    double? rating,
    int? price,
    int? cookingTime,
    int? calories,
    String? difficulty,
    List<String>? ingredients,
    List<String>? allergens,
    String? chef,
    int? reviewCount,
    bool? isSpicy,
    bool? isVegetarian,
    String? servingSize,
    List<String>? tags,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      cookingTime: cookingTime ?? this.cookingTime,
      calories: calories ?? this.calories,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      chef: chef ?? this.chef,
      reviewCount: reviewCount ?? this.reviewCount,
      isSpicy: isSpicy ?? this.isSpicy,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      servingSize: servingSize ?? this.servingSize,
      tags: tags ?? this.tags,
    );
  }

  // 価格を表示用にフォーマット
  String get formattedPrice => '¥${price.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
  )}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.category == category &&
        other.rating == rating &&
        other.price == price &&
        other.cookingTime == cookingTime &&
        other.calories == calories;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    title.hashCode ^
    description.hashCode ^
    imageUrl.hashCode ^
    category.hashCode ^
    rating.hashCode ^
    price.hashCode ^
    cookingTime.hashCode ^
    calories.hashCode;
  }
}
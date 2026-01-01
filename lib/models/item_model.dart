// ========================================
// Item Model（料理アイテムデータモデル）
// ========================================
// 料理1品の全ての情報を保持するデータクラス
// このクラスは不変（イミュータブル）であり、一度作成したら値を変更できない
// 全てのフィールドがfinalなので、データの安全性が保たれる
class ItemModel {
  // ========================================
  // 基本情報
  // ========================================

  // 一意な識別子（各料理を区別するためのID）
  final String id;

  // 料理名（例: 「特選和牛ステーキ」）
  final String title;

  // 料理の説明文（詳細な紹介文）
  final String description;

  // 料理の画像URL（ネットワーク経由で取得する画像のパス）
  final String imageUrl;

  // カテゴリー名（例: 「和食」「洋食」「中華」など）
  final String category;

  // 評価（5段階評価、例: 4.5）
  final double rating;

  // ========================================
  // 詳細情報
  // ========================================

  // 価格（円単位）
  final int price;

  // 調理時間（分単位）
  final int cookingTime;

  // カロリー（kcal単位）
  final int calories;

  // 難易度（'簡単', '普通', '難しい' のいずれか）
  final String difficulty;

  // 主な材料リスト（例: ['黒毛和牛', 'ニンニク', 'バター']）
  final List<String> ingredients;

  // アレルゲン情報リスト（例: ['乳製品', '小麦']）
  final List<String> allergens;

  // シェフ名（料理を作る料理人の名前）
  final String chef;

  // レビュー数（この料理に対するレビューの総数）
  final int reviewCount;

  // 辛い料理かどうか（trueなら辛い料理）
  final bool isSpicy;

  // ベジタリアン対応かどうか（trueなら肉・魚を使っていない）
  final bool isVegetarian;

  // 提供サイズ（例: '200g', '1人前', '10貫'）
  final String servingSize;

  // タグリスト（料理の特徴を表すキーワード、例: ['高級', '記念日', 'ディナー']）
  final List<String> tags;

  // ========================================
  // コンストラクタ
  // ========================================
  // ItemModelのインスタンスを生成する際に呼ばれる
  // required: 必須パラメータ（指定しないとエラー）
  // デフォルト値あり（this.isSpicy = falseなど）: 省略可能
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

  // ========================================
  // copyWith メソッド
  // ========================================
  // 既存のItemModelから一部のフィールドだけを変更した新しいインスタンスを作成する
  // Flutterでは不変オブジェクトを推奨しているため、既存オブジェクトを変更せず新しいオブジェクトを作る
  // 例: item.copyWith(price: 2000) → priceだけ2000に変更した新しいItemModelを返す
  // パラメータはすべてnull許容型（?付き）で、nullの場合は元の値を使用する
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
    // ?? 演算子: 左側がnullなら右側を使う（null合体演算子）
    // 例: id ?? this.id → パラメータのidがnullでなければそれを使い、nullならthis.idを使う
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

  // ========================================
  // formattedPrice getter（価格を表示用にフォーマット）
  // ========================================
  // 価格を3桁ごとにカンマ区切りで表示する（例: 5800 → ¥5,800）
  // get キーワード: 値を計算して返すプロパティ（メソッドのように()を付けずに使える）
  // 使用例: item.formattedPrice（関数呼び出しではなくプロパティとしてアクセス）
  String get formattedPrice => '¥${price.toString().replaceAllMapped(
    // RegExp: 正規表現（パターンマッチング）
    // (\d{1,3})(?=(\d{3})+(?!\d)): 3桁ごとに区切る位置を見つける
    // \d{1,3}: 1〜3桁の数字、(?=(\d{3})+(?!\d)): 後ろに3の倍数の桁が続く位置
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    // マッチした部分の後ろにカンマを追加
    (Match m) => '${m[1]},',
  )}';

  // ========================================
  // operator == （等価演算子のオーバーライド）
  // ========================================
  // 2つのItemModelが同じかどうかを判定する
  // Dartではデフォルトでは同一インスタンスかどうかを判定するが、
  // ここでは内容が同じかどうか（値の等価性）を判定するようにカスタマイズ
  // 使用例: item1 == item2 でこのメソッドが呼ばれる
  @override
  bool operator ==(Object other) {
    // identical(): 完全に同じインスタンス（メモリ上の同じオブジェクト）かチェック
    // 同じインスタンスなら当然等しいのでtrueを返す（パフォーマンス最適化）
    if (identical(this, other)) return true;

    // other is ItemModel: otherがItemModel型かチェック（型判定）
    // &&: AND演算子（すべての条件が真の場合のみ真）
    // 主要なフィールドが全て一致するかチェック（id, title, priceなど）
    // 注意: すべてのフィールドを比較しているわけではない（パフォーマンスのため）
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

  // ========================================
  // hashCode getter（ハッシュコードのオーバーライド）
  // ========================================
  // オブジェクトを識別するための整数値を返す
  // operator==をオーバーライドした場合、hashCodeも必ずオーバーライドする必要がある
  // HashMapやHashSetなどのコレクションで正しく動作させるために必要
  // ^ 演算子: XOR（排他的論理和）ビット演算子で複数のhashCodeを組み合わせる
  @override
  int get hashCode {
    // 各フィールドのhashCodeをXORで組み合わせて一意なハッシュ値を生成
    // operator==で比較したフィールドと同じフィールドを使う必要がある
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
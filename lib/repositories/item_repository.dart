import '../models/item_model.dart';

// ========================================
// Item Repository（アイテムリポジトリ抽象クラス）
// ========================================
// アイテムデータの取得・検索機能を定義する抽象クラス
// 実装クラスを差し替えることで、モックデータ・API・ローカルDBなどを切り替え可能
// これにより、テストやモック実装が容易になる（Dependency Injection パターン）
abstract class ItemRepository {
  // 全アイテムを取得
  Future<List<ItemModel>> getItems();

  // 指定IDのアイテムを取得（存在しない場合はnull）
  Future<ItemModel?> getItemById(String id);

  // 複合条件でアイテムを検索
  // query: テキスト検索（タイトル・説明・材料・タグから検索）
  // その他: 各種フィルター条件（null の場合はその条件を無視）
  Future<List<ItemModel>> searchItems({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? isVegetarian,
    bool? isSpicy,
    List<String>? tags,
  });
}

// ========================================
// Item Repository Implementation（実装クラス）
// ========================================
// ItemRepositoryの実装クラス
// 現在はモックデータを使用しているが、本番環境ではAPI呼び出しに置き換え可能
class ItemRepositoryImpl implements ItemRepository {
  // ========================================
  // モックデータ
  // ========================================
  // 開発用のサンプルデータ（12件の料理アイテム）
  // 実際のアプリでは、REST APIやGraphQLから取得するデータに置き換える
  final List<ItemModel> _mockItems = [
    ItemModel(
      id: '1',
      title: '特選和牛ステーキ',
      description: '最高級A5ランクの黒毛和牛を使用した贅沢なステーキ。口の中でとろける柔らかさと濃厚な旨味が特徴です。シェフこだわりの焼き加減で提供いたします。',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&h=600&fit=crop',
      category: '洋食',
      rating: 4.9,
      price: 5800,
      cookingTime: 25,
      calories: 680,
      difficulty: '普通',
      ingredients: ['黒毛和牛', 'ニンニク', 'バター', '赤ワイン', 'ハーブ'],
      allergens: ['乳製品'],
      chef: '山田太郎',
      reviewCount: 342,
      isSpicy: false,
      isVegetarian: false,
      servingSize: '200g',
      tags: ['高級', '記念日', 'ディナー'],
    ),
    ItemModel(
      id: '2',
      title: '本格江戸前寿司',
      description: '厳選された旬の魚介を使用した握り寿司。熟練の職人が一貫一貫丁寧に握ります。新鮮なネタと絶妙なシャリのバランスをお楽しみください。',
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800&h=600&fit=crop',
      category: '和食',
      rating: 4.8,
      price: 4200,
      cookingTime: 20,
      calories: 520,
      difficulty: '難しい',
      ingredients: ['マグロ', 'サーモン', '酢飯', '海苔', 'わさび'],
      allergens: ['魚介類', '小麦'],
      chef: '佐藤一郎',
      reviewCount: 521,
      isSpicy: false,
      isVegetarian: false,
      servingSize: '10貫',
      tags: ['伝統', '職人技', '新鮮'],
    ),
    ItemModel(
      id: '3',
      title: '四川風麻婆豆腐',
      description: '本場中国の味を再現した本格四川料理。痺れる辛さと深いコクが絶妙にマッチ。花椒の香りが食欲をそそる一品です。',
      imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=800&h=600&fit=crop',
      category: '中華',
      rating: 4.7,
      price: 1680,
      cookingTime: 18,
      calories: 450,
      difficulty: '普通',
      ingredients: ['絹豆腐', '豚ひき肉', '豆板醤', '花椒', 'ネギ'],
      allergens: ['大豆', '豚肉'],
      chef: '李明',
      reviewCount: 287,
      isSpicy: true,
      isVegetarian: false,
      servingSize: '1人前',
      tags: ['辛い', '本格', '中華'],
    ),
    ItemModel(
      id: '4',
      title: 'マルゲリータピザ',
      description: '薪窯で焼き上げた本格ナポリピザ。モッツァレラチーズとバジルの香りが絶品。外はパリッと中はもちもちの食感をお楽しみください。',
      imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800&h=600&fit=crop',
      category: 'イタリアン',
      rating: 4.6,
      price: 1980,
      cookingTime: 15,
      calories: 580,
      difficulty: '普通',
      ingredients: ['小麦粉', 'モッツァレラ', 'トマトソース', 'バジル', 'オリーブオイル'],
      allergens: ['小麦', '乳製品'],
      chef: 'Marco Rossi',
      reviewCount: 412,
      isSpicy: false,
      isVegetarian: true,
      servingSize: 'Lサイズ',
      tags: ['イタリアン', '定番', 'チーズ'],
    ),
    ItemModel(
      id: '5',
      title: 'フレンチトースト',
      description: 'ふわふわ食感の贅沢なフレンチトースト。メープルシロップとフレッシュフルーツを添えて。朝食やブランチに最適な一品です。',
      imageUrl: 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=800&h=600&fit=crop',
      category: 'カフェ',
      rating: 4.5,
      price: 1280,
      cookingTime: 12,
      calories: 420,
      difficulty: '簡単',
      ingredients: ['食パン', '卵', '牛乳', 'バニラエッセンス', 'メープルシロップ'],
      allergens: ['卵', '乳製品', '小麦'],
      chef: '田中花子',
      reviewCount: 198,
      isSpicy: false,
      isVegetarian: true,
      servingSize: '2枚',
      tags: ['ブランチ', 'スイーツ', '朝食'],
    ),
    ItemModel(
      id: '6',
      title: 'とろける抹茶パフェ',
      description: '京都産の高級抹茶を使用した和スイーツ。白玉、あんこ、アイスクリームが層になった美しいパフェ。SNS映え間違いなしの一品です。',
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800&h=600&fit=crop',
      category: 'デザート',
      rating: 4.9,
      price: 1580,
      cookingTime: 10,
      calories: 380,
      difficulty: '簡単',
      ingredients: ['抹茶', '小豆', '白玉', 'アイスクリーム', '生クリーム'],
      allergens: ['乳製品', '大豆'],
      chef: '鈴木美咲',
      reviewCount: 687,
      isSpicy: false,
      isVegetarian: true,
      servingSize: '1杯',
      tags: ['和スイーツ', 'SNS映え', '抹茶'],
    ),
    ItemModel(
      id: '7',
      title: '海鮮たっぷり海鮮丼',
      description: '新鮮な魚介がたっぷり乗った贅沢な海鮮丼。マグロ、サーモン、いくら、ウニなど豪華なラインナップ。漁港直送の鮮度が自慢です。',
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800&h=600&fit=crop&q=80',
      category: '和食',
      rating: 4.8,
      price: 2980,
      cookingTime: 15,
      calories: 620,
      difficulty: '普通',
      ingredients: ['マグロ', 'サーモン', 'いくら', 'ウニ', '酢飯'],
      allergens: ['魚介類'],
      chef: '高橋誠',
      reviewCount: 423,
      isSpicy: false,
      isVegetarian: false,
      servingSize: '1人前',
      tags: ['海鮮', '豪華', '新鮮'],
    ),
    ItemModel(
      id: '8',
      title: 'ガーリックシュリンプ',
      description: 'ハワイアンスタイルのガーリックシュリンプ。プリプリのエビとガーリックバターの相性が抜群。ライスとの相性も完璧です。',
      imageUrl: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=800&h=600&fit=crop',
      category: 'エスニック',
      rating: 4.7,
      price: 1880,
      cookingTime: 20,
      calories: 480,
      difficulty: '簡単',
      ingredients: ['エビ', 'ニンニク', 'バター', 'レモン', 'パセリ'],
      allergens: ['甲殻類', '乳製品'],
      chef: 'John Smith',
      reviewCount: 315,
      isSpicy: false,
      isVegetarian: false,
      servingSize: '8尾',
      tags: ['ハワイアン', 'ガーリック', 'エビ'],
    ),
    ItemModel(
      id: '9',
      title: 'トリュフカルボナーラ',
      description: '黒トリュフをふんだんに使用した贅沢なカルボナーラ。濃厚なクリームソースと生パスタの組み合わせが絶妙。特別な日にぴったりの一皿。',
      imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800&h=600&fit=crop',
      category: 'イタリアン',
      rating: 4.9,
      price: 2680,
      cookingTime: 18,
      calories: 720,
      difficulty: '普通',
      ingredients: ['生パスタ', '卵黄', 'パルミジャーノ', '黒トリュフ', 'ベーコン'],
      allergens: ['小麦', '卵', '乳製品', '豚肉'],
      chef: 'Giovanni Bianchi',
      reviewCount: 289,
      isSpicy: false,
      isVegetarian: false,
      servingSize: '1人前',
      tags: ['高級', 'トリュフ', 'パスタ'],
    ),
    ItemModel(
      id: '10',
      title: 'タイ風グリーンカレー',
      description: 'ココナッツミルクベースのマイルドながらもスパイシーなグリーンカレー。タイバジルの爽やかな香りが特徴。本場の味を再現しました。',
      imageUrl: 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800&h=600&fit=crop',
      category: 'エスニック',
      rating: 4.6,
      price: 1480,
      cookingTime: 25,
      calories: 550,
      difficulty: '普通',
      ingredients: ['ココナッツミルク', '鶏肉', 'グリーンカレーペースト', 'タイバジル', 'ナス'],
      allergens: [],
      chef: 'Somchai Patel',
      reviewCount: 243,
      isSpicy: true,
      isVegetarian: false,
      servingSize: '1人前',
      tags: ['タイ料理', '辛い', 'ココナッツ'],
    ),
    ItemModel(
      id: '11',
      title: 'ふわとろオムライス',
      description: 'とろとろの半熟卵で包んだ絶品オムライス。特製デミグラスソースとの相性が抜群。昔ながらの洋食屋の味を楽しめます。',
      imageUrl: 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=800&h=600&fit=crop',
      category: '洋食',
      rating: 4.7,
      price: 1380,
      cookingTime: 15,
      calories: 620,
      difficulty: '難しい',
      ingredients: ['卵', 'ケチャップライス', 'デミグラスソース', '鶏肉', 'バター'],
      allergens: ['卵', '小麦', '乳製品'],
      chef: '中村健太',
      reviewCount: 456,
      isSpicy: false,
      isVegetarian: false,
      servingSize: '1人前',
      tags: ['洋食', 'ふわとろ', '定番'],
    ),
    ItemModel(
      id: '12',
      title: 'ティラミス',
      description: 'イタリア直伝のレシピで作る本格ティラミス。マスカルポーネチーズとエスプレッソの絶妙なハーモニー。大人のデザートです。',
      imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800&h=600&fit=crop',
      category: 'デザート',
      rating: 4.8,
      price: 880,
      cookingTime: 30,
      calories: 320,
      difficulty: '普通',
      ingredients: ['マスカルポーネ', '卵', 'エスプレッソ', 'ココアパウダー', 'ビスケット'],
      allergens: ['卵', '乳製品', '小麦'],
      chef: 'Sofia Romano',
      reviewCount: 378,
      isSpicy: false,
      isVegetarian: true,
      servingSize: '1個',
      tags: ['イタリアン', 'デザート', 'コーヒー'],
    ),
  ];

  // ========================================
  // 全アイテム取得メソッド
  // ========================================
  @override
  Future<List<ItemModel>> getItems() async {
    // ネットワークAPIを呼び出している想定で遅延をシミュレート（800ms）
    // 実際のアプリでは、ここでHTTPリクエストを実行する
    // 例: final response = await http.get('https://api.example.com/items');
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockItems;
  }

  // ========================================
  // ID指定アイテム取得メソッド
  // ========================================
  @override
  Future<ItemModel?> getItemById(String id) async {
    // ネットワークAPIを呼び出している想定で遅延をシミュレート（300ms）
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      // firstWhere()は条件に一致する最初の要素を返す
      // 一致する要素がない場合は例外をスローする
      return _mockItems.firstWhere((item) => item.id == id);
    } catch (e) {
      // 該当アイテムが見つからない場合はnullを返す
      return null;
    }
  }

  // ========================================
  // 複合検索メソッド
  // ========================================
  // 複数の条件を組み合わせてアイテムを検索する
  // 全ての条件はAND条件（すべての条件を満たすアイテムのみを返す）
  @override
  Future<List<ItemModel>> searchItems({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? isVegetarian,
    bool? isSpicy,
    List<String>? tags,
  }) async {
    // ネットワーク遅延をシミュレート（リアルタイム検索のため短めに500ms）
    await Future.delayed(const Duration(milliseconds: 500));

    // 全アイテムのコピーを作成（元のリストを変更しないため）
    // List.from()で新しいリストインスタンスを作成
    var results = List<ItemModel>.from(_mockItems);

    // ========================================
    // テキスト検索（部分一致）
    // ========================================
    // タイトル、説明、材料、タグの中から検索クエリを含むアイテムを抽出
    if (query.isNotEmpty) {
      // 大文字小文字を区別しないため、クエリを小文字に変換
      final lowerQuery = query.toLowerCase();
      // where()でフィルタリング。条件に一致する要素のみを残す
      results = results.where((item) {
        // contains()で部分一致を判定
        // ||（OR）でいずれかの条件を満たせばtrue
        // any()はリスト内の要素のいずれかが条件を満たすかチェック
        return item.title.toLowerCase().contains(lowerQuery) ||
            item.description.toLowerCase().contains(lowerQuery) ||
            item.ingredients.any((ing) => ing.toLowerCase().contains(lowerQuery)) ||
            item.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
      }).toList();
    }

    // ========================================
    // カテゴリーフィルター（完全一致）
    // ========================================
    if (category != null && category.isNotEmpty) {
      results = results.where((item) => item.category == category).toList();
    }

    // ========================================
    // 価格範囲フィルター
    // ========================================
    // 最小価格フィルター（指定価格以上）
    if (minPrice != null) {
      results = results.where((item) => item.price >= minPrice).toList();
    }
    // 最大価格フィルター（指定価格以下）
    if (maxPrice != null) {
      results = results.where((item) => item.price <= maxPrice).toList();
    }

    // ========================================
    // 評価フィルター
    // ========================================
    // 指定された評価以上のアイテムのみを抽出
    if (minRating != null) {
      results = results.where((item) => item.rating >= minRating).toList();
    }

    // ========================================
    // ベジタリアンフィルター
    // ========================================
    // trueの場合のみフィルタリング（ベジタリアン向けアイテムのみ）
    if (isVegetarian != null && isVegetarian) {
      results = results.where((item) => item.isVegetarian).toList();
    }

    // ========================================
    // 辛さフィルター
    // ========================================
    // trueの場合のみフィルタリング（辛いアイテムのみ）
    if (isSpicy != null && isSpicy) {
      results = results.where((item) => item.isSpicy).toList();
    }

    // ========================================
    // タグフィルター
    // ========================================
    // 指定されたタグのいずれかを持つアイテムを抽出（OR条件）
    if (tags != null && tags.isNotEmpty) {
      results = results.where((item) {
        // any()で指定タグのいずれかがアイテムのタグに含まれるかチェック
        return tags.any((tag) => item.tags.contains(tag));
      }).toList();
    }

    // 全てのフィルター条件を適用した結果を返す
    return results;
  }
}
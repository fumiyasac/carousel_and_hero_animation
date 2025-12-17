import '../models/item_model.dart';

abstract class ItemRepository {
  Future<List<ItemModel>> getItems();
  Future<ItemModel?> getItemById(String id);
}

class ItemRepositoryImpl implements ItemRepository {
  // サンプルデータ - 実際のアプリではAPIやローカルDBから取得
  final List<ItemModel> _mockItems = [
    ItemModel(
      id: '1',
      title: '特選和牛ステーキ',
      description: '最高級A5ランクの黒毛和牛を使用した贅沢なステーキ。口の中でとろける柔らかさと濃厚な旨味が特徴です。シェフこだわりの焼き加減で提供いたします。',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&h=600&fit=crop',
      category: '洋食',
      rating: 4.9,
    ),
    ItemModel(
      id: '2',
      title: '本格江戸前寿司',
      description: '厳選された旬の魚介を使用した握り寿司。熟練の職人が一貫一貫丁寧に握ります。新鮮なネタと絶妙なシャリのバランスをお楽しみください。',
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800&h=600&fit=crop',
      category: '和食',
      rating: 4.8,
    ),
    ItemModel(
      id: '3',
      title: '四川風麻婆豆腐',
      description: '本場中国の味を再現した本格四川料理。痺れる辛さと深いコクが絶妙にマッチ。花椒の香りが食欲をそそる一品です。',
      imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=800&h=600&fit=crop',
      category: '中華',
      rating: 4.7,
    ),
    ItemModel(
      id: '4',
      title: 'マルゲリータピザ',
      description: '薪窯で焼き上げた本格ナポリピザ。モッツァレラチーズとバジルの香りが絶品。外はパリッと中はもちもちの食感をお楽しみください。',
      imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800&h=600&fit=crop',
      category: 'イタリアン',
      rating: 4.6,
    ),
    ItemModel(
      id: '5',
      title: 'フレンチトースト',
      description: 'ふわふわ食感の贅沢なフレンチトースト。メープルシロップとフレッシュフルーツを添えて。朝食やブランチに最適な一品です。',
      imageUrl: 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=800&h=600&fit=crop',
      category: 'カフェ',
      rating: 4.5,
    ),
    ItemModel(
      id: '6',
      title: 'とろける抹茶パフェ',
      description: '京都産の高級抹茶を使用した和スイーツ。白玉、あんこ、アイスクリームが層になった美しいパフェ。SNS映え間違いなしの一品です。',
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800&h=600&fit=crop',
      category: 'デザート',
      rating: 4.9,
    ),
    ItemModel(
      id: '7',
      title: '海鮮たっぷり海鮮丼',
      description: '新鮮な魚介がたっぷり乗った贅沢な海鮮丼。マグロ、サーモン、いくら、ウニなど豪華なラインナップ。漁港直送の鮮度が自慢です。',
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800&h=600&fit=crop&q=80',
      category: '和食',
      rating: 4.8,
    ),
    ItemModel(
      id: '8',
      title: 'ガーリックシュリンプ',
      description: 'ハワイアンスタイルのガーリックシュリンプ。プリプリのエビとガーリックバターの相性が抜群。ライスとの相性も完璧です。',
      imageUrl: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=800&h=600&fit=crop',
      category: 'エスニック',
      rating: 4.7,
    ),
    ItemModel(
      id: '9',
      title: 'トリュフカルボナーラ',
      description: '黒トリュフをふんだんに使用した贅沢なカルボナーラ。濃厚なクリームソースと生パスタの組み合わせが絶妙。特別な日にぴったりの一皿。',
      imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800&h=600&fit=crop',
      category: 'イタリアン',
      rating: 4.9,
    ),
    ItemModel(
      id: '10',
      title: 'タイ風グリーンカレー',
      description: 'ココナッツミルクベースのマイルドながらもスパイシーなグリーンカレー。タイバジルの爽やかな香りが特徴。本場の味を再現しました。',
      imageUrl: 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=800&h=600&fit=crop',
      category: 'エスニック',
      rating: 4.6,
    ),
    ItemModel(
      id: '11',
      title: 'ふわとろオムライス',
      description: 'とろとろの半熟卵で包んだ絶品オムライス。特製デミグラスソースとの相性が抜群。昔ながらの洋食屋の味を楽しめます。',
      imageUrl: 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=800&h=600&fit=crop',
      category: '洋食',
      rating: 4.7,
    ),
    ItemModel(
      id: '12',
      title: 'ティラミス',
      description: 'イタリア直伝のレシピで作る本格ティラミス。マスカルポーネチーズとエスプレッソの絶妙なハーモニー。大人のデザートです。',
      imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800&h=600&fit=crop',
      category: 'デザート',
      rating: 4.8,
    ),
    ItemModel(
      id: '13',
      title: 'ローストビーフ丼',
      description: '厚切りのローストビーフがたっぷり乗った豪華な丼ぶり。特製わさび醤油ソースでお召し上がりください。ボリューム満点の一品。',
      imageUrl: 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=800&h=600&fit=crop',
      category: '洋食',
      rating: 4.7,
    ),
    ItemModel(
      id: '14',
      title: '天ぷら盛り合わせ',
      description: '旬の野菜と海老を使用した揚げたての天ぷら。サクサクの衣と素材の旨みが口いっぱいに広がります。天つゆと塩でどうぞ。',
      imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800&h=600&fit=crop',
      category: '和食',
      rating: 4.8,
    ),
    ItemModel(
      id: '15',
      title: 'ペペロンチーノ',
      description: 'シンプルながら奥深い味わいのペペロンチーノ。ニンニクと唐辛子の絶妙なバランス。アルデンテに茹でた生パスタが絶品です。',
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800&h=600&fit=crop',
      category: 'イタリアン',
      rating: 4.5,
    ),
    ItemModel(
      id: '16',
      title: 'チョコレートケーキ',
      description: '濃厚なベルギーチョコレートを使用した本格チョコレートケーキ。しっとりとした食感と深い味わいが楽しめます。',
      imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800&h=600&fit=crop',
      category: 'デザート',
      rating: 4.9,
    )
  ];

  @override
  Future<List<ItemModel>> getItems() async {
    // ネットワーク遅延をシミュレート
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockItems;
  }

  @override
  Future<ItemModel?> getItemById(String id) async {
    // ネットワーク遅延をシミュレート
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
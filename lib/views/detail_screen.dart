import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/item_model.dart';
import '../config/theme_config.dart';
import '../providers/favorite_provider.dart';

// ========================================
// Detail Screen（アイテム詳細画面）
// ========================================
// 選択されたアイテムの詳細情報を表示する画面
// ConsumerWidgetでRiverpod Providerを使用（お気に入り機能など）
class DetailScreen extends ConsumerWidget {
  // 表示するアイテムデータ
  final ItemModel item;

  const DetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      // ========================================
      // CustomScrollView（カスタムスクロールビュー）
      // ========================================
      // Sliverウィジェット（可変スクロール要素）を組み合わせたスクロールビュー
      // SliverAppBar（伸縮するヘッダー）+ SliverList（コンテンツ）の組み合わせ
      body: CustomScrollView(
        slivers: [
          // ========================================
          // SliverAppBar（伸縮するアプリバー）
          // ========================================
          // スクロールに応じて伸縮するアプリバー
          // 画像ヘッダーとしてよく使用される
          SliverAppBar(
            expandedHeight: 400, // 展開時の高さ（最大400px）
            pinned: true, // スクロール時に上部に固定（最小サイズで残る）
            backgroundColor: AppTheme.primaryColor,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.softShadow,
                ),
                child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: const Icon(Icons.share, color: AppTheme.textPrimary, size: 20),
                ),
                onPressed: () async {
                  try {
                    // ローディング表示
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('画像を準備中...'),
                            ],
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }

                    // 画像をダウンロード
                    final response = await http.get(Uri.parse(item.imageUrl));
                    if (response.statusCode == 200) {
                      // 一時ディレクトリを取得
                      final tempDir = await getTemporaryDirectory();
                      final file = File('${tempDir.path}/share_image_${item.id}.jpg');

                      // 画像を保存
                      await file.writeAsBytes(response.bodyBytes);

                      // シェアするテキスト
                      final shareText = '''
${item.title}

${item.description}

カテゴリー: ${item.category}
評価: ${item.rating} (${item.reviewCount}件のレビュー)
価格: ${item.formattedPrice}
''';

                      // 画像とテキストを一緒にシェア
                      await Share.shareXFiles(
                        [XFile(file.path)],
                        text: shareText,
                        subject: item.title,
                      );

                      // 一時ファイルを削除（シェア後）
                      if (await file.exists()) {
                        await file.delete();
                      }
                    } else {
                      // 画像のダウンロードに失敗した場合はテキストのみシェア
                      final shareText = '''
${item.title}

${item.description}

カテゴリー: ${item.category}
評価: ${item.rating} (${item.reviewCount}件のレビュー)
価格: ${item.formattedPrice}
''';
                      await Share.share(
                        shareText,
                        subject: item.title,
                      );
                    }
                  } catch (e) {
                    // エラーが発生した場合はテキストのみシェア
                    final shareText = '''
${item.title}

${item.description}

カテゴリー: ${item.category}
評価: ${item.rating} (${item.reviewCount}件のレビュー)
価格: ${item.formattedPrice}
''';
                    await Share.share(
                      shareText,
                      subject: item.title,
                    );
                  } finally {
                    // ローディングを非表示
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }
                  }
                },
              ),
            ],
            // FlexibleSpaceBar: SliverAppBarの伸縮する背景領域
            flexibleSpace: FlexibleSpaceBar(
              // ========================================
              // Hero アニメーション（詳細画面側）
              // ========================================
              // 前の画面から遷移してきた際に、同じtagを持つHeroウィジェット間でアニメーション
              // 'item-${item.id}'のtagで、カルーセル/グリッドの画像と接続される
              background: Hero(
                tag: 'item-${item.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppTheme.backgroundColor,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.backgroundColor,
                          child: const Icon(
                            Icons.error,
                            size: 48,
                            color: AppTheme.textSecondary,
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // コンテンツ
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusXLarge),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // タイトルとタグ
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: AppTheme.heading1,
                          ),
                        ),
                        if (item.isVegetarian)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: const Icon(
                              Icons.eco,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),

                    // カテゴリーと評価
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TagChip(
                          icon: Icons.restaurant_menu,
                          label: item.category,
                          color: AppTheme.getCategoryColor(item.category),
                        ),
                        _TagChip(
                          icon: Icons.star,
                          label: '${item.rating} (${item.reviewCount}件)',
                          color: AppTheme.accentColor,
                        ),
                        if (item.isSpicy)
                          _TagChip(
                            icon: Icons.local_fire_department,
                            label: '辛い',
                            color: Colors.red,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

                    // 基本情報カード
                    _InfoCard(
                      children: [
                        _InfoRow(
                          icon: Icons.attach_money,
                          label: '価格',
                          value: item.formattedPrice,
                          color: AppTheme.primaryColor,
                        ),
                        const Divider(height: AppTheme.spacingLarge),
                        _InfoRow(
                          icon: Icons.access_time,
                          label: '調理時間',
                          value: '約${item.cookingTime}分',
                          color: AppTheme.secondaryColor,
                        ),
                        const Divider(height: AppTheme.spacingLarge),
                        _InfoRow(
                          icon: Icons.local_fire_department_outlined,
                          label: 'カロリー',
                          value: '${item.calories}kcal',
                          color: Colors.orange,
                        ),
                        const Divider(height: AppTheme.spacingLarge),
                        _InfoRow(
                          icon: Icons.restaurant,
                          label: '提供サイズ',
                          value: item.servingSize,
                          color: AppTheme.textPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

                    // 説明
                    _SectionTitle(
                      icon: Icons.description,
                      title: '説明',
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Text(
                      item.description,
                      style: AppTheme.body1,
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

                    // 材料
                    _SectionTitle(
                      icon: Icons.shopping_basket,
                      title: '主な材料',
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: item.ingredients.map((ingredient) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            border: Border.all(
                              color: AppTheme.getCategoryColor(item.category).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            ingredient,
                            style: AppTheme.body2,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

                    // アレルゲン情報
                    if (item.allergens.isNotEmpty) ...[
                      _SectionTitle(
                        icon: Icons.warning_amber,
                        title: 'アレルゲン情報',
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingMedium),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.allergens.join('、'),
                                style: AppTheme.body2.copyWith(color: Colors.orange[900]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLarge),
                    ],

                    // タグ
                    if (item.tags.isNotEmpty) ...[
                      _SectionTitle(
                        icon: Icons.label,
                        title: 'タグ',
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.getCategoryColor(item.category).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tag,
                                  size: 14,
                                  color: AppTheme.getCategoryColor(item.category),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.getCategoryColor(item.category),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppTheme.spacingLarge),
                    ],

                    // シェフ情報
                    _InfoCard(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                color: AppTheme.secondaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'シェフ',
                                  style: AppTheme.caption,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.chef,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(item.difficulty).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                              ),
                              child: Text(
                                item.difficulty,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getDifficultyColor(item.difficulty),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

                    // アクションボタン
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('注文機能は開発中です'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('注文する'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FavoriteButton(itemId: item.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case '簡単':
        return Colors.green;
      case '普通':
        return Colors.orange;
      case '難しい':
        return Colors.red;
      default:
        return AppTheme.textSecondary;
    }
  }
}

class _TagChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TagChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTheme.caption),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textPrimary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppTheme.heading3),
      ],
    );
  }
}

// ========================================
// Favorite Button（お気に入りボタンウィジェット）
// ========================================
// お気に入りの状態を表示し、トグル操作を行うボタン
// ConsumerWidgetでRiverpod Providerを監視
class _FavoriteButton extends ConsumerWidget {
  final String itemId;

  const _FavoriteButton({required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch()でお気に入り状態を監視
    // isFavoriteProvider(itemId)はパラメータ付きProviderの呼び出し
    // 状態が変更されると自動的にWidgetが再構築される
    final isFavoriteAsync = ref.watch(isFavoriteProvider(itemId));

    // AsyncValue.when()で非同期処理の状態に応じたUIを返す
    return isFavoriteAsync.when(
      data: (isFav) {
        return OutlinedButton.icon(
          onPressed: () async {
            // ref.read()でProviderのNotifierメソッドを呼び出す
            // アクション実行時はref.read()を使用（ref.watch()は使わない）
            // toggleFavorite()でお気に入り状態を反転させる
            await ref.read(favoriteProvider.notifier).toggleFavorite(itemId);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFav ? 'お気に入りから削除しました' : 'お気に入りに追加しました'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          label: Text(isFav ? '保存済み' : '保存'),
          style: OutlinedButton.styleFrom(
            foregroundColor: isFav ? Colors.red : AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            side: BorderSide(
              color: isFav ? Colors.red : AppTheme.primaryColor,
              width: 2,
            ),
          ),
        );
      },
      loading: () => OutlinedButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: const Text('保存'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      ),
      error: (_, __) => OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.error_outline),
        label: const Text('エラー'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      ),
    );
  }
}
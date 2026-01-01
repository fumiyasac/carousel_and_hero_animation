import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/item_provider.dart';
import '../models/item_model.dart';
import '../config/theme_config.dart';
import 'detail_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';

// ========================================
// Carousel List Screen（カルーセル＋グリッド表示画面）
// ========================================
// アプリのメイン画面：上部にカルーセルスライダー、下部にアイテムグリッドを表示
// ConsumerWidgetを継承することでRiverpodのProviderを監視できる
// 注意: StatelessWidgetではなくConsumerWidgetを使う（Riverpod用）
class CarouselListScreen extends ConsumerWidget {
  const CarouselListScreen({super.key});

  // build()メソッドの引数にWidgetRefが追加される（ConsumerWidgetの特徴）
  // WidgetRefを使用してProviderを監視（ref.watch）したり読み取り（ref.read）できる
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch()でProviderを監視
    // Providerの値が変更されると、このWidgetが自動的に再構築される
    final itemsAsync = ref.watch(itemsProvider); // AsyncValue<List<ItemModel>>
    final categories = ref.watch(categoriesProvider); // List<String>
    final selectedCategory = ref.watch(selectedCategoryProvider); // String?

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.restaurant_menu,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'グルメギャラリー',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppTheme.textPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: _CategoryFilter(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              ref.read(selectedCategoryProvider.notifier).select(category);
            },
          ),
        ),
      ),
      // ========================================
      // AsyncValue.when() を使った状態別レンダリング
      // ========================================
      // AsyncValueは非同期処理の3つの状態を管理: loading, data, error
      // when()メソッドで各状態に応じたUIを返す
      body: itemsAsync.when(
        // data: データ取得成功時の処理
        // items は Future<List<ItemModel>> から取得したデータ
        data: (items) {
          // 選択されたカテゴリーでフィルタリング
          // nullの場合は全アイテムを表示
          final filteredItems = selectedCategory == null
              ? items
              : items.where((item) => item.category == selectedCategory).toList();

          // フィルタリング結果が空の場合の表示
          if (filteredItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant,
                    size: 64,
                    color: AppTheme.textLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'メニューが見つかりません',
                    style: AppTheme.body1.copyWith(color: AppTheme.textLight),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingLarge),
                _FeaturedCarousel(items: filteredItems),
                const SizedBox(height: AppTheme.spacingXLarge),
                _GridSection(items: filteredItems),
                const SizedBox(height: AppTheme.spacingLarge),
              ],
            ),
          );
        },
        // ========================================
        // loading: データ読み込み中の表示
        // ========================================
        // Future処理が完了していない間に表示されるUI
        // CircularProgressIndicatorでローディング表示
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
        // ========================================
        // error: エラー発生時の表示
        // ========================================
        // Future処理で例外が発生した際に表示されるUI
        // error: エラーオブジェクト, stack: スタックトレース
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Text(
                'エラーが発生しました',
                style: AppTheme.heading3.copyWith(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(itemsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('再試行'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const _CategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSmall),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
        children: [
          _CategoryChip(
            label: 'すべて',
            icon: Icons.apps,
            isSelected: selectedCategory == null,
            onTap: () => onCategorySelected(null),
            color: AppTheme.textPrimary,
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          ...categories.map((category) => Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingSmall),
            child: _CategoryChip(
              label: category,
              icon: _getCategoryIcon(category),
              isSelected: selectedCategory == category,
              onTap: () => onCategorySelected(category),
              color: AppTheme.getCategoryColor(category),
            ),
          )),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '和食':
        return Icons.rice_bowl;
      case '洋食':
        return Icons.restaurant;
      case '中華':
        return Icons.ramen_dining;
      case 'イタリアン':
        return Icons.local_pizza;
      case 'エスニック':
        return Icons.travel_explore;
      case 'カフェ':
        return Icons.coffee;
      case 'デザート':
        return Icons.cake;
      default:
        return Icons.restaurant_menu;
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMedium,
          vertical: AppTheme.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE0E0E0),
            width: 2,
          ),
          boxShadow: isSelected ? AppTheme.softShadow : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCarousel extends ConsumerWidget {
  final List<ItemModel> items;

  const _FeaturedCarousel({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentCarouselIndexProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.star,
                  color: AppTheme.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '本日のおすすめ料理',
                style: AppTheme.heading2,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        // ========================================
        // CarouselSlider（スライダーウィジェット）
        // ========================================
        // carousel_sliderパッケージを使用した自動スクロールスライダー
        CarouselSlider.builder(
          itemCount: items.length,
          // itemBuilder: 各スライドの内容を構築する関数
          // index: 現在のインデックス, realIndex: 実際のアイテムインデックス
          itemBuilder: (context, index, realIndex) {
            final item = items[index];
            return _CarouselCard(item: item);
          },
          // CarouselOptions: スライダーの詳細設定
          options: CarouselOptions(
            height: 320, // スライダーの高さ
            aspectRatio: 16 / 9, // アスペクト比
            viewportFraction: 0.87, // 画面に表示される割合（0.87 = 87%）
            initialPage: 0, // 初期表示ページ
            enableInfiniteScroll: true, // 無限スクロールを有効化
            autoPlay: true, // 自動再生を有効化
            autoPlayInterval: const Duration(seconds: 5), // 5秒ごとに自動切り替え
            autoPlayAnimationDuration: const Duration(milliseconds: 1000), // アニメーション時間
            autoPlayCurve: Curves.easeInOutCubic, // アニメーションカーブ（滑らかな動き）
            enlargeCenterPage: true, // 中央のページを拡大表示
            enlargeFactor: 0.18, // 拡大率（0.18 = 18%拡大）
            scrollDirection: Axis.horizontal, // 横方向スクロール
            // ページ変更時のコールバック
            onPageChanged: (index, reason) {
              // ref.read()でProviderのNotifierメソッドを呼び出す
              // 現在のインデックスを更新（ドット表示などで使用）
              ref.read(currentCarouselIndexProvider.notifier).update(index);
            },
          ),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        _CarouselIndicator(
          itemCount: items.length,
          currentIndex: currentIndex,
        ),
      ],
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final ItemModel item;

  const _CarouselCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // タップ時の処理: 詳細画面へ遷移
      onTap: () {
        // Navigator.push()で新しい画面に遷移
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(item: item),
          ),
        );
      },
      // ========================================
      // Hero アニメーション
      // ========================================
      // Heroウィジェットで画像を囲むことで、画面遷移時に共有要素アニメーションを実現
      // 遷移元と遷移先で同じtagを持つHeroウィジェットが自動的にアニメーションする
      child: Hero(
        // tag: 一意な識別子（遷移先の画面でも同じtagを使用する必要がある）
        // 'item-${item.id}'で各アイテムごとにユニークなtagを生成
        tag: 'item-${item.id}',
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
            boxShadow: AppTheme.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 画像
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
                      child: const Icon(Icons.error, size: 48),
                    );
                  },
                ),
                // グラデーションオーバーレイ
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
                // 情報
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // タグと評価
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.getCategoryColor(item.category),
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.restaurant_menu,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.category,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor,
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.rating.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.isSpicy) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                ),
                                child: const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        // タイトル
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // 詳細情報
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.access_time,
                              text: '${item.cookingTime}分',
                            ),
                            const SizedBox(width: 8),
                            _InfoChip(
                              icon: Icons.local_fire_department_outlined,
                              text: '${item.calories}kcal',
                            ),
                            const SizedBox(width: 8),
                            _InfoChip(
                              icon: Icons.attach_money,
                              text: item.formattedPrice,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const _CarouselIndicator({
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: currentIndex == index ? 28 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: currentIndex == index
                ? AppTheme.primaryColor
                : AppTheme.textLight,
          ),
        ),
      ),
    );
  }
}

class _GridSection extends StatelessWidget {
  final List<ItemModel> items;

  const _GridSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.grid_view,
                      color: AppTheme.secondaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'すべてのメニュー',
                    style: AppTheme.heading2,
                  ),
                ],
              ),
              Text(
                '${items.length}品',
                style: AppTheme.body2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppTheme.spacingMedium,
              mainAxisSpacing: AppTheme.spacingMedium,
              childAspectRatio: 0.70,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _GridCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _GridCard extends StatelessWidget {
  final ItemModel item;

  const _GridCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(item: item),
          ),
        );
      },
      child: Hero(
        tag: 'grid-item-${item.id}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            color: Colors.white,
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 画像部分
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTheme.radiusLarge),
                      ),
                      child: Image.network(
                        item.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppTheme.backgroundColor,
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.backgroundColor,
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                    // 評価バッジ
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          boxShadow: AppTheme.softShadow,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              item.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 辛さマーク
                    if (item.isSpicy)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                            boxShadow: AppTheme.softShadow,
                          ),
                          child: const Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // 情報部分
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // カテゴリー
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.getCategoryColor(item.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            color: AppTheme.getCategoryColor(item.category),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // タイトル
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      // 価格と時間
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.formattedPrice,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 12,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${item.cookingTime}分',
                                style: AppTheme.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
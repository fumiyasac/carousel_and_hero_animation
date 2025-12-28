import 'package:flutter/material.dart';
import '../../models/item_model.dart';
import '../../config/theme_config.dart';
import '../detail_screen.dart';

// リスト表示用カード
class SearchResultListCard extends StatelessWidget {
  final ItemModel item;

  const SearchResultListCard({super.key, required this.item});

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
        tag: 'search-list-${item.id}',
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMedium,
            vertical: AppTheme.spacingSmall,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              // 画像
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppTheme.radiusMedium),
                ),
                child: Image.network(
                  item.imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 120,
                      color: AppTheme.backgroundColor,
                      child: const Icon(Icons.image_not_supported, size: 40, color: AppTheme.textLight),
                    );
                  },
                ),
              ),
              // 情報
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTheme.heading3.copyWith(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.getCategoryColor(item.category).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.category,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.getCategoryColor(item.category),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, color: AppTheme.accentColor, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            item.rating.toString(),
                            style: AppTheme.body2.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.formattedPrice,
                            style: AppTheme.heading3.copyWith(
                              color: AppTheme.primaryColor,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
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

// グリッド表示用カード
class SearchResultGridCard extends StatelessWidget {
  final ItemModel item;

  const SearchResultGridCard({super.key, required this.item});

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
        tag: 'search-grid-${item.id}',
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // 画像
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusMedium),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      item.imageUrl,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 120,
                          color: AppTheme.backgroundColor,
                          child: const Icon(Icons.image_not_supported, size: 40, color: AppTheme.textLight),
                        );
                      },
                    ),
                    // カテゴリーバッジ
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.getCategoryColor(item.category),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 情報
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: AppTheme.heading3.copyWith(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: AppTheme.accentColor, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              item.rating.toString(),
                              style: AppTheme.body2.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time, size: 12, color: AppTheme.textSecondary),
                            const SizedBox(width: 2),
                            Text(
                              '${item.cookingTime}分',
                              style: AppTheme.caption.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.formattedPrice,
                      style: AppTheme.heading3.copyWith(
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

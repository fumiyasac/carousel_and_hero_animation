import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme_config.dart';
import '../../models/search_filter_model.dart';
import '../../providers/search_provider.dart';
import '../../providers/item_provider.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late SearchFilterModel _tempFilter;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 初期化は空のモデルから開始
    _tempFilter = SearchFilterModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 依存関係が変更されたら現在のフィルター状態を取得
    final currentFilter = ref.read(searchFilterProvider);
    _tempFilter = currentFilter;
    if (currentFilter.minPrice != null) {
      _minPriceController.text = currentFilter.minPrice!.toInt().toString();
    }
    if (currentFilter.maxPrice != null) {
      _maxPriceController.text = currentFilter.maxPrice!.toInt().toString();
    }
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ハンドル
          Container(
            margin: const EdgeInsets.only(top: AppTheme.spacingSmall),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // ヘッダー
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('フィルター', style: AppTheme.heading2),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempFilter = SearchFilterModel();
                      _minPriceController.clear();
                      _maxPriceController.clear();
                    });
                  },
                  child: const Text('リセット'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // フィルター内容（スクロール可能）
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    // カテゴリーフィルター
                    _FilterSection(
                      title: 'カテゴリー',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.map((category) {
                          final isSelected = _tempFilter.category == category;
                          return FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _tempFilter = _tempFilter.copyWith(
                                  category: selected ? category : null,
                                  clearCategory: !selected,
                                );
                              });
                            },
                            selectedColor: AppTheme.getCategoryColor(category).withOpacity(0.2),
                            checkmarkColor: AppTheme.getCategoryColor(category),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

                    // 価格範囲フィルター
                    _FilterSection(
                      title: '価格範囲',
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _minPriceController,
                              decoration: const InputDecoration(
                                labelText: '最小',
                                prefixText: '¥',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final price = double.tryParse(value);
                                setState(() {
                                  _tempFilter = _tempFilter.copyWith(
                                    minPrice: price,
                                    clearMinPrice: price == null,
                                  );
                                });
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('〜'),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _maxPriceController,
                              decoration: const InputDecoration(
                                labelText: '最大',
                                prefixText: '¥',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final price = double.tryParse(value);
                                setState(() {
                                  _tempFilter = _tempFilter.copyWith(
                                    maxPrice: price,
                                    clearMaxPrice: price == null,
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

                    // 評価フィルター
                    _FilterSection(
                      title: '評価',
                      child: Column(
                        children: [4.5, 4.0, 3.5, 3.0].map((rating) {
                          return RadioListTile<double>(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (index) => Icon(
                                    index < rating ? Icons.star : Icons.star_border,
                                    color: AppTheme.accentColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text('${rating}以上'),
                              ],
                            ),
                            value: rating,
                            groupValue: _tempFilter.minRating,
                            onChanged: (value) {
                              setState(() {
                                _tempFilter = _tempFilter.copyWith(
                                  minRating: value,
                                );
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),

                    // 追加フィルター
                    _FilterSection(
                      title: '追加フィルター',
                      child: Column(
                        children: [
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Row(
                              children: [
                                Icon(Icons.eco, color: Colors.green),
                                SizedBox(width: 8),
                                Text('ベジタリアン'),
                              ],
                            ),
                            value: _tempFilter.isVegetarian ?? false,
                            onChanged: (value) {
                              setState(() {
                                _tempFilter = _tempFilter.copyWith(
                                  isVegetarian: value,
                                  clearIsVegetarian: value == false,
                                );
                              });
                            },
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Row(
                              children: [
                                Icon(Icons.local_fire_department, color: Colors.red),
                                SizedBox(width: 8),
                                Text('辛い料理'),
                              ],
                            ),
                            value: _tempFilter.isSpicy ?? false,
                            onChanged: (value) {
                              setState(() {
                                _tempFilter = _tempFilter.copyWith(
                                  isSpicy: value,
                                  clearIsSpicy: value == false,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // 適用ボタン
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // フィルターを適用
                    ref.read(searchFilterProvider.notifier).updateAll(_tempFilter);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                  child: const Text(
                    'フィルターを適用',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.heading3),
        const SizedBox(height: AppTheme.spacingSmall),
        child,
      ],
    );
  }
}

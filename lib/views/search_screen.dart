import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme_config.dart';
import '../providers/search_provider.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/search_result_card.dart';

// ========================================
// Search Screen（検索画面）
// ========================================
// アイテムの検索とフィルタリングを行う画面
// ConsumerStatefulWidgetを使用（状態を持つWidget + Riverpod Provider監視）
// StatefulWidgetとConsumerWidgetの機能を組み合わせたもの
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  // ConsumerStateを返す（通常のStateではない）
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

// ConsumerState<T>を継承することでrefとStateの両方が使える
class _SearchScreenState extends ConsumerState<SearchScreen> {
  // TextEditingController: TextFieldの入力内容を管理するコントローラー
  // Widgetの状態として保持することで、画面が再構築されても値を保持できる
  final TextEditingController _searchController = TextEditingController();

  // dispose(): Widgetが破棄される際に呼ばれるライフサイクルメソッド
  // TextEditingControllerなどのリソースを解放してメモリリークを防ぐ
  @override
  void dispose() {
    _searchController.dispose(); // コントローラーを破棄
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final viewMode = ref.watch(searchViewModeProvider);
    final filter = ref.watch(searchFilterProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () {
            // 検索状態をクリア
            ref.read(searchQueryProvider.notifier).clear();
            ref.read(searchFilterProvider.notifier).clearAll();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '検索',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          // 表示モード切り替え
          IconButton(
            icon: Icon(
              viewMode == ViewMode.grid ? Icons.view_list : Icons.grid_view,
              color: AppTheme.textPrimary,
            ),
            onPressed: () {
              ref.read(searchViewModeProvider.notifier).toggle();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 検索バーとフィルターボタン
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).update(value);
                  },
                  onClear: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).clear();
                  },
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Row(
                  children: [
                    Expanded(
                      child: _FilterChip(
                        label: filter.hasActiveFilters
                            ? 'フィルター (${filter.activeFilterCount})'
                            : 'フィルター',
                        icon: Icons.tune,
                        isActive: filter.hasActiveFilters,
                        onTap: () {
                          // ========================================
                          // showModalBottomSheet（モーダルボトムシート表示）
                          // ========================================
                          // 画面下部から上にスライドして表示されるモーダルシート
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true, // シート内のスクロールを有効化
                            backgroundColor: Colors.transparent, // 背景を透明に（シート側で角丸を実現）
                            enableDrag: true, // ドラッグで閉じることを許可
                            isDismissible: true, // 外側タップで閉じることを許可
                            // builder: シートの内容を構築する関数
                            builder: (context) => const FilterBottomSheet(),
                          );
                        },
                      ),
                    ),
                    if (filter.hasActiveFilters) ...[
                      const SizedBox(width: AppTheme.spacingSmall),
                      TextButton.icon(
                        onPressed: () {
                          ref.read(searchFilterProvider.notifier).clearAll();
                        },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('クリア'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // 検索結果
          Expanded(
            child: searchResults.when(
              data: (items) {
                if (query.isEmpty && !filter.hasActiveFilters) {
                  return const _EmptySearchState(
                    icon: Icons.search,
                    title: '検索してみましょう',
                    description: 'タイトル、材料、タグなどで検索できます',
                  );
                }

                if (items.isEmpty) {
                  return const _EmptySearchState(
                    icon: Icons.search_off,
                    title: '結果が見つかりません',
                    description: '検索条件を変えて再度お試しください',
                  );
                }

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMedium,
                        vertical: AppTheme.spacingSmall,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${items.length}件の結果',
                            style: AppTheme.body2.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: viewMode == ViewMode.grid
                          ? _GridView(items: items)
                          : _ListView(items: items),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              ),
              error: (error, stack) => _EmptySearchState(
                icon: Icons.error_outline,
                title: 'エラーが発生しました',
                description: error.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMedium,
          vertical: AppTheme.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isActive ? AppTheme.primaryColor : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTheme.body2.copyWith(
                color: isActive ? AppTheme.primaryColor : AppTheme.textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _EmptySearchState({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              title,
              style: AppTheme.heading3.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              description,
              style: AppTheme.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List items;

  const _GridView({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppTheme.spacingMedium,
        mainAxisSpacing: AppTheme.spacingMedium,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return SearchResultGridCard(item: items[index]);
      },
    );
  }
}

class _ListView extends StatelessWidget {
  final List items;

  const _ListView({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSmall),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return SearchResultListCard(item: items[index]);
      },
    );
  }
}

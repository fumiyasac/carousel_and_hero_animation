import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

// ========================================
// Search Bar Widget（検索バーウィジェット）
// ========================================
// 検索画面で使用する検索入力フィールドのカスタムWidget
// TextFieldをラップして、統一されたデザインと機能を提供
// StatelessWidget: 状態を持たないWidget（親から渡されたデータのみを使用）
class SearchBarWidget extends StatelessWidget {
  // TextEditingController: TextFieldの入力内容を管理するコントローラー
  // 親Widgetから渡され、親側で入力内容を取得・制御できる
  final TextEditingController controller;

  // ValueChanged<String>: 入力が変更された時に呼ばれるコールバック関数
  // 型はvoid Function(String value)の別名
  // 入力内容をリアルタイムで親Widgetに通知する
  final ValueChanged<String> onChanged;

  // VoidCallback: 引数なしの関数型（void Function()の別名）
  // クリアボタンが押された時に呼ばれるコールバック
  final VoidCallback onClear;

  // コンストラクタ: 必須パラメータとして3つのコールバックを受け取る
  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    // Container: 背景色や枠線などの装飾を設定するためのラッパーWidget
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        // BorderRadius.circular(): 角を丸くする（全ての角に同じ半径を適用）
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        // Border.all(): 全辺に同じ枠線を設定
        border: Border.all(
          color: const Color(0xFFE0E0E0), // 薄いグレーの枠線
          width: 1,
        ),
      ),
      // ========================================
      // TextField（テキスト入力フィールド）
      // ========================================
      // ユーザーがテキストを入力できるWidget
      child: TextField(
        // controller: 入力内容を管理
        controller: controller,
        // onChanged: 入力が変更されるたびに呼ばれる
        // 親Widgetに入力内容を通知してリアルタイム検索を実現
        onChanged: onChanged,
        // ========================================
        // InputDecoration（入力フィールドの装飾）
        // ========================================
        decoration: InputDecoration(
          // hintText: 入力がない時に表示されるプレースホルダー
          hintText: '料理名、材料、タグで検索...',
          // hintStyle: プレースホルダーのスタイル
          // copyWith(): 既存スタイルの一部だけを変更した新しいスタイルを作成
          hintStyle: AppTheme.body2.copyWith(color: AppTheme.textLight),
          // prefixIcon: 入力フィールドの左側に表示するアイコン
          prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
          // suffixIcon: 入力フィールドの右側に表示するアイコン
          // 三項演算子: 条件 ? 真の場合 : 偽の場合
          // 入力がある場合のみクリアボタンを表示、なければnull（何も表示しない）
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                  onPressed: onClear, // クリアボタンが押されたら親のonClearを呼ぶ
                )
              : null,
          // border: InputBorder.none で標準の枠線を非表示
          // 代わりにContainerのBorderで枠線を表示している
          border: InputBorder.none,
          // contentPadding: 入力フィールド内部の余白
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMedium,
            vertical: AppTheme.spacingMedium,
          ),
        ),
        // style: 入力されたテキストのスタイル
        style: AppTheme.body1,
      ),
    );
  }
}

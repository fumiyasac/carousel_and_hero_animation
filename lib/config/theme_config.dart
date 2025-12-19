import 'package:flutter/material.dart';

// アプリ全体で使用するデザインシステム
class AppTheme {
  // カラーパレット
  static const Color primaryColor = Color(0xFFFF6B6B); // メインカラー（赤系）
  static const Color secondaryColor = Color(0xFF4ECDC4); // アクセントカラー（青緑）
  static const Color accentColor = Color(0xFFFFC107); // アクセント（濃い黄金色）- より目立つように変更
  static const Color backgroundColor = Color(0xFFF7F7F7);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFF95A5A6); // より濃く調整（旧: #B2BEC3）

  // カテゴリーカラー - コントラスト改善版
  static const Map<String, Color> categoryColors = {
    '和食': Color(0xFFDC3545), // より濃く（旧: #E74C3C）
    '洋食': Color(0xFF2980B9), // より濃く（旧: #3498DB）
    '中華': Color(0xFFD35400), // より濃く（旧: #E67E22）
    'イタリアン': Color(0xFF27AE60), // より濃く（旧: #2ECC71）
    'エスニック': Color(0xFF8E44AD), // より濃く（旧: #9B59B6）
    'カフェ': Color(0xFF16A085), // より濃く（旧: #1ABC9C）
    'デザート': Color(0xFFE67E22), // より濃く（旧: #F39C12）
  };

  // シャドウ
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  // ボーダーラジアス
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;

  // スペーシング
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // テキストスタイル
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // カテゴリーカラーを取得
  static Color getCategoryColor(String category) {
    return categoryColors[category] ?? primaryColor;
  }
}
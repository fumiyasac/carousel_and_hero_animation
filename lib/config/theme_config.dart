import 'package:flutter/material.dart';

// ========================================
// App Theme（アプリケーション全体のデザインシステム）
// ========================================
// アプリ全体で一貫したデザインを保つための定数クラス
// 色、サイズ、シャドウ、スタイルなどを一元管理することで、
// デザインの変更が容易になり、コードの保守性が向上する
class AppTheme {
  // ========================================
  // カラーパレット（色の定義）
  // ========================================
  // 0xFFRRGGBB 形式: FF（不透明度）+ RRGGBB（RGB値）
  // static const: クラスレベルの定数（インスタンス化不要でアクセス可能）

  // プライマリーカラー（メインカラー）: 赤系
  // アプリの主要な色として、ボタンや重要な要素に使用
  static const Color primaryColor = Color(0xFFFF6B6B);

  // セカンダリーカラー（補助色）: 青緑系
  // プライマリーカラーを補完する色として使用
  static const Color secondaryColor = Color(0xFF4ECDC4);

  // アクセントカラー（強調色）: 濃い黄金色
  // 評価の星や特別な要素の強調に使用
  static const Color accentColor = Color(0xFFFFC107);

  // 背景色（薄いグレー）
  // 画面全体の背景として使用
  static const Color backgroundColor = Color(0xFFF7F7F7);

  // カード背景色（白）
  // カードやパネルの背景として使用
  static const Color cardColor = Colors.white;

  // テキストカラー（プライマリー）: 濃いグレー
  // 見出しや本文などの主要なテキストに使用
  static const Color textPrimary = Color(0xFF2D3436);

  // テキストカラー（セカンダリー）: 中程度のグレー
  // 補足テキストやキャプションに使用
  static const Color textSecondary = Color(0xFF636E72);

  // テキストカラー（ライト）: 薄いグレー
  // プレースホルダーや非アクティブな要素に使用
  static const Color textLight = Color(0xFF95A5A6);

  // ========================================
  // カテゴリーカラー（カテゴリー別の色定義）
  // ========================================
  // Map<String, Color>: キー（カテゴリー名）と値（色）のマッピング
  // 各料理カテゴリーに固有の色を割り当てることで視覚的な区別をつける
  // const: コンパイル時に値が確定する定数
  static const Map<String, Color> categoryColors = {
    '和食': Color(0xFFDC3545),       // 赤系（和のイメージ）
    '洋食': Color(0xFF2980B9),       // 青系（洋のイメージ）
    '中華': Color(0xFFD35400),       // オレンジ系（中華のイメージ）
    'イタリアン': Color(0xFF27AE60),  // 緑系（イタリアのイメージ）
    'エスニック': Color(0xFF8E44AD),  // 紫系（エキゾチックなイメージ）
    'カフェ': Color(0xFF16A085),     // ターコイズ系（カフェのイメージ）
    'デザート': Color(0xFFE67E22),   // 濃いオレンジ系（スイーツのイメージ）
  };

  // ========================================
  // シャドウ（影の定義）
  // ========================================
  // BoxShadow: Widgetに影を付けるための設定
  // List<BoxShadow>: 複数の影を重ねることも可能

  // カードシャドウ（カード用の影）
  // 比較的濃い影で、カードが浮いているような立体感を演出
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      // withOpacity(): 色の不透明度を調整（0.0〜1.0）
      // 0.08 = 8% の不透明度（かなり薄い影）
      color: Colors.black.withOpacity(0.08),
      // blurRadius: ぼかしの半径（大きいほどぼやける）
      blurRadius: 16,
      // offset: 影のずれ（x, y）
      // Offset(0, 4) = 横0px、下に4px
      offset: const Offset(0, 4),
    ),
  ];

  // ソフトシャドウ（より薄く柔らかい影）
  // 小さな要素や控えめな立体感を出したい場合に使用
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05), // さらに薄い影（5%）
      blurRadius: 10,                        // やや弱いぼかし
      offset: const Offset(0, 2),            // 下に2pxずらす
    ),
  ];

  // ========================================
  // ボーダーラジアス（角丸の半径）
  // ========================================
  // BorderRadius.circular() などで使用する値
  // サイズ別に定義することで、統一感のある角丸を実現
  static const double radiusSmall = 8.0;   // 小さい角丸（チップなど）
  static const double radiusMedium = 12.0; // 中程度の角丸（ボタンなど）
  static const double radiusLarge = 16.0;  // 大きい角丸（カードなど）
  static const double radiusXLarge = 20.0; // 特大の角丸（モーダルなど）

  // ========================================
  // スペーシング（余白のサイズ）
  // ========================================
  // padding や margin で使用する値
  // 統一されたスペーシングシステムにより、整然としたレイアウトを実現
  // 4の倍数で定義するのが一般的（4px, 8px, 16px...）
  static const double spacingXSmall = 4.0;  // 極小（要素間の狭い余白）
  static const double spacingSmall = 8.0;   // 小（近い要素間の余白）
  static const double spacingMedium = 16.0; // 中（標準的な余白）
  static const double spacingLarge = 24.0;  // 大（セクション間の余白）
  static const double spacingXLarge = 32.0; // 特大（大きな区切りの余白）

  // ========================================
  // テキストスタイル（文字のスタイル定義）
  // ========================================
  // TextStyle: フォントサイズ、太さ、色、行間などを定義
  // const: コンパイル時定数として定義（パフォーマンス向上）

  // 見出し1（最も大きい見出し）
  // ページタイトルや主要な見出しに使用
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,                  // 文字サイズ
    fontWeight: FontWeight.bold,   // 太字
    color: textPrimary,            // テキスト色
    height: 1.2,                   // 行の高さ（fontSize × height）
  );

  // 見出し2（中見出し）
  // セクションの見出しに使用
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );

  // 見出し3（小見出し）
  // サブセクションの見出しに使用
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  // 本文1（標準的な本文）
  // 主要な説明文やコンテンツに使用
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: textPrimary,
    height: 1.5, // 行間を広めに取って読みやすくする
  );

  // 本文2（小さめの本文）
  // 補足説明やキャプションに使用
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: textSecondary, // やや薄い色で控えめに
    height: 1.4,
  );

  // キャプション（最も小さい本文）
  // ラベルや補助的な情報に使用
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: textSecondary,
  );

  // 小さいラベル（タグやバッジなど）
  // 極小のラベルやタグに使用
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,  // やや太字（w600 = semi-bold）
    letterSpacing: 0.5,           // 文字間隔を広げて可読性向上
  );

  // ========================================
  // getCategoryColor メソッド（カテゴリー色の取得）
  // ========================================
  // カテゴリー名に対応する色を返すヘルパーメソッド
  // 引数: category（カテゴリー名の文字列）
  // 戻り値: そのカテゴリーに対応する色（存在しない場合はprimaryColor）
  // static: インスタンス化せずに AppTheme.getCategoryColor() として呼び出せる
  static Color getCategoryColor(String category) {
    // ?? 演算子: 左側がnullなら右側を返す
    // categoryColors[category] でMapから色を取得
    // 該当するカテゴリーがない場合はnullが返るので、その場合はprimaryColorを使う
    return categoryColors[category] ?? primaryColor;
  }
}